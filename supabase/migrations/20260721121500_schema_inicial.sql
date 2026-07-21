


SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;


CREATE SCHEMA IF NOT EXISTS "public";


ALTER SCHEMA "public" OWNER TO "pg_database_owner";


COMMENT ON SCHEMA "public" IS 'standard public schema';



CREATE OR REPLACE FUNCTION "public"."add_organization_member"("p_profile_id" "uuid", "p_org_id" "uuid", "p_funcao" "text") RETURNS json
    LANGUAGE "plpgsql" SECURITY DEFINER
    AS $$

BEGIN
  -- Se o usuário não existir no sistema, retorna um erro
  IF p_profile_id IS NULL THEN
    RETURN json_build_object('sucesso', false, 'mensagem', 'Usuário não encontrado. Peça para ele criar uma conta no app primeiro.');
  END IF;

  -- 2. Verifica se o usuário já está na organização para evitar duplicidade
  IF EXISTS (SELECT 1 FROM public.organization_members WHERE organization_id = p_org_id AND profile_id = p_profile_id) THEN
    RETURN json_build_object('sucesso', false, 'mensagem', 'Este usuário já faz parte da organização.');
  END IF;

  -- 3. Insere o usuário na organização com a função escolhida (operador, leitor, etc.)
  INSERT INTO public.organization_members (organization_id, profile_id, funcao)
  VALUES (p_org_id, p_profile_id, p_funcao);

  RETURN json_build_object('sucesso', true, 'mensagem', 'Membro adicionado com sucesso!');
END;
$$;


ALTER FUNCTION "public"."add_organization_member"("p_profile_id" "uuid", "p_org_id" "uuid", "p_funcao" "text") OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."check_finance_usage"() RETURNS "trigger"
    LANGUAGE "plpgsql"
    AS $$
BEGIN
  -- Verifica se existe transação vinculada ao registro que está sendo excluído
  IF (TG_TABLE_NAME = 'plano_contas') THEN
    IF EXISTS (SELECT 1 FROM public.transacoes WHERE plano_contas_id = OLD.id) THEN
      RAISE EXCEPTION 'Não é permitido excluir um Plano de Contas que possui transações. Desative-o em vez de excluir.';
    END IF;
  ELSIF (TG_TABLE_NAME = 'centros_custo') THEN
    IF EXISTS (SELECT 1 FROM public.transacoes WHERE centro_custo_id = OLD.id) THEN
      RAISE EXCEPTION 'Não é permitido excluir um Centro de Custo que possui transações. Desative-o em vez de excluir.';
    END IF;
  END IF;
  RETURN OLD;
END;
$$;


ALTER FUNCTION "public"."check_finance_usage"() OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."check_permite_lancamento"() RETURNS "trigger"
    LANGUAGE "plpgsql"
    AS $$
BEGIN
    IF (SELECT permite_lancamento FROM public.plano_contas WHERE id = NEW.conta_id) = FALSE THEN
        RAISE EXCEPTION 'Operação negada: A conta selecionada é sintética e não permite lançamentos diretos.';
    END IF;
    RETURN NEW;
END;
$$;


ALTER FUNCTION "public"."check_permite_lancamento"() OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."check_user_in_org"("org_id" "uuid") RETURNS boolean
    LANGUAGE "plpgsql" SECURITY DEFINER
    AS $$DECLARE
    v_user_id uuid;
    v_has_access boolean;
BEGIN
    -- 1. Pega o ID inofensificável do usuário que chamou a função
    v_user_id := auth.uid();

    -- 2. Se não tiver usuário logado, já nega direto
    IF v_user_id IS NULL THEN
        RETURN false;
    END IF;

    -- 3. Verifica no servidor se este usuário tem vínculo com a organização solicitada
    SELECT EXISTS (
        SELECT 1 
        FROM public.organization_members 
        WHERE profile_id = v_user_id 
          AND organization_id = check_user_in_org.org_id -- Usamos o nome original da variável aqui
    ) INTO v_has_access;

    RETURN v_has_access;
END;$$;


ALTER FUNCTION "public"."check_user_in_org"("org_id" "uuid") OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."create_my_organization"("org_name" "text", "org_type" "text", "p_user_id" "uuid") RETURNS json
    LANGUAGE "plpgsql" SECURITY DEFINER
    AS $$DECLARE
  new_org_id UUID;
BEGIN
  -- 1. Cria a Organização
  INSERT INTO public.organizations (nome, tipo)
  VALUES (org_name, org_type)
  RETURNING id INTO new_org_id;

  -- 2. Vincula o usuário passado pelo FlutterFlow como DONO
  INSERT INTO public.organization_members (organization_id, profile_id, funcao)
  VALUES (new_org_id, p_user_id, 'Dono');

  -- 3. Retorna o pacote completo em JSON mapeado para o App State do FlutterFlow
  RETURN json_build_object(
      'currentOrganizationId', new_org_id,
      'currentOrganizationType', org_type,
      'currentOrganizationName', org_name,
      'currentUser', p_user_id,
      'currentFunction', 'Dono',
      'currentPlanName', 'Gratuito' -- Ajuste este valor conforme o plano padrão do seu sistema
  );
END;$$;


ALTER FUNCTION "public"."create_my_organization"("org_name" "text", "org_type" "text", "p_user_id" "uuid") OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."fn_alertas_dashboard"("p_org_id" "uuid") RETURNS TABLE("qtd_vencidas" integer, "valor_vencidas" numeric, "qtd_hoje" integer, "valor_hoje" numeric, "qtd_faturas_cartao" integer, "valor_faturas_cartao" numeric, "qtd_cartoes_vencidos" integer, "valor_cartoes_vencidos" numeric, "qtd_cartoes_hoje" integer, "valor_cartoes_hoje" numeric, "qtd_cartoes_a_vencer" integer, "valor_cartoes_a_vencer" numeric, "proximo_melhor_dia_compra_global" "date", "limite_restante_total" numeric, "detalhes_cartoes" "jsonb")
    LANGUAGE "plpgsql" SECURITY DEFINER
    AS $$BEGIN
    --IF NOT public.check_user_in_org(p_org_id) THEN
    --    RAISE EXCEPTION 'Acesso negado: Usuário não autorizado para esta organização.';
    --END IF;

    RETURN QUERY
    WITH alertas_gerais AS (
        SELECT
            COALESCE(COUNT(t.id) FILTER (WHERE t.data_vencimento < CURRENT_DATE AND t.tipo_operacao IN ('DEBITO', 'DÉBITO') AND t.status <> 'CONCILIADO'), 0)::integer AS qtd_vencidas,
            COALESCE(SUM(t.valor) FILTER (WHERE t.data_vencimento < CURRENT_DATE AND t.tipo_operacao IN ('DEBITO', 'DÉBITO') AND t.status <> 'CONCILIADO'), 0)::numeric AS valor_vencidas,
            
            COALESCE(COUNT(t.id) FILTER (WHERE t.data_vencimento = CURRENT_DATE AND t.tipo_operacao IN ('DEBITO', 'DÉBITO') AND t.status <> 'CONCILIADO'), 0)::integer AS qtd_hoje,
            COALESCE(SUM(t.valor) FILTER (WHERE t.data_vencimento = CURRENT_DATE AND t.tipo_operacao IN ('DEBITO', 'DÉBITO') AND t.status <> 'CONCILIADO'), 0)::numeric AS valor_hoje,
            
            COALESCE(COUNT(t.id) FILTER (WHERE cb.tipo = 'CARTAO' AND t.data_pagamento IS NULL), 0)::integer AS qtd_faturas_cartao,
            COALESCE(SUM(t.valor) FILTER (WHERE cb.tipo = 'CARTAO' AND t.data_pagamento IS NULL), 0)::numeric AS valor_faturas_cartao,
            
            COALESCE(COUNT(t.id) FILTER (WHERE cb.tipo = 'CARTAO' AND t.data_pagamento IS NULL AND t.data_vencimento < CURRENT_DATE), 0)::integer AS qtd_cartoes_vencidos,
            COALESCE(SUM(t.valor) FILTER (WHERE cb.tipo = 'CARTAO' AND t.data_pagamento IS NULL AND t.data_vencimento < CURRENT_DATE), 0)::numeric AS valor_cartoes_vencidos,

            COALESCE(COUNT(t.id) FILTER (WHERE cb.tipo = 'CARTAO' AND t.data_pagamento IS NULL AND t.data_vencimento = CURRENT_DATE), 0)::integer AS qtd_cartoes_hoje,
            COALESCE(SUM(t.valor) FILTER (WHERE cb.tipo = 'CARTAO' AND t.data_pagamento IS NULL AND t.data_vencimento = CURRENT_DATE), 0)::numeric AS valor_cartoes_hoje,

            COALESCE(COUNT(t.id) FILTER (WHERE cb.tipo = 'CARTAO' AND t.data_pagamento IS NULL AND t.data_vencimento > CURRENT_DATE), 0)::integer AS qtd_cartoes_a_vencer,
            COALESCE(SUM(t.valor) FILTER (WHERE cb.tipo = 'CARTAO' AND t.data_pagamento IS NULL AND t.data_vencimento > CURRENT_DATE), 0)::numeric AS valor_cartoes_a_vencer
            
        FROM public.transacoes t
        LEFT JOIN public.contas_bancarias cb ON t.conta_bancaria_id = cb.id
        WHERE t.organization_id = p_org_id
    ),
    gastos_por_cartao AS (
        SELECT 
            t.conta_bancaria_id,
            SUM(t.valor) as gasto_total
        FROM public.transacoes t
        LEFT JOIN public.contas_bancarias cb ON t.conta_bancaria_id = cb.id
        WHERE t.organization_id = p_org_id
          AND cb.tipo = 'CARTAO'
          AND t.data_pagamento IS NULL
        GROUP BY t.conta_bancaria_id
    ),
    dados_cartoes_individuais AS (
        SELECT 
            cb.id,
            cb.nome,
            cb.limite_credito,
            GREATEST(cb.limite_credito - COALESCE(gpc.gasto_total, 0), 0) AS limite_restante,
            (
                CASE 
                    WHEN cb.dia_fechamento IS NULL THEN NULL 
                    WHEN EXTRACT(DAY FROM CURRENT_DATE) >= cb.dia_fechamento THEN
                        (DATE_TRUNC('month', CURRENT_DATE) + INTERVAL '1 month' + (cb.dia_fechamento::INT - 1) * INTERVAL '1 day' + INTERVAL '1 day')::date
                    ELSE
                        (DATE_TRUNC('month', CURRENT_DATE) + (cb.dia_fechamento::INT - 1) * INTERVAL '1 day' + INTERVAL '1 day')::date
                END
            ) AS melhor_dia_compra
        FROM public.contas_bancarias cb
        LEFT JOIN gastos_por_cartao gpc ON gpc.conta_bancaria_id = cb.id
        WHERE cb.organization_id = p_org_id
          AND cb.tipo = 'CARTAO'
          AND cb.ativo = true
    ),
    agregado_cartoes AS (
        SELECT 
            COALESCE(SUM(limite_credito), 0)::numeric AS limite_total_disponibilizado,
            MIN(melhor_dia_compra) AS proximo_melhor_dia_compra_global,
            COALESCE(jsonb_agg(
                jsonb_build_object(
                    'id', id,
                    'nome', nome,
                    'limite_total', limite_credito,
                    'limite_restante', limite_restante,
                    'melhor_dia_compra', melhor_dia_compra
                )
            ), '[]'::jsonb) AS json_cartoes
        FROM dados_cartoes_individuais
    )
    SELECT 
        a.qtd_vencidas,
        a.valor_vencidas,
        a.qtd_hoje,
        a.valor_hoje,
        a.qtd_faturas_cartao,
        a.valor_faturas_cartao,
        a.qtd_cartoes_vencidos,
        a.valor_cartoes_vencidos,
        
        a.qtd_cartoes_hoje,
        a.valor_cartoes_hoje,
        
        a.qtd_cartoes_a_vencer,
        a.valor_cartoes_a_vencer,
        ac.proximo_melhor_dia_compra_global,
        (GREATEST(ac.limite_total_disponibilizado - a.valor_faturas_cartao, 0))::numeric AS limite_restante_total,
        ac.json_cartoes AS detalhes_cartoes
    FROM alertas_gerais a
    CROSS JOIN agregado_cartoes ac;

END;$$;


ALTER FUNCTION "public"."fn_alertas_dashboard"("p_org_id" "uuid") OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."fn_autocura_saldos"() RETURNS "trigger"
    LANGUAGE "plpgsql" SECURITY DEFINER
    AS $$
DECLARE
    v_delta_origem numeric := 0;
    v_delta_destino numeric := 0;
    v_mes int;
    v_ano int;
BEGIN
    -- 1. Se for DELETE ou UPDATE, desfazemos o impacto da transação ANTIGA primeiro
    IF TG_OP = 'DELETE' OR TG_OP = 'UPDATE' THEN
        IF OLD.data_pagamento IS NOT NULL THEN
            v_mes := extract(month from OLD.data_pagamento)::int;
            v_ano := extract(year from OLD.data_pagamento)::int;

            -- Calcula o valor reverso (se era crédito, tira. Se era débito, devolve)
            IF OLD.tipo_operacao = 'CREDITO' THEN v_delta_origem := -OLD.valor;
            ELSIF OLD.tipo_operacao = 'DEBITO' THEN v_delta_origem := OLD.valor;
            ELSIF OLD.tipo_operacao = 'TRANSFERENCIA' THEN 
                v_delta_origem := OLD.valor; 
                v_delta_destino := -OLD.valor; 
            END IF;

            -- Desfaz na Origem
            IF OLD.conta_bancaria_id IS NOT NULL AND v_delta_origem <> 0 THEN
                UPDATE public.historico_saldos SET saldo_fechamento = saldo_fechamento + v_delta_origem
                WHERE conta_bancaria_id = OLD.conta_bancaria_id AND organization_id = OLD.organization_id
                AND (ano > v_ano OR (ano = v_ano AND mes >= v_mes));
            END IF;

            -- Desfaz no Destino (Transferências)
            IF OLD.conta_destino_id IS NOT NULL AND v_delta_destino <> 0 THEN
                UPDATE public.historico_saldos SET saldo_fechamento = saldo_fechamento + v_delta_destino
                WHERE conta_bancaria_id = OLD.conta_destino_id AND organization_id = OLD.organization_id
                AND (ano > v_ano OR (ano = v_ano AND mes >= v_mes));
            END IF;
            
            -- Zera os deltas para o próximo passo
            v_delta_origem := 0; v_delta_destino := 0;
        END IF;
    END IF;

    -- 2. Se for INSERT ou UPDATE, aplicamos o impacto da transação NOVA
    IF TG_OP = 'INSERT' OR TG_OP = 'UPDATE' THEN
        IF NEW.data_pagamento IS NOT NULL THEN
            v_mes := extract(month from NEW.data_pagamento)::int;
            v_ano := extract(year from NEW.data_pagamento)::int;

            -- Calcula o impacto
            IF NEW.tipo_operacao = 'CREDITO' THEN v_delta_origem := NEW.valor;
            ELSIF NEW.tipo_operacao = 'DEBITO' THEN v_delta_origem := -NEW.valor;
            ELSIF NEW.tipo_operacao = 'TRANSFERENCIA' THEN 
                v_delta_origem := -NEW.valor; 
                v_delta_destino := NEW.valor; 
            END IF;

            -- Aplica na Origem com UPSERT (Cria se não existir, atualiza se existir)
            IF NEW.conta_bancaria_id IS NOT NULL AND v_delta_origem <> 0 THEN
                INSERT INTO public.historico_saldos (organization_id, conta_bancaria_id, mes, ano, saldo_fechamento)
                VALUES (NEW.organization_id, NEW.conta_bancaria_id, v_mes, v_ano, v_delta_origem)
                ON CONFLICT (organization_id, conta_bancaria_id, mes, ano)
                DO UPDATE SET saldo_fechamento = historico_saldos.saldo_fechamento + EXCLUDED.saldo_fechamento, fechado_em = now();

                -- Propaga para o futuro
                UPDATE public.historico_saldos SET saldo_fechamento = saldo_fechamento + v_delta_origem
                WHERE conta_bancaria_id = NEW.conta_bancaria_id AND organization_id = NEW.organization_id
                AND (ano > v_ano OR (ano = v_ano AND mes > v_mes));
            END IF;

            -- Aplica no Destino com UPSERT (Transferências)
            IF NEW.conta_destino_id IS NOT NULL AND v_delta_destino <> 0 THEN
                INSERT INTO public.historico_saldos (organization_id, conta_bancaria_id, mes, ano, saldo_fechamento)
                VALUES (NEW.organization_id, NEW.conta_destino_id, v_mes, v_ano, v_delta_destino)
                ON CONFLICT (organization_id, conta_bancaria_id, mes, ano)
                DO UPDATE SET saldo_fechamento = historico_saldos.saldo_fechamento + EXCLUDED.saldo_fechamento, fechado_em = now();

                -- Propaga para o futuro
                UPDATE public.historico_saldos SET saldo_fechamento = saldo_fechamento + v_delta_destino
                WHERE conta_bancaria_id = NEW.conta_destino_id AND organization_id = NEW.organization_id
                AND (ano > v_ano OR (ano = v_ano AND mes > v_mes));
            END IF;
        END IF;
    END IF;

    RETURN NULL;
END;
$$;


ALTER FUNCTION "public"."fn_autocura_saldos"() OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."fn_detalhe_cr"("p_org_id" "uuid", "p_cr_id" "uuid", "p_data_inicio" "date", "p_data_fim" "date") RETURNS TABLE("transacaoid" "text", "descricao" "text", "valor" numeric, "tipooperacao" "text", "datacompetencia" "date", "datavencimento" "date", "datapagamento" "date", "contanome" "text", "tipo_conta" "text", "categorianome" "text")
    LANGUAGE "plpgsql"
    AS $$BEGIN
    RETURN QUERY
    SELECT 
        t.id::text AS transacaoid,
        COALESCE(t.descricao::text, '') AS descricao,
        t.valor::numeric,
        t.tipo_operacao::text AS tipooperacao,
        
        -- 1. CORREÇÃO DA DATA:
        -- Como Competência e Vencimento já são do tipo DATE no banco, 
        -- não aplicamos fuso horário. Entregamos a data pura.
        t.data_competencia AS datacompetencia,
        t.data_vencimento AS datavencimento,
        
        -- Pagamento é TIMESTAMP, então a conversão de fuso mantém-se vital aqui.
        (t.data_pagamento AT TIME ZONE 'America/Sao_Paulo')::date AS datapagamento,
        
        COALESCE(cb.nome::text, 'Não Informada') AS contanome,
        COALESCE(cb.tipo::text, 'ND') AS tipo_conta,
        pc.nome::text AS categorianome

    FROM public.transacoes t
    JOIN public.plano_contas pc ON pc.id = t.plano_contas_id
    LEFT JOIN public.contas_bancarias cb ON cb.id = t.conta_bancaria_id 
    WHERE t.organization_id = p_org_id
      AND t.centro_custo_id = p_cr_id
      
      -- 2. Garantia de SARGability e Filtro Perfeito do Último Dia
      AND t.data_pagamento >= (p_data_inicio AT TIME ZONE 'America/Sao_Paulo')
      AND t.data_pagamento <  ((p_data_fim + INTERVAL '1 day') AT TIME ZONE 'America/Sao_Paulo')
      
      AND t.status = 'CONCILIADO'
    ORDER BY t.data_pagamento DESC, t.criado_em DESC;
END;$$;


ALTER FUNCTION "public"."fn_detalhe_cr"("p_org_id" "uuid", "p_cr_id" "uuid", "p_data_inicio" "date", "p_data_fim" "date") OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."fn_gerar_transacoes_recorrentes"() RETURNS "void"
    LANGUAGE "plpgsql"
    AS $$DECLARE
    reg RECORD;
    data_vencimento_alvo DATE;
    data_competencia_alvo DATE;
    ultimo_dia_mes_atual INTEGER;
    ultimo_dia_mes_seguinte INTEGER;
    erro_mensagem text;
    erro_detalhe text;
BEGIN
    FOR reg IN 
        SELECT * FROM public.obrigacoes_recorrentes 
        WHERE ativo = TRUE 
        FOR UPDATE SKIP LOCKED
    LOOP
        BEGIN
            -- 1. CÁLCULO SEGURO DE DATAS (MENSAL)
            IF reg.periodicidade = 'MENSAL' THEN
                ultimo_dia_mes_atual := EXTRACT(DAY FROM (date_trunc('month', current_date) + interval '1 month' - interval '1 day'))::integer;
                data_vencimento_alvo := date_trunc('month', current_date)::date + (LEAST(reg.dia_vencimento, ultimo_dia_mes_atual) - 1);
                data_competencia_alvo := date_trunc('month', current_date)::date;
                
                IF data_vencimento_alvo < current_date THEN
                    ultimo_dia_mes_seguinte := EXTRACT(DAY FROM (date_trunc('month', current_date + interval '1 month') + interval '1 month' - interval '1 day'))::integer;
                    data_vencimento_alvo := date_trunc('month', current_date + interval '1 month')::date + (LEAST(reg.dia_vencimento, ultimo_dia_mes_seguinte) - 1);
                    data_competencia_alvo := date_trunc('month', current_date + interval '1 month')::date;
                END IF;

            -- 2. CÁLCULO SEGURO DE DATAS (ANUAL)
            ELSIF reg.periodicidade = 'ANUAL' THEN
                BEGIN
                    data_vencimento_alvo := make_date(cast(extract(year from current_date) as int), reg.mes_vencimento, reg.dia_vencimento);
                EXCEPTION WHEN datetime_field_overflow THEN
                    data_vencimento_alvo := make_date(cast(extract(year from current_date) as int), reg.mes_vencimento, 28);
                END;
                data_competencia_alvo := data_vencimento_alvo;
            END IF;

            -- 3. A LÓGICA DE DISPARO E INJEÇÃO
            IF current_date >= (data_vencimento_alvo - reg.dias_antecedencia) 
               AND (reg.ultima_competencia_gerada IS NULL OR reg.ultima_competencia_gerada < data_competencia_alvo) THEN
                
                -- [CORREÇÃO] Injeção estrita baseada na DDL de public.transacoes
                INSERT INTO public.transacoes (
                    organization_id, 
                    descricao, 
                    valor,             -- Alterado para respeitar check (valor > 0)
                    data_pagamento, 
                    data_vencimento,   
                    data_competencia,  
                    tipo_operacao, 
                    status, 
                    plano_contas_id,   
                    centro_custo_id, 
                    conta_bancaria_id, 
                    criado_em,
                    grupo_recorrencia_id 
                ) VALUES (
                    reg.organization_id,
                    reg.descricao || ' (Automático)',
                    ABS(reg.valor_estimado),  -- <-- SINAL NEGATIVO REMOVIDO AQUI
                    NULL, 
                    data_vencimento_alvo, 
                    data_competencia_alvo,
                    'DEBITO',
                    'PENDENTE', 
                    reg.categoria_id,
                    reg.centro_custo_id, 
                    reg.conta_bancaria_id,
                    now(),
                    reg.id::text 
                );

                UPDATE public.obrigacoes_recorrentes 
                SET ultima_competencia_gerada = data_competencia_alvo 
                WHERE id = reg.id;
                
            END IF;

        EXCEPTION WHEN OTHERS THEN
            GET STACKED DIAGNOSTICS erro_mensagem = MESSAGE_TEXT, erro_detalhe = PG_EXCEPTION_DETAIL;
            RAISE WARNING 'Falha crítica na Obrigação %: Mensagem: %, Detalhe: %', reg.id, erro_mensagem, erro_detalhe;
        END;
    END LOOP;
END;$$;


ALTER FUNCTION "public"."fn_gerar_transacoes_recorrentes"() OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."fn_grafico_dfc_diario"("p_org_id" "uuid", "p_data_inicio" "date", "p_data_fim" "date") RETURNS TABLE("dia" "text", "total_entradas" numeric, "total_saidas" numeric, "is_predicao" boolean, "tendencia_entradas" numeric)
    LANGUAGE "plpgsql" SECURITY DEFINER
    AS $$
BEGIN
    -- Validação de Segurança Organizacional
    IF NOT public.check_user_in_org(p_org_id) THEN
        RAISE EXCEPTION 'Acesso negado: Usuário não autorizado.';
    END IF;

    RETURN QUERY
    WITH 
    -- 1. Calendário de Exibição
    calendario AS (
        SELECT generate_series(
            p_data_inicio, 
            CASE 
                WHEN p_data_fim >= CURRENT_DATE THEN CURRENT_DATE + 14 
                ELSE p_data_fim 
            END, 
            '1 day'::interval
        )::date AS data_ref
    ),

    -- 2. Histórico Amplo de Amostragem (180 dias para robustez do ciclo mensal)
    historico_base AS (
        SELECT 
            t.data_pagamento::date AS data_movimento,
            EXTRACT(MONTH FROM t.data_pagamento::date) AS mes,
            EXTRACT(ISODOW FROM t.data_pagamento::date) AS dia_semana,
            EXTRACT(DAY FROM t.data_pagamento::date) AS dia_mes,
            SUM(t.valor) FILTER (WHERE t.tipo_operacao = 'CREDITO') AS entradas,
            SUM(t.valor) FILTER (WHERE t.tipo_operacao = 'DEBITO') AS saidas
        FROM public.transacoes t
        LEFT JOIN public.plano_contas pc ON t.plano_contas_id = pc.id
        LEFT JOIN public.contas_bancarias cb ON t.conta_bancaria_id = cb.id
        WHERE t.organization_id = p_org_id
          AND t.status = 'CONCILIADO'
          AND t.tipo_operacao IN ('CREDITO', 'DEBITO')
          AND pc.codigo_contabil IS DISTINCT FROM '9.9.99'
          AND cb.tipo IS DISTINCT FROM 'VIRTUAL'
          AND t.data_pagamento::date >= (CURRENT_DATE - 180)
        GROUP BY t.data_pagamento::date
    ),

    -- 3. CÁCULO DA MÉDIA GLOBAL DE REFERÊNCIA
    stats_globais AS (
        SELECT COALESCE(NULLIF(AVG(entradas), 0), 1) as media_diaria_global
        FROM historico_base
        WHERE data_movimento <= CURRENT_DATE
    ),

    -- 4. SAZONALIDADE MACRO (Mês do Ano Passado - YoY)
    fator_macro AS (
        SELECT 
            mes,
            GREATEST(0.7, LEAST(1.5, AVG(entradas) / (SELECT media_diaria_global FROM stats_globais))) as peso_mes
        FROM historico_base
        WHERE data_movimento BETWEEN (CURRENT_DATE - 365) AND (CURRENT_DATE - 1)
        GROUP BY mes
    ),

    -- 5. SAZONALIDADE MICRO (Dia da Semana - Semanas Recentes)
    fator_micro AS (
        SELECT 
            dia_semana,
            GREATEST(0.2, AVG(entradas) / (SELECT media_diaria_global FROM stats_globais)) as peso_semana
        FROM historico_base
        WHERE data_movimento >= (CURRENT_DATE - 56) AND data_movimento <= CURRENT_DATE
        GROUP BY dia_semana
    ),

    -- 6. SAZONALIDADE INTRA-MÊS (O Segredo: Janela Móvel sobre os dias 1 a 31)
    medias_puras_dia_mes AS (
        SELECT 
            dia_mes,
            AVG(COALESCE(entradas, 0)) as media_pura
        FROM historico_base
        WHERE data_movimento <= CURRENT_DATE
        GROUP BY dia_mes
    ),
    fator_intra_mes AS (
        SELECT 
            dia_mes,
            -- Filtro Matemático: Suaviza o dia com os seus vizinhos para absorver desvios de fins de semana
            AVG(media_pura) OVER (
                ORDER BY dia_mes 
                ROWS BETWEEN 1 PRECEDING AND 1 FOLLOWING
            ) / (SELECT media_diaria_global FROM stats_globais) as peso_dia_mes
        FROM medias_puras_dia_mes
    ),

    -- 7. ÂNCORA NOMINAL ATUAL (Volume de base desprovido de ruído dos últimos 28 dias)
    ancora_volume AS (
        SELECT COALESCE(AVG(entradas), (SELECT media_diaria_global FROM stats_globais)) as volume_base
        FROM historico_base
        WHERE data_movimento >= (CURRENT_DATE - 28) AND data_movimento <= CURRENT_DATE
    ),

    -- 8. ALINHAMENTO DA SÉRIE TEMPORAL DO GRÁFICO
    serie_consolidada AS (
        SELECT
            c.data_ref,
            EXTRACT(MONTH FROM c.data_ref) as mes_ref,
            EXTRACT(ISODOW FROM c.data_ref) as dia_semana_ref,
            EXTRACT(DAY FROM c.data_ref) as dia_mes_ref,
            COALESCE(h.entradas, 0) as reais_entradas,
            COALESCE(h.saidas, 0) as reais_saidas
        FROM calendario c
        LEFT JOIN historico_base h ON c.data_ref = h.data_movimento
    ),

    tendencia_passado AS (
        SELECT 
            data_ref,
            AVG(reais_entradas) OVER (ORDER BY data_ref ROWS BETWEEN 6 PRECEDING AND CURRENT ROW) as mm_7d
        FROM serie_consolidada
    )

    -- 9. PROCESSAMENTO E ENTREGA ANALÍTICA
    SELECT 
        to_char(s.data_ref, 'YYYY-MM-DD') AS dia,
        CASE WHEN s.data_ref > CURRENT_DATE THEN 0 ELSE s.reais_entradas END::numeric AS total_entradas,
        CASE WHEN s.data_ref > CURRENT_DATE THEN 0 ELSE s.reais_saidas END::numeric AS total_saidas,
        (s.data_ref > CURRENT_DATE) AS is_predicao,
        CASE 
            -- PASSADO: Rastreamento dinâmico próximo às barras executadas
            WHEN s.data_ref <= CURRENT_DATE THEN 
                COALESCE(tp.mm_7d, s.reais_entradas)
            
            -- FUTURO: Âncora * Dia da Semana * Curva de Densidade do Dia do Mês * Filtro Anual
            ELSE 
                (SELECT volume_base FROM ancora_volume)
                * COALESCE((SELECT peso_semana FROM fator_micro WHERE dia_semana = s.dia_semana_ref), 1)
                * COALESCE((SELECT peso_dia_mes FROM fator_intra_mes WHERE dia_mes = s.dia_mes_ref), 0)
                * COALESCE((SELECT peso_mes FROM fator_macro WHERE mes = s.mes_ref), 1)
        END::numeric AS tendencia_entradas
    FROM serie_consolidada s
    LEFT JOIN tendencia_passado tp ON s.data_ref = tp.data_ref
    ORDER BY s.data_ref ASC;
END;
$$;


ALTER FUNCTION "public"."fn_grafico_dfc_diario"("p_org_id" "uuid", "p_data_inicio" "date", "p_data_fim" "date") OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."fn_grafico_dfc_predicao"("p_organization_id" "uuid", "p_dias_historico" integer DEFAULT 56, "p_dias_predicao" integer DEFAULT 14) RETURNS TABLE("dia" "date", "total_entradas" numeric, "total_saidas" numeric, "is_predicao" boolean, "tendencia_entradas" numeric)
    LANGUAGE "sql" SECURITY DEFINER
    AS $$
WITH 
calendario AS (
    SELECT generate_series(
        CURRENT_DATE - p_dias_historico, 
        CURRENT_DATE + p_dias_predicao, 
        '1 day'::interval
    )::date as data_ref
),

movimentos AS (
    SELECT
        t.data_pagamento::date as data_ref,
        SUM(CASE WHEN t.tipo_operacao = 'CREDITO' THEN t.valor ELSE 0 END) as entradas,
        SUM(CASE WHEN t.tipo_operacao = 'DEBITO' THEN t.valor ELSE 0 END) as saidas
    FROM public.transacoes t
    -- INNER JOIN Essencial: A trava de segurança chk_transacao_paga_exige_conta 
    -- garante que registros CONCILIADOS sempre possuem conta_bancaria_id válida.
    INNER JOIN public.contas_bancarias cb ON t.conta_bancaria_id = cb.id
    WHERE t.organization_id = p_organization_id
      AND t.status = 'CONCILIADO'
      AND cb.tipo <> 'VIRTUAL' -- AQUI ESTÁ A CORREÇÃO CONTÁBIL: Expurgando contas virtuais
      AND t.tipo_operacao IN ('CREDITO', 'DEBITO')
      AND t.data_pagamento >= (CURRENT_DATE - p_dias_historico)
    GROUP BY 1
),

series AS (
    SELECT
        c.data_ref,
        COALESCE(m.entradas, 0) as entradas,
        COALESCE(m.saidas, 0) as saidas,
        EXTRACT(ISODOW FROM c.data_ref) as dia_semana
    FROM calendario c
    LEFT JOIN movimentos m ON c.data_ref = m.data_ref
),

stats_globais AS (
    SELECT COALESCE(NULLIF(AVG(entradas), 0), 1) as media_global 
    FROM series 
    WHERE data_ref <= CURRENT_DATE
),

fatores_semanais AS (
    SELECT 
        dia_semana,
        GREATEST(0.20, AVG(entradas) / (SELECT media_global FROM stats_globais)) as multiplicador
    FROM series
    WHERE data_ref <= CURRENT_DATE
    GROUP BY dia_semana
),

tendencia_base AS (
    SELECT 
        data_ref,
        AVG(entradas) OVER (ORDER BY data_ref ROWS BETWEEN 27 PRECEDING AND CURRENT ROW) as trend_macro
    FROM series
    WHERE data_ref <= CURRENT_DATE
),

ancora AS (
    SELECT trend_macro 
    FROM tendencia_base 
    WHERE data_ref <= CURRENT_DATE 
    ORDER BY data_ref DESC 
    LIMIT 1
)

SELECT
    s.data_ref as dia,
    s.entradas::NUMERIC as total_entradas,
    s.saidas::NUMERIC as total_saidas,
    (s.data_ref > CURRENT_DATE) as is_predicao,
    CASE 
        -- PASSADO/PRESENTE
        WHEN s.data_ref <= CURRENT_DATE THEN 
            COALESCE(
                (SELECT t.trend_macro FROM tendencia_base t WHERE t.data_ref = s.data_ref), 
                (SELECT media_global FROM stats_globais)
            ) * COALESCE(fs.multiplicador, 1)
        
        -- FUTURO PREDITIVO
        ELSE 
            COALESCE(
                (SELECT trend_macro FROM ancora), 
                (SELECT media_global FROM stats_globais)
            ) * COALESCE(fs.multiplicador, 1)
    END::NUMERIC as tendencia_entradas
