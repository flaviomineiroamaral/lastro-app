-- ============================================================================
-- MIGRAÇÃO NÍVEL 2 (PADRÃO OURO): MOTOR DE RECORRÊNCIA E CONTAS FIXAS
-- Projeto: Lastro (Supabase PostgreSQL)
-- Data: 2026-10-16
-- ============================================================================
-- O que este script entrega:
-- 1. Evolui `public.obrigacoes_recorrentes` para suportar Contas a Receber ('CREDITO')
--    e Contas a Pagar ('DEBITO'), membro_id, regras de competência e janela deslizante.
-- 2. Adiciona `tipo_recorrencia` ('UNICO', 'PARCELADO', 'FIXO') e `recorrencia_id`
--    em `public.transacoes`, com backfill automático dos dados atuais e índice de idempotência.
-- 3. Atualiza `public.vw_agendamentos` mantendo todas as colunas atuais na mesma ordem
--    e expondo `grupo_recorrencia_id`, `recorrencia_id` e `tipo_recorrencia` ao final.
-- 4. Reescreve `public.fn_gerar_transacoes_recorrentes` para operar em Janela Deslizante
--    (Rolling Window de 12 meses para Mensal), sem recriar meses excluídos individualmente.
-- 5. Cria as RPCs Padrão Ouro para o App (FlutterFlow):
--    - `public.fn_criar_lancamento_recorrente`: Cria Fixo (via regra + janela 12m) ou Parcelado (N parcelas).
--    - `public.fn_atualizar_agendamento_recorrente`: Edita 'APENAS_ESTE' ou 'ESTE_E_PROXIMOS' (reajuste em cascata).
--    - `public.fn_excluir_agendamento_recorrente`: Exclui 'APENAS_ESTE' ou 'ESTE_E_PROXIMOS' (encerramento de contrato).
-- 6. Configura job diário no `pg_cron` (se disponível) para manter a janela sempre renovada.
-- ============================================================================

BEGIN;

-- ============================================================================
-- 1. EVOLUÇÃO DA TABELA-MÃE: public.obrigacoes_recorrentes
-- ============================================================================

ALTER TABLE public.obrigacoes_recorrentes
  ADD COLUMN IF NOT EXISTS tipo_operacao text NOT NULL DEFAULT 'DEBITO',
  ADD COLUMN IF NOT EXISTS membro_id uuid REFERENCES public.membros(id) ON DELETE SET NULL,
  ADD COLUMN IF NOT EXISTS regra_competencia text NOT NULL DEFAULT 'Mesmo Mês do Vencimento',
  ADD COLUMN IF NOT EXISTS manter_competencia_fixa boolean NOT NULL DEFAULT false,
  ADD COLUMN IF NOT EXISTS data_inicio date NOT NULL DEFAULT CURRENT_DATE,
  ADD COLUMN IF NOT EXISTS data_fim date,
  ADD COLUMN IF NOT EXISTS janela_meses integer NOT NULL DEFAULT 12;

DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_constraint
    WHERE conname = 'chk_obrigacoes_tipo_operacao'
      AND conrelid = 'public.obrigacoes_recorrentes'::regclass
  ) THEN
    ALTER TABLE public.obrigacoes_recorrentes
      ADD CONSTRAINT chk_obrigacoes_tipo_operacao
      CHECK (tipo_operacao IN ('CREDITO', 'DEBITO'));
  END IF;

  IF NOT EXISTS (
    SELECT 1 FROM pg_constraint
    WHERE conname = 'chk_obrigacoes_janela_meses'
      AND conrelid = 'public.obrigacoes_recorrentes'::regclass
  ) THEN
    ALTER TABLE public.obrigacoes_recorrentes
      ADD CONSTRAINT chk_obrigacoes_janela_meses
      CHECK (janela_meses BETWEEN 1 AND 60);
  END IF;
END $$;


-- ============================================================================
-- 2. EVOLUÇÃO DA TABELA DE LANÇAMENTOS: public.transacoes
-- ============================================================================

ALTER TABLE public.transacoes
  ADD COLUMN IF NOT EXISTS tipo_recorrencia text NOT NULL DEFAULT 'UNICO',
  ADD COLUMN IF NOT EXISTS recorrencia_id uuid REFERENCES public.obrigacoes_recorrentes(id) ON DELETE SET NULL;

DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_constraint
    WHERE conname = 'chk_transacoes_tipo_recorrencia'
      AND conrelid = 'public.transacoes'::regclass
  ) THEN
    ALTER TABLE public.transacoes
      ADD CONSTRAINT chk_transacoes_tipo_recorrencia
      CHECK (tipo_recorrencia IN ('UNICO', 'PARCELADO', 'FIXO'));
  END IF;
END $$;

