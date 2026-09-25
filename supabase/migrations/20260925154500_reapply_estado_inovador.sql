-- Migration para consertar os filtros corrompidos por encoding (acentuação) e restaurar colunas antigas.

-- 1. fn_resumo_saude_cr
DROP FUNCTION IF EXISTS public.fn_resumo_saude_cr;

CREATE OR REPLACE FUNCTION public.fn_resumo_saude_cr (
  p_org_id      uuid,
  p_data_inicio date,
  p_data_fim    date
)
  RETURNS TABLE (
    qtd_verde      integer,
    qtd_amarelo    integer,
    qtd_vermelho   integer,
    top_ofensores  jsonb
  )
  LANGUAGE plpgsql
  AS $function$
DECLARE
    v_inicio_ano_contabil date;
    v_top_ofensores jsonb;
BEGIN
    v_inicio_ano_contabil := DATE_TRUNC('year', p_data_inicio)::date;

    SELECT COALESCE(jsonb_agg(
        jsonb_build_object(
            'nome', nome_cr,
            'saldo', saldo_periodo
        )
    ), '[]'::jsonb) INTO v_top_ofensores
    FROM (
        SELECT cc.nome AS nome_cr, 
               COALESCE(SUM(CASE WHEN t.tipo_operacao IN ('CREDITO', 'CRÉDITO') THEN t.valor ELSE 0 END), 0) -
               COALESCE(SUM(CASE WHEN t.tipo_operacao IN ('DEBITO', 'DÉBITO') THEN t.valor ELSE 0 END), 0) AS saldo_periodo
        FROM public.centros_custo cc
        INNER JOIN public.transacoes t ON t.centro_custo_id = cc.id
        WHERE cc.organization_id = p_org_id 
          AND cc.ativo = true
          AND t.status = 'CONCILIADO'
          AND t.data_pagamento < ((p_data_fim + INTERVAL '1 day') AT TIME ZONE 'America/Sao_Paulo')
          AND (
              (cc.permite_acumulo = false AND t.data_pagamento >= (p_data_inicio AT TIME ZONE 'America/Sao_Paulo'))
              OR 
              (cc.permite_acumulo = true AND t.data_pagamento >= (v_inicio_ano_contabil AT TIME ZONE 'America/Sao_Paulo'))
          )
        GROUP BY cc.id, cc.nome
        HAVING (COALESCE(SUM(CASE WHEN t.tipo_operacao IN ('CREDITO', 'CRÉDITO') THEN t.valor ELSE 0 END), 0) - COALESCE(SUM(CASE WHEN t.tipo_operacao IN ('DEBITO', 'DÉBITO') THEN t.valor ELSE 0 END), 0)) < 0
        ORDER BY saldo_periodo ASC
        LIMIT 3
    ) sub;

    RETURN QUERY
    WITH SaldosCR AS (
        SELECT 
            cc.id,
            COALESCE(SUM(CASE WHEN t.tipo_operacao IN ('CREDITO', 'CRÉDITO') THEN t.valor ELSE 0 END), 0) -
            COALESCE(SUM(CASE WHEN t.tipo_operacao IN ('DEBITO', 'DÉBITO') THEN t.valor ELSE 0 END), 0) AS saldo_periodo
        FROM public.centros_custo cc
        LEFT JOIN public.transacoes t ON t.centro_custo_id = cc.id
          AND t.status = 'CONCILIADO'
          AND t.data_pagamento < ((p_data_fim + INTERVAL '1 day') AT TIME ZONE 'America/Sao_Paulo')
          AND (
              (cc.permite_acumulo = false AND t.data_pagamento >= (p_data_inicio AT TIME ZONE 'America/Sao_Paulo'))
              OR 
              (cc.permite_acumulo = true AND t.data_pagamento >= (v_inicio_ano_contabil AT TIME ZONE 'America/Sao_Paulo'))
          )
        WHERE cc.organization_id = p_org_id AND cc.ativo = true
        GROUP BY cc.id
    )
    SELECT 
        COUNT(CASE WHEN saldo_periodo > 0 THEN 1 END)::integer AS qtd_verde,
        COUNT(CASE WHEN saldo_periodo = 0 THEN 1 END)::integer AS qtd_amarelo,
        COUNT(CASE WHEN saldo_periodo < 0 THEN 1 END)::integer AS qtd_vermelho,
        v_top_ofensores AS top_ofensores
    FROM SaldosCR;
