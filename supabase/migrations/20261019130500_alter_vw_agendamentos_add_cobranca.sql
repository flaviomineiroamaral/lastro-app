-- ==============================================================================
-- Atualização da view public.vw_agendamentos
-- Mantém todas as colunas existentes e acrescenta os campos de apoio à cobrança:
--   - tem_telefone (boolean)
--   - pode_cobrar (boolean)
--   - status_cobranca (text: 'VENCIDO', 'HOJE', 'A VENCER', 'SEM TELEFONE')
--   - texto_cobranca (text: modelo de mensagem dinâmico pronto para WhatsApp/SMS)
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
  t.tipo_recorrencia,
  -- Novos campos de apoio à cobrança (Acréscimos sem alterar colunas existentes)
  (m.telefone IS NOT NULL AND TRIM(m.telefone) <> '') AS tem_telefone,
  (t.status = 'PENDENTE'::text AND m.telefone IS NOT NULL AND TRIM(m.telefone) <> '') AS pode_cobrar,
  CASE
    WHEN m.telefone IS NULL OR TRIM(m.telefone) = '' THEN 'SEM TELEFONE'::text
    WHEN t.status <> 'PENDENTE'::text THEN 'PAGO'::text
    WHEN t.data_vencimento < CURRENT_DATE THEN 'VENCIDO'::text
    WHEN t.data_vencimento = CURRENT_DATE THEN 'HOJE'::text
    ELSE 'A VENCER'::text
  END AS status_cobranca,
  CASE
    WHEN m.telefone IS NULL OR TRIM(m.telefone) = '' OR t.status <> 'PENDENTE'::text THEN NULL
    WHEN t.data_vencimento < CURRENT_DATE THEN
      'Olá, ' || COALESCE(m.nome_completo, 'Cliente') || '! Consta em aberto a conta "' || COALESCE(t.descricao, 'Sem descrição') || '" no valor de R$ ' || REPLACE(TO_CHAR(COALESCE(t.valor, 0), 'FM999999990.00'), '.', ',') || ', que venceu em ' || TO_CHAR(t.data_vencimento, 'DD/MM/YYYY') || ' (' || (CURRENT_DATE - t.data_vencimento)::text || ' dias de atraso). Por favor, nos envie o comprovante caso já tenha realizado o pagamento.'
    WHEN t.data_vencimento = CURRENT_DATE THEN
      'Olá, ' || COALESCE(m.nome_completo, 'Cliente') || '! Lembramos que a conta "' || COALESCE(t.descricao, 'Sem descrição') || '" no valor de R$ ' || REPLACE(TO_CHAR(COALESCE(t.valor, 0), 'FM999999990.00'), '.', ',') || ' vence hoje (' || TO_CHAR(t.data_vencimento, 'DD/MM/YYYY') || ').'
    ELSE
      'Olá, ' || COALESCE(m.nome_completo, 'Cliente') || '! Lembramos que a conta "' || COALESCE(t.descricao, 'Sem descrição') || '" no valor de R$ ' || REPLACE(TO_CHAR(COALESCE(t.valor, 0), 'FM999999990.00'), '.', ',') || ' vencerá em ' || TO_CHAR(t.data_vencimento, 'DD/MM/YYYY') || '.'
  END AS texto_cobranca
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