-- Backfill inteligente para classificar lançamentos já existentes no banco:
-- 2.1. Vincula recorrencia_id onde grupo_recorrencia_id já era o UUID de obrigacoes_recorrentes
UPDATE public.transacoes t
SET recorrencia_id = o.id,
    tipo_recorrencia = 'FIXO'
FROM public.obrigacoes_recorrentes o
WHERE t.grupo_recorrencia_id = o.id::text
  AND t.recorrencia_id IS NULL;

-- 2.2. Lançamentos gerados pelo app como 'Fixo' (60 meses sem sufixo '(i/N)' na descrição)
UPDATE public.transacoes
SET tipo_recorrencia = 'FIXO',
    parcela_atual = NULL,
    total_parcelas = NULL
WHERE tipo_recorrencia = 'UNICO'
  AND total_parcelas = 60
  AND descricao !~ '\(\d+/\d+\)\s*$';

-- 2.3. Lançamentos parcelados (total_parcelas > 1 com sufixo ou != 60)
UPDATE public.transacoes
SET tipo_recorrencia = 'PARCELADO'
WHERE tipo_recorrencia = 'UNICO'
  AND COALESCE(total_parcelas, 1) > 1;

-- Índice para busca rápida por grupo/recorrência em edições e exclusões em cascata
CREATE INDEX IF NOT EXISTS idx_transacoes_grupo_recorrencia
  ON public.transacoes (organization_id, grupo_recorrencia_id, data_vencimento)
  WHERE grupo_recorrencia_id IS NOT NULL;

CREATE INDEX IF NOT EXISTS idx_transacoes_recorrencia_id
  ON public.transacoes (recorrencia_id, data_competencia)
  WHERE recorrencia_id IS NOT NULL;

-- Índice Único Parcial de Idempotência: impede duplicação da mesma competência para a mesma regra fixa
CREATE UNIQUE INDEX IF NOT EXISTS uq_transacoes_recorrencia_competencia
  ON public.transacoes (recorrencia_id, data_competencia)
  WHERE recorrencia_id IS NOT NULL
    AND status NOT IN ('CANCELADO', 'EXCLUIDO', 'EXCLUÍDO');


-- ============================================================================
-- 3. ATUALIZAÇÃO DA VIEW: public.vw_agendamentos
-- Mantém as 29 colunas originais na exata mesma ordem e adiciona as 3 novas no fim
-- ============================================================================

CREATE OR REPLACE VIEW public.vw_agendamentos AS
 SELECT t.id AS transacao_id,
    t.organization_id,
    t.conta_bancaria_id AS conta_id,
    c.nome AS nome_conta,
    c.tipo AS tipo_conta,
    t.data_pagamento,
    t.criado_em,
    t.descricao,
    t.valor,
    t.tipo_operacao,
    t.status,
    t.plano_contas_id AS categoria_id,
    pc.nome AS categoria_nome,
    t.centro_custo_id,
    t.membro_id,
    t.observacoes,
    t.comprovativo_url,
    t.id_unico_banco,
    COALESCE(t.parcela_atual, 0) AS parcela_atual,
    COALESCE(t.total_parcelas, 0) AS total_parcelas,
    t.data_vencimento,
    t.data_competencia,
    t.conta_destino_id,
        CASE
            WHEN (t.tipo_operacao = 'DEBITO'::text) THEN 'CP'::text
            WHEN (t.tipo_operacao = 'CREDITO'::text) THEN 'CR'::text
            ELSE 'OUTRO'::text
        END AS modulo,
        CASE
            WHEN (t.tipo_operacao = 'DEBITO'::text) THEN 'A Pagar'::text
            WHEN (t.tipo_operacao = 'CREDITO'::text) THEN 'A Receber'::text
            ELSE 'Transferência'::text
        END AS tipo_agendamento,
        CASE
            WHEN (t.data_vencimento < CURRENT_DATE) THEN 'VENCIDO'::text
            WHEN (t.data_vencimento = CURRENT_DATE) THEN 'HOJE'::text
            ELSE 'A VENCER'::text
        END AS status_prazo,
    (CURRENT_DATE - t.data_vencimento) AS dias_diferenca,
    sum(
        CASE
            WHEN (t.tipo_operacao = 'DEBITO'::text) THEN (- abs(COALESCE(t.valor, (0)::numeric)))
            WHEN (t.tipo_operacao = 'CREDITO'::text) THEN abs(COALESCE(t.valor, (0)::numeric))
            ELSE (0)::numeric
        END) OVER (PARTITION BY t.organization_id, t.tipo_operacao ORDER BY t.data_vencimento, t.id) AS saldo_progressivo,
    sum(abs(COALESCE(t.valor, (0)::numeric))) OVER (PARTITION BY t.organization_id, t.tipo_operacao ORDER BY t.data_vencimento) AS acumulado_diario,
    t.grupo_recorrencia_id,
    t.recorrencia_id,
    t.tipo_recorrencia
   FROM ((public.transacoes t
     LEFT JOIN public.plano_contas pc ON ((t.plano_contas_id = pc.id)))
     LEFT JOIN public.contas_bancarias c ON ((t.conta_bancaria_id = c.id)))
  WHERE ((t.status = 'PENDENTE'::text) AND (t.data_vencimento IS NOT NULL))
  ORDER BY t.data_vencimento, t.id;


