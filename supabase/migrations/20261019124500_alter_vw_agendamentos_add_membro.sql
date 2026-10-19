-- ==============================================================================
-- Atualização da view public.vw_agendamentos para incluir dados do membro
-- (membro_nome, membro_telefone, membro_email)
-- ==============================================================================

DROP VIEW IF EXISTS public.vw_agendamentos;

CREATE VIEW public.vw_agendamentos AS
SELECT
  t.id AS transacao_id,
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
  m.nome_completo AS membro_nome,
  m.telefone AS membro_telefone,
  m.email AS membro_email,
  t.observacoes,
  t.comprovativo_url,
  t.id_unico_banco,
  COALESCE(t.parcela_atual, 0) AS parcela_atual,
  COALESCE(t.total_parcelas, 0) AS total_parcelas,
  t.data_vencimento,
  t.data_competencia,
  t.conta_destino_id,
  CASE
    WHEN t.tipo_operacao = 'DEBITO'::text THEN 'CP'::text
    WHEN t.tipo_operacao = 'CREDITO'::text THEN 'CR'::text
    ELSE 'OUTRO'::text
  END AS modulo,
  CASE
    WHEN t.tipo_operacao = 'DEBITO'::text THEN 'A Pagar'::text
    WHEN t.tipo_operacao = 'CREDITO'::text THEN 'A Receber'::text
    ELSE 'Transferência'::text
  END AS tipo_agendamento,
  CASE
    WHEN t.data_vencimento < CURRENT_DATE THEN 'VENCIDO'::text
    WHEN t.data_vencimento = CURRENT_DATE THEN 'HOJE'::text
    ELSE 'A VENCER'::text
  END AS status_prazo,
  CURRENT_DATE - t.data_vencimento AS dias_diferenca,
  SUM(
    CASE
      WHEN t.tipo_operacao = 'DEBITO'::text THEN - abs(COALESCE(t.valor, 0::numeric))
      WHEN t.tipo_operacao = 'CREDITO'::text THEN abs(COALESCE(t.valor, 0::numeric))
      ELSE 0::numeric
    END
  ) OVER (
    PARTITION BY
      t.organization_id,
      t.tipo_operacao
    ORDER BY
      t.data_vencimento,
      t.id
  ) AS saldo_progressivo,
  SUM(abs(COALESCE(t.valor, 0::numeric))) OVER (
    PARTITION BY
      t.organization_id,
      t.tipo_operacao
    ORDER BY
      t.data_vencimento
  ) AS acumulado_diario,
  t.grupo_recorrencia_id,
  t.recorrencia_id,
  t.tipo_recorrencia
FROM
  public.transacoes t
  LEFT JOIN public.plano_contas pc ON t.plano_contas_id = pc.id
  LEFT JOIN public.contas_bancarias c ON t.conta_bancaria_id = c.id
  LEFT JOIN public.membros m ON t.membro_id = m.id
WHERE
  t.status = 'PENDENTE'::text
  AND t.data_vencimento IS NOT NULL
ORDER BY
  t.data_vencimento,
  t.id;