END;
$function$;

-- 2. fn_resumo_contas_pagar_receber
DROP FUNCTION IF EXISTS public.fn_resumo_contas_pagar_receber;

CREATE OR REPLACE FUNCTION public.fn_resumo_contas_pagar_receber (
  p_org_id uuid
)
  RETURNS TABLE (
    total_pagar                      numeric,
    total_pagar_atrasado             numeric,
    total_pagar_hoje                 numeric,
    total_pagar_vencer               numeric, 
    total_pagar_vencer_curto_prazo   numeric,
    total_pagar_vencer_longo_prazo   numeric,
    total_receber                    numeric,
    total_receber_atrasado           numeric,
    total_receber_hoje               numeric,
    total_receber_vencer             numeric, 
    total_receber_vencer_curto_prazo numeric,
    total_receber_vencer_longo_prazo numeric
  )
  LANGUAGE plpgsql
  SECURITY DEFINER
  AS $function$
BEGIN
    IF NOT public.check_user_in_org(p_org_id) THEN
        RAISE EXCEPTION 'Acesso negado: Usuário não autorizado para esta organização.';
    END IF;

    RETURN QUERY
    SELECT 
        -- CONTAS A PAGAR
        COALESCE(SUM(valor) FILTER (WHERE tipo_operacao IN ('DEBITO', 'DÉBITO')), 0)::numeric AS total_pagar,
        COALESCE(SUM(valor) FILTER (WHERE tipo_operacao IN ('DEBITO', 'DÉBITO') AND data_vencimento::date < CURRENT_DATE), 0)::numeric AS total_pagar_atrasado,
        COALESCE(SUM(valor) FILTER (WHERE tipo_operacao IN ('DEBITO', 'DÉBITO') AND data_vencimento::date = CURRENT_DATE), 0)::numeric AS total_pagar_hoje,
        COALESCE(SUM(valor) FILTER (WHERE tipo_operacao IN ('DEBITO', 'DÉBITO') AND data_vencimento::date > CURRENT_DATE), 0)::numeric AS total_pagar_vencer,
        COALESCE(SUM(valor) FILTER (WHERE tipo_operacao IN ('DEBITO', 'DÉBITO') AND data_vencimento::date > CURRENT_DATE AND data_vencimento::date <= (CURRENT_DATE + INTERVAL '1 year')), 0)::numeric AS total_pagar_vencer_curto_prazo,
        COALESCE(SUM(valor) FILTER (WHERE tipo_operacao IN ('DEBITO', 'DÉBITO') AND data_vencimento::date > (CURRENT_DATE + INTERVAL '1 year')), 0)::numeric AS total_pagar_vencer_longo_prazo,

        -- CONTAS A RECEBER
        COALESCE(SUM(valor) FILTER (WHERE tipo_operacao IN ('CREDITO', 'CRÉDITO')), 0)::numeric AS total_receber,
        COALESCE(SUM(valor) FILTER (WHERE tipo_operacao IN ('CREDITO', 'CRÉDITO') AND data_vencimento::date < CURRENT_DATE), 0)::numeric AS total_receber_atrasado,
        COALESCE(SUM(valor) FILTER (WHERE tipo_operacao IN ('CREDITO', 'CRÉDITO') AND data_vencimento::date = CURRENT_DATE), 0)::numeric AS total_receber_hoje,
        COALESCE(SUM(valor) FILTER (WHERE tipo_operacao IN ('CREDITO', 'CRÉDITO') AND data_vencimento::date > CURRENT_DATE), 0)::numeric AS total_receber_vencer,
        COALESCE(SUM(valor) FILTER (WHERE tipo_operacao IN ('CREDITO', 'CRÉDITO') AND data_vencimento::date > CURRENT_DATE AND data_vencimento::date <= (CURRENT_DATE + INTERVAL '1 year')), 0)::numeric AS total_receber_vencer_curto_prazo,
        COALESCE(SUM(valor) FILTER (WHERE tipo_operacao IN ('CREDITO', 'CRÉDITO') AND data_vencimento::date > (CURRENT_DATE + INTERVAL '1 year')), 0)::numeric AS total_receber_vencer_longo_prazo

    FROM public.transacoes
    WHERE organization_id = p_org_id
      AND status = 'PENDENTE'
      AND data_vencimento IS NOT NULL;