-- ============================================================================
-- 4. MOTOR DE JANELA DESLIZANTE: public.fn_gerar_transacoes_recorrentes
-- ============================================================================

DROP FUNCTION IF EXISTS public.fn_gerar_transacoes_recorrentes();

CREATE OR REPLACE FUNCTION public.fn_gerar_transacoes_recorrentes(
    p_recorrencia_id uuid DEFAULT NULL
)
RETURNS void
LANGUAGE plpgsql
SECURITY DEFINER
AS $function$
DECLARE
    reg RECORD;
    v_mes_base DATE;
    v_mes_alvo DATE;
    v_ultimo_dia_mes INTEGER;
    v_data_vencimento DATE;
    v_data_competencia DATE;
    v_horizonte INTEGER;
    v_offset_comp INTEGER;
    v_maior_comp_gerada DATE;
    i INTEGER;
    erro_mensagem TEXT;
    erro_detalhe TEXT;
BEGIN
    FOR reg IN
        SELECT *
        FROM public.obrigacoes_recorrentes
        WHERE ativo = TRUE
          AND (p_recorrencia_id IS NULL OR id = p_recorrencia_id)
        FOR UPDATE SKIP LOCKED
    LOOP
        BEGIN
            v_maior_comp_gerada := reg.ultima_competencia_gerada;

            -- Define o ponto de partida (mês de início da regra ou mês atual)
            v_mes_base := date_trunc('month', GREATEST(CURRENT_DATE, COALESCE(reg.data_inicio, CURRENT_DATE)))::date;

            -- Se já havia início no mês corrente mas antes de hoje (ex: dia 5 do mês atual quando cadastrada hoje),
            -- respeita o data_inicio informado na criação inicial (quando ultima_competencia_gerada IS NULL)
            IF reg.ultima_competencia_gerada IS NULL AND reg.data_inicio IS NOT NULL THEN
                v_mes_base := date_trunc('month', reg.data_inicio)::date;
            END IF;

            -- Define quantos ciclos projetar na janela deslizante
            IF reg.periodicidade = 'MENSAL' THEN
                v_horizonte := COALESCE(reg.janela_meses, 12);
            ELSE
                -- Para ANUAL, projeta o ano atual e o próximo (2 ciclos)
                v_horizonte := 2;
            END IF;

            FOR i IN 0 .. (v_horizonte - 1) LOOP
                IF reg.periodicidade = 'MENSAL' THEN
                    v_mes_alvo := (v_mes_base + (i || ' months')::interval)::date;
                    v_ultimo_dia_mes := EXTRACT(DAY FROM (v_mes_alvo + interval '1 month' - interval '1 day'))::integer;
                    v_data_vencimento := v_mes_alvo + (LEAST(reg.dia_vencimento, v_ultimo_dia_mes) - 1);

                    -- Cálculo da competência segundo a regra da obrigação
                    v_offset_comp := CASE
                        WHEN reg.regra_competencia = 'Mês Anterior' THEN -1
                        WHEN reg.regra_competencia = 'Mês Seguinte' THEN 1
                        ELSE 0
                    END;

                    IF reg.manter_competencia_fixa AND reg.data_inicio IS NOT NULL THEN
                        v_data_competencia := reg.data_inicio;
                    ELSE
                        v_data_competencia := (v_mes_alvo + (v_offset_comp || ' months')::interval)::date
                                              + (LEAST(reg.dia_vencimento, EXTRACT(DAY FROM ((v_mes_alvo + (v_offset_comp || ' months')::interval) + interval '1 month' - interval '1 day'))::integer) - 1);
                    END IF;

                ELSIF reg.periodicidade = 'ANUAL' THEN
                    BEGIN
                        v_data_vencimento := make_date(
                            EXTRACT(YEAR FROM v_mes_base)::int + i,
                            COALESCE(reg.mes_vencimento, EXTRACT(MONTH FROM v_mes_base)::int),
                            reg.dia_vencimento
                        );
                    EXCEPTION WHEN datetime_field_overflow THEN
                        v_data_vencimento := make_date(
                            EXTRACT(YEAR FROM v_mes_base)::int + i,
                            COALESCE(reg.mes_vencimento, EXTRACT(MONTH FROM v_mes_base)::int),
                            28
                        );
                    END;
                    v_data_competencia := v_data_vencimento;
                END IF;

                -- Respeita a data_fim do contrato, se houver
                IF reg.data_fim IS NOT NULL AND v_data_vencimento > reg.data_fim THEN
                    EXIT;
                END IF;

                -- Só insere se for uma competência ainda não alcançada pela janela anterior
                -- (evita recriar um mês intermediário que o usuário tenha excluído manualmente)
                IF reg.ultima_competencia_gerada IS NULL OR v_data_competencia > reg.ultima_competencia_gerada THEN
                    INSERT INTO public.transacoes (
                        organization_id,
                        descricao,
                        valor,
                        data_pagamento,
                        data_vencimento,
                        data_competencia,
                        tipo_operacao,
                        status,
                        plano_contas_id,
                        centro_custo_id,
                        conta_bancaria_id,
                        membro_id,
                        criado_em,
                        grupo_recorrencia_id,
                        recorrencia_id,
                        tipo_recorrencia,
                        parcela_atual,
                        total_parcelas
                    ) VALUES (
                        reg.organization_id,
                        reg.descricao,
                        ABS(reg.valor_estimado),
                        NULL,
                        v_data_vencimento,
                        v_data_competencia,
                        COALESCE(reg.tipo_operacao, 'DEBITO'),
                        'PENDENTE',
                        reg.categoria_id,
                        reg.centro_custo_id,
                        NULL, -- Conta bancária só é exigida quando CONCILIADO (chk_transacao_paga_exige_conta)
                        reg.membro_id,
                        now(),
                        reg.id::text,
                        reg.id,
                        'FIXO',
                        NULL,
                        NULL
                    )
                    ON CONFLICT (recorrencia_id, data_competencia)
                    WHERE recorrencia_id IS NOT NULL
                      AND status NOT IN ('CANCELADO', 'EXCLUIDO', 'EXCLUÍDO')
                    DO NOTHING;

                    IF v_maior_comp_gerada IS NULL OR v_data_competencia > v_maior_comp_gerada THEN
                        v_maior_comp_gerada := v_data_competencia;
                    END IF;
                END IF;
            END LOOP;

            IF v_maior_comp_gerada IS DISTINCT FROM reg.ultima_competencia_gerada THEN
                UPDATE public.obrigacoes_recorrentes
                SET ultima_competencia_gerada = v_maior_comp_gerada
                WHERE id = reg.id;
            END IF;

        EXCEPTION WHEN OTHERS THEN
            GET STACKED DIAGNOSTICS erro_mensagem = MESSAGE_TEXT, erro_detalhe = PG_EXCEPTION_DETAIL;
            RAISE WARNING 'Falha na Obrigação Recorrente %: %, Detalhe: %', reg.id, erro_mensagem, erro_detalhe;
        END;
    END LOOP;