FROM series s
LEFT JOIN fatores_semanais fs ON s.dia_semana = fs.dia_semana
ORDER BY s.data_ref ASC;
$$;


ALTER FUNCTION "public"."fn_grafico_dfc_predicao"("p_organization_id" "uuid", "p_dias_historico" integer, "p_dias_predicao" integer) OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."fn_grafico_dre_diario"("p_org_id" "uuid", "p_data_inicio" "date", "p_data_fim" "date") RETURNS TABLE("dia" "text", "total_receitas" numeric, "total_despesas" numeric)
    LANGUAGE "plpgsql" SECURITY DEFINER
    AS $$
BEGIN
    -- 1. Validação de Segurança
    IF NOT public.check_user_in_org(p_org_id) THEN
        RAISE EXCEPTION 'Acesso negado: Usuário não autorizado para esta organização.';
    END IF;

    -- 2. Geração da Série Temporal e Agrupamento
    RETURN QUERY
    WITH calendario AS (
        -- Cria uma linha para CADA dia dentro do intervalo solicitado (O eixo X perfeito)
        SELECT generate_series(p_data_inicio, p_data_fim, '1 day'::interval)::date AS data_calendario
    ),
    dados_diarios AS (
        -- Consome APENAS da View base, mantendo a mesma regra do DRE e do Rollup
        SELECT 
            v.data_competencia_real,
            COALESCE(SUM(v.valor_absoluto) FILTER (WHERE v.tipo_conta = 'RECEITA'), 0) AS receitas,
            COALESCE(SUM(v.valor_absoluto) FILTER (WHERE v.tipo_conta = 'DESPESA'), 0) AS despesas
        FROM public.vw_transacoes_competencia v
        WHERE v.organization_id = p_org_id
          AND v.data_competencia_real >= p_data_inicio
          AND v.data_competencia_real <= p_data_fim
        GROUP BY v.data_competencia_real
    )
    SELECT 
        to_char(c.data_calendario, 'DD/MM') AS dia,
        COALESCE(d.receitas, 0)::numeric AS total_receitas,
        COALESCE(d.despesas, 0)::numeric AS total_despesas
    FROM calendario c
    LEFT JOIN dados_diarios d ON c.data_calendario = d.data_competencia_real
    ORDER BY c.data_calendario ASC; -- Garante a ordem cronológica estrita da esquerda para a direita no gráfico
END;
$$;


ALTER FUNCTION "public"."fn_grafico_dre_diario"("p_org_id" "uuid", "p_data_inicio" "date", "p_data_fim" "date") OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."fn_listar_obrigacoes_recorrentes"("p_org_id" "uuid", "p_apenas_ativas" boolean DEFAULT true) RETURNS TABLE("id" "uuid", "organization_id" "uuid", "descricao" "text", "categoria_id" "uuid", "categoria_nome" "text", "centro_custo_id" "uuid", "centro_custo_nome" "text", "conta_bancaria_id" "uuid", "conta_bancaria_nome" "text", "periodicidade" "text", "dia_vencimento" integer, "mes_vencimento" integer, "dias_antecedencia" integer, "valor_estimado" numeric, "ativo" boolean, "ultima_competencia_gerada" "date")
    LANGUAGE "plpgsql" SECURITY DEFINER
    AS $$BEGIN
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
        o.dias_antecedencia,
        o.valor_estimado,
        o.ativo,
        o.ultima_competencia_gerada
    FROM public.obrigacoes_recorrentes o
    -- AJUSTE OS NOMES AQUI PARA O PADRÃO EXATO DO SEU SUPABASE
    LEFT JOIN public.plano_contas c ON c.id = o.categoria_id 
    LEFT JOIN public.centros_custo cc ON cc.id = o.centro_custo_id 
    LEFT JOIN public.contas_bancarias cb ON cb.id = o.conta_bancaria_id
    WHERE o.organization_id = p_org_id
      AND (NOT p_apenas_ativas OR o.ativo = TRUE)
    ORDER BY o.periodicidade DESC, o.dia_vencimento ASC;
END;$$;


ALTER FUNCTION "public"."fn_listar_obrigacoes_recorrentes"("p_org_id" "uuid", "p_apenas_ativas" boolean) OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."fn_relatorio_cr_analitico"("p_org_id" "uuid", "p_data_inicio" "date", "p_data_fim" "date") RETURNS TABLE("cc_id" "uuid", "cc_nome" "text", "cor_hex" "text", "permite_acumulo" boolean, "is_fundo" boolean, "is_padrao" boolean, "ativo" boolean, "calc_despesa" numeric, "calc_receita" numeric, "calc_subsidio_recebido" numeric, "calc_subsidio_concedido" numeric, "calc_subsidio" numeric, "saldo_caixa" numeric, "autossuficiencia" numeric)
    LANGUAGE "plpgsql" SECURITY DEFINER
    AS $$
DECLARE
    v_inicio_exercicio date;
BEGIN
    -- Validação de Segurança (Fail-Fast)
    IF NOT public.check_user_in_org(p_org_id) THEN 
        RAISE EXCEPTION 'Acesso negado.';
    END IF;

    -- Início do ano contabilístico
    v_inicio_exercicio := DATE_TRUNC('year', p_data_inicio)::date;

    RETURN QUERY
    WITH cr_movimentacao AS (
        SELECT 
            cc.id AS cc_id,
            cc.nome::text AS cc_nome,
            cc.cor_hex::text AS cor_hex,
            cc.permite_acumulo,
            cc.is_fundo,
            cc.is_padrao,
            cc.ativo,
            
            -- 1. DESPESAS E RECEITAS OPERACIONAIS
            COALESCE(SUM(t.valor) FILTER (
                WHERE t.tipo_operacao IN ('DEBITO', 'DÉBITO') 
                  AND pc.codigo_contabil != '9.9.99'
                  AND t.data_pagamento >= p_data_inicio::timestamp
            ), 0) AS calc_despesa,
            
            COALESCE(SUM(t.valor) FILTER (
                WHERE t.tipo_operacao IN ('CREDITO', 'CRÉDITO') 
                  AND pc.codigo_contabil != '9.9.99'
                  AND t.data_pagamento >= p_data_inicio::timestamp
            ), 0) AS calc_receita,
            
            -- 2. SEPARAÇÃO ESTRITA DE SUBSÍDIOS (Fim do Acoplamento Semântico)
            COALESCE(SUM(t.valor) FILTER (
                WHERE t.tipo_operacao IN ('CREDITO', 'CRÉDITO') 
                  AND pc.codigo_contabil = '9.9.99'
                  AND t.data_pagamento >= p_data_inicio::timestamp
            ), 0) AS calc_subsidio_recebido,
            
            COALESCE(SUM(t.valor) FILTER (
                WHERE t.tipo_operacao IN ('DEBITO', 'DÉBITO') 
                  AND pc.codigo_contabil = '9.9.99'
                  AND t.data_pagamento >= p_data_inicio::timestamp
            ), 0) AS calc_subsidio_concedido,
            
            -- 3. SALDO ACUMULADO (Exercício Fiscal)
            COALESCE(SUM(
                CASE 
                    WHEN t.tipo_operacao IN ('CREDITO', 'CRÉDITO') THEN t.valor 
                    ELSE -t.valor 
                END
            ) FILTER (
                WHERE t.data_pagamento >= v_inicio_exercicio::timestamp
            ), 0) AS calc_saldo_exercicio
            
        FROM public.centros_custo cc
        LEFT JOIN public.transacoes t 
            ON t.centro_custo_id = cc.id 
            AND t.organization_id = p_org_id
            AND t.status = 'CONCILIADO'
            AND t.data_pagamento < (p_data_fim + INTERVAL '1 day')::timestamp
        LEFT JOIN public.plano_contas pc 
            ON pc.id = t.plano_contas_id
        WHERE cc.organization_id = p_org_id AND cc.ativo = true
        GROUP BY cc.id, cc.nome, cc.cor_hex, cc.permite_acumulo, cc.is_fundo, cc.is_padrao, cc.ativo
    )
    SELECT 
        cm.cc_id,
        cm.cc_nome,
        cm.cor_hex,
        cm.permite_acumulo,
        cm.is_fundo,
        cm.is_padrao,
        cm.ativo,
        cm.calc_despesa::numeric,
        cm.calc_receita::numeric,
        
        -- Exportamos as colunas limpas para a UI
        cm.calc_subsidio_recebido::numeric,
        cm.calc_subsidio_concedido::numeric,
        (cm.calc_subsidio_recebido - cm.calc_subsidio_concedido)::numeric AS calc_subsidio,
        
        -- O Saldo Híbrido Final
        CASE 
            WHEN cm.permite_acumulo = true THEN cm.calc_saldo_exercicio::numeric
            ELSE ((cm.calc_receita + cm.calc_subsidio_recebido) - (cm.calc_despesa + cm.calc_subsidio_concedido))::numeric 
        END AS saldo_caixa,
        
        -- Autossuficiência 
        CASE 
            WHEN cm.calc_despesa = 0 AND cm.calc_receita > 0 THEN 100.00
            WHEN cm.calc_despesa = 0 THEN 0.00
            ELSE ROUND(((cm.calc_receita / cm.calc_despesa) * 100), 2)
        END::numeric AS autossuficiencia
        
    FROM cr_movimentacao cm
    ORDER BY cm.cc_nome ASC;
END;
$$;


ALTER FUNCTION "public"."fn_relatorio_cr_analitico"("p_org_id" "uuid", "p_data_inicio" "date", "p_data_fim" "date") OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."fn_relatorio_cr_sintetico"("p_org_id" "uuid", "p_data_inicio" "date", "p_data_fim" "date") RETURNS TABLE("total_arrecadado" numeric, "subsidios_concedidos" numeric, "subsidios_recebidos" numeric, "subsidios_alocados" numeric, "despesas_proprias" numeric, "saldo_disponivel" numeric, "saude_orcamentaria" numeric)
    LANGUAGE "plpgsql" SECURITY DEFINER
    AS $$
BEGIN
    RETURN QUERY
    WITH movimentos_fundo_geral AS (
        SELECT 
            -- 1. ARRECADAÇÃO GLOBAL (Apenas Dinheiro Operacional Real)
            COALESCE(SUM(t.valor) FILTER (
                WHERE t.tipo_operacao IN ('CREDITO', 'CRÉDITO') 
                  AND pc.codigo_contabil != '9.9.99'
            ), 0) AS arrecadacao_total,
            
            -- 2. SUBSÍDIOS CONCEDIDOS (Saídas do Fundo Geral para projetos)
            COALESCE(SUM(t.valor) FILTER (
                WHERE t.tipo_operacao IN ('DEBITO', 'DÉBITO') 
                  AND pc.codigo_contabil = '9.9.99'
            ), 0) AS sub_concedidos,
            
            -- 3. SUBSÍDIOS RECEBIDOS (Repasses de lucro de eventos ou estornos)
            COALESCE(SUM(t.valor) FILTER (
                WHERE t.tipo_operacao IN ('CREDITO', 'CRÉDITO') 
                  AND pc.codigo_contabil = '9.9.99'
            ), 0) AS sub_recebidos,
            
            -- 4. DESPESAS DIRETAS (Gastos diretos da Matriz)
            COALESCE(SUM(t.valor) FILTER (
                WHERE t.tipo_operacao IN ('DEBITO', 'DÉBITO') 
                  AND pc.codigo_contabil != '9.9.99'
            ), 0) AS despesas_fundo
            
        FROM public.transacoes t
        LEFT JOIN public.plano_contas pc ON pc.id = t.plano_contas_id
        LEFT JOIN public.centros_custo cc ON cc.id = t.centro_custo_id
        WHERE t.organization_id = p_org_id
          AND t.status = 'CONCILIADO'
          
          -- Filtro temporal com tipagem pura agnóstica
          AND t.data_pagamento >= p_data_inicio::timestamp
          AND t.data_pagamento < (p_data_fim + INTERVAL '1 day')::timestamp
          
          AND cc.is_fundo = true
    )
    SELECT 
        m.arrecadacao_total::numeric,
        m.sub_concedidos::numeric,
        m.sub_recebidos::numeric,
        (m.sub_concedidos - m.sub_recebidos)::numeric AS subsidios_alocados,
        m.despesas_fundo::numeric,
        
        -- O saldo matemático exato do Fundo
        (m.arrecadacao_total + m.sub_recebidos - m.sub_concedidos - m.despesas_fundo)::numeric AS saldo_disponivel,
        
        -- Saúde Global
        CASE 
            WHEN (m.arrecadacao_total + m.sub_recebidos) = 0 THEN 0.00
            ELSE ROUND((((m.arrecadacao_total + m.sub_recebidos - m.sub_concedidos - m.despesas_fundo) / (m.arrecadacao_total + m.sub_recebidos)) * 100), 2)
        END::numeric AS saude_orcamentaria
        
    FROM movimentos_fundo_geral m;
END;
$$;


ALTER FUNCTION "public"."fn_relatorio_cr_sintetico"("p_org_id" "uuid", "p_data_inicio" "date", "p_data_fim" "date") OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."fn_relatorio_cr_sintetico_por_id"("p_org_id" "uuid", "p_data_inicio" "date", "p_data_fim" "date", "p_centro_custo_id" "uuid") RETURNS TABLE("total_arrecadado" numeric, "subsidios_concedidos" numeric, "subsidios_recebidos" numeric, "subsidios_alocados" numeric, "despesas_proprias" numeric, "saldo_disponivel" numeric, "saude_orcamentaria" numeric)
    LANGUAGE "plpgsql" SECURITY DEFINER
    AS $$
DECLARE
    v_inicio_exercicio date;
    v_permite_acumulo boolean;
BEGIN
    -- Trava de segurança multi-tenant
    IF NOT public.check_user_in_org(p_org_id) THEN
        RAISE EXCEPTION 'Acesso negado: Usuário não autorizado.';
    END IF;

    -- 1. Busca a regra de negócio específica deste Centro de Custo
    SELECT permite_acumulo INTO v_permite_acumulo
    FROM public.centros_custo
    WHERE id = p_centro_custo_id AND organization_id = p_org_id;

    -- Fallback de segurança caso o CR não exista
    IF v_permite_acumulo IS NULL THEN
        v_permite_acumulo := false;
    END IF;

    -- 2. Define o início do ano contábil (Se quiser acúmulo infinito, remova esta trava no futuro)
    v_inicio_exercicio := DATE_TRUNC('year', p_data_inicio)::date;

    RETURN QUERY
    WITH movimentos AS (
        SELECT 
            -- ==========================================
            -- BLOCO A: MÉTRICAS DO PERÍODO EXATO (Performance)
            -- Só contabiliza se a data for >= p_data_inicio
            -- ==========================================
            COALESCE(SUM(t.valor) FILTER (
                WHERE t.tipo_operacao IN ('CREDITO', 'CRÉDITO') 
                  AND pc.codigo_contabil != '9.9.99'
                  AND t.data_pagamento >= p_data_inicio::timestamp
            ), 0) AS arrecadacao_periodo,
            
            COALESCE(SUM(t.valor) FILTER (
                WHERE t.tipo_operacao IN ('DEBITO', 'DÉBITO') 
                  AND pc.codigo_contabil = '9.9.99'
                  AND t.data_pagamento >= p_data_inicio::timestamp
            ), 0) AS sub_concedido_periodo,
            
            COALESCE(SUM(t.valor) FILTER (
                WHERE t.tipo_operacao IN ('CREDITO', 'CRÉDITO') 
                  AND pc.codigo_contabil = '9.9.99'
                  AND t.data_pagamento >= p_data_inicio::timestamp
            ), 0) AS sub_recebido_periodo,
            
            COALESCE(SUM(t.valor) FILTER (
                WHERE t.tipo_operacao IN ('DEBITO', 'DÉBITO') 
                  AND pc.codigo_contabil != '9.9.99'
                  AND t.data_pagamento >= p_data_inicio::timestamp
            ), 0) AS despesa_periodo,

            -- ==========================================
            -- BLOCO B: MÉTRICA DE ACÚMULO (Reserva de Caixa)
            -- Contabiliza tudo desde o início do ano
            -- ==========================================
            COALESCE(SUM(
                CASE 
                    WHEN t.tipo_operacao IN ('CREDITO', 'CRÉDITO') THEN t.valor 
                    ELSE -t.valor 
                END
            ) FILTER (
                WHERE t.data_pagamento >= v_inicio_exercicio::timestamp
            ), 0) AS saldo_acumulado_ano
            
        FROM public.transacoes t
        LEFT JOIN public.plano_contas pc ON pc.id = t.plano_contas_id
        WHERE t.organization_id = p_org_id
          AND t.centro_custo_id = p_centro_custo_id
          AND t.status = 'CONCILIADO'
          
          -- A varredura da tabela vai até ao fim do período solicitado...
          AND t.data_pagamento < (p_data_fim + INTERVAL '1 day')::timestamp
          
          -- ...mas recua até o início do ano para garantir o cálculo do Acumulado (Bloco B)
          AND t.data_pagamento >= v_inicio_exercicio::timestamp
    )
    SELECT 
        m.arrecadacao_periodo::numeric AS total_arrecadado,
        m.sub_concedido_periodo::numeric AS subsidios_concedidos,
        m.sub_recebido_periodo::numeric AS subsidios_recebidos,
        (m.sub_concedido_periodo - m.sub_recebido_periodo)::numeric AS subsidios_alocados,
        m.despesa_periodo::numeric AS despesas_proprias,
        
        -- A MÁGICA DA INTEGRAÇÃO: Saldo Híbrido baseado na regra do CR
        CASE 
            WHEN v_permite_acumulo = true THEN m.saldo_acumulado_ano::numeric
            ELSE ((m.arrecadacao_periodo + m.sub_recebido_periodo) - (m.despesa_periodo + m.sub_concedido_periodo))::numeric
        END AS saldo_disponivel,
        
        -- Saúde Orçamentária
        -- Nota Crítica: A Saúde SEMPRE avalia a performance do mês, nunca do ano.
        -- Uma máquina doente que queima muito dinheiro hoje não pode ser mascarada por reservas antigas.
        CASE 
            WHEN (m.arrecadacao_periodo + m.sub_recebido_periodo) = 0 THEN 0.00
            ELSE ROUND((((m.arrecadacao_periodo + m.sub_recebido_periodo - m.sub_concedido_periodo - m.despesa_periodo) / (m.arrecadacao_periodo + m.sub_recebido_periodo)) * 100), 2)
        END::numeric AS saude_orcamentaria
        
    FROM movimentos m;
END;
$$;


ALTER FUNCTION "public"."fn_relatorio_cr_sintetico_por_id"("p_org_id" "uuid", "p_data_inicio" "date", "p_data_fim" "date", "p_centro_custo_id" "uuid") OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."fn_relatorio_dfc_analitico"("p_org_id" "uuid", "p_data_inicio" "date", "p_data_fim" "date") RETURNS TABLE("ordem" integer, "tipo_linha" "text", "conta_id" "uuid", "conta_codigo" "text", "conta_nome" "text", "conta_tipo" "text", "descricao" "text", "entradas" numeric, "saidas" numeric, "saldo" numeric)
    LANGUAGE "plpgsql" SECURITY DEFINER
    AS $$DECLARE
    v_saldo_abertura_contas numeric := 0;
    v_saldo_transacoes_passadas numeric := 0;
    v_saldo_inicial numeric := 0;
    v_fco_in numeric := 0; v_fco_out numeric := 0;
    v_fci_in numeric := 0; v_fci_out numeric := 0;
    v_fcf_in numeric := 0; v_fcf_out numeric := 0;
    r RECORD;
BEGIN
    IF NOT public.check_user_in_org(p_org_id) THEN
        RAISE EXCEPTION 'Acesso negado: Usuário não autorizado.';
    END IF;

    -- ==========================================
    -- 1. PRÉ-AGREGAÇÃO EM MEMÓRIA (Otimização I/O)
    -- ==========================================
    -- Cria uma tabela temporária apenas com o sumário por conta.
    -- Reduz milhões de linhas a algumas dezenas.
    CREATE TEMP TABLE temp_transacoes ON COMMIT DROP AS
    SELECT 
        pc.id, pc.codigo_contabil, pc.nome, pc.tipo,
        COALESCE(SUM(t.valor) FILTER (WHERE t.tipo_operacao = 'CREDITO'), 0) as in_val,
        COALESCE(SUM(t.valor) FILTER (WHERE t.tipo_operacao = 'DEBITO'), 0) as out_val
    FROM public.transacoes t
    JOIN public.plano_contas pc ON t.plano_contas_id = pc.id
    WHERE t.organization_id = p_org_id 
      AND t.status = 'CONCILIADO'
      AND t.data_pagamento::date >= p_data_inicio 
      AND t.data_pagamento::date <= p_data_fim
    GROUP BY pc.id, pc.codigo_contabil, pc.nome, pc.tipo;

    -- ==========================================
    -- 2. CÁLCULO DO SALDO INICIAL
    -- ==========================================
    SELECT COALESCE(SUM(saldo_inicial), 0) INTO v_saldo_abertura_contas
    FROM public.contas_bancarias WHERE organization_id = p_org_id AND ativo = true;

    SELECT COALESCE(SUM(CASE WHEN tipo_operacao = 'CREDITO' THEN valor ELSE -valor END), 0) 
    INTO v_saldo_transacoes_passadas
    FROM public.transacoes
    WHERE organization_id = p_org_id AND status = 'CONCILIADO' AND tipo_operacao IN ('CREDITO', 'DEBITO') AND data_pagamento::date < p_data_inicio;

    v_saldo_inicial := v_saldo_abertura_contas + v_saldo_transacoes_passadas;

    ordem := 10; tipo_linha := 'SALDO'; 
    conta_id := NULL; conta_codigo := NULL; conta_nome := NULL; conta_tipo := NULL; 
    descricao := 'SALDO INICIAL CAIXA/BANCOS'; entradas := 0; saidas := 0; saldo := v_saldo_inicial; 
    RETURN NEXT;

    -- ==========================================
    -- 3. FCO (Lendo da Memória)
    -- ==========================================
    ordem := 20; tipo_linha := 'CABECALHO'; 
    descricao := '1. FLUXO ATIVIDADES OPERACIONAIS (FCO)'; entradas := 0; saidas := 0; saldo := 0; 
    RETURN NEXT;

    FOR r IN (SELECT * FROM temp_transacoes WHERE codigo_contabil LIKE '1.%' OR codigo_contabil LIKE '2.%' ORDER BY codigo_contabil) LOOP
        ordem := 21; tipo_linha := 'CATEGORIA'; 
        conta_id := r.id; conta_codigo := r.codigo_contabil; conta_nome := r.nome; conta_tipo := r.tipo; 
        descricao := r.codigo_contabil || ' - ' || r.nome; 
        entradas := r.in_val; saidas := r.out_val; saldo := r.in_val - r.out_val; 
        RETURN NEXT;
        v_fco_in := v_fco_in + r.in_val; v_fco_out := v_fco_out + r.out_val;
    END LOOP;

    ordem := 29; tipo_linha := 'TOTAL'; 
    conta_id := NULL; conta_codigo := NULL; conta_nome := NULL; conta_tipo := NULL; 
    descricao := 'TOTAL OPERACIONAL (FCO)'; entradas := v_fco_in; saidas := v_fco_out; saldo := v_fco_in - v_fco_out; 
    RETURN NEXT;

    -- ==========================================
    -- 4. FCI (Lendo da Memória)
    -- ==========================================
    ordem := 30; tipo_linha := 'CABECALHO'; 
    descricao := '2. FLUXO ATIVIDADES INVESTIMENTO (FCI)'; entradas := 0; saidas := 0; saldo := 0; 
    RETURN NEXT;

    FOR r IN (SELECT * FROM temp_transacoes WHERE codigo_contabil LIKE '3.%' ORDER BY codigo_contabil) LOOP
        ordem := 31; tipo_linha := 'CATEGORIA'; 
        conta_id := r.id; conta_codigo := r.codigo_contabil; conta_nome := r.nome; conta_tipo := r.tipo; 
        descricao := r.codigo_contabil || ' - ' || r.nome; 
        entradas := r.in_val; saidas := r.out_val; saldo := r.in_val - r.out_val; 
        RETURN NEXT;
        v_fci_in := v_fci_in + r.in_val; v_fci_out := v_fci_out + r.out_val;
    END LOOP;

    ordem := 39; tipo_linha := 'TOTAL'; 
    conta_id := NULL; conta_codigo := NULL; conta_nome := NULL; conta_tipo := NULL; 
    descricao := 'TOTAL INVESTIMENTOS (FCI)'; entradas := v_fci_in; saidas := v_fci_out; saldo := v_fci_in - v_fci_out; 
    RETURN NEXT;

    -- ==========================================
    -- 5. FCF (Lendo da Memória)
    -- ==========================================
    ordem := 40; tipo_linha := 'CABECALHO'; 
    descricao := '3. FLUXO ATIVIDADES FINANCIAMENTO (FCF)'; entradas := 0; saidas := 0; saldo := 0; 
    RETURN NEXT;

    FOR r IN (SELECT * FROM temp_transacoes WHERE codigo_contabil LIKE '4.%' OR codigo_contabil LIKE '5.%' ORDER BY codigo_contabil) LOOP
        ordem := 41; tipo_linha := 'CATEGORIA'; 
        conta_id := r.id; conta_codigo := r.codigo_contabil; conta_nome := r.nome; conta_tipo := r.tipo; 
        descricao := r.codigo_contabil || ' - ' || r.nome; 
        entradas := r.in_val; saidas := r.out_val; saldo := r.in_val - r.out_val; 
        RETURN NEXT;
        v_fcf_in := v_fcf_in + r.in_val; v_fcf_out := v_fcf_out + r.out_val;
    END LOOP;

    ordem := 49; tipo_linha := 'TOTAL'; 
    conta_id := NULL; conta_codigo := NULL; conta_nome := NULL; conta_tipo := NULL; 
    descricao := 'TOTAL FINANCIAMENTOS (FCF)'; entradas := v_fcf_in; saidas := v_fcf_out; saldo := v_fcf_in - v_fcf_out; 
    RETURN NEXT;

    -- ==========================================
    -- 6. FECHAMENTO
    -- ==========================================
    ordem := 50; tipo_linha := 'SALDO'; 
    descricao := 'GERAÇÃO LÍQUIDA DE CAIXA NO PERÍODO'; 
    entradas := (v_fco_in + v_fci_in + v_fcf_in); saidas := (v_fco_out + v_fci_out + v_fcf_out); 
    saldo := entradas - saidas; 
    RETURN NEXT;

    ordem := 60; tipo_linha := 'SALDO'; 
    descricao := 'SALDO FINAL CAIXA/BANCOS'; 
    entradas := 0; saidas := 0; 
    saldo := v_saldo_inicial + (v_fco_in + v_fci_in + v_fcf_in) - (v_fco_out + v_fci_out + v_fcf_out); 
    RETURN NEXT;

END;$$;


ALTER FUNCTION "public"."fn_relatorio_dfc_analitico"("p_org_id" "uuid", "p_data_inicio" "date", "p_data_fim" "date") OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."fn_relatorio_dfc_sintetico"("p_org_id" "uuid", "p_data_inicio" "date", "p_data_fim" "date") RETURNS TABLE("saldo_inicial" numeric, "total_entradas" numeric, "total_saidas" numeric, "geracao_caixa" numeric, "saldo_final" numeric)
    LANGUAGE "plpgsql" SECURITY DEFINER
    AS $$DECLARE
    v_data_inicio_pura timestamp;
    v_data_fim_pura timestamp;BEGIN
    IF NOT public.check_user_in_org(p_org_id) THEN
        RAISE EXCEPTION 'Acesso negado: Usuário não autorizado.';
    END IF;

    v_data_inicio_pura := p_data_inicio::timestamp;
    v_data_fim_pura    := p_data_fim::timestamp;

    RETURN QUERY
    WITH saldos_bancarios AS (
        SELECT COALESCE(SUM(c.saldo_inicial), 0) AS abertura
        FROM public.contas_bancarias c
        WHERE c.organization_id = p_org_id 
          AND c.ativo = true 
          AND COALESCE(c.tipo, '') != 'VIRTUAL'
          AND c.criado_em::timestamp <= v_data_fim_pura
    ),
    leitura_unica_transacoes AS (
        SELECT 
            -- Saldo Passado Histórico
            COALESCE(SUM(CASE WHEN t.tipo_operacao IN ('CREDITO', 'CRÉDITO') THEN t.valor ELSE -t.valor END) 
                FILTER (WHERE date_trunc('day', t.data_pagamento)::timestamp < date_trunc('day', v_data_inicio_pura)), 0) AS saldo_passado,
            
            -- O INTERCETADOR: Soma o setup de saldo inicial se ele acontecer dentro do período pesquisado
            COALESCE(SUM(t.valor) 
                FILTER (WHERE t.tipo_operacao IN ('CREDITO', 'CRÉDITO') 
                    AND COALESCE(pc.is_conta_implantacao, false) = true
                    AND date_trunc('day', t.data_pagamento)::timestamp >= date_trunc('day', v_data_inicio_pura) 
                    AND date_trunc('day', t.data_pagamento)::timestamp <= date_trunc('day', v_data_fim_pura)), 0) AS entradas_setup,

            -- Entradas Reais do Período (Faturamento / Arrecadação de verdade)
            COALESCE(SUM(t.valor) 
                FILTER (WHERE t.tipo_operacao IN ('CREDITO', 'CRÉDITO') 
                    AND COALESCE(pc.is_conta_implantacao, false) = false
                    AND date_trunc('day', t.data_pagamento)::timestamp >= date_trunc('day', v_data_inicio_pura) 
                    AND date_trunc('day', t.data_pagamento)::timestamp <= date_trunc('day', v_data_fim_pura)), 0) AS entradas_periodo,
            
            -- Saídas Reais do Período
            COALESCE(SUM(t.valor) 
                FILTER (WHERE t.tipo_operacao IN ('DEBITO', 'DÉBITO') 
                    AND date_trunc('day', t.data_pagamento)::timestamp >= date_trunc('day', v_data_inicio_pura) 
                    AND date_trunc('day', t.data_pagamento)::timestamp <= date_trunc('day', v_data_fim_pura)), 0) AS saidas_periodo
        
        FROM public.transacoes t
        LEFT JOIN public.plano_contas pc ON pc.id = t.plano_contas_id
        LEFT JOIN public.contas_bancarias cb ON cb.id = t.conta_bancaria_id
        WHERE t.organization_id = p_org_id
          AND t.status = 'CONCILIADO'
          AND t.tipo_operacao IN ('CREDITO', 'CRÉDITO', 'DEBITO', 'DÉBITO')
          AND t.transferencia_interna_id IS NULL
          AND pc.codigo_contabil != '9.9.99'
          AND COALESCE(cb.tipo, '') != 'VIRTUAL'
    )
    SELECT 
        (sb.abertura + lut.saldo_passado + lut.entradas_setup)::numeric AS saldo_inicial,
        lut.entradas_periodo::numeric AS total_entradas,
        lut.saidas_periodo::numeric AS total_saidas,
        (lut.entradas_periodo - lut.saidas_periodo)::numeric AS geracao_caixa,
        (sb.abertura + lut.saldo_passado + lut.entradas_setup + lut.entradas_periodo - lut.saidas_periodo)::numeric AS saldo_final
    FROM saldos_bancarios sb
    CROSS JOIN leitura_unica_transacoes lut;
END;$$;


ALTER FUNCTION "public"."fn_relatorio_dfc_sintetico"("p_org_id" "uuid", "p_data_inicio" "date", "p_data_fim" "date") OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."fn_relatorio_dre_analitico"("p_org_id" "uuid", "p_data_inicio" "date", "p_data_fim" "date") RETURNS TABLE("plano_contas_id" "uuid", "codigo_contabil" "text", "nome" "text", "tipo" "text", "sintetica" boolean, "nivel" integer, "valor_total" numeric)
    LANGUAGE "plpgsql" SECURITY DEFINER
    AS $_$
BEGIN
    -- Validação de Segurança
    IF NOT public.check_user_in_org(p_org_id) THEN
        RAISE EXCEPTION 'Acesso negado: Usuário não autorizado para esta organização.';
    END IF;

    RETURN QUERY
    WITH transacoes_agrupadas AS (
        -- Agrupa na memória RAM antes de processar a árvore hierárquica
        SELECT 
            v.plano_contas_id,
            v.codigo_contabil,
            SUM(v.valor_liquido) as total_conta
        FROM public.vw_transacoes_competencia v
        WHERE v.organization_id = p_org_id
          AND v.data_competencia_real >= p_data_inicio
          AND v.data_competencia_real <= p_data_fim
        GROUP BY v.plano_contas_id, v.codigo_contabil
    ),
    plano_contas_preparado AS (
        -- Metadados estruturais do plano de contas
        SELECT 
            pc.id,
            pc.codigo_contabil,
            pc.nome,
            pc.tipo,
            NOT pc.permite_lancamento AS sintetica,
            LENGTH(pc.codigo_contabil) - LENGTH(REPLACE(pc.codigo_contabil, '.', '')) AS nivel,
            REGEXP_REPLACE(pc.codigo_contabil, '\.0$', '') || '.%' AS prefixo_busca
        FROM public.plano_contas pc
        WHERE pc.organization_id = p_org_id
          AND UPPER(pc.tipo) IN ('RECEITA', 'DESPESA')
    )
    SELECT 
        pcp.id AS plano_contas_id,
        -- CORREÇÃO DE TIPAGEM AQUI: Forçando o casting para TEXT
        pcp.codigo_contabil::text,
        pcp.nome::text,
        pcp.tipo::text,
        pcp.sintetica,
        -- PostgreSQL pode ler o cálculo de LENGTH como BIGINT dependendo da versão, 
        -- então garantimos que saia como INT primitivo.
        pcp.nivel::int, 
        COALESCE((
            SELECT SUM(ta.total_conta)
            FROM transacoes_agrupadas ta
            WHERE ta.codigo_contabil = pcp.codigo_contabil
               OR ta.codigo_contabil LIKE pcp.prefixo_busca
        ), 0)::numeric AS valor_total
    FROM plano_contas_preparado pcp
    ORDER BY STRING_TO_ARRAY(pcp.codigo_contabil, '.')::INT[] ASC;
END;
$_$;


ALTER FUNCTION "public"."fn_relatorio_dre_analitico"("p_org_id" "uuid", "p_data_inicio" "date", "p_data_fim" "date") OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."fn_relatorio_dre_sintetico"("p_org_id" "uuid", "p_data_inicio" "date", "p_data_fim" "date") RETURNS TABLE("soma_receitas" numeric, "soma_despesas" numeric, "soma_liquido" numeric, "margem_lucro_percentual" numeric)
    LANGUAGE "plpgsql" SECURITY DEFINER
    AS $$
