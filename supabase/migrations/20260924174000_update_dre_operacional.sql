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