END;
$function$;


-- ============================================================================
-- 5. RPC DE CRIAÇÃO UNIFICADA (CHAMADA PELO APP):
--    public.fn_criar_lancamento_recorrente
-- ============================================================================

CREATE OR REPLACE FUNCTION public.fn_criar_lancamento_recorrente(
    p_org_id uuid,
    p_conta_id uuid,
    p_tipo_conta text,
    p_descricao text,
    p_valor numeric,
    p_data_primeiro_vencimento date,
    p_data_primeira_competencia date,
    p_regra_competencia text,
    p_manter_competencia_fixa boolean,
    p_tipo_operacao text,
    p_total_parcelas integer,
    p_is_parcelamento boolean,
    p_categoria_id uuid,
    p_centro_custo_id uuid,
    p_membro_id uuid DEFAULT NULL,
    p_primeira_paga boolean DEFAULT false,
    p_data_pagamento timestamp with time zone DEFAULT NULL
)
RETURNS jsonb
LANGUAGE plpgsql
SECURITY DEFINER
AS $function$
DECLARE
    v_recorrencia_id uuid;
    v_grupo_id text;
    v_base_comp date;
    v_venc date;
    v_comp date;
    v_ultimo_dia int;
    v_offset int;
    v_status_op text;
    v_regra text;
    i int;