BEGIN
    -- Validação de Segurança
    IF NOT public.check_user_in_org(p_org_id) THEN
        RAISE EXCEPTION 'Acesso negado: Usuário não autorizado para esta organização.';
    END IF;

    RETURN QUERY
    WITH calculo_dre AS (
        SELECT 
            -- O uso do FILTER é a forma mais performática no Postgres para pivoteamento condicional
            COALESCE(SUM(v.valor_absoluto) FILTER (WHERE v.tipo_conta = 'RECEITA'), 0) AS receitas,
            COALESCE(SUM(v.valor_absoluto) FILTER (WHERE v.tipo_conta = 'DESPESA'), 0) AS despesas,
            COALESCE(SUM(v.valor_liquido), 0) AS liquido
        FROM public.vw_transacoes_competencia v
        WHERE v.organization_id = p_org_id
          AND v.data_competencia_real >= p_data_inicio
          AND v.data_competencia_real <= p_data_fim
    )
    SELECT 
        c.receitas::numeric,
        c.despesas::numeric,
        c.liquido::numeric,
        -- Trava matemática para divisão por zero em meses sem receita
        CASE 
            WHEN c.receitas > 0 THEN ROUND((c.liquido / c.receitas) * 100, 2)::numeric
            ELSE 0::numeric
        END AS margem_lucro_percentual
    FROM calculo_dre c;
END;
$$;


ALTER FUNCTION "public"."fn_relatorio_dre_sintetico"("p_org_id" "uuid", "p_data_inicio" "date", "p_data_fim" "date") OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."fn_resumo_conciliacao_dashboard"("p_org_id" "uuid", "p_data_inicio" timestamp with time zone, "p_data_fim" timestamp with time zone) RETURNS TABLE("saldo_inicial_historico" numeric, "resultado_operacional" numeric, "disponibilidade_real" numeric)
    LANGUAGE "plpgsql" SECURITY DEFINER
    AS $$
BEGIN
    -- 1. Validação de Segurança Básica (A sua trava já existente)
    IF NOT public.check_user_in_org(p_org_id) THEN
        RAISE EXCEPTION 'Acesso negado: Usuário não autorizado para esta organização.';
    END IF;

    RETURN QUERY
    WITH movimentos AS (
        -- CTE (Common Table Expression) para extrair os valores limpos e tipados
        SELECT 
            t.data_pagamento,
            CASE WHEN t.tipo_operacao = 'CREDITO' THEN t.valor ELSE 0 END AS entrada,
            CASE WHEN t.tipo_operacao = 'DEBITO' THEN t.valor ELSE 0 END AS saida
        FROM public.transacoes t
        INNER JOIN public.contas_bancarias cb ON t.conta_bancaria_id = cb.id
        WHERE t.organization_id = p_org_id
          AND cb.tipo IS DISTINCT FROM 'VIRTUAL' -- A trava de isolamento contábil
          AND t.status = 'CONCILIADO' -- Opcional: garante que só conta o dinheiro de fato compensado
    )
    SELECT 
        -- 1. Herança do Passado (Tudo estritamente antes da data de início)
        COALESCE(
            SUM(entrada - saida) FILTER (WHERE data_pagamento < p_data_inicio), 
            0
        )::NUMERIC(12,2) AS saldo_inicial_historico,
        
        -- 2. Desempenho do Exercício (Apenas dentro das balizas de data)
        COALESCE(
            SUM(entrada - saida) FILTER (WHERE data_pagamento >= p_data_inicio AND data_pagamento <= p_data_fim), 
            0
        )::NUMERIC(12,2) AS resultado_operacional,
        
        -- 3. Disponibilidade Real (Todo o passado + todo o presente até a data limite)
        COALESCE(
            SUM(entrada - saida) FILTER (WHERE data_pagamento <= p_data_fim), 
            0
        )::NUMERIC(12,2) AS disponibilidade_real
    FROM movimentos;

END;
$$;


ALTER FUNCTION "public"."fn_resumo_conciliacao_dashboard"("p_org_id" "uuid", "p_data_inicio" timestamp with time zone, "p_data_fim" timestamp with time zone) OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."fn_resumo_contas_pagar_receber"("p_org_id" "uuid") RETURNS TABLE("total_pagar" numeric, "total_pagar_atrasado" numeric, "total_pagar_hoje" numeric, "total_pagar_vencer" numeric, "total_receber" numeric, "total_receber_atrasado" numeric, "total_receber_hoje" numeric, "total_receber_vencer" numeric)
    LANGUAGE "plpgsql" SECURITY DEFINER
    AS $$
BEGIN
    -- 1. Validação de Segurança Blindada
    IF NOT public.check_user_in_org(p_org_id) THEN
        RAISE EXCEPTION 'Acesso negado: Usuário não autorizado para esta organização.';
    END IF;

    -- 2. Agregação Direta com Index Seek e Null Safety
    RETURN QUERY
    SELECT
        -- CONTAS A PAGAR
        COALESCE(SUM(valor) FILTER (
            WHERE tipo_operacao IN ('DEBITO', 'DÉBITO')
        ), 0)::numeric AS total_pagar,
        
        COALESCE(SUM(valor) FILTER (
            WHERE tipo_operacao IN ('DEBITO', 'DÉBITO') 
              AND data_vencimento::date < CURRENT_DATE
        ), 0)::numeric AS total_pagar_atrasado,
        
        COALESCE(SUM(valor) FILTER (
            WHERE tipo_operacao IN ('DEBITO', 'DÉBITO') 
              AND data_vencimento::date = CURRENT_DATE
        ), 0)::numeric AS total_pagar_hoje,
        
        COALESCE(SUM(valor) FILTER (
            WHERE tipo_operacao IN ('DEBITO', 'DÉBITO') 
              AND data_vencimento::date > CURRENT_DATE
        ), 0)::numeric AS total_pagar_vencer,

        -- CONTAS A RECEBER
        COALESCE(SUM(valor) FILTER (
            WHERE tipo_operacao IN ('CREDITO', 'CRÉDITO')
        ), 0)::numeric AS total_receber,
        
        COALESCE(SUM(valor) FILTER (
            WHERE tipo_operacao IN ('CREDITO', 'CRÉDITO') 
              AND data_vencimento::date < CURRENT_DATE
        ), 0)::numeric AS total_receber_atrasado,
        
        COALESCE(SUM(valor) FILTER (
            WHERE tipo_operacao IN ('CREDITO', 'CRÉDITO') 
              AND data_vencimento::date = CURRENT_DATE
        ), 0)::numeric AS total_receber_hoje,
        
        COALESCE(SUM(valor) FILTER (
            WHERE tipo_operacao IN ('CREDITO', 'CRÉDITO') 
              AND data_vencimento::date > CURRENT_DATE
        ), 0)::numeric AS total_receber_vencer

    FROM public.transacoes
    WHERE organization_id = p_org_id
      AND status = 'PENDENTE'
      AND data_vencimento IS NOT NULL;
END;
$$;


ALTER FUNCTION "public"."fn_resumo_contas_pagar_receber"("p_org_id" "uuid") OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."fn_resumo_saude_cr"("p_org_id" "uuid", "p_data_inicio" "date", "p_data_fim" "date") RETURNS TABLE("qtd_verde" integer, "qtd_amarelo" integer, "qtd_vermelho" integer)
    LANGUAGE "plpgsql"
    AS $$
DECLARE
    v_inicio_ano_contabil date;
BEGIN
    -- Determina o início do ano contábil com base na data de início solicitada
    -- Ex: Se p_data_inicio for '2026-05-01', v_inicio_ano_contabil será '2026-01-01'
    v_inicio_ano_contabil := DATE_TRUNC('year', p_data_inicio)::date;

    RETURN QUERY
    WITH SaldosCR AS (
        SELECT
            cc.id,
            COALESCE(SUM(CASE WHEN t.tipo_operacao = 'CREDITO' THEN t.valor ELSE 0 END), 0) -
            COALESCE(SUM(CASE WHEN t.tipo_operacao = 'DEBITO' THEN t.valor ELSE 0 END), 0) AS saldo_periodo
        FROM public.centros_custo cc
        INNER JOIN public.transacoes t ON t.centro_custo_id = cc.id
        WHERE cc.organization_id = p_org_id 
          AND cc.ativo = true
          AND t.status = 'CONCILIADO'
          
          -- O limite final é sempre o mesmo para todos (o último dia do período)
          AND t.data_pagamento < ((p_data_fim + INTERVAL '1 day') AT TIME ZONE 'America/Sao_Paulo')
          
          -- A MÁGICA TEMPORAL: Bifurcação do limite inicial
          AND (
              (cc.permite_acumulo = false AND t.data_pagamento >= (p_data_inicio AT TIME ZONE 'America/Sao_Paulo'))
              OR 
              (cc.permite_acumulo = true AND t.data_pagamento >= (v_inicio_ano_contabil AT TIME ZONE 'America/Sao_Paulo'))
          )
        GROUP BY cc.id
    )
    SELECT
        COUNT(CASE WHEN saldo_periodo > 0 THEN 1 END)::integer AS qtd_verde,
        COUNT(CASE WHEN saldo_periodo = 0 THEN 1 END)::integer AS qtd_amarelo,
        COUNT(CASE WHEN saldo_periodo < 0 THEN 1 END)::integer AS qtd_vermelho
    FROM SaldosCR;
END;
$$;


ALTER FUNCTION "public"."fn_resumo_saude_cr"("p_org_id" "uuid", "p_data_inicio" "date", "p_data_fim" "date") OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."fn_update_org_pulse"() RETURNS "trigger"
    LANGUAGE "plpgsql" SECURITY DEFINER
    AS $$
DECLARE
    v_org_id uuid;
BEGIN
    -- Descobre de qual organização é a transação
    IF TG_OP = 'DELETE' THEN
        v_org_id := OLD.organization_id;
    ELSE
        v_org_id := NEW.organization_id;
    END IF;

    -- Atualiza o relógio (Faz um UPSERT rápido)
    IF v_org_id IS NOT NULL THEN
        INSERT INTO public.org_pulse (organization_id, ultima_atualizacao)
        VALUES (v_org_id, now())
        ON CONFLICT (organization_id)
        DO UPDATE SET ultima_atualizacao = now();
    END IF;

    RETURN NULL;
END;
$$;


ALTER FUNCTION "public"."fn_update_org_pulse"() OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."fn_validar_conta_analitica"() RETURNS "trigger"
    LANGUAGE "plpgsql"
    AS $$
BEGIN
    -- Validação: Se a conta for sintética (permite_lancamento = false), bloqueia.
    IF (SELECT permite_lancamento FROM public.plano_contas WHERE id = NEW.plano_contas_id) = FALSE THEN
        RAISE EXCEPTION 'A conta selecionada é SINTÉTICA (Pai). Lançamentos só são permitidos em subcontas analíticas.';
    END IF;
    RETURN NEW;
END;
$$;


ALTER FUNCTION "public"."fn_validar_conta_analitica"() OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."gerar_proximo_codigo_subconta"("p_organization_id" "uuid", "p_codigo_pai" "text") RETURNS "text"
    LANGUAGE "plpgsql"
    AS $_$
DECLARE
  v_max_sufixo INTEGER;
  v_novo_codigo TEXT;
BEGIN
  -- 1. Busca o maior número entre os filhos DIRETOS
  -- Usamos Regex para garantir que, se o pai é '2.5', ele leia '2.5.01', mas IGNORE '2.5.01.01'
  SELECT COALESCE(MAX(
    substring(codigo_contabil from '^' || replace(p_codigo_pai, '.', '\.') || '\.(\d+)$')::INTEGER
  ), 0)
  INTO v_max_sufixo
  FROM public.plano_contas
  WHERE organization_id = p_organization_id
    AND codigo_contabil ~ ('^' || replace(p_codigo_pai, '.', '\.') || '\.\d+$');

  -- 2. Gera o novo código com 2 dígitos (ex: 01, 02, ..., 10, 11)
  -- Se for o primeiro filho, v_max_sufixo é 0, então 0+1 = 1 -> '01'
  v_novo_codigo := p_codigo_pai || '.' || lpad((v_max_sufixo + 1)::TEXT, 2, '0');
  
  RETURN v_novo_codigo;
END;
$_$;


ALTER FUNCTION "public"."gerar_proximo_codigo_subconta"("p_organization_id" "uuid", "p_codigo_pai" "text") OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."handle_new_user"() RETURNS "trigger"
    LANGUAGE "plpgsql" SECURITY DEFINER
    AS $$
BEGIN
  INSERT INTO public.profiles (id, email)
  VALUES (new.id, new.email);
  RETURN new;
END;
$$;


ALTER FUNCTION "public"."handle_new_user"() OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."is_org_member"("_org_id" "uuid") RETURNS boolean
    LANGUAGE "plpgsql" SECURITY DEFINER
    AS $$
BEGIN
  RETURN EXISTS (
    SELECT 1
    FROM public.organization_members
    WHERE organization_id = _org_id
    AND profile_id = auth.uid()
  );
END;
$$;


ALTER FUNCTION "public"."is_org_member"("_org_id" "uuid") OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."manter_unico_centro_custo_padrao"() RETURNS "trigger"
    LANGUAGE "plpgsql"
    AS $$
BEGIN
  -- Verifica se o registro que está chegando tem a chave 'is_padrao' como VERDADEIRA
  IF NEW.is_padrao = TRUE THEN
    
    -- Se for verdadeira, o banco altera todos os outros da mesma organização para FALSO
    UPDATE public.centros_custo
    SET is_padrao = FALSE
    WHERE organization_id = NEW.organization_id
      AND id <> NEW.id -- Proteção: garante que ele não desmarque a si mesmo
      AND is_padrao = TRUE; -- Otimização: só mexe em quem já estava como verdadeiro
      
  END IF;
  
  -- Deixa o registro original seguir o seu caminho e ser salvo
  RETURN NEW;
END;
$$;


ALTER FUNCTION "public"."manter_unico_centro_custo_padrao"() OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."manter_unico_fundo_geral"() RETURNS "trigger"
    LANGUAGE "plpgsql" SECURITY DEFINER
    AS $$
BEGIN
    -- Se o registro que está sendo salvo/atualizado foi marcado como Fundo Geral
    IF NEW.is_fundo = true THEN
        -- Desmarca qualquer outro Centro de Custo desta mesma organização que seja Fundo Geral
        UPDATE public.centros_custo
        SET is_fundo = false
        WHERE organization_id = NEW.organization_id
          AND id <> NEW.id -- Evita atualizar a si mesmo
          AND is_fundo = true;
    END IF;
    
    RETURN NEW;
END;
$$;


ALTER FUNCTION "public"."manter_unico_fundo_geral"() OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."obter_cache_centros_custo"("p_org_id" "uuid") RETURNS TABLE("id" "uuid", "nome" "text", "descricao" "text", "ativo" boolean, "is_padrao" boolean, "is_fundo" boolean, "permite_acumulo" boolean, "cor_hex" "text")
    LANGUAGE "plpgsql"
    AS $$
BEGIN
    -- Validação de segurança
    IF NOT public.check_user_in_org(p_org_id) THEN 
        RAISE EXCEPTION 'Acesso negado.'; 
    END IF;

    RETURN QUERY
    SELECT 
        cc.id,
        cc.nome::text,
        cc.descricao::text,
        COALESCE(cc.ativo, true)::boolean,      
        COALESCE(cc.is_padrao, false)::boolean, 
        COALESCE(cc.is_fundo, false)::boolean, 
        COALESCE(cc.permite_acumulo, false)::boolean, 
        cc.cor_hex::text
    FROM public.centros_custo cc
    WHERE cc.organization_id = p_org_id
    ORDER BY cc.nome ASC;
END;
$$;


ALTER FUNCTION "public"."obter_cache_centros_custo"("p_org_id" "uuid") OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."obter_cache_contas_bancarias"("p_org_id" "uuid") RETURNS TABLE("id" "uuid", "nome" "text", "tipo" "text", "banco_codigo" "text", "agencia_conta" "text", "saldo_inicial" numeric, "ativo" boolean, "limite_credito" numeric, "dia_vencimento" integer, "dia_fechamento" integer)
    LANGUAGE "plpgsql" SECURITY DEFINER
    AS $$
BEGIN
    IF NOT public.check_user_in_org(p_org_id) THEN RAISE EXCEPTION 'Acesso negado.'; END IF;

    RETURN QUERY
    SELECT 
        c.id,
        c.nome::text,
        c.tipo::text,
        c.banco_codigo::text,
        c.agencia_conta::text,
        COALESCE(c.saldo_inicial, 0.00),
        COALESCE(c.ativo, true)::boolean,
        COALESCE(c.limite_credito, 0.00),
        c.dia_vencimento::integer,
        c.dia_fechamento::integer
    FROM public.contas_bancarias c
    WHERE c.organization_id = p_org_id
    ORDER BY c.nome ASC;
END;
$$;


ALTER FUNCTION "public"."obter_cache_contas_bancarias"("p_org_id" "uuid") OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."obter_cache_membros_light"("p_org_id" "uuid") RETURNS TABLE("id" "uuid", "nome_completo" "text", "ativo" boolean)
    LANGUAGE "plpgsql" SECURITY DEFINER
    AS $$
BEGIN
    IF NOT public.check_user_in_org(p_org_id) THEN RAISE EXCEPTION 'Acesso negado.'; END IF;

    RETURN QUERY
    SELECT 
        m.id,
        m.nome_completo,
        m.ativo
    FROM public.membros m
    WHERE m.organization_id = p_org_id
    ORDER BY m.nome_completo ASC;
END;
$$;


ALTER FUNCTION "public"."obter_cache_membros_light"("p_org_id" "uuid") OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."obter_cache_plano_contas"("p_org_id" "uuid") RETURNS TABLE("id" "uuid", "codigo_contabil" "text", "nome" "text", "tipo" "text", "nome_exibicao" "text", "natureza_fluxo" "text", "permite_lancamento" boolean, "instrucao_uso" "text")
    LANGUAGE "plpgsql" SECURITY DEFINER
    AS $$
BEGIN
    IF NOT public.check_user_in_org(p_org_id) THEN RAISE EXCEPTION 'Acesso negado.'; END IF;

    RETURN QUERY
    SELECT 
        pc.id,
        pc.codigo_contabil::text,
        pc.nome::text,
        pc.tipo::text,
        CASE 
            WHEN starts_with(TRIM(pc.nome::text), pc.codigo_contabil::text) THEN
                pc.codigo_contabil::text || ' - ' || 
                LTRIM(SUBSTRING(TRIM(pc.nome::text) FROM length(pc.codigo_contabil::text) + 1), ' -')
            ELSE pc.codigo_contabil::text || ' - ' || pc.nome::text
        END AS nome_exibicao,
        pc.natureza_fluxo::text,
        COALESCE(pc.permite_lancamento, true)::boolean,
        pc.instrucao_uso::text
    FROM public.plano_contas pc
    WHERE pc.organization_id = p_org_id
    ORDER BY pc.codigo_contabil ASC;
END;
$$;


ALTER FUNCTION "public"."obter_cache_plano_contas"("p_org_id" "uuid") OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."obter_detalhe_transacao_otimizado"("p_org_id" "uuid", "p_transacao_id" "uuid") RETURNS TABLE("transacao_id" "uuid", "data_pagamento" timestamp with time zone, "data_vencimento" "date", "data_competencia" "date", "descricao" "text", "tipo_operacao" "text", "status" "text", "valor" numeric, "conta_bancaria_id" "uuid", "conta_origem_nome" "text", "conta_destino_id" "uuid", "conta_destino_nome" "text", "plano_contas_id" "uuid", "categoria_nome" "text", "centro_custo_id" "uuid", "centro_custo_nome" "text", "membro_id" "uuid", "membro_nome" "text", "observacoes" "text", "comprovativo_url" "text")
    LANGUAGE "plpgsql" SECURITY DEFINER
    AS $$
BEGIN
    IF NOT public.check_user_in_org(p_org_id) THEN
        RAISE EXCEPTION 'Acesso negado: Usuário não autorizado.';
    END IF;

    RETURN QUERY
    SELECT 
        t.id AS transacao_id,
        t.data_pagamento,
        t.data_vencimento,
        t.data_competencia,
        t.descricao,
        t.tipo_operacao,
        t.status,
        t.valor,
        
        -- O seu SELECT modificado:
        t.conta_bancaria_id,
        COALESCE(c_origem.nome, 'Sem conta de origem') AS conta_origem_nome,
        t.conta_destino_id,
        COALESCE(c_destino.nome, 'Sem conta de destino') AS conta_destino_nome,
        t.plano_contas_id,
        COALESCE(pc.nome, 'Sem categoria') AS categoria_nome,
        t.centro_custo_id,
        COALESCE(cc.nome, 'Sem centro de custo') AS centro_custo_nome,
        t.membro_id,
        COALESCE(m.nome_completo, 'Sem membro') AS membro_nome,
        
        t.observacoes,
        t.comprovativo_url
    FROM 
        public.transacoes t
    LEFT JOIN public.contas_bancarias c_origem ON t.conta_bancaria_id = c_origem.id
    LEFT JOIN public.contas_bancarias c_destino ON t.conta_destino_id = c_destino.id
    LEFT JOIN public.plano_contas pc ON t.plano_contas_id = pc.id
    LEFT JOIN public.centros_custo cc ON t.centro_custo_id = cc.id
    LEFT JOIN public.membros m ON t.membro_id = m.id
    WHERE 
        t.id = p_transacao_id 
        AND t.organization_id = p_org_id;

END;
$$;


ALTER FUNCTION "public"."obter_detalhe_transacao_otimizado"("p_org_id" "uuid", "p_transacao_id" "uuid") OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."obter_detalhes_dfc_categoria"("p_org_id" "uuid", "p_data_inicio" "date", "p_data_fim" "date", "p_categoria_id" "uuid") RETURNS TABLE("transacao_id" "uuid", "descricao" "text", "valor" numeric, "tipo_operacao" "text", "data_vencimento" "date", "data_pagamento" timestamp with time zone, "data_competencia" "date", "tipo_conta" "text", "conta_nome" "text", "centro_custo_nome" "text")
    LANGUAGE "plpgsql" SECURITY DEFINER
    AS $$DECLARE
    -- [BLINDAGEM TEMPORAL]: Variáveis em TIMESTAMP puro
    v_data_inicio_pura timestamp;
    v_data_fim_pura timestamp;
BEGIN
    -- =========================================================
    -- 1. VALIDAÇÃO DE SEGURANÇA (Fail-Fast)
    -- =========================================================
    IF NOT public.check_user_in_org(p_org_id) THEN
        RAISE EXCEPTION 'Acesso negado: Usuário não autorizado.';
    END IF;

    -- Purifica os parâmetros de entrada
    v_data_inicio_pura := p_data_inicio::timestamp;
    v_data_fim_pura    := p_data_fim::timestamp;

    RETURN QUERY
    SELECT 
        t.id AS transacao_id,
        t.descricao::text,
        t.valor::numeric,
        t.tipo_operacao::text,
        t.data_vencimento,
        t.data_pagamento,
        t.data_competencia,
        cb.tipo::text AS tipo_conta,
        COALESCE(cb.nome, 'Conta não informada')::text AS conta_nome,
        COALESCE(cc.nome, 'Sem centro custo')::text AS centro_custo_nome
    FROM public.transacoes t
    LEFT JOIN public.contas_bancarias cb ON t.conta_bancaria_id = cb.id
    LEFT JOIN public.centros_custo cc ON t.centro_custo_id = cc.id
    WHERE t.organization_id = p_org_id
      AND t.status = 'CONCILIADO'
      AND t.plano_contas_id = p_categoria_id
      
      -- [BLINDAGEM CONTÁBIL]: Isola transações reais, removendo ruído de transferências
      AND t.transferencia_interna_id IS NULL
      
      -- [SARGability Perfeita]: Comparação indexada com data pura
      AND t.data_pagamento >= v_data_inicio_pura
      AND t.data_pagamento < (v_data_fim_pura + INTERVAL '1 day')
      
    ORDER BY t.data_pagamento DESC, t.id DESC;
END;$$;


ALTER FUNCTION "public"."obter_detalhes_dfc_categoria"("p_org_id" "uuid", "p_data_inicio" "date", "p_data_fim" "date", "p_categoria_id" "uuid") OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."obter_detalhes_dre_categoria"("p_org_id" "uuid", "p_data_inicio" "date", "p_data_fim" "date", "p_categoria_id" "uuid") RETURNS TABLE("transacao_id" "uuid", "descricao" "text", "valor" numeric, "valor_movimento" numeric, "tipo_operacao" "text", "status" "text", "data_referencia_dre" "date", "data_vencimento" "date", "data_pagamento" timestamp with time zone, "data_competencia" "date", "conta_nome" "text", "tipo_conta" "text", "centro_custo_nome" "text")
    LANGUAGE "plpgsql" SECURITY DEFINER
    AS $$
BEGIN
    -- Validação de Segurança Blindada
    IF NOT public.check_user_in_org(p_org_id) THEN
        RAISE EXCEPTION 'Acesso negado: Usuário não autorizado.';
    END IF;

    RETURN QUERY
    SELECT 
        t.id AS transacao_id,
        t.descricao,
        t.valor,
        -- Matemática Contábil do DRE:
        CASE
            WHEN t.tipo_operacao = 'CREDITO' THEN t.valor
            ELSE t.valor * -1
        END AS valor_movimento,
        t.tipo_operacao,
        t.status,
        -- A essência do DRE: Data de Referência
        COALESCE(t.data_competencia, t.data_vencimento) AS data_referencia_dre,
        t.data_vencimento,
        t.data_pagamento,
        t.data_competencia,
        COALESCE(c.nome, 'Conta não informada') AS conta_nome,
        c.tipo AS tipo_conta,
        COALESCE(cc.nome, 'Sem centro custo') AS centro_custo_nome
    FROM public.transacoes t
    -- INNER JOIN para garantir que apenas Receitas e Despesas sejam processadas
    JOIN public.plano_contas pc ON t.plano_contas_id = pc.id
    LEFT JOIN public.centros_custo cc ON cc.id = t.centro_custo_id
    LEFT JOIN public.contas_bancarias c ON c.id = t.conta_bancaria_id
    WHERE t.organization_id = p_org_id
      AND t.status <> 'CANCELADO'
      AND pc.tipo IN ('RECEITA', 'DESPESA')
      AND t.plano_contas_id = p_categoria_id
      -- Filtro de Performance usando Regime de Competência
      AND COALESCE(t.data_competencia, t.data_vencimento) >= p_data_inicio
      AND COALESCE(t.data_competencia, t.data_vencimento) <= p_data_fim
    -- A sua exigência de ordenação vista na imagem:
    ORDER BY 
      COALESCE(t.data_competencia, t.data_vencimento) ASC, 
      t.data_vencimento ASC;
END;
$$;


ALTER FUNCTION "public"."obter_detalhes_dre_categoria"("p_org_id" "uuid", "p_data_inicio" "date", "p_data_fim" "date", "p_categoria_id" "uuid") OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."obter_extrato_por_periodo"("p_organization_id" "uuid", "p_conta_id" "uuid", "p_data_inicio" timestamp with time zone, "p_data_fim" timestamp with time zone) RETURNS TABLE("transacao_id" "uuid", "data_linha_tempo" timestamp with time zone, "descricao" "text", "categoria_nome" "text", "valor_movimento" numeric, "saldo_progressivo" numeric, "tipo_operacao" "text", "status" "text", "data_competencia" "date", "comprovativo_url" "text")
    LANGUAGE "plpgsql" SECURITY DEFINER
    AS $$DECLARE
    v_saldo_anterior numeric;
    v_saldo_inicial_conta numeric;
BEGIN
    -- 1. Obter o saldo inicial cadastrado na conta
    SELECT saldo_inicial INTO v_saldo_inicial_conta 
    FROM public.contas_bancarias 
    WHERE id = p_conta_id AND organization_id = p_organization_id;

    -- 2. Calcular o somatório de movimentos ANTES do período (Saldo Anterior)
    WITH movimentos_anteriores AS (
        SELECT 
            CASE WHEN t.tipo_operacao = 'CREDITO' THEN t.valor ELSE t.valor * -1 END as mov
        FROM transacoes t
        WHERE t.organization_id = p_organization_id 
          AND t.conta_bancaria_id = p_conta_id
          AND t.status = 'CONCILIADO'
          AND t.data_pagamento < p_data_inicio

        UNION ALL

        SELECT t.valor as mov
        FROM transacoes t
        WHERE t.organization_id = p_organization_id 
          AND t.conta_destino_id = p_conta_id
          AND t.tipo_operacao = 'TRANSFERENCIA'
          AND t.status = 'CONCILIADO'
          AND t.data_pagamento < p_data_inicio
    )
    SELECT COALESCE(SUM(mov), 0) + COALESCE(v_saldo_inicial_conta, 0) INTO v_saldo_anterior 
    FROM movimentos_anteriores;

    -- 3. Retornar os dados
    RETURN QUERY
    WITH extrato_do_periodo AS (
        -- A CORREÇÃO ESTÁ AQUI: Apelidamos a view de 'vw' e especificamos a origem das colunas
        SELECT * FROM public.vw_extrato_individual vw
        WHERE vw.organization_id = p_organization_id
          AND vw.conta_id = p_conta_id
          AND vw.data_linha_tempo >= p_data_inicio
          AND vw.data_linha_tempo <= p_data_fim
    )
    
    SELECT 
        e.transacao_id,
        e.data_linha_tempo,
        e.descricao,
        e.categoria_nome,
        e.valor_movimento,
        -- MUDANÇA 1: A matemática soma cronologicamente (Do mais antigo para o mais novo) usando criado_em
        v_saldo_anterior + SUM(e.valor_movimento) OVER (
            ORDER BY e.data_linha_tempo ASC, e.criado_em ASC, e.transacao_id ASC
        ) as saldo_progressivo,
        e.tipo_operacao,
        e.status,
        e.data_competencia, 
        e.comprovativo_url
    FROM extrato_do_periodo e
    -- MUDANÇA 2: A visualização entrega invertido (Do mais novo para o mais antigo) usando criado_em
    ORDER BY e.data_linha_tempo DESC, e.criado_em DESC, e.transacao_id DESC;
END;$$;


ALTER FUNCTION "public"."obter_extrato_por_periodo"("p_organization_id" "uuid", "p_conta_id" "uuid", "p_data_inicio" timestamp with time zone, "p_data_fim" timestamp with time zone) OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."obter_pendencias_fechamento_mes"("p_org_id" "uuid", "p_data_fim" timestamp with time zone) RETURNS TABLE("total_pagar_aberto" numeric, "total_receber_aberto" numeric)
    LANGUAGE "plpgsql" SECURITY DEFINER
    AS $$
BEGIN
    IF NOT public.check_user_in_org(p_org_id) THEN
        RAISE EXCEPTION 'Acesso negado: Usuário não autorizado.';
    END IF;

    RETURN QUERY
    SELECT 
        -- Soma débitos que vencem até o limite do mês (incluindo os já atrasados)
        COALESCE(SUM(t.valor) FILTER (WHERE t.tipo_operacao IN ('DEBITO', 'DÉBITO')), 0)::numeric AS total_pagar_aberto,
        
        -- Soma créditos que vencem até o limite do mês
        COALESCE(SUM(t.valor) FILTER (WHERE t.tipo_operacao IN ('CREDITO', 'CRÉDITO')), 0)::numeric AS total_receber_aberto
    FROM public.transacoes t
    WHERE t.organization_id = p_org_id
      AND t.status = 'PENDENTE' -- [ATENÇÃO] Altere para 'ABERTO' se no seu sistema for essa a palavra
      AND t.data_vencimento <= p_data_fim
      AND t.transferencia_interna_id IS NULL;
END;
$$;


ALTER FUNCTION "public"."obter_pendencias_fechamento_mes"("p_org_id" "uuid", "p_data_fim" timestamp with time zone) OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."obter_projecao_titulos_retroativa"("p_org_id" "uuid", "p_data_fim" timestamp with time zone) RETURNS TABLE("total_pagar" numeric, "total_pagar_atrasado" numeric, "total_pagar_hoje" numeric, "total_pagar_vencer" numeric, "total_receber" numeric, "total_receber_atrasado" numeric, "total_receber_hoje" numeric, "total_receber_vencer" numeric)
    LANGUAGE "plpgsql" SECURITY DEFINER
    AS $$
BEGIN
    IF NOT public.check_user_in_org(p_org_id) THEN
        RAISE EXCEPTION 'Acesso negado: Usuário não autorizado.';
    END IF;

    RETURN QUERY
    WITH titulos_abertos_na_epoca AS (
        SELECT
            t.tipo_operacao,
            t.valor,
            t.data_vencimento
        FROM public.transacoes t
        WHERE t.organization_id = p_org_id
          AND t.status != 'CANCELADO'
          AND t.transferencia_interna_id IS NULL
          AND COALESCE(t.data_vencimento, t.criado_em) IS NOT NULL
          
          -- A MÁGICA: A dívida estava aberta no último dia do mês do relatório?
          -- Ou nunca foi paga (IS NULL) ou foi paga no futuro (DEPOIS de p_data_fim).
          AND (t.data_pagamento IS NULL OR date_trunc('day', t.data_pagamento) > date_trunc('day', p_data_fim))
          
          -- A CONDIÇÃO DE EXISTÊNCIA: A dívida já era conhecida no mês? 
          -- Foi registada antes/durante o mês OU tem vencimento antes/durante o mês.
          AND (date_trunc('day', t.criado_em) <= date_trunc('day', p_data_fim) OR date_trunc('day', t.data_vencimento) <= date_trunc('day', p_data_fim))
    )
    SELECT
        -- BLOCO: A PAGAR (DEBITO)
        COALESCE(SUM(valor) FILTER (WHERE tipo_operacao IN ('DEBITO', 'DÉBITO')), 0)::numeric,
        COALESCE(SUM(valor) FILTER (WHERE tipo_operacao IN ('DEBITO', 'DÉBITO') AND date_trunc('day', data_vencimento) < date_trunc('day', p_data_fim)), 0)::numeric,
        COALESCE(SUM(valor) FILTER (WHERE tipo_operacao IN ('DEBITO', 'DÉBITO') AND date_trunc('day', data_vencimento) = date_trunc('day', p_data_fim)), 0)::numeric,
        COALESCE(SUM(valor) FILTER (WHERE tipo_operacao IN ('DEBITO', 'DÉBITO') AND date_trunc('day', data_vencimento) > date_trunc('day', p_data_fim)), 0)::numeric,

        -- BLOCO: A RECEBER (CREDITO)
        COALESCE(SUM(valor) FILTER (WHERE tipo_operacao IN ('CREDITO', 'CRÉDITO')), 0)::numeric,
        COALESCE(SUM(valor) FILTER (WHERE tipo_operacao IN ('CREDITO', 'CRÉDITO') AND date_trunc('day', data_vencimento) < date_trunc('day', p_data_fim)), 0)::numeric,
        COALESCE(SUM(valor) FILTER (WHERE tipo_operacao IN ('CREDITO', 'CRÉDITO') AND date_trunc('day', data_vencimento) = date_trunc('day', p_data_fim)), 0)::numeric,
        COALESCE(SUM(valor) FILTER (WHERE tipo_operacao IN ('CREDITO', 'CRÉDITO') AND date_trunc('day', data_vencimento) > date_trunc('day', p_data_fim)), 0)::numeric
    FROM titulos_abertos_na_epoca;