END;
$function$;

-- 3. obter_saldo_total_org
DROP FUNCTION IF EXISTS public.obter_saldo_total_org;

CREATE OR REPLACE FUNCTION public.obter_saldo_total_org (
  p_org_id uuid
)
  RETURNS TABLE (
    total_saldo_inicial   numeric,
    total_entradas_geral  numeric,
    total_saidas_geral    numeric,
    saldo_liquido_geral   numeric,
    saldo_disponivel_real numeric,
    total_faturas_cartao  numeric,
    total_a_receber       numeric,
    total_a_pagar         numeric,
    resumo_ativo_passivo  numeric,
    total_ativos          numeric,
    total_passivos        numeric,
    saldo_bloqueado       numeric
  )
  LANGUAGE plpgsql
  SECURITY DEFINER
  AS $function$
BEGIN
    IF NOT public.check_user_in_org(p_org_id) THEN
        RAISE EXCEPTION 'Acesso negado: Usuário não autorizado para esta organização.';
    END IF;

    RETURN QUERY
    WITH caixa_realizado AS (
        SELECT 
            COALESCE(SUM(v.saldo_inicial), 0)::numeric AS c_saldo_inicial,
            COALESCE(SUM(v.total_entradas), 0)::numeric AS c_entradas_geral,
            COALESCE(SUM(v.total_saidas), 0)::numeric AS c_saidas_geral,
            (COALESCE(SUM(v.total_entradas), 0) - COALESCE(SUM(v.total_saidas), 0))::numeric AS c_liquido_geral,
            
            -- O Disponível Real Só pega dinheiro solto.
            COALESCE(SUM(CASE WHEN v.tipo_conta NOT IN ('CARTAO', 'CARTÃO', 'VIRTUAL', 'APLICACAO', 'APLICAÇÃO', 'POUPANCA', 'POUPANÇA', 'INVESTIMENTO', 'FUNDO_DE_RESERVA', 'CAPITAL') THEN v.saldo_atual ELSE 0 END), 0)::numeric AS c_disponivel_real,
            
            -- O que está parado/investido
            COALESCE(SUM(CASE WHEN v.tipo_conta IN ('APLICACAO', 'APLICAÇÃO', 'POUPANCA', 'POUPANÇA', 'INVESTIMENTO', 'FUNDO_DE_RESERVA', 'CAPITAL') THEN v.saldo_atual ELSE 0 END), 0)::numeric AS c_reservas,

            -- Faturas de Cartão 
            COALESCE(SUM(CASE WHEN v.tipo_conta IN ('CARTAO', 'CARTÃO') THEN (v.saldo_atual * -1) ELSE 0 END), 0)::numeric AS c_faturas_cartao
            
        FROM public.obter_saldos_contas(p_org_id) v
    ),
    previsao_futura AS (
        SELECT
            COALESCE(SUM(t.valor) FILTER (WHERE t.tipo_operacao IN ('CREDITO', 'CRÉDITO')), 0)::numeric AS a_receber,
            COALESCE(SUM(t.valor) FILTER (WHERE t.tipo_operacao IN ('DEBITO', 'DÉBITO')), 0)::numeric AS a_pagar
        FROM public.transacoes t
        LEFT JOIN public.plano_contas pc ON t.plano_contas_id = pc.id
        LEFT JOIN public.contas_bancarias cb ON t.conta_bancaria_id = cb.id
        WHERE t.organization_id = p_org_id
          AND t.status = 'PENDENTE'
          AND pc.codigo_contabil IS DISTINCT FROM '9.9.99'
          AND (cb.tipo IS DISTINCT FROM 'CARTAO' AND cb.tipo IS DISTINCT FROM 'CARTÃO')
    )
    SELECT 
        c.c_saldo_inicial AS total_saldo_inicial,
        c.c_entradas_geral AS total_entradas_geral,
        c.c_saidas_geral AS total_saidas_geral,
        c.c_liquido_geral AS saldo_liquido_geral,
        c.c_disponivel_real AS saldo_disponivel_real,
        c.c_faturas_cartao AS total_faturas_cartao,
        p.a_receber AS total_a_receber,
        p.a_pagar AS total_a_pagar,
        
        -- Métrica Original
        ((c.c_disponivel_real + c.c_reservas + p.a_receber) - (c.c_faturas_cartao + p.a_pagar))::numeric AS resumo_ativo_passivo,
        
        -- Novas métricas desmembradas para o FlutterFlow não esconder a matemática
        (c.c_disponivel_real + c.c_reservas + p.a_receber)::numeric AS total_ativos,
        (c.c_faturas_cartao + p.a_pagar)::numeric AS total_passivos,
        c.c_reservas AS saldo_bloqueado
        
    FROM caixa_realizado c CROSS JOIN previsao_futura p;