BEGIN
    IF NOT public.check_user_in_org(p_org_id) THEN
        RAISE EXCEPTION 'Acesso negado: Usuário não autorizado para esta organização.';
    END IF;

    v_regra := TRIM(COALESCE(p_regra_competencia, 'Mesmo Mês do Vencimento'));
    v_base_comp := COALESCE(p_data_primeira_competencia, p_data_primeiro_vencimento);

    -- ========================================================================
    -- CASO A: LANÇAMENTO FIXO (Regra-Mãe + Janela Deslizante de 12 meses)
    -- ========================================================================
    IF NOT COALESCE(p_is_parcelamento, false) THEN
        INSERT INTO public.obrigacoes_recorrentes (
            organization_id,
            descricao,
            categoria_id,
            centro_custo_id,
            conta_bancaria_id,
            membro_id,
            tipo_operacao,
            periodicidade,
            dia_vencimento,
            mes_vencimento,
            dias_antecedencia,
            valor_estimado,
            regra_competencia,
            manter_competencia_fixa,
            data_inicio,
            janela_meses,
            ativo
        ) VALUES (
            p_org_id,
            p_descricao,
            p_categoria_id,
            p_centro_custo_id,
            p_conta_id,
            p_membro_id,
            UPPER(TRIM(p_tipo_operacao)),
            'MENSAL',
            EXTRACT(DAY FROM p_data_primeiro_vencimento)::int,
            NULL,
            20,
            ABS(p_valor),
            v_regra,
            COALESCE(p_manter_competencia_fixa, false),
            p_data_primeiro_vencimento,
            12,
            TRUE
        )
        RETURNING id INTO v_recorrencia_id;

        -- Materializa imediatamente os primeiros 12 meses na tabela transacoes
        PERFORM public.fn_gerar_transacoes_recorrentes(v_recorrencia_id);

        -- Se o usuário marcou o 1º lançamento como já Pago/Recebido (ou Cartão)
        IF (p_primeira_paga OR p_tipo_conta = 'CARTAO') AND p_conta_id IS NOT NULL THEN
            UPDATE public.transacoes
            SET status = 'CONCILIADO',
                conta_bancaria_id = p_conta_id,
                data_pagamento = CASE WHEN p_tipo_conta = 'CARTAO' THEN NULL ELSE COALESCE(p_data_pagamento, now()) END
            WHERE id = (
                SELECT id FROM public.transacoes
                WHERE recorrencia_id = v_recorrencia_id
                ORDER BY data_vencimento ASC
                LIMIT 1
            );
        END IF;

        RETURN jsonb_build_object(
            'sucesso', true,
            'tipo_recorrencia', 'FIXO',
            'recorrencia_id', v_recorrencia_id,
            'grupo_recorrencia_id', v_recorrencia_id::text
        );

    -- ========================================================================
    -- CASO B: LANÇAMENTO PARCELADO (Gera as N parcelas finitas)
    -- ========================================================================
    ELSE
        IF COALESCE(p_total_parcelas, 0) <= 0 THEN
            RETURN jsonb_build_object('sucesso', false, 'mensagem', 'Total de parcelas inválido.');
        END IF;

        v_grupo_id := 'GRP-' || (EXTRACT(EPOCH FROM clock_timestamp()) * 1000)::bigint::text;
        v_status_op := CASE WHEN p_tipo_conta = 'CARTAO' THEN 'CONCILIADO' ELSE 'PENDENTE' END;

        FOR i IN 0 .. (p_total_parcelas - 1) LOOP
            -- 1. Cálculo seguro do vencimento avançando i meses
            v_ultimo_dia := EXTRACT(DAY FROM (date_trunc('month', p_data_primeiro_vencimento) + ((i + 1) || ' months')::interval - interval '1 day'))::int;
            v_venc := (date_trunc('month', p_data_primeiro_vencimento) + (i || ' months')::interval)::date
                      + (LEAST(EXTRACT(DAY FROM p_data_primeiro_vencimento)::int, v_ultimo_dia) - 1);

            -- 2. Cálculo da competência
            IF v_regra = 'Mesmo Mês da Competência' THEN
                IF p_manter_competencia_fixa THEN
                    v_comp := v_base_comp;
                ELSE
                    v_ultimo_dia := EXTRACT(DAY FROM (date_trunc('month', v_base_comp) + ((i + 1) || ' months')::interval - interval '1 day'))::int;
                    v_comp := (date_trunc('month', v_base_comp) + (i || ' months')::interval)::date
                              + (LEAST(EXTRACT(DAY FROM v_base_comp)::int, v_ultimo_dia) - 1);
                END IF;
            ELSE
                v_offset := CASE
                    WHEN v_regra = 'Mês Anterior' THEN -1
                    WHEN v_regra = 'Mês Seguinte' THEN 1
                    ELSE 0
                END;

                IF p_manter_competencia_fixa THEN
                    IF i = 0 THEN
                        v_ultimo_dia := EXTRACT(DAY FROM (date_trunc('month', v_venc) + ((v_offset + 1) || ' months')::interval - interval '1 day'))::int;
                        v_base_comp := (date_trunc('month', v_venc) + (v_offset || ' months')::interval)::date
                                       + (LEAST(EXTRACT(DAY FROM v_venc)::int, v_ultimo_dia) - 1);
                    END IF;
                    v_comp := v_base_comp;
                ELSE
                    v_ultimo_dia := EXTRACT(DAY FROM (date_trunc('month', v_venc) + ((v_offset + 1) || ' months')::interval - interval '1 day'))::int;
                    v_comp := (date_trunc('month', v_venc) + (v_offset || ' months')::interval)::date
                              + (LEAST(EXTRACT(DAY FROM v_venc)::int, v_ultimo_dia) - 1);
                END IF;
            END IF;

            INSERT INTO public.transacoes (
                organization_id,
                conta_bancaria_id,
                descricao,
                valor,
                data_vencimento,
                data_competencia,
                data_pagamento,
                tipo_operacao,
                status,
                grupo_recorrencia_id,
                recorrencia_id,
                tipo_recorrencia,
                parcela_atual,
                total_parcelas,
                plano_contas_id,
                centro_custo_id,
                membro_id
            ) VALUES (
                p_org_id,
                CASE WHEN (i = 0 AND p_primeira_paga) OR p_tipo_conta = 'CARTAO' THEN p_conta_id ELSE NULL END,
                p_descricao || ' (' || (i + 1) || '/' || p_total_parcelas || ')',
                ABS(p_valor),
                v_venc,
                v_comp,
                CASE WHEN i = 0 AND p_primeira_paga AND p_tipo_conta <> 'CARTAO' THEN COALESCE(p_data_pagamento, now()) ELSE NULL END,
                UPPER(TRIM(p_tipo_operacao)),
                CASE WHEN i = 0 AND p_primeira_paga THEN 'CONCILIADO' ELSE v_status_op END,
                v_grupo_id,
                NULL,
                'PARCELADO',
                i + 1,
                p_total_parcelas,
                p_categoria_id,
                p_centro_custo_id,
                p_membro_id
            );
        END LOOP;

        RETURN jsonb_build_object(
            'sucesso', true,
            'tipo_recorrencia', 'PARCELADO',
            'recorrencia_id', NULL,
            'grupo_recorrencia_id', v_grupo_id
        );
    END IF;