END;
$$;


ALTER FUNCTION "public"."obter_projecao_titulos_retroativa"("p_org_id" "uuid", "p_data_fim" timestamp with time zone) OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."obter_saldo_total_org"("p_org_id" "uuid") RETURNS TABLE("total_saldo_inicial" numeric, "total_entradas_geral" numeric, "total_saidas_geral" numeric, "saldo_liquido_geral" numeric, "saldo_disponivel_real" numeric, "total_faturas_cartao" numeric, "total_a_receber" numeric, "total_a_pagar" numeric, "resumo_ativo_passivo" numeric)
    LANGUAGE "plpgsql" SECURITY DEFINER
    AS $$BEGIN
    -- 1. Validação de Segurança Básica
    IF NOT public.check_user_in_org(p_org_id) THEN
        RAISE EXCEPTION 'Acesso negado: Usuário não autorizado para esta organização.';
    END IF;

    RETURN QUERY
    WITH 
    -- A) CAIXA REALIZADO (O PRESENTE): Separação estrita de Liquidez
    caixa_realizado AS (
        SELECT
            COALESCE(SUM(v.saldo_inicial), 0)::numeric AS c_saldo_inicial,
            COALESCE(SUM(v.total_entradas), 0)::numeric AS c_entradas_geral,
            COALESCE(SUM(v.total_saidas), 0)::numeric AS c_saidas_geral,
            COALESCE(SUM(v.saldo_atual), 0)::numeric AS c_liquido_geral,
            
            -- [CORREÇÃO]: Saldo Disponível Real (Liquidez Imediata - Whitelist)
            COALESCE(SUM(CASE WHEN v.tipo_conta IN ('CORRENTE', 'CAIXA_FISICO', 'CAIXA FÍSICO') THEN v.saldo_atual ELSE 0 END), 0)::numeric AS c_disponivel_real,
            
            -- [NOVA MÉTRICA]: Reservas de Médio/Longo Prazo
            COALESCE(SUM(CASE WHEN v.tipo_conta IN ('APLICACAO', 'APLICAÇÃO', 'POUPANCA', 'POUPANÇA', 'INVESTIMENTO') THEN v.saldo_atual ELSE 0 END), 0)::numeric AS c_reservas,

            -- Faturas de Cartão (Dívida transformando o sinal em positivo para o cálculo de passivo)
            COALESCE(SUM(CASE WHEN v.tipo_conta IN ('CARTAO', 'CARTÃO') THEN (v.saldo_atual * -1) ELSE 0 END), 0)::numeric AS c_faturas_cartao
            
        FROM public.view_saldos_contas v
        WHERE v.organization_id = p_org_id
          AND v.tipo_conta IS DISTINCT FROM 'VIRTUAL'
    ),
    
    -- B) PREVISÃO FUTURA (O FUTURO): Busca o Contas a Pagar e a Receber pendente
    previsao_futura AS (
        SELECT
            COALESCE(SUM(t.valor) FILTER (WHERE t.tipo_operacao IN ('CREDITO', 'CRÉDITO')), 0)::numeric AS a_receber,
            COALESCE(SUM(t.valor) FILTER (WHERE t.tipo_operacao IN ('DEBITO', 'DÉBITO')), 0)::numeric AS a_pagar
        FROM public.transacoes t
        LEFT JOIN public.plano_contas pc ON t.plano_contas_id = pc.id
        LEFT JOIN public.contas_bancarias cb ON t.conta_bancaria_id = cb.id
        WHERE t.organization_id = p_org_id
          AND t.status = 'PENDENTE'
          
          -- Filtros de segurança arquitetural do sistema LASTRO
          AND pc.codigo_contabil IS DISTINCT FROM '9.9.99'
          AND COALESCE(cb.tipo, '') IS DISTINCT FROM 'VIRTUAL'
    )
    
    -- C) ENTREGA ANALÍTICA: Cruzamento de dados estruturados
    SELECT 
        -- As 6 colunas originais
        c.c_saldo_inicial AS total_saldo_inicial,
        c.c_entradas_geral AS total_entradas_geral,
        c.c_saidas_geral AS total_saidas_geral,
        c.c_liquido_geral AS saldo_liquido_geral,
        c.c_disponivel_real AS saldo_disponivel_real,
        c.c_faturas_cartao AS total_faturas_cartao,
        
        -- As 3 colunas de Previsão
        p.a_receber AS total_a_receber,
        p.a_pagar AS total_a_pagar,
        
        -- A Métrica de Ouro (Ativo Circulante Global - Passivo Exigível)
        -- Agora blindada: Liquidez Imediata + Reservas + A Receber - (Faturas + A Pagar)
        ((c.c_disponivel_real + c.c_reservas + p.a_receber) - (c.c_faturas_cartao + p.a_pagar))::numeric AS resumo_ativo_passivo
        
        -- Opcional: Se desejar exportar a variável de reservas para o FlutterFlow no futuro, adicione a linha abaixo:
        -- , c.c_reservas AS total_reservas
        
    FROM caixa_realizado c CROSS JOIN previsao_futura p;
END;$$;


ALTER FUNCTION "public"."obter_saldo_total_org"("p_org_id" "uuid") OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."obter_saldos_contas"("p_org_id" "uuid") RETURNS TABLE("conta_id" "uuid", "nome_conta" "text", "tipo_conta" "text", "saldo_inicial" numeric, "total_entradas" numeric, "total_saidas" numeric, "saldo_atual" numeric, "dia_fechamento" smallint, "dia_vencimento" smallint)
    LANGUAGE "plpgsql" SECURITY DEFINER
    AS $$BEGIN
    -- 1. Validação de Segurança (O pulo do gato para evitar vazamento de dados)
    IF NOT public.check_user_in_org(p_org_id) THEN
        RAISE EXCEPTION 'Acesso negado: Usuário não autorizado para esta organização.';
    END IF;

    -- 2. Busca os dados da view já filtrados e ordenados
    RETURN QUERY
    SELECT
        v.conta_id,
        v.nome_conta,
        v.tipo_conta,
        v.saldo_inicial,
        v.total_entradas,
        v.total_saidas,
        v.saldo_atual,
        v.dia_fechamento,
        v.dia_vencimento 
    FROM public.view_saldos_contas v
    WHERE v.organization_id = p_org_id
    ORDER BY v.nome_conta ASC, v.saldo_atual ASC;

END;$$;


ALTER FUNCTION "public"."obter_saldos_contas"("p_org_id" "uuid") OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."obter_saldos_contas_por_periodo"("p_org_id" "uuid", "p_data_inicio" timestamp with time zone, "p_data_fim" timestamp with time zone) RETURNS TABLE("conta_id" "uuid", "nome_conta" "text", "tipo_conta" "text", "saldo_inicial" numeric, "total_entradas" numeric, "total_saidas" numeric, "saldo_atual" numeric, "dia_fechamento" smallint, "dia_vencimento" smallint)
    LANGUAGE "plpgsql" SECURITY DEFINER
    AS $$
BEGIN
    IF NOT public.check_user_in_org(p_org_id) THEN
        RAISE EXCEPTION 'Acesso negado: Usuário não autorizado.';
    END IF;

    RETURN QUERY
    WITH extrato_bruto AS (
         SELECT 
             t.conta_bancaria_id AS conta_id, 
             c_1.tipo AS tipo_conta,
             CASE WHEN (t.tipo_operacao = 'CREDITO' AND COALESCE(pc.is_conta_implantacao, false) = false) THEN t.valor ELSE 0::numeric END AS entrada_comum,
             CASE WHEN (t.tipo_operacao = 'CREDITO' AND COALESCE(pc.is_conta_implantacao, false) = true) THEN t.valor ELSE 0::numeric END AS entrada_implantacao, 
             CASE WHEN (t.tipo_operacao IN ('DEBITO', 'TRANSFERENCIA')) THEN t.valor ELSE 0::numeric END AS saida, 
             
             -- A MÁGICA: Se a transação não tiver data_pagamento (ex: faturas de cartão em aberto), 
             -- o sistema resgata a data de vencimento ou a data de criação.
             -- (Nota: Se a sua coluna de criação não for 'criado_em', altere para 'created_at')
             COALESCE(t.data_pagamento, t.data_vencimento, t.criado_em) AS data_ref 
             
         FROM public.transacoes t 
         JOIN public.contas_bancarias c_1 ON c_1.id = t.conta_bancaria_id
         LEFT JOIN public.plano_contas pc ON t.plano_contas_id = pc.id
         WHERE t.status = 'CONCILIADO' AND t.organization_id = p_org_id AND t.conta_bancaria_id IS NOT NULL
         
         UNION ALL 
         
         SELECT 
             t.conta_destino_id AS conta_id, 
             c_1.tipo AS tipo_conta,
             t.valor AS entrada_comum, 
             0::numeric AS entrada_implantacao, 
             0::numeric AS saida, 
             COALESCE(t.data_pagamento, t.data_vencimento, t.criado_em) AS data_ref 
         FROM public.transacoes t 
         JOIN public.contas_bancarias c_1 ON c_1.id = t.conta_destino_id
         WHERE t.status = 'CONCILIADO' AND t.tipo_operacao = 'TRANSFERENCIA' AND t.conta_destino_id IS NOT NULL AND t.organization_id = p_org_id
    ),
    resumo_movimentos AS (
         SELECT 
             eb.conta_id,
             SUM(eb.entrada_implantacao) AS total_implantacao,
             
             SUM(eb.entrada_comum) FILTER (WHERE date_trunc('day', eb.data_ref) < date_trunc('day', p_data_inicio)) AS entradas_passadas,
             SUM(eb.saida) FILTER (WHERE date_trunc('day', eb.data_ref) < date_trunc('day', p_data_inicio)) AS saidas_passadas,
             
             SUM(eb.entrada_comum) FILTER (WHERE date_trunc('day', eb.data_ref) >= date_trunc('day', p_data_inicio) AND date_trunc('day', eb.data_ref) <= date_trunc('day', p_data_fim)) AS entradas_periodo,
             SUM(eb.saida) FILTER (WHERE date_trunc('day', eb.data_ref) >= date_trunc('day', p_data_inicio) AND date_trunc('day', eb.data_ref) <= date_trunc('day', p_data_fim)) AS saidas_periodo
             
         FROM extrato_bruto eb
         GROUP BY eb.conta_id
    )
    SELECT 
        c.id AS conta_id,
        c.nome::text AS nome_conta,
        c.tipo::text AS tipo_conta,
        
        (COALESCE(c.saldo_inicial, 0) + COALESCE(rm.total_implantacao, 0) + COALESCE(rm.entradas_passadas, 0) - COALESCE(rm.saidas_passadas, 0))::numeric AS saldo_inicial,
        COALESCE(rm.entradas_periodo, 0)::numeric AS total_entradas,
        COALESCE(rm.saidas_periodo, 0)::numeric AS total_saidas,
        (COALESCE(c.saldo_inicial, 0) + COALESCE(rm.total_implantacao, 0) + COALESCE(rm.entradas_passadas, 0) - COALESCE(rm.saidas_passadas, 0) + COALESCE(rm.entradas_periodo, 0) - COALESCE(rm.saidas_periodo, 0))::numeric AS saldo_atual,
        
        c.dia_fechamento,
        c.dia_vencimento
    FROM public.contas_bancarias c
    LEFT JOIN resumo_movimentos rm ON rm.conta_id = c.id
    WHERE c.organization_id = p_org_id AND c.ativo = true
    ORDER BY c.tipo ASC, c.nome ASC;
END;
$$;


