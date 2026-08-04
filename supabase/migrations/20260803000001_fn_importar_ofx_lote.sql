-- Função RPC: Importação OFX em lote com conciliação inteligente de pendentes
-- Criado em: 2026-08-03
--
-- Recebe um JSONB com array de transações OFX, e para cada item:
--   1. IGNORA  se já existir um registro com o mesmo id_unico_banco (fitid)
--   2. CONCILIA se encontrar um registro PENDENTE com mesmo valor/tipo/data (±5 dias)
--   3. INSERE  como novo registro CONCILIADO caso contrário
--
-- Retorna: { importados, conciliados, duplicados, total }
-- Performance: 1 único roundtrip HTTP vs. N*2 roundtrips no modelo anterior.

CREATE OR REPLACE FUNCTION public.fn_importar_ofx_lote(
  p_org_id          uuid,
  p_conta_id        uuid,
  p_transacoes      jsonb
)
RETURNS jsonb
LANGUAGE plpgsql SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
  v_item            jsonb;
  v_fitid           text;
  v_descricao       text;
  v_valor           numeric;
  v_tipo            text;
  v_data_pgto       timestamptz;
  v_data_comp       date;
  v_data_venc       date;
  v_plano_id        uuid;
  v_centro_id       uuid;
  v_pendente_id     uuid;
  v_importados      integer := 0;
  v_conciliados     integer := 0;
  v_duplicados      integer := 0;
BEGIN
  -- Segurança multi-tenant: valida que o usuário pertence à organização
  IF NOT public.check_user_in_org(p_org_id) THEN
    RAISE EXCEPTION 'Acesso negado: usuário não autorizado para esta organização.';
  END IF;

  FOR v_item IN SELECT jsonb_array_elements(p_transacoes) LOOP
    v_fitid     := v_item->>'fitid';
    v_descricao := COALESCE(v_item->>'descricao', 'Sem descrição');
    v_valor     := (v_item->>'valor')::numeric;
    v_tipo      := v_item->>'tipo_operacao';
    v_data_pgto := (v_item->>'data_pagamento')::timestamptz;
    v_data_comp := (v_item->>'data_competencia')::date;
    v_data_venc := COALESCE((v_item->>'data_vencimento')::date, v_data_comp);
    v_plano_id  := NULLIF(v_item->>'plano_contas_id', '')::uuid;
    v_centro_id := NULLIF(v_item->>'centro_custo_id', '')::uuid;

    -- 1. DEDUPLICAÇÃO: já existe registro com este fitid nesta organização?
    IF EXISTS (
      SELECT 1 FROM public.transacoes
      WHERE organization_id = p_org_id
        AND id_unico_banco  = v_fitid
    ) THEN
      v_duplicados := v_duplicados + 1;
      CONTINUE;
    END IF;

    -- 2. CONCILIAÇÃO INTELIGENTE:
    --    Busca o registro PENDENTE mais próximo em data, mesmo valor e tipo,
    --    nesta conta, sem fitid ainda vinculado, dentro da janela de ±5 dias.
    SELECT id INTO v_pendente_id
    FROM public.transacoes
    WHERE organization_id   = p_org_id
      AND conta_bancaria_id = p_conta_id
      AND status            = 'PENDENTE'
      AND tipo_operacao     = v_tipo
      AND valor             = v_valor
      AND id_unico_banco    IS NULL
      AND data_vencimento   BETWEEN (v_data_comp - INTERVAL '5 days')
                                AND (v_data_comp + INTERVAL '5 days')
    ORDER BY ABS(EXTRACT(EPOCH FROM (data_vencimento::timestamp - v_data_comp::timestamp)))
    LIMIT 1;

    IF v_pendente_id IS NOT NULL THEN
      -- CONCILIA: vincula o fitid do banco e marca como CONCILIADO
      UPDATE public.transacoes SET
        id_unico_banco = v_fitid,
        data_pagamento = v_data_pgto,
        status         = 'CONCILIADO'
      WHERE id = v_pendente_id;
      v_conciliados := v_conciliados + 1;

    ELSE
      -- IMPORTA: cria novo registro já com status CONCILIADO
      INSERT INTO public.transacoes (
        organization_id,
        conta_bancaria_id,
        descricao,
        valor,
        tipo_operacao,
        status,
        id_unico_banco,
        data_pagamento,
        data_competencia,
        data_vencimento,
        plano_contas_id,
        centro_custo_id
      ) VALUES (
        p_org_id,
        p_conta_id,
        v_descricao,
        v_valor,
        v_tipo,
        'CONCILIADO',
        v_fitid,
        v_data_pgto,
        v_data_comp,
        v_data_venc,
        v_plano_id,
        v_centro_id
      );
      v_importados := v_importados + 1;
    END IF;

  END LOOP;

  RETURN jsonb_build_object(
    'importados',  v_importados,
    'conciliados', v_conciliados,
    'duplicados',  v_duplicados,
    'total',       v_importados + v_conciliados + v_duplicados
  );

EXCEPTION WHEN OTHERS THEN
  RAISE EXCEPTION 'Erro na importação em lote: % | SQLSTATE: %', SQLERRM, SQLSTATE;
END;
$$;

ALTER FUNCTION public.fn_importar_ofx_lote(uuid, uuid, jsonb) OWNER TO postgres;

-- Permissão de execução para usuários autenticados (via RLS a segurança já é garantida)
GRANT EXECUTE ON FUNCTION public.fn_importar_ofx_lote(uuid, uuid, jsonb) TO authenticated;
