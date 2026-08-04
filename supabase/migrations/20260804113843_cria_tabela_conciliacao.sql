-- Migration unit 1: schema_changes
-- Transaction mode: transactional
-- Boundary reason: default

SET check_function_bodies = false;

DROP FUNCTION public.fn_importar_ofx_lote(p_org_id uuid, p_conta_id uuid, p_transacoes jsonb);

DROP TRIGGER trg_regras_cat_timestamp ON public.regras_categorizacao;

DROP FUNCTION public.fn_atualizar_regras_timestamp();

DROP POLICY regras_categorizacao_org_policy ON public.regras_categorizacao;

DROP TABLE public.regras_categorizacao;