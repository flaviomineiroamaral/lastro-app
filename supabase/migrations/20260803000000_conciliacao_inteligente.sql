-- Migration: Sistema de Memória de Categorização para Conciliação OFX Inteligente
-- Criado em: 2026-08-03

CREATE TABLE IF NOT EXISTS public.regras_categorizacao (
  id                  uuid DEFAULT gen_random_uuid() PRIMARY KEY,
  organization_id     uuid NOT NULL REFERENCES public.organizations(id) ON DELETE CASCADE,
  padrao_descricao    text NOT NULL,
  plano_contas_id     uuid REFERENCES public.plano_contas(id) ON DELETE SET NULL,
  centro_custo_id     uuid REFERENCES public.centros_custo(id) ON DELETE SET NULL,
  tipo_operacao       text CHECK (tipo_operacao IN ('CREDITO', 'DEBITO')),
  contagem_usos       integer DEFAULT 1 NOT NULL,
  criado_em           timestamptz DEFAULT now(),
  atualizado_em       timestamptz DEFAULT now(),
  UNIQUE (organization_id, padrao_descricao, tipo_operacao)
);

COMMENT ON TABLE public.regras_categorizacao IS
  'Memória de categorização automática: aprende associações entre descrições de transações e categorias contábeis conforme o usuário confirma importações.';

-- RLS: cada organização vê e gerencia apenas suas próprias regras
ALTER TABLE public.regras_categorizacao ENABLE ROW LEVEL SECURITY;

CREATE POLICY "regras_categorizacao_org_policy"
  ON public.regras_categorizacao
  FOR ALL
  USING (public.check_user_in_org(organization_id))
  WITH CHECK (public.check_user_in_org(organization_id));

-- Índice para busca rápida por organização (usado no engine de sugestão)
CREATE INDEX IF NOT EXISTS idx_regras_cat_org
  ON public.regras_categorizacao(organization_id);

-- Índice composto para o UNIQUE lookup de upsert
CREATE INDEX IF NOT EXISTS idx_regras_cat_padrao
  ON public.regras_categorizacao(organization_id, padrao_descricao, tipo_operacao);

-- Trigger para atualizar atualizado_em automaticamente
CREATE OR REPLACE FUNCTION public.fn_atualizar_regras_timestamp()
RETURNS TRIGGER LANGUAGE plpgsql AS $$
BEGIN
  NEW.atualizado_em = now();
  RETURN NEW;
END;
$$;

CREATE TRIGGER trg_regras_cat_timestamp
BEFORE UPDATE ON public.regras_categorizacao
FOR EACH ROW EXECUTE FUNCTION public.fn_atualizar_regras_timestamp();

ALTER TABLE public.regras_categorizacao OWNER TO postgres;