ALTER FUNCTION "public"."obter_saldos_contas_por_periodo"("p_org_id" "uuid", "p_data_inicio" timestamp with time zone, "p_data_fim" timestamp with time zone) OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."populate_organization_defaults"() RETURNS "trigger"
    LANGUAGE "plpgsql" SECURITY DEFINER
    AS $_$BEGIN
  -- =================================================================
  -- ⛪ CENÁRIO 1: IGREJA (Gestão Eclesiástica Profissional)
  -- =================================================================
  IF NEW.tipo = 'Igreja' THEN

    -- A. Contas Bancárias
    INSERT INTO public.contas_bancarias (organization_id, nome, tipo, saldo_inicial) VALUES
    (NEW.id, '01. Cofre / Tesouraria (Dinheiro em Espécie)', 'CAIXA_FISICO', 0.00),
    (NEW.id, '02. Conta Corrente Principal (Movimento)', 'CORRENTE', 0.00),
    (NEW.id, '03. Cartão de Crédito Corporativo', 'CARTAO', 0.00),
    (NEW.id, '04. Fundo de Obras e Construção (Poupança)', 'POUPANCA', 0.00),
    (NEW.id, '05. Fundo de Missões (Conta Específica)', 'CORRENTE', 0.00),
    (NEW.id, '99. Transferências Internas', 'VIRTUAL', 0.00),
    (NEW.id, '06. Investimentos e Aplicações (Reserva)', 'INVESTIMENTO', 0.00);

    -- B. Centros de Custo (Distribuição do Orçamento)
    INSERT INTO public.centros_custo (organization_id, nome, is_padrao, is_fundo, ativo, cor_hex, descricao) VALUES
    (NEW.id, '00. Fundo Geral / Tesouraria', false, true, true, '#8E949D', 'Fundo Geral oficial da instituição, onde caem os dízimos não carimbados.'),
    (NEW.id, '01. Administração e Templo', true, false, true, '#D32F2F', 'Custos operacionais fixos, escritório, contas de consumo e gestão central.'),
    (NEW.id, '02. Eventos e Comunhão', false, false, true, '#C2185B', 'Festividades, retiros, recepções e momentos de confraternização da irmandade.'),
    (NEW.id, '03. Ministério de Missões e Evangelismo', false, false, true, '#7B1FA2', 'Ações de impacto, viagens missionárias, sustento de obreiros no campo.'),
    (NEW.id, '04. Ministério de Ensino (EBD)', false, false, true, '#512DA8', 'Funcionamento da Escola Bíblica, seminários de formação e materiais pedagógicos.'),
    (NEW.id, '05. Ministério Infantil e Juniores', false, false, true, '#303F9F', 'Atividades, lanches e recursos didáticos para o departamento de crianças.'),
    (NEW.id, '06. Ministério de Jovens e Adolescentes', false, false, true, '#1976D2', 'Ações, cultos e eventos voltados para a juventude (rede jovem).'),
    (NEW.id, '07. Ministério de Louvor e Mídia', false, false, true, '#0097A7', 'Equipamentos de som, instrumentos, equipe de transmissão e projeção.'),
    (NEW.id, '08. Ministério de Mulheres', false, false, true, '#00796B', 'Atividades e eventos realizados pelo departamento feminino.'),
    (NEW.id, '09. Ministério de Homens', false, false, true, '#388E3C', 'Atividades e eventos realizados pelo departamento masculino.'),
    (NEW.id, '10. Ministério de Ação Social', false, false, true, '#AFB42B', 'Cestas básicas e auxílio a famílias em vulnerabilidade dentro e fora da igreja.'),
    (NEW.id, '11. Manutenção Predial e Zeladoria', false, false, true, '#F57C00', 'Cuidados com o templo físico, climatização, limpeza, reformas e pequenos reparos.'),
    (NEW.id, '12. Terceiros e Adiantamentos', false, false, true, '#5D4037', 'Valores em trânsito, reembolsos ou pagamentos por conta de terceiros.');

    -- C. Plano de Contas Eclesiástico (CORRIGIDO E NORMALIZADO)
    INSERT INTO public.plano_contas 
    (organization_id, nome, codigo_contabil, tipo, natureza_fluxo, permite_lancamento, instrucao_uso) 
    VALUES

    -- 1.0 RECEITAS (SINTÉTICA)
    (NEW.id, '1.0 RECEITAS DA IGREJA', '1.0', 'RECEITA', 'ENTRADA', FALSE, 'Grupo principal de entradas e arrecadações.'),

    (NEW.id, '1.1 Entradas Operacionais', '1.1', 'RECEITA', 'ENTRADA', FALSE, 'Agrupador de dízimos e ofertas.'),
    (NEW.id, 'Dízimos', '1.1.01', 'RECEITA', 'ENTRADA', TRUE, 'Contribuições regulares e sistemáticas de membros (10%).'),
    (NEW.id, 'Ofertas de Culto Público (Alçadas)', '1.1.02', 'RECEITA', 'ENTRADA', TRUE, 'Valores voluntários entregues nos cultos sem destinação específica.'),
    (NEW.id, 'Ofertas Carimbadas para Missões', '1.1.03', 'RECEITA', 'ENTRADA', TRUE, 'Valores específicos exclusivos para o fundo de missões.'),
    (NEW.id, 'Ofertas para Construção e Reformas', '1.1.04', 'RECEITA', 'ENTRADA', TRUE, 'Arrecadações específicas para obras ou compra de imóveis.'),
    (NEW.id, 'Votos e Doações Específicas', '1.1.05', 'RECEITA', 'ENTRADA', TRUE, 'Ex: Doação de um irmão para comprar cadeiras ou um ar condicionado.'),
    (NEW.id, 'Venda de Cantina, Bazar e Livraria', '1.1.06', 'RECEITA', 'ENTRADA', TRUE, 'Receita bruta de vendas internas realizadas por ministérios.'),
    (NEW.id, 'Inscrições de Eventos e Retiros', '1.1.07', 'RECEITA', 'ENTRADA', TRUE, 'Taxas pagas por membros para participar de retiros, acampamentos ou jantares.'),
	(NEW.id, 'Outras Entradas Operacionais', '1.1.99', 'RECEITA', 'ENTRADA', TRUE, 'Receitas eventuais que não se enquadram nas categorias principais.'),	

    (NEW.id, '1.2 Receitas Não Operacionais', '1.2', 'RECEITA', 'ENTRADA', FALSE, 'Ganhos financeiros ou extraordinários.'),
    (NEW.id, 'Rendimentos Financeiros', '1.2.01', 'RECEITA', 'ENTRADA', TRUE, 'Juros de aplicações, CDB, Poupança do Fundo de Construção.'),
    (NEW.id, 'Reembolsos e Devoluções', '1.2.02', 'RECEITA', 'ENTRADA', TRUE, 'Retorno de trocos ou acertos de adiantamentos feitos a líderes.'),
    (NEW.id, 'Venda de Bens/Ativos Usados', '1.2.03', 'RECEITA', 'ENTRADA', TRUE, 'Recebimento pela venda de um carro da igreja, instrumentos antigos, etc.'),
    (NEW.id, 'Outras Entradas Não Oper.', '1.2.99', 'RECEITA', 'ENTRADA', TRUE, 'Receitas eventuais que não se enquadram nas categorias principais.'),	

    -- 2.0 DESPESAS (SINTÉTICA)
    (NEW.id, '2.0 DESPESAS DA IGREJA', '2.0', 'DESPESA', 'SAIDA', FALSE, 'Grupo principal de saídas operacionais.'),

    (NEW.id, '2.1 Sustento Pastoral e Pessoal', '2.1', 'DESPESA', 'SAIDA', FALSE, 'Gastos com liderança, ministros e funcionários da igreja.'),
    (NEW.id, 'Prebenda Pastoral (Congrua)', '2.1.01', 'DESPESA', 'SAIDA', TRUE, 'Sustento do ministro religioso (Não é salário, é provento eclesiástico).'),
    (NEW.id, 'Auxílio Moradia/Combustível Pastoral', '2.1.02', 'DESPESA', 'SAIDA', TRUE, 'Ajuda de custo específica prevista em ata para o pastor.'),
    (NEW.id, 'Ofertas a Preletores/Cantores Convidados', '2.1.03', 'DESPESA', 'SAIDA', TRUE, 'Honorários/Ofertas entregues a convidados externos.'),
    (NEW.id, 'Salários Funcionários (CLT)', '2.1.04', 'DESPESA', 'SAIDA', TRUE, 'Folha de pagamento de secretária, zelador, etc.'),
    (NEW.id, 'Encargos e Impostos (INSS/FGTS/IRRF)', '2.1.05', 'DESPESA', 'SAIDA', TRUE, 'Tributos sobre folha e INSS patronal/retido do pastor.'),
    (NEW.id, 'Benefícios (VT/VA)', '2.1.06', 'DESPESA', 'SAIDA', TRUE, 'Vale transporte e alimentação de funcionários CLT.'),

    (NEW.id, '2.2 Estrutura e Administração', '2.2', 'DESPESA', 'SAIDA', FALSE, 'Gastos fixos para manter as portas da igreja abertas.'),
    (NEW.id, 'Aluguel do Imóvel/Templo', '2.2.01', 'DESPESA', 'SAIDA', TRUE, 'Pagamento mensal de locação do espaço físico.'),
    (NEW.id, 'Energia Elétrica/Água/Gás', '2.2.02', 'DESPESA', 'SAIDA', TRUE, 'Contas de concessionárias.'),
    (NEW.id, 'Internet/Telefonia/Streaming', '2.2.03', 'DESPESA', 'SAIDA', TRUE, 'Planos de fibra ótica e comunicação da secretaria.'),
    (NEW.id, 'Manutenção Predial e Reparos', '2.2.04', 'DESPESA', 'SAIDA', TRUE, 'Consertos, troca de lâmpadas, limpeza de ar condicionado.'),
    (NEW.id, 'Segurança e Monitoramento', '2.2.05', 'DESPESA', 'SAIDA', TRUE, 'Empresa de alarme, câmeras e vigilância.'),
    (NEW.id, 'Limpeza e Higiene', '2.2.06', 'DESPESA', 'SAIDA', TRUE, 'Insumos de limpeza e pagamento de diárias de zeladoria.'),
    (NEW.id, 'Contabilidade, Cartório e Jurídico', '2.2.07', 'DESPESA', 'SAIDA', TRUE, 'Honorários contábeis, taxas de registro de atas e advogados.'),
    (NEW.id, 'Taxas Bancárias', '2.2.08', 'DESPESA', 'SAIDA', TRUE, 'Tarifas de conta, aluguel de maquininha de cartão e juros de boletos.'),
    (NEW.id, 'Taxas Associativas (Convenção/Ordem)', '2.2.09', 'DESPESA', 'SAIDA', TRUE, 'Contribuições mensais para a Convenção Estadual ou Nacional.'),
    (NEW.id, 'Direitos Autorais e Licenças (ECAD)', '2.2.10', 'DESPESA', 'SAIDA', TRUE, 'Recolhimento obrigatório por uso de obras musicais.'),
    (NEW.id, 'Materiais de Escritório', '2.2.11', 'DESPESA', 'SAIDA', TRUE, 'Compra de papelaria, insumos de impressão e organização de escritório.'),
    (NEW.id, 'Seguros (Imóvel/Veículos/Eventos)', '2.2.12', 'DESPESA', 'SAIDA', TRUE, 'Apólices de proteção de bens e responsabilidade civil.'),
    (NEW.id, 'Juros e Multas', '2.2.13', 'DESPESA', 'SAIDA', 'TRUE', 'Encargos e penalidades por atraso no pagamento de obrigações.'),
    (NEW.id, 'Adiantamentos/Pagamentos por Terceiros', '2.2.14', 'DESPESA', 'SAIDA', TRUE, 'Valores repassados a terceiros que serão reembolsados futuramente.'),
    (NEW.id, 'Taxas e Alvarás Governamentais', '2.2.15', 'DESPESA', 'SAIDA', TRUE, 'Renovação de licenças de funcionamento, bombeiros e taxas municipais.'),
    (NEW.id, 'Copa e Cozinha', '2.2.16', 'DESPESA', 'SAIDA', TRUE, 'Insumos como café, açúcar e materiais de limpeza voltados para a copa.'),
    (NEW.id, 'Combustível e Transporte', '2.2.17', 'DESPESA', 'SAIDA', TRUE, 'Deslocamento de veículos oficiais e ajuda de custo para transporte.'),
    (NEW.id, 'Fretes e Entregas', 'DESPESA', '2.2.18', 'SAIDA', TRUE, 'Custos com transportadoras, envios postais ou motoboys.'),

    (NEW.id, '2.3 Educação Cristã', '2.3', 'DESPESA', 'SAIDA', FALSE, 'Investimento no ensino e Escola Bíblica.'),
    (NEW.id, 'Material Didático (Revistas EBD)', '2.3.01', 'DESPESA', 'SAIDA', TRUE, 'Compra de revistas trimestrais, Bíblias e livros para alunos.'),
    (NEW.id, 'Treinamento de Líderes e Cursos', '2.3.02', 'DESPESA', 'SAIDA', TRUE, 'Inscrição de líderes em seminários ou capacitações externas.'),

    (NEW.id, '2.4 Comunicação, Mídia e Som', '2.4', 'DESPESA', 'SAIDA', FALSE, 'Tecnologia da igreja.'),
    (NEW.id, 'Softwares e Assinaturas Digitais', '2.4.01', 'DESPESA', 'SAIDA', TRUE, 'Mensalidade do sistema de gestão, Holyrics, Canva, Zoom.'),
    (NEW.id, 'Equipamentos e Acessórios (Som/Vídeo)', '2.4.02', 'DESPESA', 'SAIDA', TRUE, 'Cabos, pilhas, palhetas, pequenos reparos em instrumentos.'),
    (NEW.id, 'Gráfica, Banners e Impressos', '2.4.03', 'DESPESA', 'SAIDA', TRUE, 'Impressão de panfletos, faixas de eventos e informativos.'),

    (NEW.id, '2.5 Ação Social', '2.5', 'DESPESA', 'SAIDA', FALSE, 'Ministério de benevolência voltado à comunidade local.'),
    (NEW.id, 'Cestas Básicas e Alimentos', '2.5.01', 'DESPESA', 'SAIDA', TRUE, 'Compra de alimentos para doação a famílias carentes.'),
    (NEW.id, 'Ajuda Financeira a Membros', '2.5.02', 'DESPESA', 'SAIDA', TRUE, 'Pagamento de contas de luz, remédios ou auxílio funeral para irmãos necessitados.'),

    (NEW.id, '2.6 Liturgia e Eventos', '2.6', 'DESPESA', 'SAIDA', FALSE, 'Custos com cultos, ceia, festividades e recepções.'),
    (NEW.id, 'Ceia do Senhor (Elementos)', '2.6.01', 'DESPESA', 'SAIDA', TRUE, 'Pão, suco de uva e cálices descartáveis.'),
    (NEW.id, 'Decoração e Infraestrutura de Eventos', '2.6.02', 'DESPESA', 'SAIDA', TRUE, 'Locação de tendas, cadeiras extras, flores e decoração para festas.'),
    (NEW.id, 'Alimentação de Eventos/Cantina', '2.6.03', 'DESPESA', 'SAIDA', TRUE, 'Compra de insumos para fazer almoços, jantares ou lanches de eventos.'),
    (NEW.id, 'Hospedagem e Passagens', '2.6.04', 'DESPESA', 'SAIDA', TRUE, 'Hotel, passagens aéreas ou rodoviárias para preletores visitantes.'),
	(NEW.id, 'Presentes e Homenagens', '2.6.05', 'DESPESA', 'SAIDA', TRUE, 'Itens adquiridos para presentear membros, voluntários ou datas comemorativas.'),
	
    -- GRUPO NOVO CORRIGIDO: MISSÕES (Obrigatório devido às receitas de missões)
    (NEW.id, '2.7 Missões e Evangelismo', '2.7', 'DESPESA', 'SAIDA', FALSE, 'Saídas exclusivas para avanço missionário.'),
    (NEW.id, 'Sustento Missionário (Campo)', '2.7.01', 'DESPESA', 'SAIDA', TRUE, 'Envio financeiro mensal para missionários apoiados pela igreja.'),
    (NEW.id, 'Agências Missionárias', '2.7.02', 'DESPESA', 'SAIDA', TRUE, 'Doações institucionais para bases missionárias.'),
    (NEW.id, 'Materiais de Evangelismo e Impacto', '2.7.03', 'DESPESA', 'SAIDA', TRUE, 'Compra de folhetos, Bíblias para doação e ações de rua.'),

    -- 3.0 ATIVOS (Patrimônio) - Raízes com Natureza NULL
    (NEW.id, '3.0 ATIVOS E IMOBILIZADO', '3.0', 'ATIVO', NULL, FALSE, 'Investimentos duráveis e aquisição de patrimônio da igreja.'),
    (NEW.id, '3.1 Aquisições Patrimoniais', '3.1', 'ATIVO', NULL, FALSE, 'Agrupador de bens tangíveis.'),
    (NEW.id, 'Aquisição de Imóveis (Templo/Terrenos)', '3.1.01', 'ATIVO', 'SAIDA', TRUE, 'Compra de imóveis. Diminui o caixa, mas aumenta o patrimônio.'),
    (NEW.id, 'Aquisição de Veículos (Frota da Igreja)', '3.1.02', 'ATIVO', 'SAIDA', TRUE, 'Compra de ônibus, vans ou carros institucionais.'),
    (NEW.id, 'Instrumentos Musicais e Mesa de Som', '3.1.03', 'ATIVO', 'SAIDA', TRUE, 'Equipamentos duráveis e de alto valor (Ativo Imobilizado).'),
    (NEW.id, 'Móveis, Ar Condicionado e Instalações', '3.1.04', 'ATIVO', 'SAIDA', TRUE, 'Climatização pesada, bancos de madeira, púlpitos e telões de LED.'),

    -- 4.0 PASSIVOS (Dívidas) - Raízes com Natureza NULL
    (NEW.id, '4.0 PASSIVOS E OBRIGAÇÕES', '4.0', 'PASSIVO', NULL, FALSE, 'Registro de obrigações financeiras de longo prazo e empréstimos.'),
    (NEW.id, '4.1 Empréstimos e Parcelamentos', '4.1', 'PASSIVO', NULL, FALSE, 'Agrupador de movimentação de dívidas.'),
    (NEW.id, 'Entrada de Dinheiro via Empréstimo', '4.1.01', 'PASSIVO', 'ENTRADA', TRUE, 'Gera entrada de caixa via crédito tomado no banco.'),
    (NEW.id, 'Amortização do Principal (Pagamento da Dívida)', '4.1.02', 'PASSIVO', 'SAIDA', TRUE, 'Redução da dívida pagando parcelas (Lançar os juros na conta 2.2.08).'),
    (NEW.id, 'Acordos e Dívidas Renegociadas', '4.1.03', 'PASSIVO', 'SAIDA', TRUE, 'Pagamento de compromissos atrasados negociados a longo prazo.'),

    -- 5.0 PATRIMÔNIO LÍQUIDO E TRANSIÇÕES - Raízes com Natureza NULL
    (NEW.id, '5.0 PATRIMÔNIO SOCIAL', '5.0', 'PL', NULL, FALSE, 'Riqueza acumulada da organização religiosa.'),
    (NEW.id, '5.1 Fundo Institucional', '5.1', 'PL', NULL, FALSE, 'Agrupador de capital da igreja.'),
    (NEW.id, 'Fundo Patrimonial da Igreja', '5.1.01', 'PL', NULL, TRUE, 'Representa o valor do estatuto e fundação histórica.'),
    (NEW.id, 'Superávit / Reservas Acumuladas', '5.1.02', 'PL', NULL, TRUE, 'Sobras financeiras de anos anteriores.'),
    (NEW.id, 'Ajuste de Balanço Inicial (Implantação)', '5.1.03', 'PL', NULL, TRUE, 'Usado apenas para inserir o saldo das contas bancárias ao começar a usar o sistema.'),

    -- 9.9.99 Conta de trânsito (SISTEMA)
    (NEW.id, 'Transferências Internas / Subsídios', '9.9.99', 'PL', NULL, TRUE, 'Conta de trânsito invisível para transferir recursos e orçamentos entre Ministérios.');

  -- =================================================================
  -- 🏢 CENÁRIO 2: ONG / OSC (Organização da Sociedade Civil)
  -- =================================================================
  ELSIF NEW.tipo = 'OSC' THEN

    -- A. Contas Bancárias (Rastreabilidade e Compliance)
    -- Na OSC, é obrigatório separar o dinheiro público do dinheiro privado.
    INSERT INTO public.contas_bancarias (organization_id, nome, tipo, saldo_inicial) VALUES
    (NEW.id, '01. Caixa Fixo / Tesouraria (Dinheiro em Espécie)', 'CAIXA_FISICO', 0.00),
    (NEW.id, '02. Conta Corrente Principal (Recursos Livres/Próprios)', 'CORRENTE', 0.00),
    (NEW.id, '03. Conta Vinculada - Fomento Municipal/Estadual', 'CORRENTE', 0.00),
    (NEW.id, '04. Conta Vinculada - Emendas Parlamentares', 'CORRENTE', 0.00),
    (NEW.id, '05. Cartão de Crédito Corporativo', 'CARTAO', 0.00),
    (NEW.id, '06. Fundo de Reserva Institucional (Aplicações)', 'INVESTIMENTO', 0.00),
    (NEW.id, '99. Transferências Internas', 'VIRTUAL', 0.00);

    -- B. Centros de Custo (Estrutura Analítica de Projetos - EAP)
    INSERT INTO public.centros_custo (organization_id, nome, is_padrao, is_fundo, ativo, cor_hex, descricao) VALUES
    (NEW.id, '00. Fundo Geral / Matriz Institucional', false, true, true, '#8E949D', 'O caixa livre da OSC. Recebe doações sem restrição e financia a máquina administrativa.'),
    (NEW.id, '01. Gestão Executiva e Governança', true, false, true, '#D32F2F', 'Custeio da diretoria, honorários contábeis/jurídicos e obrigações estatutárias.'),
    (NEW.id, '02. Captação de Recursos e Comunicação', false, false, true, '#C2185B', 'Equipe de telemarketing, marketing social, campanhas e elaboração de projetos.'),
    (NEW.id, '03. Projeto: Assistência Social e Acolhimento', false, false, true, '#1976D2', 'Atendimento direto, distribuição de cestas, roupas e triagem de vulnerabilidade.'),
    (NEW.id, '04. Projeto: Educação e Capacitação', false, false, true, '#512DA8', 'Cursos de qualificação profissional, reforço escolar e inclusão digital.'),
    (NEW.id, '05. Projeto: Cultura e Esporte Comunitário', false, false, true, '#0097A7', 'Oficinas de música, teatro, escolinhas de futebol, judô e balé.'),
    (NEW.id, '06. Projeto: Saúde e Bem-Estar', false, false, true, '#388E3C', 'Terapias, atendimento psicológico, assistência nutricional e campanhas de prevenção.'),
    (NEW.id, '07. Geração de Renda: Bazar e Brechó', false, false, true, '#F57C00', 'Estrutura de venda de itens doados para gerar recursos próprios (livres).'),
    (NEW.id, '08. Geração de Renda: Cantina e Oficinas', false, false, true, '#AFB42B', 'Venda de produtos fabricados na OSC (padaria comunitária, artesanato).'),
    (NEW.id, '09. Manutenção Predial e Frota', false, false, true, '#5D4037', 'Custo com a sede física, contas de consumo, limpeza e manutenção das vans/kombis.'),
    (NEW.id, '10. Voluntariado e Ação Comunitária', false, false, true, '#7B1FA2', 'Gestão, treinamento e ressarcimento de ajudas de custo para a rede de voluntários.'),
    (NEW.id, '11. Terceiros e Repasses em Trânsito', false, false, true, '#455A64', 'Valores pendentes de prestação de contas de oficineiros e educadores.');

    -- C. Plano de Contas OSC (Adequado ao MROSC e ITG 2002)
    INSERT INTO public.plano_contas 
    (organization_id, nome, codigo_contabil, tipo, natureza_fluxo, permite_lancamento, instrucao_uso) 
    VALUES

    -- 1.0 RECEITAS (SINTÉTICA)
    (NEW.id, '1.0 RECEITAS E ARRECADAÇÕES', '1.0', 'RECEITA', 'ENTRADA', FALSE, 'Grupo principal de entradas da organização.'),

    (NEW.id, '1.1 Receitas com Restrição (Recursos Carimbados)', '1.1', 'RECEITA', 'ENTRADA', FALSE, 'Verbas que exigem prestação de contas rigorosa da finalidade.'),
    (NEW.id, 'Subvenções e Fomentos Municipais', '1.1.01', 'RECEITA', 'ENTRADA', TRUE, 'Repasses da prefeitura (Termo de Fomento ou Colaboração).'),
    (NEW.id, 'Subvenções e Fomentos Estaduais/Federais', '1.1.02', 'RECEITA', 'ENTRADA', TRUE, 'Repasses do Estado ou União para execução de projetos.'),
    (NEW.id, 'Emendas Parlamentares', '1.1.03', 'RECEITA', 'ENTRADA', TRUE, 'Recursos direcionados por deputados ou vereadores.'),
    (NEW.id, 'Fundos de Direitos (FIA, Fundo do Idoso)', '1.1.04', 'RECEITA', 'ENTRADA', TRUE, 'Captação via renúncia fiscal do Imposto de Renda.'),
    (NEW.id, 'Patrocínio de Empresas (Projetos Específicos)', '1.1.05', 'RECEITA', 'ENTRADA', TRUE, 'Empresas que doam para uma oficina ou evento específico.'),

    (NEW.id, '1.2 Receitas sem Restrição (Recursos Livres)', '1.2', 'RECEITA', 'ENTRADA', FALSE, 'Geração de caixa próprio da OSC (Fundo Geral).'),
    (NEW.id, 'Doações de Pessoas Físicas (Doadores/Padrinhos)', '1.2.01', 'RECEITA', 'ENTRADA', TRUE, 'Contribuições mensais via carnê, PIX ou cartão de crédito.'),
    (NEW.id, 'Doações de Pessoas Jurídicas (Livres)', '1.2.02', 'RECEITA', 'ENTRADA', TRUE, 'Empresas que apoiam a causa sem exigir vinculação a um projeto.'),
    (NEW.id, 'Arrecadação de Campanhas e Telemarketing', '1.2.03', 'RECEITA', 'ENTRADA', TRUE, 'Doações geradas por ligações ativas ou campanhas de rua.'),
    (NEW.id, 'Eventos Beneficentes (Jantares, Feijoadas)', '1.2.04', 'RECEITA', 'ENTRADA', TRUE, 'Venda de convites e arrecadações em eventos de gala ou populares.'),
    (NEW.id, 'Venda de Produtos (Bazar, Brechó, Artesanato)', '1.2.05', 'RECEITA', 'ENTRADA', TRUE, 'Receita bruta gerada pelas frentes de economia solidária da OSC.'),
    (NEW.id, 'Prestação de Serviços (Cursos/Palestras)', '1.2.06', 'RECEITA', 'ENTRADA', TRUE, 'Recebimento por capacitações ou consultorias oferecidas pela OSC.'),

    (NEW.id, '1.3 Receitas Financeiras e Extraordinárias', '1.3', 'RECEITA', 'ENTRADA', FALSE, 'Ganhos passivos de capital.'),
    (NEW.id, 'Rendimentos de Aplicações e Poupança', '1.3.01', 'RECEITA', 'ENTRADA', TRUE, 'Juros sobre os saldos mantidos nas contas bancárias.'),
    (NEW.id, 'Recuperação de Despesas / Reembolsos', '1.3.02', 'RECEITA', 'ENTRADA', TRUE, 'Devolução de valores adiantados que não foram utilizados.'),
    (NEW.id, 'Venda de Ativos Imobilizados (Sucata/Veículos)', '1.3.03', 'RECEITA', 'ENTRADA', TRUE, 'Entrada de caixa pela venda de bens obsoletos da instituição.'),

    -- 2.0 DESPESAS E CUSTOS (SINTÉTICA)
    (NEW.id, '2.0 DESPESAS E CUSTOS SOCIAIS', '2.0', 'DESPESA', 'SAIDA', FALSE, 'Grupo principal de desembolsos da organização.'),

    (NEW.id, '2.1 Pessoal e Encargos (RH Técnico e Administrativo)', '2.1', 'DESPESA', 'SAIDA', FALSE, 'Custeio da equipe contratada.'),
    (NEW.id, 'Salários e Ordenados (CLT)', '2.1.01', 'DESPESA', 'SAIDA', TRUE, 'Folha de pagamento de assistentes sociais, psicólogos, coordenadores.'),
    (NEW.id, 'Encargos Trabalhistas (INSS/FGTS/PIS)', '2.1.02', 'DESPESA', 'SAIDA', TRUE, 'Tributos sobre a folha (observar isenções de CEBAS, se houver).'),
    (NEW.id, 'Benefícios (Vale Transporte/Alimentação)', '2.1.03', 'DESPESA', 'SAIDA', TRUE, 'Benefícios legais pagos aos funcionários.'),
    (NEW.id, 'Serviços de Terceiros e Autônomos (RPA/PJ)', '2.1.04', 'DESPESA', 'SAIDA', TRUE, 'Honorários de oficineiros, palestrantes e profissionais sem vínculo CLT.'),
    (NEW.id, 'Ajuda de Custo para Voluntários (Lei 9.608/98)', '2.1.05', 'DESPESA', 'SAIDA', TRUE, 'Ressarcimento legal de transporte e alimentação para voluntários.'),

    (NEW.id, '2.2 Custos Diretos dos Projetos Fim (Atividade-Fim)', '2.2', 'DESPESA', 'SAIDA', FALSE, 'Despesas que chegam diretamente ao beneficiário da OSC.'),
    (NEW.id, 'Gêneros Alimentícios e Cestas Básicas', '2.2.01', 'DESPESA', 'SAIDA', TRUE, 'Comida para doação ou preparo de lanches para as crianças/assistidos.'),
    (NEW.id, 'Material Pedagógico, Didático e Cultural', '2.2.02', 'DESPESA', 'SAIDA', TRUE, 'Cadernos, livros, tintas, instrumentos musicais para as oficinas.'),
    (NEW.id, 'Medicamentos, Fraldas e Materiais de Saúde', '2.2.03', 'DESPESA', 'SAIDA', TRUE, 'Insumos hospitalares, higiene pessoal e farmácia para doação.'),
    (NEW.id, 'Vestuário e Uniformes (Assistidos)', '2.2.04', 'DESPESA', 'SAIDA', TRUE, 'Compra de roupas, cobertores e uniformes para os projetos esportivos.'),
    (NEW.id, 'Transporte de Assistidos / Excursões', '2.2.05', 'DESPESA', 'SAIDA', TRUE, 'Fretamento de ônibus para levar crianças a museus ou torneios.'),

    (NEW.id, '2.3 Custos de Estrutura e Administração (Atividade-Meio)', '2.3', 'DESPESA', 'SAIDA', FALSE, 'Gastos fixos para manter as portas abertas.'),
    (NEW.id, 'Aluguel do Prédio/Sede e Condomínio', '2.3.01', 'DESPESA', 'SAIDA', TRUE, 'Pagamento mensal de locação.'),
    (NEW.id, 'Água, Luz e Gás', '2.3.02', 'DESPESA', 'SAIDA', TRUE, 'Contas de concessionárias.'),
    (NEW.id, 'Internet, Telefonia e Hospedagem de Sites', '2.3.03', 'DESPESA', 'SAIDA', TRUE, 'Comunicação da sede e sistemas de gestão.'),
    (NEW.id, 'Contabilidade, Auditoria e Honorários Jurídicos', '2.3.04', 'DESPESA', 'SAIDA', TRUE, 'Custos essenciais para manter a OSC regularizada nos conselhos.'),
    (NEW.id, 'Manutenção Predial, Reformas e Reparos', '2.3.05', 'DESPESA', 'SAIDA', TRUE, 'Consertos hidráulicos, elétricos, pintura e climatização.'),
    (NEW.id, 'Material de Limpeza e Higiene (Sede)', '2.3.06', 'DESPESA', 'SAIDA', TRUE, 'Insumos para manter a salubridade da organização.'),
    (NEW.id, 'Material de Escritório, Papelaria e Correios', '2.3.07', 'DESPESA', 'SAIDA', TRUE, 'Impressões, toners, papel A4, envios de correspondência.'),
    (NEW.id, 'Combustível, Manutenção e Seguro de Veículos', '2.3.08', 'DESPESA', 'SAIDA', TRUE, 'Custo da frota própria (kombi, vans, carros de apoio).'),
    (NEW.id, 'Despesas de Captação e Marketing', '2.3.09', 'DESPESA', 'SAIDA', TRUE, 'Tráfego pago, impressão de banners, comissionamento de telemarketing.'),
    (NEW.id, 'Taxas Bancárias, Juros e Anuidades', '2.3.10', 'DESPESA', 'SAIDA', TRUE, 'Custo de manutenção de conta, tarifas de boletos e maquininhas.'),
    (NEW.id, 'Taxas de Cartório e Emolumentos', '2.3.11', 'DESPESA', 'SAIDA', TRUE, 'Despesas com registro de atas, estatutos e reconhecimento de firmas.'),
    (NEW.id, 'Multas, Juros e Penalidades (Tributos)', '2.3.12', 'DESPESA', 'SAIDA', TRUE, 'Pagamento de juros e multas por atraso (Ex: DARF Receita Federal). Não usar verba pública para isto.'),

    -- 3.0 ATIVOS (Patrimônio) - Raízes com Natureza NULL
    (NEW.id, '3.0 ATIVOS E IMOBILIZADO', '3.0', 'ATIVO', NULL, FALSE, 'Investimentos duráveis e aquisição de patrimônio da organização.'),
    (NEW.id, '3.1 Aquisições Patrimoniais', '3.1', 'ATIVO', NULL, FALSE, 'Agrupador de bens tangíveis.'),
    (NEW.id, 'Aquisição de Imóveis (Sede Própria/Terrenos)', '3.1.01', 'ATIVO', 'SAIDA', TRUE, 'Compra de imóveis. Diminui o caixa, mas aumenta o patrimônio.'),
    (NEW.id, 'Aquisição de Veículos e Ambulâncias', '3.1.02', 'ATIVO', 'SAIDA', TRUE, 'Compra de frota para uso institucional.'),
    (NEW.id, 'Máquinas, Equipamentos Industriais e Médicos', '3.1.03', 'ATIVO', 'SAIDA', TRUE, 'Ex: Fornos para padaria solidária, macas, equipamentos de ponta.'),
    (NEW.id, 'Móveis, Informática e Climatização', '3.1.04', 'ATIVO', 'SAIDA', TRUE, 'Computadores, mesas, cadeiras, projetores e ar-condicionado.'),

    -- 4.0 PASSIVOS (Dívidas) - Raízes com Natureza NULL
    (NEW.id, '4.0 PASSIVOS E OBRIGAÇÕES', '4.0', 'PASSIVO', NULL, FALSE, 'Registro de obrigações financeiras de longo prazo e empréstimos.'),
    (NEW.id, '4.1 Empréstimos e Acordos Trabalhistas', '4.1', 'PASSIVO', NULL, FALSE, 'Agrupador de movimentação de dívidas.'),
    (NEW.id, 'Entrada de Dinheiro via Empréstimo', '4.1.01', 'PASSIVO', 'ENTRADA', TRUE, 'Gera entrada de caixa via crédito tomado no banco.'),
    (NEW.id, 'Amortização do Principal (Pagamento da Dívida)', '4.1.02', 'PASSIVO', 'SAIDA', TRUE, 'Redução da dívida pagando parcelas.'),
    (NEW.id, 'Pagamento de Acordos e Indenizações Judiciais', '4.1.03', 'PASSIVO', 'SAIDA', TRUE, 'Pagamento de processos cíveis ou trabalhistas parcelados.'),

    -- 5.0 PATRIMÔNIO LÍQUIDO E TRANSIÇÕES - Raízes com Natureza NULL
    (NEW.id, '5.0 PATRIMÔNIO SOCIAL', '5.0', 'PL', NULL, FALSE, 'Riqueza acumulada da Organização da Sociedade Civil.'),
    (NEW.id, '5.1 Fundo Institucional e Reservas', '5.1', 'PL', NULL, FALSE, 'Agrupador de capital da OSC.'),
    (NEW.id, 'Patrimônio Social (Fundo Inicial)', '5.1.01', 'PL', NULL, TRUE, 'Representa o valor da dotação inicial no estatuto da instituição.'),
    (NEW.id, 'Superávit / Déficit Acumulado', '5.1.02', 'PL', NULL, TRUE, 'Sobras financeiras de anos anteriores (Legalmente não distribuíveis).'),
    (NEW.id, 'Ajuste de Balanço Inicial (Implantação)', '5.1.03', 'PL', NULL, TRUE, 'Usado apenas para inserir o saldo das contas bancárias ao começar a usar o sistema.'),

    -- 9.9.99 Conta de trânsito (SISTEMA) - A mais crítica do seu sistema Híbrido
    (NEW.id, 'Transferências Internas / Subsídios', '9.9.99', 'PL', NULL, TRUE, 'Conta de trânsito invisível. Usada pelo Fundo Geral para cobrir déficits dos projetos sociais (Ex: Mandar R$ 5k da Matriz para a Educação).');
       
  -- 🏠 CENÁRIO 3: PESSOAL (Família e Patrimônio)
  -- =================================================================
  ELSIF NEW.tipo = 'Família' THEN

    -- A. Contas Bancárias
    INSERT INTO public.contas_bancarias (organization_id, nome, tipo, saldo_inicial) VALUES
    (NEW.id, '01. Carteira (Dinheiro Vivo)', 'CAIXA_FISICO', 0.00),
    (NEW.id, '02. Conta Corrente Principal', 'CORRENTE', 0.00),
    (NEW.id, '03. Conta Conjunta/Secundária', 'CORRENTE', 0.00),
    (NEW.id, '04. Cartão de Crédito', 'CARTAO', 0.00),
    (NEW.id, '05. Vale Alimentação/Refeição', 'CORRENTE', 0.00),
    (NEW.id, '06. Reserva de Emergência (Liquidez Diária)', 'INVESTIMENTO', 0.00),
    (NEW.id, '99. Transferências Internas', 'VIRTUAL', 0.00),
    (NEW.id, '06. Investimentos (Corretora/Ações)', 'INVESTIMENTO', 0.00);

    -- B. Centros de Custo
    INSERT INTO public.centros_custo (organization_id, nome, is_padrao, is_fundo, ativo, cor_hex, descricao) VALUES
    (NEW.id, '00. Fundo Geral', false, true, true, '#8E949D', 'Local destinado a guardar todos os recebimentos antes da distribuição.'),
    (NEW.id, '01. Manutenção da Casa', true, false, true, '#D32F2F', 'Gastos compartilhados da residência: supermercado, contas de consumo e suprimentos.'),
    (NEW.id, '02. Pessoal - Titular', false, false, true, '#C2185B', 'Gastos individuais e exclusivos do titular: vestuário, hobbies, cuidados e lazer pessoal.'),
    (NEW.id, '03. Pessoal - Cônjuge', false, false, true, '#7B1FA2', 'Gastos individuais e exclusivos do cônjuge: vestuário, hobbies, cuidados e lazer pessoal.'),
    (NEW.id, '04. Filhos e Dependentes', false, false, true, '#512DA8', 'Custos com educação, saúde, vestuário e lazer voltados especificamente para os filhos.'),
    (NEW.id, '05. Animais de Estimação (Pets)', false, false, true, '#303F9F', 'Saúde, alimentação e higiene dos animais da família (Veterinário, Ração, Banho).'),
    (NEW.id, '06. Gestão de Veículos', false, false, true, '#1976D2', 'Custos totais de manutenção, combustível, impostos e seguros da frota familiar.'),
    (NEW.id, '07. Patrimônio e Imóvel', false, false, true, '#0097A7', 'Investimentos na propriedade: reformas, impostos prediais, seguros e valorização do bem.'),
    (NEW.id, '08. Lazer e Estilo de Vida', false, false, true, '#00796B', 'Gastos com qualidade de vida: viagens, passeios em família, jantares fora e entretenimento.'),
    (NEW.id, '09. Terceiros e Empréstimos', false, false, true, '#388E3C', 'Dinheiro em trânsito: valores emprestados a outros ou pagamentos de dívidas de terceiros.');

    -- C. Plano de Contas Corrigido (Fiel ao JSON)
    INSERT INTO public.plano_contas 
    (organization_id, nome, codigo_contabil, tipo, natureza_fluxo, permite_lancamento, instrucao_uso) 
    VALUES

    -- GRUPO 1: RECEITAS
    (NEW.id, '1.0 RECEITAS FAMILIARES', '1.0', 'RECEITA', 'ENTRADA', FALSE, 'Grupo principal de todas as entradas financeiras da família.'),
    
    (NEW.id, '1.1 Renda Ativa', '1.1', 'RECEITA', 'ENTRADA', FALSE, 'Ganhos resultantes do esforço direto e tempo de trabalho.'),
    (NEW.id, 'Salário Líquido (Holerite)', '1.1.01', 'RECEITA', 'ENTRADA', TRUE, 'Valor líquido que entra na conta após descontos do holerite.'),
    (NEW.id, 'Adiantamento Salarial (Vale)', '1.1.02', 'RECEITA', 'ENTRADA', TRUE, 'Valores recebidos antecipadamente do salário mensal.'),
    (NEW.id, '13º Salário/Férias', '1.1.03', 'RECEITA', 'ENTRADA', TRUE, 'Recebimentos sazonais de férias e gratificação natalina.'),
    (NEW.id, 'Bônus PLR', '1.1.04', 'RECEITA', 'ENTRADA', TRUE, 'Participação nos lucros e premiações corporativas.'),
    (NEW.id, 'Pró-labore (Retirada)', '1.1.05', 'RECEITA', 'ENTRADA', TRUE, 'Remuneração fixa retirada pelos sócios ou titulares.'),
    
    (NEW.id, '1.2 Renda Passiva e Extra', '1.2', 'RECEITA', 'ENTRADA', FALSE, 'Ganhos que não dependem diretamente de jornada de trabalho fixa.'),
    (NEW.id, 'Renda Extra/Freelance', '1.2.01', 'RECEITA', 'ENTRADA', TRUE, 'Trabalhos pontuais, consultorias e serviços extras.'),
    (NEW.id, 'Dividendos/Rendimentos', '1.2.02', 'RECEITA', 'ENTRADA', TRUE, 'Lucros de investimentos, ações, FIIs e juros de contas.'),
    (NEW.id, 'Reembolso de Terceiros (Cartão/Empréstimo)', '1.2.03', 'RECEITA', 'ENTRADA', TRUE, 'Retorno de valores emprestados ou gastos no seu cartão para outros.'),
    (NEW.id, 'Presentes em Dinheiro', '1.2.04', 'RECEITA', 'ENTRADA', TRUE, 'Doações, presentes de aniversário ou heranças pontuais.'),
    
    (NEW.id, '1.3 Outras Entradas', '1.3', 'RECEITA', 'ENTRADA', FALSE, 'Entradas diversas e desmobilização de ativos.'),
    (NEW.id, 'Venda de Bens Menores', '1.3.01', 'RECEITA', 'ENTRADA', TRUE, 'Venda de itens usados (OLX, eletrónicos antigos, móveis).'),

    -- GRUPO 2: DESPESAS
    (NEW.id, '2.0 DESPESAS FAMILIARES', '2.0', 'DESPESA', 'SAIDA', FALSE, 'Agrupador geral de saídas da família.'),
    
    (NEW.id, '2.1 Habitação', '2.1', 'DESPESA', 'SAIDA', FALSE, 'Custos de manutenção e permanência na residência.'),
    (NEW.id, 'Aluguel Habitacional', '2.1.01', 'DESPESA', 'SAIDA', TRUE, 'Pagamento mensal de moradia.'),
    (NEW.id, 'Condomínio', '2.1.02', 'DESPESA', 'SAIDA', TRUE, 'Taxas condominiais e rateios extras de moradia.'),
    (NEW.id, 'Energia/Água/Gás', '2.1.03', 'DESPESA', 'SAIDA', TRUE, 'Contas mensais de utilidades básicas da residência.'),
    (NEW.id, 'Internet/TV/Celular', '2.1.04', 'DESPESA', 'SAIDA', TRUE, 'Serviços de telecomunicação, fibra e planos de dados móveis.'),
    (NEW.id, 'IPTU/Seguro Residencial', '2.1.05', 'DESPESA', 'SAIDA', TRUE, 'Impostos anuais e seguros para proteção do imóvel.'),
    (NEW.id, 'Manutenção e Reparos Casa', '2.1.06', 'DESPESA', 'SAIDA', TRUE, 'Pequenos consertos, manutenções e reparos na residência.'),
    (NEW.id, 'Serviços Domésticos (Diarista)', '2.1.07', 'DESPESA', 'SAIDA', TRUE, 'Pagamento de diaristas, jardineiros ou passadeiras.'),
    (NEW.id, 'Suprimentos e Limpeza', '2.1.08', 'DESPESA', 'SAIDA', TRUE, 'Produtos de limpeza, higiene e utilidades domésticas (não alimentares).'),
    
    (NEW.id, '2.2 Alimentação', '2.2', 'DESPESA', 'SAIDA', FALSE, 'Gastos com sustento e prazer gastronômico.'),
    (NEW.id, 'Supermercado e Feira', '2.2.01', 'DESPESA', 'SAIDA', TRUE, 'Compras de mantimentos essenciais para alimentação da casa.'),
    (NEW.id, 'Padaria e Açougue', '2.2.02', 'DESPESA', 'SAIDA', TRUE, 'Compras diárias ou semanais de pães, frios e carnes frescas.'),
    (NEW.id, 'Restaurantes e Delivery', '2.2.03', 'DESPESA', 'SAIDA', TRUE, 'Refeições fora de casa, aplicativos de delivery e lanches.'),
    
    (NEW.id, '2.3 Saúde e Bem Estar', '2.3', 'DESPESA', 'SAIDA', FALSE, 'Cuidados com a integridade física e mental.'),
    (NEW.id, 'Plano de Saúde/Odonto', '2.3.01', 'DESPESA', 'SAIDA', TRUE, 'Mensalidades de convênios médicos e odontológicos.'),
    (NEW.id, 'Farmácia e Medicamentos', '2.3.02', 'DESPESA', 'SAIDA', TRUE, 'Compras de remédios de uso contínuo ou itens de farmácia.'),
    (NEW.id, 'Estética/Salão/Barbearia', '2.3.03', 'DESPESA', 'SAIDA', TRUE, 'Cuidados pessoais, salão, cortes de cabelo e estética.'),
    (NEW.id, 'Academia e Esportes', '2.3.04', 'DESPESA', 'SAIDA', TRUE, 'Mensalidades de academias, natação ou práticas esportivas.'),
    (NEW.id, 'Medicos\Odontos\Psicólogo\Exames\Outros (Particular)', '2.3.05', 'DESPESA', 'SAIDA', TRUE, 'Consultas e procedimentos médicos particulares, não cobertos por plano.'),
    
    (NEW.id, '2.4 Transporte', '2.4', 'DESPESA', 'SAIDA', FALSE, 'Custos de mobilidade urbana e viagens curtas.'),
    (NEW.id, 'Combustível', '2.4.01', 'DESPESA', 'SAIDA', TRUE, 'Gasolina, etanol, diesel ou recarga elétrica para veículos.'),
    (NEW.id, 'Uber/Táxi/Transporte Público', '2.4.02', 'DESPESA', 'SAIDA', TRUE, 'Custos com mobilidade urbana, táxi e aplicativos de transporte.'),
    (NEW.id, 'IPVA/Licenciamento/Seguro Auto', '2.4.03', 'DESPESA', 'SAIDA', TRUE, 'Impostos anuais obrigatórios e proteção veicular.'),
    (NEW.id, 'Manutenção Mecânica/Lava-jato', '2.4.04', 'DESPESA', 'SAIDA', TRUE, 'Revisões, oficina, troca de óleo, pneus e estética automotiva.'),
    (NEW.id, 'Multas e Infrações', '2.4.05', 'DESPESA', 'SAIDA', TRUE, 'Custos com penalidades de trânsito (inesperados).'),
    
    (NEW.id, '2.5 Estilo de Vida e Educação', '2.5', 'DESPESA', 'SAIDA', FALSE, 'Investimento em conhecimento e qualidade de vida.'),
    (NEW.id, 'Mensalidade Escolar/Faculdade', '2.5.01', 'DESPESA', 'SAIDA', TRUE, 'Educação formal regular, seja escola básica ou ensino superior.'),
    (NEW.id, 'Cursos e Material Escolar', '2.5.02', 'DESPESA', 'SAIDA', TRUE, 'Livros didáticos, cursos livres, mentorias e papelaria estudantil.'),
    (NEW.id, 'Assinaturas Digitais (Netflix/Spotify)', '2.5.03', 'DESPESA', 'SAIDA', TRUE, 'Serviços de streaming (vídeo/música), armazenamento em nuvem e VPNs.'),
    (NEW.id, 'Viagens e Férias', '2.5.04', 'DESPESA', 'SAIDA', TRUE, 'Passagens, hospedagens, passeios e gastos turísticos de lazer.'),
    (NEW.id, 'Vestuário, Calçados e Acessórios', '2.5.05', 'DESPESA', 'SAIDA', TRUE, 'Aquisição de roupas, calçados e acessórios de uso pessoal.'),
    (NEW.id, 'Despesas com Pets (Veterinário/Ração)', '2.5.06', 'DESPESA', 'SAIDA', TRUE, 'Cuidados, ração, banho e tosa, e consultas veterinárias de pets.'),
    (NEW.id, 'Presentes e Comemorações', '2.5.07', 'DESPESA', 'SAIDA', TRUE, 'Compra de presentes para aniversários, casamentos e datas festivas.'),
    (NEW.id, 'Eletrônicos e Pequenos Gadgets', '2.5.08', 'DESPESA', 'SAIDA', TRUE, 'Mouses, teclados, carregadores e itens de tecnologia.'),
    (NEW.id, 'Compras para Terceiros (Empréstimo Cartão)', '2.5.09', 'DESPESA', 'SAIDA', TRUE, 'Compras no seu cartão ou adiantamentos que serão pagos por terceiros.'),
    (NEW.id, 'Outras Despesas Pessoais', '2.5.10', 'DESPESA', 'SAIDA', TRUE, 'Pequenos gastos que não se enquadram nas categorias principais.'),
    
    (NEW.id, '2.6 Obrigações e Finanças', '2.6', 'DESPESA', 'SAIDA', FALSE, 'Compromissos éticos, civis e financeiros.'),
    (NEW.id, 'Dízimos', '2.6.01', 'DESPESA', 'SAIDA', TRUE, 'Contribuições religiosas mensais.'),
    (NEW.id, 'Ofertas/Doações', '2.6.02', 'DESPESA', 'SAIDA', TRUE, 'Apoio ministerial e doações de caridade.'),
    (NEW.id, 'Imposto de Renda (IRPF)', '2.6.03', 'DESPESA', 'SAIDA', TRUE, 'Pagamento de DARF, ajuste anual de IR ou carnê-leão.'),
    (NEW.id, 'Taxas Bancárias e Anuidades', '2.6.04', 'DESPESA', 'SAIDA', TRUE, 'Manutenção de conta e anuidade de cartões.'),
    (NEW.id, 'Juros e Multas Financeiras', '2.6.05', 'DESPESA', 'SAIDA', TRUE, 'Apenas os JUROS de boletos, cheque especial ou dívidas.'),
    (NEW.id, 'Seguro de Vida/Previdência Privada', '2.6.06', 'DESPESA', 'SAIDA', TRUE, 'Proteção familiar e aportes para aposentadoria privada.'),

    -- GRUPO 3: ATIVOS
    (NEW.id, '3.0 ATIVOS (Patrimônio)', '3.0', 'ATIVO', NULL, FALSE, 'Aquisição de bens duráveis e investimentos.'),
    
    (NEW.id, '3.1 Aquisições Patrimoniais', '3.1', 'ATIVO', NULL, FALSE, 'Agrupador de bens tangíveis.'),
    (NEW.id, 'Aquisição de Imóvel', '3.1.01', 'ATIVO', 'SAIDA', TRUE, 'Compra de casa, lote ou apartamento. Impacta caixa, aumenta ativo.'),
    (NEW.id, 'Aquisição de Veículo', '3.1.02', 'ATIVO', 'SAIDA', TRUE, 'Troca ou compra de carro/moto. Impacta caixa, mas aumenta ativo.'),
    (NEW.id, 'Eletrodomésticos e Móveis', '3.1.03', 'ATIVO', 'SAIDA', TRUE, 'Geladeira, Máquina de Lavar, Sofás (Bens duráveis).'),
    (NEW.id, 'Aportes em Investimentos', '3.1.04', 'ATIVO', 'SAIDA', TRUE, 'Envio de dinheiro para Corretora, Ações, FIIs ou CDB.'),

    -- GRUPO 4: PASSIVOS
    (NEW.id, '4.0 PASSIVOS (Dívidas)', '4.0', 'PASSIVO', NULL, FALSE, 'Controle de obrigações de longo prazo.'),
    
    (NEW.id, '4.1 Empréstimos e Parcelamentos', '4.1', 'PASSIVO', NULL, FALSE, 'Agrupador de movimentação de dívidas.'),
    (NEW.id, 'Entrada de Empréstimo', '4.1.01', 'PASSIVO', 'ENTRADA', TRUE, 'Entrada de dinheiro no caixa proveniente de crédito de terceiros.'),
    (NEW.id, 'Amortização de Principal (Financiamento/Empréstimo)', '4.1.02', 'PASSIVO', 'SAIDA', TRUE, 'Pagamento APENAS DO PRINCIPAL da dívida. Juros devem ir para a conta de Juros.'),
    (NEW.id, 'Pagamento de Fatura Atrasada / Acordo', '4.1.03', 'PASSIVO', 'SAIDA', TRUE, 'Quitação de obrigações de faturas de cartões rotativos passados.'),

    -- GRUPO 5: PATRIMÔNIO LÍQUIDO
    (NEW.id, '5.0 PATRIMÔNIO LÍQUIDO', '5.0', 'PL', NULL, FALSE, 'Representa a riqueza real da família (Ativos - Passivos).'),
    
    (NEW.id, '5.1 Fundo Institucional', '5.1', 'PL', NULL, FALSE, 'Agrupador de capital da igreja.'),
    (NEW.id, 'Patrimônio Líquido Familiar', '5.1.01', 'PL', NULL, TRUE, 'Valor líquido da riqueza acumulada pela família (Soma de Ativos - Passivos).'),
    (NEW.id, 'Ajustes de Avaliação Patrimonial', '5.1.02', 'PL', NULL, TRUE, 'Usado para ajustar a valorização ou depreciação de bens sem envolver saída de caixa.'),
    (NEW.id, 'Ajuste de Balanço Inicial (Implantação)', '5.1.03', 'PL', NULL, TRUE, 'Usado apenas para inserir o saldo das contas bancárias ao começar a usar o sistema.'),
    
    -- SISTEMA
    (NEW.id, 'Transferências Internas / Subsídios', '9.9.99', 'PL', NULL, TRUE, 'Conta de trânsito invisível. Usada exclusivamente pelo sistema para transferir orçamentos entre Centros de Resultado.');

  -- =================================================================
  -- 🏢 CENÁRIO 4: COMÉRCIO (Gestão Empresarial)
  -- =================================================================
  ELSIF NEW.tipo = 'Negócio' THEN

    -- A. Contas Bancárias (Ajustado conceitualmente)
    INSERT INTO public.contas_bancarias (organization_id, nome, tipo, saldo_inicial) VALUES
    (NEW.id, '01. Caixa Operacional (PDV/Gaveta)', 'CAIXA_FISICO', 0.00),
    (NEW.id, '02. Banco PJ Principal', 'CORRENTE', 0.00),
    (NEW.id, '03. Banco PJ Secundário', 'CORRENTE', 0.00),
    (NEW.id, '04. Cartão de Crédito Corporativo', 'CARTAO', 0.00),
    (NEW.id, '05. Recebíveis Cartão/Gateways (A Receber)', 'CORRENTE', 0.00), 
    (NEW.id, '99. Transferências Internas', 'VIRTUAL', 0.00),
    (NEW.id, '06. Conta Investimento / Reserva PJ', 'INVESTIMENTO', 0.00);

    -- B. CENTROS DE CUSTO (Distribuição por Resultado)
    INSERT INTO public.centros_custo (organization_id, nome, is_padrao, is_fundo, ativo, cor_hex, descricao) VALUES
    (NEW.id, '00. Fundo Geral', false, true, true, '#8E949D', 'Local destinado a guardar todos os recebimentos.'),
    (NEW.id, '01. Vendas e Expansão', false, false, true, '#D32F2F', 'Equipe comercial, tráfego pago e aquisição de clientes (Foco em Receita).'),
    (NEW.id, '02. Operações e Entrega', false, false, true, '#C2185B', 'Execução do serviço e suporte ao cliente (Foco em Retenção).'),
    (NEW.id, '03. Tecnologia e Inovação', false, false, true, '#7B1FA2', 'Desenvolvimento, AWS, licenças SaaS e infraestrutura digital.'),
    (NEW.id, '04. Back-office e Gestão', true, false, true, '#512DA8', 'Diretoria, financeiro, RH e infraestrutura da sede. (PADRÃO)'),
    (NEW.id, '05. Logística e Suprimentos', false, false, true, '#303F9F', 'Compras, gestão de estoque e fretes de saída.');

    -- C. Plano de Contas (ARQUITETURA SIMÉTRICA DE 3 NÍVEIS)
    INSERT INTO public.plano_contas 
    (organization_id, nome, codigo_contabil, tipo, natureza_fluxo, permite_lancamento, instrucao_uso) 
    VALUES

    -- 1.0 RECEITAS
    (NEW.id, '1.0 RECEITAS', '1.0', 'RECEITA', 'ENTRADA', FALSE, 'Raiz de entradas.'),
    
    (NEW.id, '1.1 Receita Bruta Operacional', '1.1', 'RECEITA', 'ENTRADA', FALSE, 'Faturamento total.'),
    (NEW.id, 'Venda de Produtos (Mercadorias)', '1.1.01', 'RECEITA', 'ENTRADA', TRUE, 'Entrada por vendas de estoque.'),
    (NEW.id, 'Prestação de Serviços', '1.1.02', 'RECEITA', 'ENTRADA', TRUE, 'Faturamento de contratos e mão de obra.'),
    
    (NEW.id, '1.2 Deduções da Receita', '1.2', 'RECEITA', 'SAIDA', FALSE, 'Impostos diretos e estornos.'),
    (NEW.id, 'Impostos S/ Vendas (DAS/ISS/ICMS)', '1.2.01', 'RECEITA', 'SAIDA', TRUE, 'Tributos incidentes direto na Nota Fiscal.'),
    (NEW.id, 'Devoluções e Estornos', '1.2.02', 'RECEITA', 'SAIDA', TRUE, 'Devolução de dinheiro por vendas canceladas.'),
    (NEW.id, 'Descontos Concedidos', '1.2.03', 'RECEITA', 'SAIDA', TRUE, 'Abatimentos financeiros dados aos clientes.'),

    (NEW.id, '1.3 Receitas Não Operacionais', '1.3', 'RECEITA', 'ENTRADA', FALSE, 'Ganhos secundários.'),
    (NEW.id, 'Rendimentos Financeiros', '1.3.01', 'RECEITA', 'ENTRADA', TRUE, 'Juros e rendimentos de aplicações da empresa.'),

    -- 2.0 CUSTOS E DESPESAS (Nivelamento Simétrico)
    (NEW.id, '2.0 CUSTOS E DESPESAS', '2.0', 'DESPESA', 'SAIDA', FALSE, 'Raiz de saídas.'),
    
    (NEW.id, '2.1 Custos Variáveis (CMV/CSV)', '2.1', 'DESPESA', 'SAIDA', FALSE, 'Gastos atrelados diretamente ao volume de vendas.'),
    (NEW.id, 'Compra de Mercadoria p/ Revenda', '2.1.01', 'DESPESA', 'SAIDA', TRUE, 'Custo de aquisição junto a fornecedores.'),
    (NEW.id, 'Insumos e Materiais Aplicados', '2.1.02', 'DESPESA', 'SAIDA', TRUE, 'Materiais gastos na prestação do serviço.'),
    (NEW.id, 'Taxas de Cartão e Gateways', '2.1.03', 'DESPESA', 'SAIDA', TRUE, 'Taxas retidas pela maquininha ou emissor de PIX.'),
    (NEW.id, 'Comissões de Vendas', '2.1.04', 'DESPESA', 'SAIDA', TRUE, 'Variável pago à equipe comercial.'),
    (NEW.id, 'Fretes de Entrega (Saída)', '2.1.05', 'DESPESA', 'SAIDA', TRUE, 'Custo logístico de enviar ao cliente.'),

    (NEW.id, '2.2 Despesas de Pessoal e Gestão', '2.2', 'DESPESA', 'SAIDA', FALSE, 'Custos fixos com capital humano (OPEX).'),
    (NEW.id, 'Pró-labore dos Sócios', '2.2.01', 'DESPESA', 'SAIDA', TRUE, 'Salário fixo retirado pelos donos.'),
    (NEW.id, 'Salários e Encargos (Admin)', '2.2.02', 'DESPESA', 'SAIDA', TRUE, 'Folha e impostos (INSS/FGTS) da equipe.'),
    (NEW.id, 'Benefícios (VT/VR/Saúde)', '2.2.03', 'DESPESA', 'SAIDA', TRUE, 'Auxílios, planos de saúde e vales aos colaboradores.'),

    (NEW.id, '2.3 Ocupação e Infraestrutura', '2.3', 'DESPESA', 'SAIDA', FALSE, 'Manutenção do espaço físico da empresa.'),
    (NEW.id, 'Aluguel, Condomínio e IPTU', '2.3.01', 'DESPESA', 'SAIDA', TRUE, 'Custo do imóvel comercial.'),
    (NEW.id, 'Energia, Água e Internet', '2.3.02', 'DESPESA', 'SAIDA', TRUE, 'Utilidades de operação da sede.'),
    (NEW.id, 'Limpeza e Manutenção Predial', '2.3.03', 'DESPESA', 'SAIDA', TRUE, 'Insumos de limpeza e pequenos reparos.'),

    (NEW.id, '2.4 Tecnologia e Sistemas', '2.4', 'DESPESA', 'SAIDA', FALSE, 'Ecossistema digital corporativo.'),
    (NEW.id, 'Softwares e Licenças (SaaS)', '2.4.01', 'DESPESA', 'SAIDA', TRUE, 'Sistemas ERP, CRM, Assinaturas.'),
    (NEW.id, 'Servidores e Domínios', '2.4.02', 'DESPESA', 'SAIDA', TRUE, 'Hospedagem, AWS, Google Workspace.'),

    (NEW.id, '2.5 Administrativo e Legal', '2.5', 'DESPESA', 'SAIDA', FALSE, 'Burocracia e operação interna.'),
    (NEW.id, 'Contabilidade e Jurídico', '2.5.01', 'DESPESA', 'SAIDA', TRUE, 'Honorários de contadores e advogados.'),
    (NEW.id, 'Taxas Municipais e Alvarás', '2.5.02', 'DESPESA', 'SAIDA', TRUE, 'Renovação de licenças de funcionamento.'),
    (NEW.id, 'Material de Escritório/Copa', '2.5.03', 'DESPESA', 'SAIDA', TRUE, 'Insumos internos, papelaria, café.'),

    (NEW.id, '2.6 Marketing e Aquisição (CAC)', '2.6', 'DESPESA', 'SAIDA', FALSE, 'Motor de crescimento e atração de clientes.'),
    (NEW.id, 'Tráfego Pago (Ads)', '2.6.01', 'DESPESA', 'SAIDA', TRUE, 'Investimento em Google, Meta, TikTok Ads.'),
    (NEW.id, 'Viagens e Representação', '2.6.02', 'DESPESA', 'SAIDA', TRUE, 'Deslocamentos comerciais, jantares e networking.'),

    (NEW.id, '2.7 Resultado Financeiro', '2.7', 'DESPESA', 'SAIDA', FALSE, 'Despesas e tarifas bancárias.'),
    (NEW.id, 'Juros e Multas Pagos', '2.7.01', 'DESPESA', 'SAIDA', TRUE, 'Penalidades por atrasos de boletos e impostos.'),
    (NEW.id, 'Taxas de Antecipação de Recebíveis', '2.7.02', 'DESPESA', 'SAIDA', TRUE, 'Custo financeiro de antecipar vendas do cartão.'),
    (NEW.id, 'Tarifas Bancárias (Manutenção/PIX)', '2.7.03', 'DESPESA', 'SAIDA', TRUE, 'Taxas de manutenção de conta e emissão de boletos.'),

    -- 3.0 ATIVOS (Nulo na raiz, Fluxo nas folhas)
    (NEW.id, '3.0 ATIVOS', '3.0', 'ATIVO', NULL, FALSE, 'Bens e direitos da empresa.'),
    
    (NEW.id, '3.1 Ativo Circulante', '3.1', 'ATIVO', NULL, FALSE, 'Bens de alta liquidez e direitos de curto prazo.'),
    (NEW.id, 'Estoque de Mercadorias', '3.1.01', 'ATIVO', 'SAIDA', TRUE, 'Compras de produtos destinados ao estoque.'),
    (NEW.id, 'Adiantamentos a Fornecedores', '3.1.02', 'ATIVO', 'SAIDA', TRUE, 'Dinheiro pago antes da mercadoria/serviço ser entregue.'),

    (NEW.id, '3.2 Ativo Imobilizado', '3.2', 'ATIVO', NULL, FALSE, 'Bens duráveis e investimentos operacionais.'),
    (NEW.id, 'Equipamentos de TI', '3.2.01', 'ATIVO', 'SAIDA', TRUE, 'Aquisição de computadores, impressoras e hardware.'),
    (NEW.id, 'Móveis e Utensílios', '3.2.02', 'ATIVO', 'SAIDA', TRUE, 'Mobiliário da loja/escritório, ar condicionado.'),
    (NEW.id, 'Veículos Próprios', '3.2.03', 'ATIVO', 'SAIDA', TRUE, 'Compra de frota registrada no CNPJ da empresa.'),

    -- 4.0 PASSIVOS (Nulo na raiz, Fluxo nas folhas)
    (NEW.id, '4.0 PASSIVOS E OBRIGAÇÕES', '4.0', 'PASSIVO', NULL, FALSE, 'Obrigações e dívidas contraídas.'),
    
    (NEW.id, '4.1 Passivo Circulante (Curto Prazo)', '4.1', 'PASSIVO', NULL, FALSE, 'Contas e impostos a pagar até 12 meses.'),
    (NEW.id, 'Fornecedores a Pagar', '4.1.01', 'PASSIVO', 'SAIDA', TRUE, 'Pagamento de faturas e boletos de compras a prazo.'),
    (NEW.id, 'Impostos a Recolher', '4.1.02', 'PASSIVO', 'SAIDA', TRUE, 'Pagamento de tributos que haviam sido apurados.'),
    (NEW.id, 'Férias e 13º (Provisões pagas)', '4.1.03', 'PASSIVO', 'SAIDA', TRUE, 'Saída de caixa para acerto de encargos trabalhistas anuais.'),

    (NEW.id, '4.2 Exigível a Longo Prazo / Financiamentos', '4.2', 'PASSIVO', NULL, FALSE, 'Dívidas bancárias e obrigações acima de 12 meses.'),
    (NEW.id, 'Entrada de Empréstimos Bancários', '4.2.01', 'PASSIVO', 'ENTRADA', TRUE, 'Injeção de capital no caixa provindo de financiamentos.'),
    (NEW.id, 'Amortização de Principal (Pagamento da Dívida)', '4.2.02', 'PASSIVO', 'SAIDA', TRUE, 'Pagamento da parcela do empréstimo (Juros lançar em 2.7.01).'),

    -- 5.0 PATRIMÔNIO LÍQUIDO (Totalmente Neutro na raiz)
    (NEW.id, '5.0 PATRIMÔNIO LÍQUIDO', '5.0', 'PL', NULL, FALSE, 'Riqueza dos sócios e capital da empresa.'),
    
    (NEW.id, '5.1 Capital e Reservas', '5.1', 'PL', NULL, FALSE, 'Resultados, aportes e distribuições.'),
    (NEW.id, 'Capital Social Integralizado (Aporte)', '5.1.01', 'PL', 'ENTRADA', TRUE, 'Injeção de dinheiro no caixa pelos sócios.'),
    (NEW.id, 'Reserva de Lucros (Retenção)', '5.1.02', 'PL', NULL, TRUE, 'Reconhecimento contábil de lucro retido (Sem efeito de caixa).'),
    (NEW.id, 'Distribuição de Lucros (Dividendos)', '5.1.03', 'PL', 'SAIDA', TRUE, 'Saque de lucros pagos aos sócios (Impacta o caixa).'),
    (NEW.id, 'Ajuste de Balanço Inicial (Implantação)', '5.1.04', 'PL', NULL, TRUE, 'Conta de ajuste para inserir saldos bancários no início do uso.'),

    -- SISTEMA
    (NEW.id, 'Transferências Internas / Subsídios', '9.9.99', 'PL', NULL, TRUE, 'Conta de trânsito invisível para transferir recursos.');

  -- =================================================================
  -- 🏭 CENÁRIO 5: INDÚSTRIA
  -- =================================================================
  ELSIF NEW.tipo = 'Indústria' THEN
  
    -- A. Contas Bancárias
    INSERT INTO public.contas_bancarias (organization_id, nome, tipo, saldo_inicial) VALUES
    (NEW.id, '01. Caixa Fixo Almoxarifado / Fábrica', 'CAIXA_FISICO', 0.00),
    (NEW.id, '02. Conta Movimento Principal (Recebimentos)', 'CORRENTE', 0.00),
    (NEW.id, '03. Conta Pagamento (Folha e Fornecedores)', 'CORRENTE', 0.00),
    (NEW.id, '04. Cartão de Crédito Corporativo (Compras)', 'CARTAO', 0.00),
    (NEW.id, '05. Conta FINAME / BNDES / Fomento', 'CORRENTE', 0.00),
    (NEW.id, '06. Provisão Tributária e Encargos (Reserva)', 'INVESTIMENTO', 0.00),
    (NEW.id, '99. Transferências Internas', 'VIRTUAL', 0.00),
    (NEW.id, '07. Fundo de Depreciação e CAPEX (Maquinário)', 'INVESTIMENTO', 0.00);
    
    -- B. CENTROS DE CUSTO
    INSERT INTO public.centros_custo (organization_id, nome, is_padrao, is_fundo, ativo, cor_hex, descricao) VALUES
    (NEW.id, '00. Fundo Geral', false, true, true, '#8E949D', 'Local destinado a guardar todos os recebimentos não rateados.'),
    (NEW.id, '01. Chão de Fábrica / Produção', false, false, true, '#D32F2F', 'Coração da indústria: Mão de obra direta e transformação.'),
    (NEW.id, '02. Logística e Frota Pesada', false, false, true, '#C2185B', 'Escoamento de produção, caminhões e transportadoras.'),
    (NEW.id, '03. Manutenção Industrial', false, false, true, '#7B1FA2', 'Engenharia de manutenção, preventivas e corretivas de maquinário.'),
    (NEW.id, '04. Engenharia e P&D', false, false, true, '#512DA8', 'Desenvolvimento de novos produtos, protótipos e laboratório.'),
    (NEW.id, '05. Comercial e Vendas B2B', false, false, true, '#303F9F', 'Representantes comerciais, feiras industriais e prospecção.'),
    (NEW.id, '06. Administrativo Fabril', true, false, true, '#1976D2', 'Diretoria, RH, Contabilidade e infraestrutura de escritório. (PADRÃO)');

    -- C. PLANO DE CONTAS (ACHATADO PARA 3 NÍVEIS EXATOS)
    INSERT INTO public.plano_contas 
    (organization_id, nome, codigo_contabil, tipo, natureza_fluxo, permite_lancamento, instrucao_uso) VALUES

    -- 1.0 RECEITAS
    (NEW.id, '1.0 RECEITAS INDUSTRIAIS', '1.0', 'RECEITA', 'ENTRADA', FALSE, 'Raiz de faturamento.'),
    
    (NEW.id, '1.1 Receita Bruta Industrial', '1.1', 'RECEITA', 'ENTRADA', FALSE, 'Faturamento de bens produzidos.'),
    (NEW.id, 'Venda de Produção Própria', '1.1.01', 'RECEITA', 'ENTRADA', TRUE, 'Nota fiscal de saída de produtos acabados.'),
    (NEW.id, 'Venda de Sucatas e Subprodutos', '1.1.02', 'RECEITA', 'ENTRADA', TRUE, 'Receita com aparas, plástico moído, paletes velhos.'),
    
    (NEW.id, '1.2 Deduções e Impostos S/ Vendas', '1.2', 'RECEITA', 'SAIDA', FALSE, 'Tributação e cancelamentos.'),
    (NEW.id, 'Impostos Diretos (IPI/ICMS/PIS/COFINS)', '1.2.01', 'RECEITA', 'SAIDA', TRUE, 'Tributos faturados na nota de saída.'),
    (NEW.id, 'Devoluções de Produção', '1.2.02', 'RECEITA', 'SAIDA', TRUE, 'Lotes recusados pelo cliente ou estornos.'),

    -- 2.0 CUSTOS E DESPESAS (Reestruturado para Simetria)
    (NEW.id, '2.0 CUSTOS E DESPESAS', '2.0', 'DESPESA', 'SAIDA', FALSE, 'Raiz de saídas operacionais e fabris.'),
    
    (NEW.id, '2.1 Matéria-Prima (MP)', '2.1', 'DESPESA', 'SAIDA', FALSE, 'Insumos base da transformação.'),
    (NEW.id, 'Compra de Matéria-Prima Base', '2.1.01', 'DESPESA', 'SAIDA', TRUE, 'Aquisição de aço, grãos, polímeros, químicos.'),
    (NEW.id, 'Embalagens Industriais', '2.1.02', 'DESPESA', 'SAIDA', TRUE, 'Caixas de papelão, stretch, paletes de envio.'),

    (NEW.id, '2.2 Mão de Obra Direta (MOD)', '2.2', 'DESPESA', 'SAIDA', FALSE, 'Custos diretos com a equipe fabril.'),
    (NEW.id, 'Salários e Encargos (Chão de Fábrica)', '2.2.01', 'DESPESA', 'SAIDA', TRUE, 'Folha de operadores de linha e montadores.'),
    (NEW.id, 'Benefícios Fabris e EPIs', '2.2.02', 'DESPESA', 'SAIDA', TRUE, 'Refeitório fabril, botas, luvas e segurança do trabalho.'),

    (NEW.id, '2.3 Custos Indiretos de Fabricação (CIF)', '2.3', 'DESPESA', 'SAIDA', FALSE, 'Despesas para manter a fábrica rodando.'),
    (NEW.id, 'Energia Industrial e Gás', '2.3.01', 'DESPESA', 'SAIDA', TRUE, 'Insumo elétrico de alta tensão e combustíveis para fornos.'),
    (NEW.id, 'Manutenção de Máquinas e Peças', '2.3.02', 'DESPESA', 'SAIDA', TRUE, 'Serviços de tornearia, lubrificantes e rolamentos.'),

    (NEW.id, '2.4 Logística e Distribuição', '2.4', 'DESPESA', 'SAIDA', FALSE, 'Despesas de entrega e escoamento.'),
    (NEW.id, 'Diesel, Arla e Manutenção de Frota', '2.4.01', 'DESPESA', 'SAIDA', TRUE, 'Custos com caminhões próprios.'),
    (NEW.id, 'Fretes Terceirizados e Pedágios', '2.4.02', 'DESPESA', 'SAIDA', TRUE, 'Pagamento a transportadoras terceiras e rotas.'),

    (NEW.id, '2.5 Despesas Administrativas (OPEX)', '2.5', 'DESPESA', 'SAIDA', FALSE, 'Custo do escritório da fábrica e gestão.'),
    (NEW.id, 'Pró-labore da Diretoria', '2.5.01', 'DESPESA', 'SAIDA', TRUE, 'Remuneração fixa dos sócios.'),
    (NEW.id, 'Salários e Encargos (Escritório)', '2.5.02', 'DESPESA', 'SAIDA', TRUE, 'Folha do RH, Financeiro e Suprimentos.'),
    (NEW.id, 'Aluguel, Condomínio e Limpeza (Sede)', '2.5.03', 'DESPESA', 'SAIDA', TRUE, 'Ocupação do prédio administrativo.'),
    (NEW.id, 'Sistemas ERP e Licenças', '2.5.04', 'DESPESA', 'SAIDA', TRUE, 'Software de gestão fabril e engenharias (CAD/SIGMA).'),
    (NEW.id, 'Contabilidade, Jurídico e Alvarás', '2.5.05', 'DESPESA', 'SAIDA', TRUE, 'Honorários, taxas e renovação de licenças.'),

    (NEW.id, '2.6 Marketing e Vendas B2B', '2.6', 'DESPESA', 'SAIDA', FALSE, 'Custo de aquisição comercial.'),
    (NEW.id, 'Comissões de Representantes', '2.6.01', 'DESPESA', 'SAIDA', TRUE, 'Percentuais pagos por contratos fechados.'),
    (NEW.id, 'Feiras Industriais e Amostras', '2.6.02', 'DESPESA', 'SAIDA', TRUE, 'Stands em feiras e envio de protótipos a clientes.'),

    (NEW.id, '2.7 Resultado Financeiro', '2.7', 'DESPESA', 'SAIDA', FALSE, 'Custo do capital financeiro.'),
    (NEW.id, 'Juros de Financiamentos Fabris', '2.7.01', 'DESPESA', 'SAIDA', TRUE, 'Apenas os JUROS pagos por maquinário financiado.'),
    (NEW.id, 'Variação Cambial Passiva', '2.7.02', 'DESPESA', 'SAIDA', TRUE, 'Prejuízo na importação de insumos pela alta do dólar.'),
    (NEW.id, 'Taxas Bancárias e Antecipações', '2.7.03', 'DESPESA', 'SAIDA', TRUE, 'Custo de antecipação, Pix PJ e manutenção de conta.'),

    -- 3.0 ATIVOS (Raízes Nulas)
    (NEW.id, '3.0 ATIVOS', '3.0', 'ATIVO', NULL, FALSE, 'Bens e estoques da indústria.'),
    
    (NEW.id, '3.1 Estoques (Circulante)', '3.1', 'ATIVO', NULL, FALSE, 'O giro material da indústria.'),
    (NEW.id, 'Estoque de Matéria-Prima (MP)', '3.1.01', 'ATIVO', 'SAIDA', TRUE, 'Insumos guardados no almoxarifado.'),
    (NEW.id, 'Estoque de Produtos Acabados (PA)', '3.1.02', 'ATIVO', 'SAIDA', TRUE, 'Valor de produtos prontos para faturamento.'),

    (NEW.id, '3.2 Ativo Imobilizado', '3.2', 'ATIVO', NULL, FALSE, 'O parque fabril (CAPEX).'),
    (NEW.id, 'Máquinas e Equipamentos Pesados', '3.2.01', 'ATIVO', 'SAIDA', TRUE, 'Tornos, injetoras, extrusoras, caldeiras.'),
    (NEW.id, 'Veículos e Empilhadeiras', '3.2.02', 'ATIVO', 'SAIDA', TRUE, 'Caminhões e maquinário de movimentação interna.'),

    -- 4.0 PASSIVOS (Raízes Nulas)
    (NEW.id, '4.0 PASSIVOS E OBRIGAÇÕES', '4.0', 'PASSIVO', NULL, FALSE, 'Obrigações e dívidas assumidas.'),
    
    (NEW.id, '4.1 Passivo Circulante (Curto Prazo)', '4.1', 'PASSIVO', NULL, FALSE, 'Obrigações imediatas.'),
    (NEW.id, 'Fornecedores de Matéria-Prima', '4.1.01', 'PASSIVO', 'SAIDA', TRUE, 'Pgto de insumos para a fábrica (Gera saída).'),
    (NEW.id, 'Impostos Industriais a Recolher', '4.1.02', 'PASSIVO', 'SAIDA', TRUE, 'IPI/ICMS apurado (Gera saída no pagamento).'),

    (NEW.id, '4.2 Exigível a Longo Prazo e Financiamentos', '4.2', 'PASSIVO', NULL, FALSE, 'Dívidas estruturais.'),
    (NEW.id, 'Entrada de Financiamentos (BNDES/FINAME)', '4.2.01', 'PASSIVO', 'ENTRADA', TRUE, 'Entrada de crédito subsidiado para compra de imobilizado no caixa.'),
    (NEW.id, 'Amortização do Principal (Pagamento FINAME)', '4.2.02', 'PASSIVO', 'SAIDA', TRUE, 'Redução da dívida do maquinário através das parcelas pagas.'),

    -- 5.0 PATRIMÔNIO LÍQUIDO (Raízes e Reservas Nulas)
    (NEW.id, '5.0 PATRIMÔNIO LÍQUIDO', '5.0', 'PL', NULL, FALSE, 'Capital próprio e reinvestimento.'),
    
    (NEW.id, '5.1 Capital e Reservas', '5.1', 'PL', NULL, FALSE, 'Valor estrutural do negócio.'),
    (NEW.id, 'Capital Social Integralizado', '5.1.01', 'PL', 'ENTRADA', TRUE, 'Dinheiro investido inicialmente pelos donos.'),
    (NEW.id, 'Reserva para Ampliação Fabril', '5.1.02', 'PL', NULL, TRUE, 'Lucro retido para comprar novas máquinas (Registro sem efeito de caixa).'),
    (NEW.id, 'Distribuição de Lucros', '5.1.03', 'PL', 'SAIDA', TRUE, 'Lucro enviado aos sócios no exercício.'),
    (NEW.id, 'Ajuste de Balanço Inicial (Implantação)', '5.1.04', 'PL', NULL, TRUE, 'Conta de ajuste para inserir saldos bancários no início do uso.'),
    
    -- SISTEMA
    (NEW.id, 'Transferências Internas / Subsídios', '9.9.99', 'PL', NULL, TRUE, 'Conta de trânsito invisível para transferir orçamentos.');
  END IF;
  
  RETURN NEW;