END;
$function$;
-- Migration para separar Custo Operacional vs Custo Financeiro no DRE
-- Criado pelo assistente Antigravity

DROP FUNCTION IF EXISTS public.fn_relatorio_dre_sintetico;

CREATE OR REPLACE FUNCTION public.fn_relatorio_dre_sintetico (
  p_org_id      uuid,
  p_data_inicio date,
  p_data_fim    date
)
  RETURNS TABLE (
    soma_receitas              numeric,
    soma_despesas              numeric,
    soma_liquido               numeric,
    margem_lucro_percentual    numeric,
    -- NOVAS COLUNAS PARA SEGREGAÇÃO (EBITDA / RESULTADO FINANCEIRO)
    soma_despesas_operacionais numeric,
    soma_despesas_financeiras  numeric,
    resultado_operacional      numeric
  )
  LANGUAGE plpgsql
  SECURITY DEFINER
  AS $function$
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
            
            -- SEGREGAÇÃO: Despesas Operacionais vs Financeiras
            -- (Assumindo que contas do grupo 2.7 sejam financeiras, como no padrão Lastro)
            COALESCE(SUM(v.valor_absoluto) FILTER (WHERE v.tipo_conta = 'DESPESA' AND (v.codigo_contabil NOT LIKE '2.7%' OR v.codigo_contabil IS NULL)), 0) AS despesas_op,
            COALESCE(SUM(v.valor_absoluto) FILTER (WHERE v.tipo_conta = 'DESPESA' AND v.codigo_contabil LIKE '2.7%'), 0) AS despesas_fin,

            COALESCE(SUM(v.valor_liquido), 0) AS liquido
        FROM public.vw_transacoes_competencia v
        WHERE v.organization_id = p_org_id
          AND v.data_competencia_real >= p_data_inicio
          AND v.data_competencia_real <= p_data_fim
    )
    SELECT 
        c.receitas::numeric AS soma_receitas,
        c.despesas::numeric AS soma_despesas,
        c.liquido::numeric AS soma_liquido,
        
        -- Trava matemática para divisão por zero em meses sem receita
        CASE 
            WHEN c.receitas > 0 THEN ROUND((c.liquido / c.receitas) * 100, 2)::numeric
            ELSE 0::numeric
        END AS margem_lucro_percentual,
        
        -- EXPORTAÇÃO DOS NOVOS DADOS
        c.despesas_op::numeric AS soma_despesas_operacionais,
        c.despesas_fin::numeric AS soma_despesas_financeiras,
        (c.receitas - c.despesas_op)::numeric AS resultado_operacional
        
    FROM calculo_dre c;
END;
$function$;