END;
$function$;


-- ============================================================================
-- 6. RPC DE EDIÇÃO EM CASCATA ("APENAS ESTE" vs "ESTE E PRÓXIMOS")
-- ============================================================================

CREATE OR REPLACE FUNCTION public.fn_atualizar_agendamento_recorrente(
    p_org_id uuid,
    p_transacao_id uuid,
    p_escopo text, -- 'APENAS_ESTE' ou 'ESTE_E_PROXIMOS'
    p_valor numeric,
    p_descricao text,
    p_categoria_id uuid,
    p_centro_custo_id uuid,
    p_membro_id uuid,
    p_data_vencimento date,
    p_status text DEFAULT 'PENDENTE',
    p_conta_bancaria_id uuid DEFAULT NULL,
    p_data_pagamento timestamp with time zone DEFAULT NULL,
    p_comprovativo_url text DEFAULT NULL
)
RETURNS jsonb
LANGUAGE plpgsql
SECURITY DEFINER
AS $function$
DECLARE
    v_atual public.transacoes%ROWTYPE;
    v_novo_dia int;
    v_qtd_atualizada int := 0;
BEGIN
    IF NOT public.check_user_in_org(p_org_id) THEN
        RAISE EXCEPTION 'Acesso negado: Usuário não autorizado para esta organização.';
    END IF;

    SELECT * INTO v_atual
    FROM public.transacoes
    WHERE id = p_transacao_id AND organization_id = p_org_id;

    IF NOT FOUND THEN
        RETURN jsonb_build_object('sucesso', false, 'mensagem', 'Lançamento não encontrado.');
    END IF;

    -- 1. Atualiza o lançamento selecionado (inclusive eventual baixa/pagamento)
    UPDATE public.transacoes
    SET valor = ABS(p_valor),
        descricao = p_descricao,
        plano_contas_id = p_categoria_id,
        centro_custo_id = p_centro_custo_id,
        membro_id = p_membro_id,
        data_vencimento = p_data_vencimento,
        status = p_status,
        conta_bancaria_id = CASE WHEN p_status = 'CONCILIADO' THEN p_conta_bancaria_id ELSE NULL END,
        data_pagamento = CASE WHEN p_status = 'CONCILIADO' THEN p_data_pagamento ELSE NULL END,
        comprovativo_url = COALESCE(p_comprovativo_url, comprovativo_url)
    WHERE id = p_transacao_id AND organization_id = p_org_id;

    v_qtd_atualizada := 1;

    -- 2. Se o escopo for 'ESTE_E_PROXIMOS', propaga para os lançamentos futuros PENDENTES
    IF UPPER(TRIM(COALESCE(p_escopo, 'APENAS_ESTE'))) = 'ESTE_E_PROXIMOS'
       AND (v_atual.recorrencia_id IS NOT NULL OR v_atual.grupo_recorrencia_id IS NOT NULL) THEN

        v_novo_dia := EXTRACT(DAY FROM p_data_vencimento)::int;

        UPDATE public.transacoes t
        SET valor = ABS(p_valor),
            descricao = CASE
                WHEN t.tipo_recorrencia = 'PARCELADO' AND t.parcela_atual IS NOT NULL AND t.total_parcelas IS NOT NULL
                    THEN regexp_replace(p_descricao, '\s*\(\d+/\d+\)\s*$', '') || ' (' || t.parcela_atual || '/' || t.total_parcelas || ')'
                ELSE p_descricao
            END,
            plano_contas_id = p_categoria_id,
            centro_custo_id = p_centro_custo_id,
            membro_id = p_membro_id,
            data_vencimento = (
                date_trunc('month', t.data_vencimento)::date +
                (LEAST(
                    v_novo_dia,
                    EXTRACT(DAY FROM (date_trunc('month', t.data_vencimento) + interval '1 month' - interval '1 day'))::int
                ) - 1)
            )
        WHERE t.organization_id = p_org_id
          AND t.id <> p_transacao_id
          AND t.status = 'PENDENTE'
          AND t.data_vencimento > v_atual.data_vencimento
          AND (
              (v_atual.recorrencia_id IS NOT NULL AND t.recorrencia_id = v_atual.recorrencia_id)
              OR (v_atual.grupo_recorrencia_id IS NOT NULL AND t.grupo_recorrencia_id = v_atual.grupo_recorrencia_id)
          );

        GET DIAGNOSTICS v_qtd_atualizada = ROW_COUNT;
        v_qtd_atualizada := v_qtd_atualizada + 1;

        -- Atualiza também a regra-mãe em obrigacoes_recorrentes para que futuros meses sigam o novo padrão
        IF v_atual.recorrencia_id IS NOT NULL THEN
            UPDATE public.obrigacoes_recorrentes
            SET valor_estimado = ABS(p_valor),
                descricao = p_descricao,
                categoria_id = p_categoria_id,
                centro_custo_id = p_centro_custo_id,
                membro_id = p_membro_id,
                dia_vencimento = v_novo_dia
            WHERE id = v_atual.recorrencia_id
              AND organization_id = p_org_id;
        END IF;
    END IF;

    RETURN jsonb_build_object(
        'sucesso', true,
        'qtd_atualizada', v_qtd_atualizada
    );