END;$_$;


ALTER FUNCTION "public"."populate_organization_defaults"() OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."rls_auto_enable"() RETURNS "event_trigger"
    LANGUAGE "plpgsql" SECURITY DEFINER
    SET "search_path" TO 'pg_catalog'
    AS $$
DECLARE
  cmd record;
BEGIN
  FOR cmd IN
    SELECT *
    FROM pg_event_trigger_ddl_commands()
    WHERE command_tag IN ('CREATE TABLE', 'CREATE TABLE AS', 'SELECT INTO')
      AND object_type IN ('table','partitioned table')
  LOOP
     IF cmd.schema_name IS NOT NULL AND cmd.schema_name IN ('public') AND cmd.schema_name NOT IN ('pg_catalog','information_schema') AND cmd.schema_name NOT LIKE 'pg_toast%' AND cmd.schema_name NOT LIKE 'pg_temp%' THEN
      BEGIN
        EXECUTE format('alter table if exists %s enable row level security', cmd.object_identity);
        RAISE LOG 'rls_auto_enable: enabled RLS on %', cmd.object_identity;
      EXCEPTION
        WHEN OTHERS THEN
          RAISE LOG 'rls_auto_enable: failed to enable RLS on %', cmd.object_identity;
      END;
     ELSE
        RAISE LOG 'rls_auto_enable: skip % (either system schema or not in enforced list: %.)', cmd.object_identity, cmd.schema_name;
     END IF;
  END LOOP;
END;
$$;


ALTER FUNCTION "public"."rls_auto_enable"() OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."sanitize_transacao_data"() RETURNS "trigger"
    LANGUAGE "plpgsql"
    AS $$
BEGIN
    -- A. Higiene do STATUS
    IF NEW.status IS NOT NULL THEN
        -- Remove espaços nas pontas e transforma tudo em MAIÚSCULO
        NEW.status := UPPER(TRIM(NEW.status));
        -- Remove acentos comuns para garantir o padrão
        NEW.status := REPLACE(NEW.status, 'Í', 'I');
    END IF;

    -- B. Higiene do TIPO_OPERACAO
    IF NEW.tipo_operacao IS NOT NULL THEN
        -- Remove espaços e transforma em MAIÚSCULO
        NEW.tipo_operacao := UPPER(TRIM(NEW.tipo_operacao));
        -- Remove os acentos da palavra 'CRÉDITO' ou 'DÉBITO' ou 'TRANSFERÊNCIA'
        NEW.tipo_operacao := REPLACE(NEW.tipo_operacao, 'É', 'E');
        NEW.tipo_operacao := REPLACE(NEW.tipo_operacao, 'Ê', 'E');
    END IF;

    -- C. Higiene da DESCRIÇÃO (Bônus de UX: Remove espaços duplicados se o utilizador digitar mal)
    IF NEW.descricao IS NOT NULL THEN
        NEW.descricao := TRIM(NEW.descricao);
    END IF;

    RETURN NEW;
END;
$$;


ALTER FUNCTION "public"."sanitize_transacao_data"() OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."set_created_by"() RETURNS "trigger"
    LANGUAGE "plpgsql"
    AS $$
BEGIN
  -- Define o ID do perfil baseado no usuário autenticado no Supabase
  NEW.criado_por := auth.uid();
  RETURN NEW;
END;
$$;


ALTER FUNCTION "public"."set_created_by"() OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."uuid_generate_v7"() RETURNS "uuid"
    LANGUAGE "plpgsql"
    AS $$
DECLARE
  unix_ts_ms bytea;
  uuid_bytes bytea;
BEGIN
  -- 1. Captura o timestamp atual em milissegundos
  unix_ts_ms = substring(int8send(floor(extract(epoch from clock_timestamp()) * 1000)::bigint) from 3);
  
  -- 2. Gera 16 bytes aleatórios
  uuid_bytes = gen_random_bytes(16);
  
  -- 3. Sobrescreve os primeiros 6 bytes com o Timestamp (A essência do v7)
  uuid_bytes = overlay(uuid_bytes placing unix_ts_ms from 1 for 6);
  
  -- 4. Define a Versão 7 e a Variante usando manipulação Bitwise (Seguro e rápido)
  -- Byte 6 (Versão): Limpa os 4 bits altos e aplica 0111 (112)
  uuid_bytes = set_byte(uuid_bytes, 6, (get_byte(uuid_bytes, 6) & 15) | 112);
  -- Byte 8 (Variante): Limpa os 2 bits altos e aplica 10 (128)
  uuid_bytes = set_byte(uuid_bytes, 8, (get_byte(uuid_bytes, 8) & 63) | 128);
  
  -- 5. Retorna o UUID formatado
  RETURN encode(uuid_bytes, 'hex')::uuid;
END
$$;


ALTER FUNCTION "public"."uuid_generate_v7"() OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."validate_transacao_logic"() RETURNS "trigger"
    LANGUAGE "plpgsql"
    AS $$
DECLARE
    tipo_plano TEXT;
BEGIN
    -- Busca o tipo (RECEITA/DESPESA) no plano de contas
    SELECT tipo INTO tipo_plano FROM public.plano_contas WHERE id = NEW.plano_contas_id;

    -- Se o plano é de RECEITA, a operação deve ser CREDITO (ou Transferência)
    IF tipo_plano = 'RECEITA' AND NEW.tipo_operacao = 'DEBITO' THEN
        RAISE EXCEPTION 'Inconsistência: Você não pode lançar um DÉBITO em uma conta de RECEITA.';
    END IF;

    -- Se o plano é de DESPESA, a operação deve ser DEBITO
    IF tipo_plano = 'DESPESA' AND NEW.tipo_operacao = 'CREDITO' THEN
        RAISE EXCEPTION 'Inconsistência: Você não pode lançar um CRÉDITO em uma conta de DESPESA.';
    END IF;

    RETURN NEW;
END;
$$;


ALTER FUNCTION "public"."validate_transacao_logic"() OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."verificar_pai_tem_transacoes"("p_organization_id" "uuid", "p_codigo_filho" "text") RETURNS boolean
    LANGUAGE "plpgsql"
    AS $_$
DECLARE
  v_codigo_pai TEXT;
  v_id_pai UUID;
  v_tem_transacoes BOOLEAN;
BEGIN
  -- Extrai o código do pai (Ex: de '1.1.05' tira o '1.1')
  v_codigo_pai := substring(p_codigo_filho from '^(.*)\.[^\.]+$');
  
  -- Se for conta raiz (não tem ponto), não tem pai para validar
  IF v_codigo_pai IS NULL THEN
    RETURN FALSE;
  END IF;

  -- Pega o ID da conta pai
  SELECT id INTO v_id_pai 
  FROM public.plano_contas 
  WHERE codigo_contabil = v_codigo_pai AND organization_id = p_organization_id;

  -- Verifica se existe alguma transação (conciliada ou pendente) vinculada diretamente ao Pai
  SELECT EXISTS (
    SELECT 1 FROM public.transacoes WHERE plano_contas_id = v_id_pai
  ) INTO v_tem_transacoes;

  RETURN v_tem_transacoes;
END;
$_$;


ALTER FUNCTION "public"."verificar_pai_tem_transacoes"("p_organization_id" "uuid", "p_codigo_filho" "text") OWNER TO "postgres";

SET default_tablespace = '';

SET default_table_access_method = "heap";


CREATE TABLE IF NOT EXISTS "public"."centros_custo" (
    "id" "uuid" DEFAULT "public"."uuid_generate_v7"() NOT NULL,
    "organization_id" "uuid" NOT NULL,
    "nome" "text" NOT NULL,
    "descricao" "text",
    "ativo" boolean DEFAULT true,
    "criado_em" timestamp with time zone DEFAULT "now"(),
    "is_padrao" boolean DEFAULT false,
    "cor_hex" character varying(7) DEFAULT '#9E9E9E'::character varying,
    "is_fundo" boolean DEFAULT false,
    "permite_acumulo" boolean DEFAULT false
);


ALTER TABLE "public"."centros_custo" OWNER TO "postgres";


COMMENT ON COLUMN "public"."centros_custo"."descricao" IS 'Explicação da finalidade do departamento ou unidade de custo.';



COMMENT ON COLUMN "public"."centros_custo"."is_padrao" IS 'Define se o centro de custo foi criado pelo sistema no setup inicial.';



CREATE TABLE IF NOT EXISTS "public"."contas_bancarias" (
    "id" "uuid" DEFAULT "public"."uuid_generate_v7"() NOT NULL,
    "organization_id" "uuid" NOT NULL,
    "nome" "text" NOT NULL,
    "tipo" "text" NOT NULL,
    "banco_codigo" character varying(10),
    "agencia_conta" character varying(50),
    "saldo_inicial" numeric(12,2) DEFAULT 0.00,
    "ativo" boolean DEFAULT true,
    "criado_em" timestamp with time zone DEFAULT "now"(),
    "limite_credito" numeric DEFAULT 0.00,
    "dia_vencimento" smallint,
    "dia_fechamento" smallint,
    CONSTRAINT "contas_bancarias_tipo_check" CHECK (("tipo" = ANY (ARRAY['CORRENTE'::"text", 'POUPANCA'::"text", 'INVESTIMENTO'::"text", 'CAIXA_FISICO'::"text", 'VIRTUAL'::"text", 'FUNDO_DE_RESERVA'::"text", 'CARTAO'::"text"])))
);


ALTER TABLE "public"."contas_bancarias" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."historico_saldos" (
    "id" "uuid" DEFAULT "public"."uuid_generate_v7"() NOT NULL,
    "organization_id" "uuid" NOT NULL,
    "conta_bancaria_id" "uuid" NOT NULL,
    "mes" integer NOT NULL,
    "ano" integer NOT NULL,
    "saldo_fechamento" numeric(12,2) NOT NULL,
    "fechado_em" timestamp with time zone DEFAULT "now"(),
    "fechado_por" "uuid",
    CONSTRAINT "historico_saldos_mes_check" CHECK ((("mes" >= 1) AND ("mes" <= 12)))
);


ALTER TABLE "public"."historico_saldos" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."membros" (
    "id" "uuid" DEFAULT "public"."uuid_generate_v7"() NOT NULL,
    "organization_id" "uuid" NOT NULL,
    "nome_completo" "text" NOT NULL,
    "cpf" character varying(14),
    "email" "text",
    "telefone" "text",
    "ativo" boolean DEFAULT true,
    "criado_em" timestamp with time zone DEFAULT "now"()
);


ALTER TABLE "public"."membros" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."obrigacoes_recorrentes" (
    "id" "uuid" DEFAULT "public"."uuid_generate_v7"() NOT NULL,
    "organization_id" "uuid" NOT NULL,
    "descricao" "text" NOT NULL,
    "categoria_id" "uuid",
    "centro_custo_id" "uuid",
    "conta_bancaria_id" "uuid",
    "periodicidade" "text" NOT NULL,
    "dia_vencimento" integer NOT NULL,
    "mes_vencimento" integer,
    "dias_antecedencia" integer DEFAULT 20 NOT NULL,
    "valor_estimado" numeric(15,2) DEFAULT 0.00 NOT NULL,
    "ativo" boolean DEFAULT true NOT NULL,
    "ultima_competencia_gerada" "date",
    "criado_em" timestamp with time zone DEFAULT "now"() NOT NULL,
    CONSTRAINT "chk_coerencia_periodicidade" CHECK (((("periodicidade" = 'MENSAL'::"text") AND ("mes_vencimento" IS NULL)) OR (("periodicidade" = 'ANUAL'::"text") AND ("mes_vencimento" IS NOT NULL)))),
    CONSTRAINT "chk_dia_vencimento" CHECK ((("dia_vencimento" >= 1) AND ("dia_vencimento" <= 31))),
    CONSTRAINT "chk_dias_antecedencia" CHECK (("dias_antecedencia" >= 0)),
    CONSTRAINT "chk_mes_vencimento" CHECK ((("mes_vencimento" IS NULL) OR (("mes_vencimento" >= 1) AND ("mes_vencimento" <= 12)))),
    CONSTRAINT "chk_periodicidade" CHECK (("periodicidade" = ANY (ARRAY['MENSAL'::"text", 'ANUAL'::"text"])))
);


ALTER TABLE "public"."obrigacoes_recorrentes" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."orcamentos_centro_custo" (
    "id" "uuid" DEFAULT "public"."uuid_generate_v7"() NOT NULL,
    "organization_id" "uuid" NOT NULL,
    "centro_custo_id" "uuid" NOT NULL,
    "identificador_projeto" "text" NOT NULL,
    "data_inicio" "date" NOT NULL,
    "data_fim" "date" NOT NULL,
    "valor_orcado" numeric(12,2) DEFAULT 0.00 NOT NULL,
    "criado_em" timestamp with time zone DEFAULT "now"(),
    CONSTRAINT "check_intervalo_datas" CHECK (("data_fim" >= "data_inicio"))
);


ALTER TABLE "public"."orcamentos_centro_custo" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."org_pulse" (
    "organization_id" "uuid" NOT NULL,
    "ultima_atualizacao" timestamp with time zone DEFAULT "now"()
);


ALTER TABLE "public"."org_pulse" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."organization_members" (
    "id" "uuid" DEFAULT "public"."uuid_generate_v7"() NOT NULL,
    "organization_id" "uuid" NOT NULL,
    "profile_id" "uuid" NOT NULL,
    "funcao" "text" DEFAULT 'operador'::"text",
    "entrada_em" timestamp with time zone DEFAULT "now"(),
    CONSTRAINT "organization_members_funcao_check" CHECK (("funcao" = ANY (ARRAY['dono'::"text", 'administrador'::"text", 'operador'::"text", 'leitor'::"text", 'Dono'::"text", 'Administrador'::"text", 'Operador'::"text", 'Leitor'::"text"])))
);


ALTER TABLE "public"."organization_members" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."organizations" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "nome" "text" NOT NULL,
    "tipo" "text" DEFAULT 'Família'::"text",
    "documento_cnpj" "text",
    "plano" "text" DEFAULT 'Gratuito'::"text",
    "ativo" boolean DEFAULT true,
    "criado_em" timestamp with time zone DEFAULT "now"(),
    CONSTRAINT "organizations_plano_check" CHECK (("plano" = ANY (ARRAY['Gratuito'::"text", 'Básico'::"text", 'Plus'::"text", 'gratuito'::"text", 'basico'::"text", 'plus'::"text"]))),
    CONSTRAINT "organizations_tipo_check" CHECK (("tipo" = ANY (ARRAY['Igreja'::"text", 'OSC'::"text", 'Família'::"text", 'Negócio'::"text", 'Indústria'::"text"])))
);


ALTER TABLE "public"."organizations" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."plano_contas" (
    "id" "uuid" DEFAULT "public"."uuid_generate_v7"() NOT NULL,
    "organization_id" "uuid" NOT NULL,
    "codigo_contabil" character varying(20) NOT NULL,
    "nome" "text" NOT NULL,
    "tipo" "text" NOT NULL,
    "criado_em" timestamp with time zone DEFAULT "now"(),
    "natureza_fluxo" character varying(10),
    "permite_lancamento" boolean DEFAULT true,
    "instrucao_uso" "text",
    "is_conta_implantacao" boolean DEFAULT false,
    CONSTRAINT "plano_contas_tipo_check" CHECK (("tipo" = ANY (ARRAY['RECEITA'::"text", 'DESPESA'::"text", 'ATIVO'::"text", 'PASSIVO'::"text", 'PL'::"text", 'Receita'::"text", 'Despesa'::"text", 'Ativo'::"text", 'Passivo'::"text"])))
);


ALTER TABLE "public"."plano_contas" OWNER TO "postgres";


COMMENT ON COLUMN "public"."plano_contas"."permite_lancamento" IS 'Define se a conta é analítica (TRUE) ou sintética/agrupadora (FALSE).';



COMMENT ON COLUMN "public"."plano_contas"."instrucao_uso" IS 'Texto de ajuda contextual para orientar o usuário no momento do lançamento.';



CREATE TABLE IF NOT EXISTS "public"."profiles" (
    "id" "uuid" NOT NULL,
    "email" "text" NOT NULL,
    "nome_completo" "text",
    "avatar_url" "text",
    "criado_em" timestamp with time zone DEFAULT "timezone"('utc'::"text", "now"()),
    "fcm_token" "text",
    "hasAskedPush" boolean
);


ALTER TABLE "public"."profiles" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."transacoes" (
    "id" "uuid" DEFAULT "public"."uuid_generate_v7"() NOT NULL,
    "organization_id" "uuid" NOT NULL,
    "descricao" "text" NOT NULL,
    "valor" numeric(12,2) NOT NULL,
    "data_pagamento" timestamp with time zone,
    "tipo_operacao" "text" NOT NULL,
    "status" "text" DEFAULT 'CONCILIADO'::"text",
    "conta_bancaria_id" "uuid",
    "plano_contas_id" "uuid",
    "centro_custo_id" "uuid",
    "membro_id" "uuid",
    "comprovativo_url" "text",
    "observacoes" "text",
    "criado_por" "uuid",
    "criado_em" timestamp with time zone DEFAULT "now"(),
    "id_unico_banco" "text",
    "data_vencimento" "date" NOT NULL,
    "data_competencia" "date" NOT NULL,
    "conta_destino_id" "uuid",
    "grupo_recorrencia_id" "text",
    "parcela_atual" integer,
    "total_parcelas" integer,
    "notificacao_vencimento_enviada" boolean DEFAULT false,
    "transferencia_interna_id" "uuid",
    CONSTRAINT "chk_transacao_paga_exige_conta" CHECK ((("status" = ANY (ARRAY['PENDENTE'::"text", 'CANCELADO'::"text"])) OR (("status" = 'CONCILIADO'::"text") AND ("conta_bancaria_id" IS NOT NULL)))),
    CONSTRAINT "transacoes_status_check" CHECK (("status" = ANY (ARRAY['PENDENTE'::"text", 'CONCILIADO'::"text", 'CANCELADO'::"text", 'EXCLUÍDO'::"text"]))),
    CONSTRAINT "transacoes_tipo_operacao_check" CHECK (("tipo_operacao" = ANY (ARRAY['CREDITO'::"text", 'DEBITO'::"text", 'TRANSFERENCIA'::"text"]))),
    CONSTRAINT "transacoes_valor_check" CHECK (("valor" > (0)::numeric))
);


ALTER TABLE "public"."transacoes" OWNER TO "postgres";


CREATE OR REPLACE VIEW "public"."view_membros_equipe" WITH ("security_invoker"='true') AS
 SELECT "om"."id" AS "vinculo_id",
    "om"."organization_id",
    "o"."nome" AS "nome_organizacao",
    "om"."profile_id",
    "p"."nome_completo" AS "nome_utilizador",
    "p"."email",
    "om"."funcao",
    "o"."tipo" AS "tipo_organizacao",
    "o"."plano" AS "plano_organizacao"
   FROM (("public"."organization_members" "om"
     JOIN "public"."profiles" "p" ON (("om"."profile_id" = "p"."id")))
     JOIN "public"."organizations" "o" ON (("om"."organization_id" = "o"."id")));


ALTER VIEW "public"."view_membros_equipe" OWNER TO "postgres";


CREATE OR REPLACE VIEW "public"."view_saldos_contas" WITH ("security_invoker"='true') AS
 WITH "extrato_bruto" AS (
         SELECT "t"."conta_bancaria_id" AS "conta_id",
            "c_1"."tipo" AS "tipo_conta",
                CASE
                    WHEN ("t"."tipo_operacao" = 'CREDITO'::"text") THEN "t"."valor"
                    ELSE (0)::numeric
                END AS "entrada",
                CASE
                    WHEN ("t"."tipo_operacao" = ANY (ARRAY['DEBITO'::"text", 'TRANSFERENCIA'::"text"])) THEN "t"."valor"
                    ELSE (0)::numeric
                END AS "saida",
            "t"."data_pagamento"
           FROM ("public"."transacoes" "t"
             JOIN "public"."contas_bancarias" "c_1" ON (("c_1"."id" = "t"."conta_bancaria_id")))
          WHERE ("t"."status" = 'CONCILIADO'::"text")
        UNION ALL
         SELECT "t"."conta_destino_id" AS "conta_id",
            "c_1"."tipo" AS "tipo_conta",
            "t"."valor" AS "entrada",
            (0)::numeric AS "saida",
            "t"."data_pagamento"
           FROM ("public"."transacoes" "t"
             JOIN "public"."contas_bancarias" "c_1" ON (("c_1"."id" = "t"."conta_destino_id")))
          WHERE (("t"."status" = 'CONCILIADO'::"text") AND ("t"."tipo_operacao" = 'TRANSFERENCIA'::"text") AND ("t"."conta_destino_id" IS NOT NULL))
        ), "resumo_movimentos" AS (
         SELECT "extrato_bruto"."conta_id",
            "sum"("extrato_bruto"."entrada") AS "total_entradas",
            "sum"("extrato_bruto"."saida") AS "total_saidas"
           FROM "extrato_bruto"
          WHERE
                CASE
                    WHEN ("extrato_bruto"."tipo_conta" = 'CARTAO'::"text") THEN true
                    ELSE ("date"("extrato_bruto"."data_pagamento") <= CURRENT_DATE)
                END
          GROUP BY "extrato_bruto"."conta_id"
        )
 SELECT "c"."organization_id",
    "c"."id" AS "conta_id",
    "c"."nome" AS "nome_conta",
    "c"."tipo" AS "tipo_conta",
    "c"."saldo_inicial",
    COALESCE("r"."total_entradas", (0)::numeric) AS "total_entradas",
    COALESCE("r"."total_saidas", (0)::numeric) AS "total_saidas",
    (("c"."saldo_inicial" + COALESCE("r"."total_entradas", (0)::numeric)) - COALESCE("r"."total_saidas", (0)::numeric)) AS "saldo_atual",
    "c"."dia_fechamento",
    "c"."dia_vencimento"
   FROM ("public"."contas_bancarias" "c"
     LEFT JOIN "resumo_movimentos" "r" ON (("c"."id" = "r"."conta_id")))
  WHERE ("c"."ativo" = true);


ALTER VIEW "public"."view_saldos_contas" OWNER TO "postgres";


CREATE OR REPLACE VIEW "public"."vw_agendamentos" WITH ("security_invoker"='true') AS
 SELECT "t"."id" AS "transacao_id",
    "t"."organization_id",
    "t"."conta_bancaria_id" AS "conta_id",
    "c"."nome" AS "nome_conta",
    "c"."tipo" AS "tipo_conta",
    "t"."data_pagamento",
    "t"."criado_em",
    "t"."descricao",
    "t"."valor",
    "t"."tipo_operacao",
    "t"."status",
    "t"."plano_contas_id" AS "categoria_id",
    "pc"."nome" AS "categoria_nome",
    "t"."centro_custo_id",
    "t"."membro_id",
    "t"."observacoes",
    "t"."comprovativo_url",
    "t"."id_unico_banco",
    COALESCE("t"."parcela_atual", 0) AS "parcela_atual",
    COALESCE("t"."total_parcelas", 0) AS "total_parcelas",
    "t"."data_vencimento",
    "t"."data_competencia",
    "t"."conta_destino_id",
        CASE
            WHEN ("t"."tipo_operacao" = 'DEBITO'::"text") THEN 'CP'::"text"
            WHEN ("t"."tipo_operacao" = 'CREDITO'::"text") THEN 'CR'::"text"
            ELSE 'OUTRO'::"text"
        END AS "modulo",
        CASE
            WHEN ("t"."tipo_operacao" = 'DEBITO'::"text") THEN 'A Pagar'::"text"
            WHEN ("t"."tipo_operacao" = 'CREDITO'::"text") THEN 'A Receber'::"text"
            ELSE 'Transferência'::"text"
        END AS "tipo_agendamento",
        CASE
            WHEN ("t"."data_vencimento" < CURRENT_DATE) THEN 'VENCIDO'::"text"
            WHEN ("t"."data_vencimento" = CURRENT_DATE) THEN 'HOJE'::"text"
            ELSE 'A VENCER'::"text"
        END AS "status_prazo",
    (CURRENT_DATE - "t"."data_vencimento") AS "dias_diferenca",
    "sum"(
        CASE
            WHEN ("t"."tipo_operacao" = 'DEBITO'::"text") THEN (- "abs"(COALESCE("t"."valor", (0)::numeric)))
            WHEN ("t"."tipo_operacao" = 'CREDITO'::"text") THEN "abs"(COALESCE("t"."valor", (0)::numeric))
            ELSE (0)::numeric
        END) OVER (PARTITION BY "t"."organization_id", "t"."tipo_operacao" ORDER BY "t"."data_vencimento", "t"."id") AS "saldo_progressivo",
    "sum"("abs"(COALESCE("t"."valor", (0)::numeric))) OVER (PARTITION BY "t"."organization_id", "t"."tipo_operacao" ORDER BY "t"."data_vencimento") AS "acumulado_diario"
   FROM (("public"."transacoes" "t"
     LEFT JOIN "public"."plano_contas" "pc" ON (("t"."plano_contas_id" = "pc"."id")))
     LEFT JOIN "public"."contas_bancarias" "c" ON (("t"."conta_bancaria_id" = "c"."id")))
  WHERE (("t"."status" = 'PENDENTE'::"text") AND ("t"."data_vencimento" IS NOT NULL))
  ORDER BY "t"."data_vencimento", "t"."id";


ALTER VIEW "public"."vw_agendamentos" OWNER TO "postgres";


CREATE OR REPLACE VIEW "public"."vw_contas_para_notificar" WITH ("security_invoker"='on') AS
 SELECT "t"."id" AS "transacao_id",
    "t"."organization_id",
    "o"."nome" AS "nome_organizacao",
    "t"."descricao",
    "t"."valor",
    "t"."data_vencimento",
    "array_agg"("om"."profile_id") AS "admins_to_notify"
   FROM (("public"."transacoes" "t"
     JOIN "public"."organizations" "o" ON (("o"."id" = "t"."organization_id")))
     JOIN "public"."organization_members" "om" ON (("om"."organization_id" = "t"."organization_id")))
  WHERE (("t"."status" <> 'CONCILIADO'::"text") AND ("t"."tipo_operacao" = 'DEBITO'::"text") AND ("t"."data_vencimento" <= CURRENT_DATE) AND ("t"."notificacao_vencimento_enviada" = false) AND ("om"."funcao" = ANY (ARRAY['dono'::"text", 'Dono'::"text", 'administrador'::"text", 'Administrador'::"text"])))
  GROUP BY "t"."id", "t"."organization_id", "o"."nome", "t"."descricao", "t"."valor", "t"."data_vencimento";


ALTER VIEW "public"."vw_contas_para_notificar" OWNER TO "postgres";


CREATE OR REPLACE VIEW "public"."vw_extrato_individual" WITH ("security_invoker"='true') AS
 WITH "extrato_bruto" AS (
         SELECT "t"."id" AS "transacao_id",
            "t"."organization_id",
            "t"."conta_bancaria_id" AS "conta_id",
            "t"."conta_bancaria_id" AS "conta_origem_id",
            "t"."data_pagamento",
            "t"."criado_em",
                CASE
                    WHEN ("t"."tipo_operacao" = 'TRANSFERENCIA'::"text") THEN ('Transf. enviada p/ '::"text" || "c_destino"."nome")
                    ELSE "t"."descricao"
                END AS "descricao",
            "t"."tipo_operacao",
            "t"."status",
            "t"."plano_contas_id" AS "categoria_id",
            "t"."centro_custo_id",
            "t"."membro_id",
            "t"."comprovativo_url",
            "t"."observacoes",
            "t"."id_unico_banco",
            "t"."data_vencimento",
            "t"."data_competencia",
            "t"."conta_destino_id",
            "t"."valor",
                CASE
                    WHEN ("t"."tipo_operacao" = 'CREDITO'::"text") THEN "t"."valor"
                    ELSE ("t"."valor" * ('-1'::integer)::numeric)
                END AS "valor_movimento"
           FROM ("public"."transacoes" "t"
             LEFT JOIN "public"."contas_bancarias" "c_destino" ON (("c_destino"."id" = "t"."conta_destino_id")))
          WHERE (("t"."status" = 'CONCILIADO'::"text") AND ("t"."conta_bancaria_id" IS NOT NULL))
        UNION ALL
         SELECT "t"."id" AS "transacao_id",
            "t"."organization_id",
            "t"."conta_destino_id" AS "conta_id",
            "t"."conta_bancaria_id" AS "conta_origem_id",
            "t"."data_pagamento",
            "t"."criado_em",
            ('Transf. recebida de '::"text" || "c_origem"."nome") AS "descricao",
            "t"."tipo_operacao",
            "t"."status",
            "t"."plano_contas_id" AS "categoria_id",
            "t"."centro_custo_id",
            "t"."membro_id",
            "t"."comprovativo_url",
            "t"."observacoes",
            "t"."id_unico_banco",
            "t"."data_vencimento",
            "t"."data_competencia",
            "t"."conta_destino_id",
            "t"."valor",
            "t"."valor" AS "valor_movimento"
           FROM ("public"."transacoes" "t"
             JOIN "public"."contas_bancarias" "c_origem" ON (("c_origem"."id" = "t"."conta_bancaria_id")))
          WHERE (("t"."tipo_operacao" = 'TRANSFERENCIA'::"text") AND ("t"."status" = 'CONCILIADO'::"text") AND ("t"."conta_destino_id" IS NOT NULL))
        )
 SELECT "e"."transacao_id",
    "e"."organization_id",
    "e"."conta_id",
    "e"."conta_origem_id",
    "c"."nome" AS "nome_conta",
    "c"."tipo" AS "tipo_conta",
    "e"."data_pagamento",
    "e"."criado_em",
    "e"."descricao",
    "e"."tipo_operacao",
    "e"."status",
    "e"."categoria_id",
    "p"."nome" AS "categoria_nome",
    "p"."codigo_contabil",
    "e"."centro_custo_id",
    "cc"."nome" AS "centro_custo_nome",
    "e"."membro_id",
    "e"."comprovativo_url",
    "e"."observacoes",
    "e"."id_unico_banco",
    "e"."data_vencimento",
    "e"."data_competencia",
    "e"."conta_destino_id",
    "e"."valor",
    "e"."valor_movimento",
    COALESCE("e"."data_competencia", "e"."data_vencimento") AS "data_referencia_dre",
    ("date_trunc"('day'::"text", COALESCE(
        CASE
            WHEN ("c"."tipo" = 'CARTAO'::"text") THEN ("e"."data_vencimento")::timestamp with time zone
            ELSE "e"."data_pagamento"
        END, ("e"."data_vencimento")::timestamp with time zone, ("e"."data_competencia")::timestamp with time zone)) + '12:00:00'::interval) AS "data_linha_tempo",
    ("c"."saldo_inicial" + "sum"("e"."valor_movimento") OVER (PARTITION BY "e"."conta_id" ORDER BY ("date_trunc"('day'::"text", COALESCE(
        CASE
            WHEN ("c"."tipo" = 'CARTAO'::"text") THEN ("e"."data_vencimento")::timestamp with time zone
            ELSE "e"."data_pagamento"
        END, ("e"."data_vencimento")::timestamp with time zone, ("e"."data_competencia")::timestamp with time zone)) + '12:00:00'::interval), "e"."data_competencia")) AS "saldo_progressivo"
   FROM ((("extrato_bruto" "e"
     JOIN "public"."contas_bancarias" "c" ON (("c"."id" = "e"."conta_id")))
     LEFT JOIN "public"."plano_contas" "p" ON (("p"."id" = "e"."categoria_id")))
     LEFT JOIN "public"."centros_custo" "cc" ON (("cc"."id" = "e"."centro_custo_id")));


ALTER VIEW "public"."vw_extrato_individual" OWNER TO "postgres";


CREATE OR REPLACE VIEW "public"."vw_saldo_total_org" WITH ("security_invoker"='true') AS
 SELECT "organization_id",
    "sum"("saldo_inicial") AS "total_saldo_inicial",
    "sum"("total_entradas") AS "total_entradas_geral",
    "sum"("total_saidas") AS "total_saidas_geral",
    "sum"("saldo_atual") AS "saldo_liquido_geral",
    "sum"(
        CASE
            WHEN ("tipo_conta" <> 'CARTAO'::"text") THEN "saldo_atual"
            ELSE (0)::numeric
        END) AS "saldo_disponivel_real",
    "sum"(
        CASE
            WHEN ("tipo_conta" = 'CARTAO'::"text") THEN ("saldo_atual" * ('-1'::integer)::numeric)
            ELSE (0)::numeric
        END) AS "total_faturas_cartao"
   FROM "public"."view_saldos_contas"
  GROUP BY "organization_id";


ALTER VIEW "public"."vw_saldo_total_org" OWNER TO "postgres";


CREATE OR REPLACE VIEW "public"."vw_transacoes_competencia" WITH ("security_invoker"='on') AS
 SELECT "t"."id",
    "t"."organization_id",
    "t"."plano_contas_id",
    "t"."status",
    COALESCE("t"."data_competencia", "t"."data_vencimento") AS "data_competencia_real",
    "pc"."codigo_contabil",
    "pc"."tipo" AS "tipo_conta",
    "t"."valor" AS "valor_absoluto",
        CASE
            WHEN ("pc"."tipo" = 'RECEITA'::"text") THEN "t"."valor"
            WHEN ("pc"."tipo" = 'DESPESA'::"text") THEN ("t"."valor" * ('-1'::integer)::numeric)
            ELSE (0)::numeric
        END AS "valor_liquido"
   FROM ("public"."transacoes" "t"
     JOIN "public"."plano_contas" "pc" ON (("t"."plano_contas_id" = "pc"."id")))
  WHERE ("t"."status" <> 'CANCELADO'::"text");


ALTER VIEW "public"."vw_transacoes_competencia" OWNER TO "postgres";


ALTER TABLE ONLY "public"."centros_custo"
    ADD CONSTRAINT "centros_custo_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."contas_bancarias"
    ADD CONSTRAINT "contas_bancarias_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."historico_saldos"
    ADD CONSTRAINT "historico_saldos_organization_id_conta_bancaria_id_mes_ano_key" UNIQUE ("organization_id", "conta_bancaria_id", "mes", "ano");



ALTER TABLE ONLY "public"."historico_saldos"
    ADD CONSTRAINT "historico_saldos_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."membros"
    ADD CONSTRAINT "membros_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."obrigacoes_recorrentes"
    ADD CONSTRAINT "obrigacoes_recorrentes_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."orcamentos_centro_custo"
    ADD CONSTRAINT "orcamentos_centro_custo_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."org_pulse"
    ADD CONSTRAINT "org_pulse_pkey" PRIMARY KEY ("organization_id");



ALTER TABLE ONLY "public"."organization_members"
    ADD CONSTRAINT "organization_members_organization_id_profile_id_key" UNIQUE ("organization_id", "profile_id");



ALTER TABLE ONLY "public"."organization_members"
    ADD CONSTRAINT "organization_members_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."organizations"
    ADD CONSTRAINT "organizations_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."plano_contas"
    ADD CONSTRAINT "plano_contas_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."profiles"
    ADD CONSTRAINT "profiles_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."transacoes"
    ADD CONSTRAINT "transacoes_id_banco_unico_org_key" UNIQUE ("organization_id", "id_unico_banco");



ALTER TABLE ONLY "public"."transacoes"
    ADD CONSTRAINT "transacoes_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."orcamentos_centro_custo"
    ADD CONSTRAINT "uq_orcamento_cc_projeto" UNIQUE ("organization_id", "centro_custo_id", "identificador_projeto", "data_inicio", "data_fim");



CREATE INDEX "idx_centros_custo_is_fundo" ON "public"."centros_custo" USING "btree" ("organization_id", "is_fundo");



CREATE INDEX "idx_contas_bancarias_organization_id" ON "public"."contas_bancarias" USING "btree" ("organization_id");



CREATE INDEX "idx_contas_bancarias_tipo" ON "public"."contas_bancarias" USING "btree" ("id", "tipo");



CREATE INDEX "idx_membros_org" ON "public"."membros" USING "btree" ("organization_id");



CREATE INDEX "idx_obrigacoes_org_ativo" ON "public"."obrigacoes_recorrentes" USING "btree" ("organization_id", "ativo");



CREATE INDEX "idx_orcamentos_cc_datas" ON "public"."orcamentos_centro_custo" USING "btree" ("organization_id", "data_inicio", "data_fim");



CREATE INDEX "idx_org_members_organization_id" ON "public"."organization_members" USING "btree" ("organization_id");



CREATE INDEX "idx_org_members_profile_id" ON "public"."organization_members" USING "btree" ("profile_id");



CREATE INDEX "idx_plano_contas_codigo" ON "public"."plano_contas" USING "btree" ("codigo_contabil");



CREATE INDEX "idx_plano_contas_permitir_lancamento" ON "public"."plano_contas" USING "btree" ("permite_lancamento");



CREATE INDEX "idx_transacoes_alerta_vencimento" ON "public"."transacoes" USING "btree" ("organization_id", "data_vencimento", "tipo_operacao") WHERE ("status" <> 'CONCILIADO'::"text");



CREATE INDEX "idx_transacoes_conta_destino" ON "public"."transacoes" USING "btree" ("conta_destino_id");



CREATE INDEX "idx_transacoes_dre" ON "public"."transacoes" USING "btree" ("organization_id", "data_pagamento");



CREATE INDEX "idx_transacoes_org_status" ON "public"."transacoes" USING "btree" ("organization_id", "status");



CREATE INDEX "idx_transacoes_organization_id" ON "public"."transacoes" USING "btree" ("organization_id");



CREATE INDEX "idx_transacoes_pagamento" ON "public"."transacoes" USING "btree" ("organization_id", "data_pagamento", "status");



CREATE INDEX "idx_transacoes_transferencia_interna" ON "public"."transacoes" USING "btree" ("transferencia_interna_id");



CREATE INDEX "idx_transacoes_vencimento" ON "public"."transacoes" USING "btree" ("organization_id", "data_vencimento", "status");



CREATE INDEX "transacoes_status_idx" ON "public"."transacoes" USING "btree" ("status");



CREATE OR REPLACE TRIGGER "on_org_created_populate_defaults" AFTER INSERT ON "public"."organizations" FOR EACH ROW EXECUTE FUNCTION "public"."populate_organization_defaults"();



CREATE OR REPLACE TRIGGER "tg_prevent_delete_centro_custo" BEFORE DELETE ON "public"."centros_custo" FOR EACH ROW EXECUTE FUNCTION "public"."check_finance_usage"();



CREATE OR REPLACE TRIGGER "tg_prevent_delete_plano_contas" BEFORE DELETE ON "public"."plano_contas" FOR EACH ROW EXECUTE FUNCTION "public"."check_finance_usage"();



CREATE OR REPLACE TRIGGER "tg_sanitize_transacao" BEFORE INSERT OR UPDATE ON "public"."transacoes" FOR EACH ROW EXECUTE FUNCTION "public"."sanitize_transacao_data"();



CREATE OR REPLACE TRIGGER "tg_set_transacao_audit" BEFORE INSERT ON "public"."transacoes" FOR EACH ROW EXECUTE FUNCTION "public"."set_created_by"();



CREATE OR REPLACE TRIGGER "tg_validate_finance_logic" BEFORE INSERT OR UPDATE ON "public"."transacoes" FOR EACH ROW EXECUTE FUNCTION "public"."validate_transacao_logic"();



CREATE OR REPLACE TRIGGER "tr_impedir_lancamento_sintetico" BEFORE INSERT OR UPDATE ON "public"."transacoes" FOR EACH ROW EXECUTE FUNCTION "public"."fn_validar_conta_analitica"();



CREATE OR REPLACE TRIGGER "trg_audit_dml_centros_custo" AFTER INSERT OR DELETE OR UPDATE ON "public"."centros_custo" FOR EACH STATEMENT EXECUTE FUNCTION "monitor"."log_table_dml"();



CREATE OR REPLACE TRIGGER "trg_audit_dml_contas_bancarias" AFTER INSERT OR DELETE OR UPDATE ON "public"."contas_bancarias" FOR EACH STATEMENT EXECUTE FUNCTION "monitor"."log_table_dml"();



CREATE OR REPLACE TRIGGER "trg_audit_dml_historico_saldos" AFTER INSERT OR DELETE OR UPDATE ON "public"."historico_saldos" FOR EACH STATEMENT EXECUTE FUNCTION "monitor"."log_table_dml"();



CREATE OR REPLACE TRIGGER "trg_audit_dml_membros" AFTER INSERT OR DELETE OR UPDATE ON "public"."membros" FOR EACH STATEMENT EXECUTE FUNCTION "monitor"."log_table_dml"();



CREATE OR REPLACE TRIGGER "trg_audit_dml_obrigacoes_recorrentes" AFTER INSERT OR DELETE OR UPDATE ON "public"."obrigacoes_recorrentes" FOR EACH STATEMENT EXECUTE FUNCTION "monitor"."log_table_dml"();



CREATE OR REPLACE TRIGGER "trg_audit_dml_orcamentos_centro_custo" AFTER INSERT OR DELETE OR UPDATE ON "public"."orcamentos_centro_custo" FOR EACH STATEMENT EXECUTE FUNCTION "monitor"."log_table_dml"();



CREATE OR REPLACE TRIGGER "trg_audit_dml_org_pulse" AFTER INSERT OR DELETE OR UPDATE ON "public"."org_pulse" FOR EACH STATEMENT EXECUTE FUNCTION "monitor"."log_table_dml"();



CREATE OR REPLACE TRIGGER "trg_audit_dml_organization_members" AFTER INSERT OR DELETE OR UPDATE ON "public"."organization_members" FOR EACH STATEMENT EXECUTE FUNCTION "monitor"."log_table_dml"();



CREATE OR REPLACE TRIGGER "trg_audit_dml_organizations" AFTER INSERT OR DELETE OR UPDATE ON "public"."organizations" FOR EACH STATEMENT EXECUTE FUNCTION "monitor"."log_table_dml"();



CREATE OR REPLACE TRIGGER "trg_audit_dml_plano_contas" AFTER INSERT OR DELETE OR UPDATE ON "public"."plano_contas" FOR EACH STATEMENT EXECUTE FUNCTION "monitor"."log_table_dml"();



CREATE OR REPLACE TRIGGER "trg_audit_dml_profiles" AFTER INSERT OR DELETE OR UPDATE ON "public"."profiles" FOR EACH STATEMENT EXECUTE FUNCTION "monitor"."log_table_dml"();



CREATE OR REPLACE TRIGGER "trg_audit_dml_transacoes" AFTER INSERT OR DELETE OR UPDATE ON "public"."transacoes" FOR EACH STATEMENT EXECUTE FUNCTION "monitor"."log_table_dml"();



CREATE OR REPLACE TRIGGER "trg_autocura_saldos" AFTER INSERT OR DELETE OR UPDATE ON "public"."transacoes" FOR EACH ROW EXECUTE FUNCTION "public"."fn_autocura_saldos"();



CREATE OR REPLACE TRIGGER "trg_pulse_transacoes" AFTER INSERT OR DELETE OR UPDATE ON "public"."transacoes" FOR EACH ROW EXECUTE FUNCTION "public"."fn_update_org_pulse"();



CREATE OR REPLACE TRIGGER "trg_unico_fundo_geral" BEFORE INSERT OR UPDATE ON "public"."centros_custo" FOR EACH ROW EXECUTE FUNCTION "public"."manter_unico_fundo_geral"();



CREATE OR REPLACE TRIGGER "trg_unico_padrao" BEFORE INSERT OR UPDATE ON "public"."centros_custo" FOR EACH ROW EXECUTE FUNCTION "public"."manter_unico_centro_custo_padrao"();