END;
$function$;


-- ============================================================================
-- 7. RPC DE EXCLUSÃO EM CASCATA ("APENAS ESTE" vs "ESTE E PRÓXIMOS")
-- ============================================================================

CREATE OR REPLACE FUNCTION public.fn_excluir_agendamento_recorrente(
    p_org_id uuid,
    p_transacao_id uuid,
    p_escopo text DEFAULT 'APENAS_ESTE' -- 'APENAS_ESTE' ou 'ESTE_E_PROXIMOS'
)
RETURNS jsonb
LANGUAGE plpgsql
SECURITY DEFINER
AS $function$
DECLARE
    v_atual public.transacoes%ROWTYPE;
    v_qtd_excluida int := 0;
BEGIN
    IF NOT public.check_user_in_org(p_org_id) THEN
        RAISE EXCEPTION 'Acesso negado: Usuário não autorizado para esta organização.';
    END IF;

    SELECT * INTO v_atual
    FROM public.transacoes
    WHERE id = p_transacao_id AND organization_id = p_org_id;

    IF NOT FOUND THEN
        RETURN jsonb_build_object('sucesso', false, 'mensagem', 'Lançamento não encontrado.');
    END IF;

    IF UPPER(TRIM(COALESCE(p_escopo, 'APENAS_ESTE'))) = 'ESTE_E_PROXIMOS'
       AND (v_atual.recorrencia_id IS NOT NULL OR v_atual.grupo_recorrencia_id IS NOT NULL) THEN

        -- 1. Remove este lançamento e todos os próximos PENDENTES do mesmo grupo/recorrência
        --    (preservando intacto tudo que já foi CONCILIADO/pago no passado)
        DELETE FROM public.transacoes t
        WHERE t.organization_id = p_org_id
          AND (
              t.id = p_transacao_id
              OR (
                  t.status = 'PENDENTE'
                  AND t.data_vencimento >= v_atual.data_vencimento
                  AND (
                      (v_atual.recorrencia_id IS NOT NULL AND t.recorrencia_id = v_atual.recorrencia_id)
                      OR (v_atual.grupo_recorrencia_id IS NOT NULL AND t.grupo_recorrencia_id = v_atual.grupo_recorrencia_id)
                  )
              )
          );

        GET DIAGNOSTICS v_qtd_excluida = ROW_COUNT;

        -- 2. Encerra a regra-mãe para que a janela deslizante não gere novos meses
        IF v_atual.recorrencia_id IS NOT NULL THEN
            UPDATE public.obrigacoes_recorrentes
            SET ativo = FALSE,
                data_fim = (v_atual.data_vencimento - interval '1 day')::date
            WHERE id = v_atual.recorrencia_id
              AND organization_id = p_org_id;
        END IF;

    ELSE
        -- Exclui apenas a ocorrência selecionada
        DELETE FROM public.transacoes
        WHERE id = p_transacao_id AND organization_id = p_org_id;

        GET DIAGNOSTICS v_qtd_excluida = ROW_COUNT;
    END IF;

    RETURN jsonb_build_object(
        'sucesso', true,
        'qtd_excluida', v_qtd_excluida
    );