ALTER TABLE ONLY "public"."centros_custo"
    ADD CONSTRAINT "centros_custo_organization_id_fkey" FOREIGN KEY ("organization_id") REFERENCES "public"."organizations"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."contas_bancarias"
    ADD CONSTRAINT "contas_bancarias_organization_id_fkey" FOREIGN KEY ("organization_id") REFERENCES "public"."organizations"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."historico_saldos"
    ADD CONSTRAINT "historico_saldos_conta_bancaria_id_fkey" FOREIGN KEY ("conta_bancaria_id") REFERENCES "public"."contas_bancarias"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."historico_saldos"
    ADD CONSTRAINT "historico_saldos_fechado_por_fkey" FOREIGN KEY ("fechado_por") REFERENCES "public"."profiles"("id");



ALTER TABLE ONLY "public"."historico_saldos"
    ADD CONSTRAINT "historico_saldos_organization_id_fkey" FOREIGN KEY ("organization_id") REFERENCES "public"."organizations"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."membros"
    ADD CONSTRAINT "membros_organization_id_fkey" FOREIGN KEY ("organization_id") REFERENCES "public"."organizations"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."orcamentos_centro_custo"
    ADD CONSTRAINT "orcamentos_centro_custo_centro_custo_id_fkey" FOREIGN KEY ("centro_custo_id") REFERENCES "public"."centros_custo"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."org_pulse"
    ADD CONSTRAINT "org_pulse_organization_id_fkey" FOREIGN KEY ("organization_id") REFERENCES "public"."organizations"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."organization_members"
    ADD CONSTRAINT "organization_members_organization_id_fkey" FOREIGN KEY ("organization_id") REFERENCES "public"."organizations"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."organization_members"
    ADD CONSTRAINT "organization_members_profile_id_fkey" FOREIGN KEY ("profile_id") REFERENCES "public"."profiles"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."plano_contas"
    ADD CONSTRAINT "plano_contas_organization_id_fkey" FOREIGN KEY ("organization_id") REFERENCES "public"."organizations"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."profiles"
    ADD CONSTRAINT "profiles_id_fkey" FOREIGN KEY ("id") REFERENCES "auth"."users"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."transacoes"
    ADD CONSTRAINT "transacoes_centro_custo_id_fkey" FOREIGN KEY ("centro_custo_id") REFERENCES "public"."centros_custo"("id");



ALTER TABLE ONLY "public"."transacoes"
    ADD CONSTRAINT "transacoes_conta_bancaria_id_fkey" FOREIGN KEY ("conta_bancaria_id") REFERENCES "public"."contas_bancarias"("id");



ALTER TABLE ONLY "public"."transacoes"
    ADD CONSTRAINT "transacoes_conta_destino_id_fkey" FOREIGN KEY ("conta_destino_id") REFERENCES "public"."contas_bancarias"("id");



ALTER TABLE ONLY "public"."transacoes"
    ADD CONSTRAINT "transacoes_criado_por_fkey" FOREIGN KEY ("criado_por") REFERENCES "public"."profiles"("id");



ALTER TABLE ONLY "public"."transacoes"
    ADD CONSTRAINT "transacoes_membro_id_fkey" FOREIGN KEY ("membro_id") REFERENCES "public"."membros"("id");



ALTER TABLE ONLY "public"."transacoes"
    ADD CONSTRAINT "transacoes_organization_id_fkey" FOREIGN KEY ("organization_id") REFERENCES "public"."organizations"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."transacoes"
    ADD CONSTRAINT "transacoes_plano_contas_id_fkey" FOREIGN KEY ("plano_contas_id") REFERENCES "public"."plano_contas"("id");



CREATE POLICY "Gestão de centros por org" ON "public"."centros_custo" USING ("public"."check_user_in_org"("organization_id"));



CREATE POLICY "Gestão de contas por org" ON "public"."contas_bancarias" USING ("public"."check_user_in_org"("organization_id"));



CREATE POLICY "Gestão de histórico por org" ON "public"."historico_saldos" USING ("public"."check_user_in_org"("organization_id"));



CREATE POLICY "Gestão de membros por org" ON "public"."membros" USING ("public"."check_user_in_org"("organization_id"));



CREATE POLICY "Gestão de plano de contas por org" ON "public"."plano_contas" USING ("public"."check_user_in_org"("organization_id"));



CREATE POLICY "Gestão de transações por org" ON "public"."transacoes" USING ("public"."check_user_in_org"("organization_id")) WITH CHECK ("public"."check_user_in_org"("organization_id"));



CREATE POLICY "Isolamento de Organização - Leitura" ON "public"."transacoes" FOR SELECT USING (("organization_id" IN ( SELECT "organization_members"."organization_id"
   FROM "public"."organization_members"
  WHERE ("organization_members"."profile_id" = "auth"."uid"()))));



CREATE POLICY "Isolamento por Org Pulse" ON "public"."org_pulse" FOR SELECT USING ("public"."check_user_in_org"("organization_id"));



CREATE POLICY "Isolamento por Organização (Transacoes)" ON "public"."transacoes" FOR SELECT TO "authenticated" USING ("public"."check_user_in_org"("organization_id"));



CREATE POLICY "Isolar_Orgs_Delete" ON "public"."transacoes" FOR DELETE USING ("public"."check_user_in_org"("organization_id"));



CREATE POLICY "Isolar_Orgs_Insert" ON "public"."transacoes" FOR INSERT WITH CHECK ("public"."check_user_in_org"("organization_id"));



CREATE POLICY "Isolar_Orgs_Select" ON "public"."transacoes" FOR SELECT USING ("public"."check_user_in_org"("organization_id"));



CREATE POLICY "Isolar_Orgs_Update" ON "public"."transacoes" FOR UPDATE USING ("public"."check_user_in_org"("organization_id"));



CREATE POLICY "Membros veem membros da mesma org" ON "public"."organization_members" FOR SELECT USING ("public"."check_user_in_org"("organization_id"));



CREATE POLICY "Permissao_Total_Autenticado" ON "public"."obrigacoes_recorrentes" TO "authenticated" USING (("auth"."uid"() IS NOT NULL)) WITH CHECK (("auth"."uid"() IS NOT NULL));



CREATE POLICY "Permitir Update no proprio perfil" ON "public"."profiles" FOR UPDATE USING (("auth"."uid"() = "id"));



CREATE POLICY "RLS_profiles_equipa" ON "public"."profiles" FOR SELECT USING (("id" IN ( SELECT "organization_members"."profile_id"
   FROM "public"."organization_members"
  WHERE ("organization_members"."organization_id" IN ( SELECT "organization_members_1"."organization_id"
           FROM "public"."organization_members" "organization_members_1"
          WHERE ("organization_members_1"."profile_id" = "auth"."uid"()))))));



CREATE POLICY "Usuários veem o próprio perfil" ON "public"."profiles" FOR SELECT USING (("auth"."uid"() = "id"));



CREATE POLICY "Usuários veem suas organizações" ON "public"."organizations" FOR SELECT USING ((EXISTS ( SELECT 1
   FROM "public"."organization_members"
  WHERE (("organization_members"."organization_id" = "organizations"."id") AND ("organization_members"."profile_id" = "auth"."uid"())))));



ALTER TABLE "public"."centros_custo" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."contas_bancarias" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."historico_saldos" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."membros" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."obrigacoes_recorrentes" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."orcamentos_centro_custo" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."org_pulse" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."organization_members" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."organizations" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."plano_contas" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."profiles" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."transacoes" ENABLE ROW LEVEL SECURITY;


GRANT USAGE ON SCHEMA "public" TO "postgres";
GRANT USAGE ON SCHEMA "public" TO "anon";
GRANT USAGE ON SCHEMA "public" TO "authenticated";
GRANT USAGE ON SCHEMA "public" TO "service_role";



GRANT ALL ON FUNCTION "public"."add_organization_member"("p_profile_id" "uuid", "p_org_id" "uuid", "p_funcao" "text") TO "anon";
GRANT ALL ON FUNCTION "public"."add_organization_member"("p_profile_id" "uuid", "p_org_id" "uuid", "p_funcao" "text") TO "authenticated";
GRANT ALL ON FUNCTION "public"."add_organization_member"("p_profile_id" "uuid", "p_org_id" "uuid", "p_funcao" "text") TO "service_role";



GRANT ALL ON FUNCTION "public"."check_finance_usage"() TO "anon";
GRANT ALL ON FUNCTION "public"."check_finance_usage"() TO "authenticated";
GRANT ALL ON FUNCTION "public"."check_finance_usage"() TO "service_role";



GRANT ALL ON FUNCTION "public"."check_permite_lancamento"() TO "anon";
GRANT ALL ON FUNCTION "public"."check_permite_lancamento"() TO "authenticated";
GRANT ALL ON FUNCTION "public"."check_permite_lancamento"() TO "service_role";



GRANT ALL ON FUNCTION "public"."check_user_in_org"("org_id" "uuid") TO "anon";
GRANT ALL ON FUNCTION "public"."check_user_in_org"("org_id" "uuid") TO "authenticated";
GRANT ALL ON FUNCTION "public"."check_user_in_org"("org_id" "uuid") TO "service_role";



GRANT ALL ON FUNCTION "public"."create_my_organization"("org_name" "text", "org_type" "text", "p_user_id" "uuid") TO "anon";
GRANT ALL ON FUNCTION "public"."create_my_organization"("org_name" "text", "org_type" "text", "p_user_id" "uuid") TO "authenticated";
GRANT ALL ON FUNCTION "public"."create_my_organization"("org_name" "text", "org_type" "text", "p_user_id" "uuid") TO "service_role";



GRANT ALL ON FUNCTION "public"."fn_alertas_dashboard"("p_org_id" "uuid") TO "anon";
GRANT ALL ON FUNCTION "public"."fn_alertas_dashboard"("p_org_id" "uuid") TO "authenticated";
GRANT ALL ON FUNCTION "public"."fn_alertas_dashboard"("p_org_id" "uuid") TO "service_role";



GRANT ALL ON FUNCTION "public"."fn_autocura_saldos"() TO "anon";
GRANT ALL ON FUNCTION "public"."fn_autocura_saldos"() TO "authenticated";
GRANT ALL ON FUNCTION "public"."fn_autocura_saldos"() TO "service_role";



GRANT ALL ON FUNCTION "public"."fn_detalhe_cr"("p_org_id" "uuid", "p_cr_id" "uuid", "p_data_inicio" "date", "p_data_fim" "date") TO "anon";
GRANT ALL ON FUNCTION "public"."fn_detalhe_cr"("p_org_id" "uuid", "p_cr_id" "uuid", "p_data_inicio" "date", "p_data_fim" "date") TO "authenticated";
GRANT ALL ON FUNCTION "public"."fn_detalhe_cr"("p_org_id" "uuid", "p_cr_id" "uuid", "p_data_inicio" "date", "p_data_fim" "date") TO "service_role";



GRANT ALL ON FUNCTION "public"."fn_gerar_transacoes_recorrentes"() TO "anon";
GRANT ALL ON FUNCTION "public"."fn_gerar_transacoes_recorrentes"() TO "authenticated";
GRANT ALL ON FUNCTION "public"."fn_gerar_transacoes_recorrentes"() TO "service_role";



GRANT ALL ON FUNCTION "public"."fn_grafico_dfc_diario"("p_org_id" "uuid", "p_data_inicio" "date", "p_data_fim" "date") TO "anon";
GRANT ALL ON FUNCTION "public"."fn_grafico_dfc_diario"("p_org_id" "uuid", "p_data_inicio" "date", "p_data_fim" "date") TO "authenticated";
GRANT ALL ON FUNCTION "public"."fn_grafico_dfc_diario"("p_org_id" "uuid", "p_data_inicio" "date", "p_data_fim" "date") TO "service_role";



GRANT ALL ON FUNCTION "public"."fn_grafico_dfc_predicao"("p_organization_id" "uuid", "p_dias_historico" integer, "p_dias_predicao" integer) TO "anon";
GRANT ALL ON FUNCTION "public"."fn_grafico_dfc_predicao"("p_organization_id" "uuid", "p_dias_historico" integer, "p_dias_predicao" integer) TO "authenticated";
GRANT ALL ON FUNCTION "public"."fn_grafico_dfc_predicao"("p_organization_id" "uuid", "p_dias_historico" integer, "p_dias_predicao" integer) TO "service_role";



GRANT ALL ON FUNCTION "public"."fn_grafico_dre_diario"("p_org_id" "uuid", "p_data_inicio" "date", "p_data_fim" "date") TO "anon";
GRANT ALL ON FUNCTION "public"."fn_grafico_dre_diario"("p_org_id" "uuid", "p_data_inicio" "date", "p_data_fim" "date") TO "authenticated";
GRANT ALL ON FUNCTION "public"."fn_grafico_dre_diario"("p_org_id" "uuid", "p_data_inicio" "date", "p_data_fim" "date") TO "service_role";



GRANT ALL ON FUNCTION "public"."fn_listar_obrigacoes_recorrentes"("p_org_id" "uuid", "p_apenas_ativas" boolean) TO "anon";
GRANT ALL ON FUNCTION "public"."fn_listar_obrigacoes_recorrentes"("p_org_id" "uuid", "p_apenas_ativas" boolean) TO "authenticated";
GRANT ALL ON FUNCTION "public"."fn_listar_obrigacoes_recorrentes"("p_org_id" "uuid", "p_apenas_ativas" boolean) TO "service_role";



GRANT ALL ON FUNCTION "public"."fn_relatorio_cr_analitico"("p_org_id" "uuid", "p_data_inicio" "date", "p_data_fim" "date") TO "anon";
GRANT ALL ON FUNCTION "public"."fn_relatorio_cr_analitico"("p_org_id" "uuid", "p_data_inicio" "date", "p_data_fim" "date") TO "authenticated";
GRANT ALL ON FUNCTION "public"."fn_relatorio_cr_analitico"("p_org_id" "uuid", "p_data_inicio" "date", "p_data_fim" "date") TO "service_role";



GRANT ALL ON FUNCTION "public"."fn_relatorio_cr_sintetico"("p_org_id" "uuid", "p_data_inicio" "date", "p_data_fim" "date") TO "anon";
GRANT ALL ON FUNCTION "public"."fn_relatorio_cr_sintetico"("p_org_id" "uuid", "p_data_inicio" "date", "p_data_fim" "date") TO "authenticated";
GRANT ALL ON FUNCTION "public"."fn_relatorio_cr_sintetico"("p_org_id" "uuid", "p_data_inicio" "date", "p_data_fim" "date") TO "service_role";



GRANT ALL ON FUNCTION "public"."fn_relatorio_cr_sintetico_por_id"("p_org_id" "uuid", "p_data_inicio" "date", "p_data_fim" "date", "p_centro_custo_id" "uuid") TO "anon";
GRANT ALL ON FUNCTION "public"."fn_relatorio_cr_sintetico_por_id"("p_org_id" "uuid", "p_data_inicio" "date", "p_data_fim" "date", "p_centro_custo_id" "uuid") TO "authenticated";
GRANT ALL ON FUNCTION "public"."fn_relatorio_cr_sintetico_por_id"("p_org_id" "uuid", "p_data_inicio" "date", "p_data_fim" "date", "p_centro_custo_id" "uuid") TO "service_role";



GRANT ALL ON FUNCTION "public"."fn_relatorio_dfc_analitico"("p_org_id" "uuid", "p_data_inicio" "date", "p_data_fim" "date") TO "anon";
GRANT ALL ON FUNCTION "public"."fn_relatorio_dfc_analitico"("p_org_id" "uuid", "p_data_inicio" "date", "p_data_fim" "date") TO "authenticated";
GRANT ALL ON FUNCTION "public"."fn_relatorio_dfc_analitico"("p_org_id" "uuid", "p_data_inicio" "date", "p_data_fim" "date") TO "service_role";



GRANT ALL ON FUNCTION "public"."fn_relatorio_dfc_sintetico"("p_org_id" "uuid", "p_data_inicio" "date", "p_data_fim" "date") TO "anon";
GRANT ALL ON FUNCTION "public"."fn_relatorio_dfc_sintetico"("p_org_id" "uuid", "p_data_inicio" "date", "p_data_fim" "date") TO "authenticated";
GRANT ALL ON FUNCTION "public"."fn_relatorio_dfc_sintetico"("p_org_id" "uuid", "p_data_inicio" "date", "p_data_fim" "date") TO "service_role";



GRANT ALL ON FUNCTION "public"."fn_relatorio_dre_analitico"("p_org_id" "uuid", "p_data_inicio" "date", "p_data_fim" "date") TO "anon";
GRANT ALL ON FUNCTION "public"."fn_relatorio_dre_analitico"("p_org_id" "uuid", "p_data_inicio" "date", "p_data_fim" "date") TO "authenticated";
GRANT ALL ON FUNCTION "public"."fn_relatorio_dre_analitico"("p_org_id" "uuid", "p_data_inicio" "date", "p_data_fim" "date") TO "service_role";



GRANT ALL ON FUNCTION "public"."fn_relatorio_dre_sintetico"("p_org_id" "uuid", "p_data_inicio" "date", "p_data_fim" "date") TO "anon";
GRANT ALL ON FUNCTION "public"."fn_relatorio_dre_sintetico"("p_org_id" "uuid", "p_data_inicio" "date", "p_data_fim" "date") TO "authenticated";
GRANT ALL ON FUNCTION "public"."fn_relatorio_dre_sintetico"("p_org_id" "uuid", "p_data_inicio" "date", "p_data_fim" "date") TO "service_role";



GRANT ALL ON FUNCTION "public"."fn_resumo_conciliacao_dashboard"("p_org_id" "uuid", "p_data_inicio" timestamp with time zone, "p_data_fim" timestamp with time zone) TO "anon";
GRANT ALL ON FUNCTION "public"."fn_resumo_conciliacao_dashboard"("p_org_id" "uuid", "p_data_inicio" timestamp with time zone, "p_data_fim" timestamp with time zone) TO "authenticated";
GRANT ALL ON FUNCTION "public"."fn_resumo_conciliacao_dashboard"("p_org_id" "uuid", "p_data_inicio" timestamp with time zone, "p_data_fim" timestamp with time zone) TO "service_role";



GRANT ALL ON FUNCTION "public"."fn_resumo_contas_pagar_receber"("p_org_id" "uuid") TO "anon";
GRANT ALL ON FUNCTION "public"."fn_resumo_contas_pagar_receber"("p_org_id" "uuid") TO "authenticated";
GRANT ALL ON FUNCTION "public"."fn_resumo_contas_pagar_receber"("p_org_id" "uuid") TO "service_role";



GRANT ALL ON FUNCTION "public"."fn_resumo_saude_cr"("p_org_id" "uuid", "p_data_inicio" "date", "p_data_fim" "date") TO "anon";
GRANT ALL ON FUNCTION "public"."fn_resumo_saude_cr"("p_org_id" "uuid", "p_data_inicio" "date", "p_data_fim" "date") TO "authenticated";
GRANT ALL ON FUNCTION "public"."fn_resumo_saude_cr"("p_org_id" "uuid", "p_data_inicio" "date", "p_data_fim" "date") TO "service_role";



GRANT ALL ON FUNCTION "public"."fn_update_org_pulse"() TO "anon";
GRANT ALL ON FUNCTION "public"."fn_update_org_pulse"() TO "authenticated";
GRANT ALL ON FUNCTION "public"."fn_update_org_pulse"() TO "service_role";



GRANT ALL ON FUNCTION "public"."fn_validar_conta_analitica"() TO "anon";
GRANT ALL ON FUNCTION "public"."fn_validar_conta_analitica"() TO "authenticated";
GRANT ALL ON FUNCTION "public"."fn_validar_conta_analitica"() TO "service_role";



GRANT ALL ON FUNCTION "public"."gerar_proximo_codigo_subconta"("p_organization_id" "uuid", "p_codigo_pai" "text") TO "anon";
GRANT ALL ON FUNCTION "public"."gerar_proximo_codigo_subconta"("p_organization_id" "uuid", "p_codigo_pai" "text") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gerar_proximo_codigo_subconta"("p_organization_id" "uuid", "p_codigo_pai" "text") TO "service_role";



GRANT ALL ON FUNCTION "public"."handle_new_user"() TO "anon";
GRANT ALL ON FUNCTION "public"."handle_new_user"() TO "authenticated";
GRANT ALL ON FUNCTION "public"."handle_new_user"() TO "service_role";



GRANT ALL ON FUNCTION "public"."is_org_member"("_org_id" "uuid") TO "anon";
GRANT ALL ON FUNCTION "public"."is_org_member"("_org_id" "uuid") TO "authenticated";
GRANT ALL ON FUNCTION "public"."is_org_member"("_org_id" "uuid") TO "service_role";



GRANT ALL ON FUNCTION "public"."manter_unico_centro_custo_padrao"() TO "anon";
GRANT ALL ON FUNCTION "public"."manter_unico_centro_custo_padrao"() TO "authenticated";
GRANT ALL ON FUNCTION "public"."manter_unico_centro_custo_padrao"() TO "service_role";



GRANT ALL ON FUNCTION "public"."manter_unico_fundo_geral"() TO "anon";
GRANT ALL ON FUNCTION "public"."manter_unico_fundo_geral"() TO "authenticated";
GRANT ALL ON FUNCTION "public"."manter_unico_fundo_geral"() TO "service_role";



GRANT ALL ON FUNCTION "public"."obter_cache_centros_custo"("p_org_id" "uuid") TO "anon";
GRANT ALL ON FUNCTION "public"."obter_cache_centros_custo"("p_org_id" "uuid") TO "authenticated";
GRANT ALL ON FUNCTION "public"."obter_cache_centros_custo"("p_org_id" "uuid") TO "service_role";



GRANT ALL ON FUNCTION "public"."obter_cache_contas_bancarias"("p_org_id" "uuid") TO "anon";
GRANT ALL ON FUNCTION "public"."obter_cache_contas_bancarias"("p_org_id" "uuid") TO "authenticated";
GRANT ALL ON FUNCTION "public"."obter_cache_contas_bancarias"("p_org_id" "uuid") TO "service_role";



GRANT ALL ON FUNCTION "public"."obter_cache_membros_light"("p_org_id" "uuid") TO "anon";
GRANT ALL ON FUNCTION "public"."obter_cache_membros_light"("p_org_id" "uuid") TO "authenticated";
GRANT ALL ON FUNCTION "public"."obter_cache_membros_light"("p_org_id" "uuid") TO "service_role";



GRANT ALL ON FUNCTION "public"."obter_cache_plano_contas"("p_org_id" "uuid") TO "anon";
GRANT ALL ON FUNCTION "public"."obter_cache_plano_contas"("p_org_id" "uuid") TO "authenticated";
GRANT ALL ON FUNCTION "public"."obter_cache_plano_contas"("p_org_id" "uuid") TO "service_role";



GRANT ALL ON FUNCTION "public"."obter_detalhe_transacao_otimizado"("p_org_id" "uuid", "p_transacao_id" "uuid") TO "anon";
GRANT ALL ON FUNCTION "public"."obter_detalhe_transacao_otimizado"("p_org_id" "uuid", "p_transacao_id" "uuid") TO "authenticated";
GRANT ALL ON FUNCTION "public"."obter_detalhe_transacao_otimizado"("p_org_id" "uuid", "p_transacao_id" "uuid") TO "service_role";



GRANT ALL ON FUNCTION "public"."obter_detalhes_dfc_categoria"("p_org_id" "uuid", "p_data_inicio" "date", "p_data_fim" "date", "p_categoria_id" "uuid") TO "anon";
GRANT ALL ON FUNCTION "public"."obter_detalhes_dfc_categoria"("p_org_id" "uuid", "p_data_inicio" "date", "p_data_fim" "date", "p_categoria_id" "uuid") TO "authenticated";
GRANT ALL ON FUNCTION "public"."obter_detalhes_dfc_categoria"("p_org_id" "uuid", "p_data_inicio" "date", "p_data_fim" "date", "p_categoria_id" "uuid") TO "service_role";



GRANT ALL ON FUNCTION "public"."obter_detalhes_dre_categoria"("p_org_id" "uuid", "p_data_inicio" "date", "p_data_fim" "date", "p_categoria_id" "uuid") TO "anon";
GRANT ALL ON FUNCTION "public"."obter_detalhes_dre_categoria"("p_org_id" "uuid", "p_data_inicio" "date", "p_data_fim" "date", "p_categoria_id" "uuid") TO "authenticated";
GRANT ALL ON FUNCTION "public"."obter_detalhes_dre_categoria"("p_org_id" "uuid", "p_data_inicio" "date", "p_data_fim" "date", "p_categoria_id" "uuid") TO "service_role";



GRANT ALL ON FUNCTION "public"."obter_extrato_por_periodo"("p_organization_id" "uuid", "p_conta_id" "uuid", "p_data_inicio" timestamp with time zone, "p_data_fim" timestamp with time zone) TO "anon";
GRANT ALL ON FUNCTION "public"."obter_extrato_por_periodo"("p_organization_id" "uuid", "p_conta_id" "uuid", "p_data_inicio" timestamp with time zone, "p_data_fim" timestamp with time zone) TO "authenticated";
GRANT ALL ON FUNCTION "public"."obter_extrato_por_periodo"("p_organization_id" "uuid", "p_conta_id" "uuid", "p_data_inicio" timestamp with time zone, "p_data_fim" timestamp with time zone) TO "service_role";



GRANT ALL ON FUNCTION "public"."obter_pendencias_fechamento_mes"("p_org_id" "uuid", "p_data_fim" timestamp with time zone) TO "anon";
GRANT ALL ON FUNCTION "public"."obter_pendencias_fechamento_mes"("p_org_id" "uuid", "p_data_fim" timestamp with time zone) TO "authenticated";
GRANT ALL ON FUNCTION "public"."obter_pendencias_fechamento_mes"("p_org_id" "uuid", "p_data_fim" timestamp with time zone) TO "service_role";



GRANT ALL ON FUNCTION "public"."obter_projecao_titulos_retroativa"("p_org_id" "uuid", "p_data_fim" timestamp with time zone) TO "anon";
GRANT ALL ON FUNCTION "public"."obter_projecao_titulos_retroativa"("p_org_id" "uuid", "p_data_fim" timestamp with time zone) TO "authenticated";
GRANT ALL ON FUNCTION "public"."obter_projecao_titulos_retroativa"("p_org_id" "uuid", "p_data_fim" timestamp with time zone) TO "service_role";



GRANT ALL ON FUNCTION "public"."obter_saldo_total_org"("p_org_id" "uuid") TO "anon";
GRANT ALL ON FUNCTION "public"."obter_saldo_total_org"("p_org_id" "uuid") TO "authenticated";
GRANT ALL ON FUNCTION "public"."obter_saldo_total_org"("p_org_id" "uuid") TO "service_role";



GRANT ALL ON FUNCTION "public"."obter_saldos_contas"("p_org_id" "uuid") TO "anon";
GRANT ALL ON FUNCTION "public"."obter_saldos_contas"("p_org_id" "uuid") TO "authenticated";
GRANT ALL ON FUNCTION "public"."obter_saldos_contas"("p_org_id" "uuid") TO "service_role";



GRANT ALL ON FUNCTION "public"."obter_saldos_contas_por_periodo"("p_org_id" "uuid", "p_data_inicio" timestamp with time zone, "p_data_fim" timestamp with time zone) TO "anon";
GRANT ALL ON FUNCTION "public"."obter_saldos_contas_por_periodo"("p_org_id" "uuid", "p_data_inicio" timestamp with time zone, "p_data_fim" timestamp with time zone) TO "authenticated";
GRANT ALL ON FUNCTION "public"."obter_saldos_contas_por_periodo"("p_org_id" "uuid", "p_data_inicio" timestamp with time zone, "p_data_fim" timestamp with time zone) TO "service_role";



GRANT ALL ON FUNCTION "public"."populate_organization_defaults"() TO "anon";
GRANT ALL ON FUNCTION "public"."populate_organization_defaults"() TO "authenticated";
GRANT ALL ON FUNCTION "public"."populate_organization_defaults"() TO "service_role";



GRANT ALL ON FUNCTION "public"."rls_auto_enable"() TO "anon";
GRANT ALL ON FUNCTION "public"."rls_auto_enable"() TO "authenticated";
GRANT ALL ON FUNCTION "public"."rls_auto_enable"() TO "service_role";



GRANT ALL ON FUNCTION "public"."sanitize_transacao_data"() TO "anon";
GRANT ALL ON FUNCTION "public"."sanitize_transacao_data"() TO "authenticated";
GRANT ALL ON FUNCTION "public"."sanitize_transacao_data"() TO "service_role";



GRANT ALL ON FUNCTION "public"."set_created_by"() TO "anon";
GRANT ALL ON FUNCTION "public"."set_created_by"() TO "authenticated";
GRANT ALL ON FUNCTION "public"."set_created_by"() TO "service_role";



GRANT ALL ON FUNCTION "public"."uuid_generate_v7"() TO "anon";
GRANT ALL ON FUNCTION "public"."uuid_generate_v7"() TO "authenticated";
GRANT ALL ON FUNCTION "public"."uuid_generate_v7"() TO "service_role";



GRANT ALL ON FUNCTION "public"."validate_transacao_logic"() TO "anon";
GRANT ALL ON FUNCTION "public"."validate_transacao_logic"() TO "authenticated";
GRANT ALL ON FUNCTION "public"."validate_transacao_logic"() TO "service_role";



GRANT ALL ON FUNCTION "public"."verificar_pai_tem_transacoes"("p_organization_id" "uuid", "p_codigo_filho" "text") TO "anon";
GRANT ALL ON FUNCTION "public"."verificar_pai_tem_transacoes"("p_organization_id" "uuid", "p_codigo_filho" "text") TO "authenticated";
GRANT ALL ON FUNCTION "public"."verificar_pai_tem_transacoes"("p_organization_id" "uuid", "p_codigo_filho" "text") TO "service_role";



GRANT ALL ON TABLE "public"."centros_custo" TO "anon";
GRANT ALL ON TABLE "public"."centros_custo" TO "authenticated";
GRANT ALL ON TABLE "public"."centros_custo" TO "service_role";



GRANT ALL ON TABLE "public"."contas_bancarias" TO "anon";
GRANT ALL ON TABLE "public"."contas_bancarias" TO "authenticated";
GRANT ALL ON TABLE "public"."contas_bancarias" TO "service_role";



GRANT ALL ON TABLE "public"."historico_saldos" TO "anon";
GRANT ALL ON TABLE "public"."historico_saldos" TO "authenticated";
GRANT ALL ON TABLE "public"."historico_saldos" TO "service_role";



GRANT ALL ON TABLE "public"."membros" TO "anon";
GRANT ALL ON TABLE "public"."membros" TO "authenticated";
GRANT ALL ON TABLE "public"."membros" TO "service_role";



GRANT ALL ON TABLE "public"."obrigacoes_recorrentes" TO "anon";
GRANT ALL ON TABLE "public"."obrigacoes_recorrentes" TO "authenticated";
GRANT ALL ON TABLE "public"."obrigacoes_recorrentes" TO "service_role";



GRANT ALL ON TABLE "public"."orcamentos_centro_custo" TO "anon";
GRANT ALL ON TABLE "public"."orcamentos_centro_custo" TO "authenticated";
GRANT ALL ON TABLE "public"."orcamentos_centro_custo" TO "service_role";



GRANT ALL ON TABLE "public"."org_pulse" TO "anon";
GRANT ALL ON TABLE "public"."org_pulse" TO "authenticated";
GRANT ALL ON TABLE "public"."org_pulse" TO "service_role";



GRANT ALL ON TABLE "public"."organization_members" TO "anon";
GRANT ALL ON TABLE "public"."organization_members" TO "authenticated";
GRANT ALL ON TABLE "public"."organization_members" TO "service_role";



GRANT ALL ON TABLE "public"."organizations" TO "anon";
GRANT ALL ON TABLE "public"."organizations" TO "authenticated";
GRANT ALL ON TABLE "public"."organizations" TO "service_role";



GRANT ALL ON TABLE "public"."plano_contas" TO "anon";
GRANT ALL ON TABLE "public"."plano_contas" TO "authenticated";
GRANT ALL ON TABLE "public"."plano_contas" TO "service_role";



GRANT ALL ON TABLE "public"."profiles" TO "anon";
GRANT ALL ON TABLE "public"."profiles" TO "authenticated";
GRANT ALL ON TABLE "public"."profiles" TO "service_role";



GRANT ALL ON TABLE "public"."transacoes" TO "anon";
GRANT ALL ON TABLE "public"."transacoes" TO "authenticated";
GRANT ALL ON TABLE "public"."transacoes" TO "service_role";



GRANT ALL ON TABLE "public"."view_membros_equipe" TO "anon";
GRANT ALL ON TABLE "public"."view_membros_equipe" TO "authenticated";
GRANT ALL ON TABLE "public"."view_membros_equipe" TO "service_role";



GRANT ALL ON TABLE "public"."view_saldos_contas" TO "anon";
GRANT ALL ON TABLE "public"."view_saldos_contas" TO "authenticated";
GRANT ALL ON TABLE "public"."view_saldos_contas" TO "service_role";



GRANT ALL ON TABLE "public"."vw_agendamentos" TO "anon";
GRANT ALL ON TABLE "public"."vw_agendamentos" TO "authenticated";
GRANT ALL ON TABLE "public"."vw_agendamentos" TO "service_role";



GRANT ALL ON TABLE "public"."vw_contas_para_notificar" TO "anon";
GRANT ALL ON TABLE "public"."vw_contas_para_notificar" TO "authenticated";
GRANT ALL ON TABLE "public"."vw_contas_para_notificar" TO "service_role";



GRANT ALL ON TABLE "public"."vw_extrato_individual" TO "anon";
GRANT ALL ON TABLE "public"."vw_extrato_individual" TO "authenticated";
GRANT ALL ON TABLE "public"."vw_extrato_individual" TO "service_role";



GRANT ALL ON TABLE "public"."vw_saldo_total_org" TO "anon";
GRANT ALL ON TABLE "public"."vw_saldo_total_org" TO "authenticated";
GRANT ALL ON TABLE "public"."vw_saldo_total_org" TO "service_role";



GRANT ALL ON TABLE "public"."vw_transacoes_competencia" TO "anon";
GRANT ALL ON TABLE "public"."vw_transacoes_competencia" TO "authenticated";
GRANT ALL ON TABLE "public"."vw_transacoes_competencia" TO "service_role";



ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON SEQUENCES TO "postgres";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON SEQUENCES TO "anon";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON SEQUENCES TO "authenticated";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON SEQUENCES TO "service_role";






ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON FUNCTIONS TO "postgres";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON FUNCTIONS TO "anon";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON FUNCTIONS TO "authenticated";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON FUNCTIONS TO "service_role";






ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON TABLES TO "postgres";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON TABLES TO "anon";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON TABLES TO "authenticated";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON TABLES TO "service_role";