END;
$function$;


-- ============================================================================
-- 8. ATUALIZAÇÃO DE fn_listar_obrigacoes_recorrentes (INCLUINDO tipo_operacao, janela_meses, membro_id, membro_nome)
-- ============================================================================

DROP FUNCTION IF EXISTS public.fn_listar_obrigacoes_recorrentes(uuid, boolean);

CREATE OR REPLACE FUNCTION public.fn_listar_obrigacoes_recorrentes(
    p_org_id uuid,
    p_apenas_ativas boolean DEFAULT true
)
RETURNS TABLE(
    id uuid,
    organization_id uuid,
    descricao text,
    categoria_id uuid,
    categoria_nome text,
    centro_custo_id uuid,
    centro_custo_nome text,
    conta_bancaria_id uuid,
    conta_bancaria_nome text,
    periodicidade text,
    dia_vencimento integer,
    mes_vencimento integer,
    dias_antecedencia integer,
    valor_estimado numeric,
    ativo boolean,
    ultima_competencia_gerada date,
    tipo_operacao text,
    janela_meses integer,
    membro_id uuid,
    membro_nome text
)
LANGUAGE plpgsql
SECURITY DEFINER
AS $function$
BEGIN
    RETURN QUERY
    SELECT 
        o.id,
        o.organization_id,
        o.descricao,
        o.categoria_id,
        COALESCE(c.nome, 'Sem Categoria')::TEXT AS categoria_nome,
        o.centro_custo_id,
        COALESCE(cc.nome, 'Sem Centro de Custo')::TEXT AS centro_custo_nome,
        o.conta_bancaria_id,
        COALESCE(cb.nome, 'Não Definida')::TEXT AS conta_bancaria_nome,
        o.periodicidade,
        o.dia_vencimento,
        o.mes_vencimento,
        COALESCE(o.janela_meses, o.dias_antecedencia, 12)::integer AS dias_antecedencia,
        o.valor_estimado,
        o.ativo,
        o.ultima_competencia_gerada,
        COALESCE(o.tipo_operacao, 'DEBITO')::TEXT AS tipo_operacao,
        COALESCE(o.janela_meses, 12)::integer AS janela_meses,
        o.membro_id,
        COALESCE(m.nome_completo, 'Sem Membro')::TEXT AS membro_nome
    FROM public.obrigacoes_recorrentes o
    LEFT JOIN public.plano_contas c ON c.id = o.categoria_id 
    LEFT JOIN public.centros_custo cc ON cc.id = o.centro_custo_id 
    LEFT JOIN public.contas_bancarias cb ON cb.id = o.conta_bancaria_id
    LEFT JOIN public.membros m ON m.id = o.membro_id
    WHERE o.organization_id = p_org_id
      AND (NOT p_apenas_ativas OR o.ativo = TRUE)
    ORDER BY o.periodicidade DESC, o.dia_vencimento ASC;
END;
$function$;


-- ============================================================================
-- 9. AGENDAMENTO AUTOMÁTICO NO PG_CRON (SE DISPONÍVEL NO SUPABASE)
-- ============================================================================

DO $$
BEGIN
    IF EXISTS (SELECT 1 FROM pg_extension WHERE extname = 'pg_cron') THEN
        PERFORM cron.schedule(
            'lastro-gerador-recorrencias-diario',
            '0 3 * * *',
            $cron$SELECT public.fn_gerar_transacoes_recorrentes();$cron$
        );
    END IF;
EXCEPTION WHEN OTHERS THEN
    RAISE NOTICE 'pg_cron não disponível ou sem permissão de schedule: %', SQLERRM;
END $$;

NOTIFY pgrst, 'reload schema';

COMMIT;
