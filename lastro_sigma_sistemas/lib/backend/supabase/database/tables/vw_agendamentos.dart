import '../database.dart';

class VwAgendamentosTable extends SupabaseTable<VwAgendamentosRow> {
  @override
  String get tableName => 'vw_agendamentos';

  @override
  VwAgendamentosRow createRow(Map<String, dynamic> data) =>
      VwAgendamentosRow(data);
}

class VwAgendamentosRow extends SupabaseDataRow {
  VwAgendamentosRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => VwAgendamentosTable();

  String? get transacaoId => getField<String>('transacao_id');
  set transacaoId(String? value) => setField<String>('transacao_id', value);

  String? get organizationId => getField<String>('organization_id');
  set organizationId(String? value) =>
      setField<String>('organization_id', value);

  String? get contaId => getField<String>('conta_id');
  set contaId(String? value) => setField<String>('conta_id', value);

  String? get nomeConta => getField<String>('nome_conta');
  set nomeConta(String? value) => setField<String>('nome_conta', value);

  String? get tipoConta => getField<String>('tipo_conta');
  set tipoConta(String? value) => setField<String>('tipo_conta', value);

  DateTime? get dataPagamento => getField<DateTime>('data_pagamento');
  set dataPagamento(DateTime? value) =>
      setField<DateTime>('data_pagamento', value);

  DateTime? get criadoEm => getField<DateTime>('criado_em');
  set criadoEm(DateTime? value) => setField<DateTime>('criado_em', value);

  String? get descricao => getField<String>('descricao');
  set descricao(String? value) => setField<String>('descricao', value);

  double? get valor => getField<double>('valor');
  set valor(double? value) => setField<double>('valor', value);

  String? get tipoOperacao => getField<String>('tipo_operacao');
  set tipoOperacao(String? value) => setField<String>('tipo_operacao', value);

  String? get status => getField<String>('status');
  set status(String? value) => setField<String>('status', value);

  String? get categoriaId => getField<String>('categoria_id');
  set categoriaId(String? value) => setField<String>('categoria_id', value);

  String? get categoriaNome => getField<String>('categoria_nome');
  set categoriaNome(String? value) => setField<String>('categoria_nome', value);

  String? get centroCustoId => getField<String>('centro_custo_id');
  set centroCustoId(String? value) =>
      setField<String>('centro_custo_id', value);

  String? get membroId => getField<String>('membro_id');
  set membroId(String? value) => setField<String>('membro_id', value);

  String? get observacoes => getField<String>('observacoes');
  set observacoes(String? value) => setField<String>('observacoes', value);

  String? get comprovativoUrl => getField<String>('comprovativo_url');
  set comprovativoUrl(String? value) =>
      setField<String>('comprovativo_url', value);

  String? get idUnicoBanco => getField<String>('id_unico_banco');
  set idUnicoBanco(String? value) => setField<String>('id_unico_banco', value);

  int? get parcelaAtual => getField<int>('parcela_atual');
  set parcelaAtual(int? value) => setField<int>('parcela_atual', value);

  int? get totalParcelas => getField<int>('total_parcelas');
  set totalParcelas(int? value) => setField<int>('total_parcelas', value);

  DateTime? get dataVencimento => getField<DateTime>('data_vencimento');
  set dataVencimento(DateTime? value) =>
      setField<DateTime>('data_vencimento', value);

  DateTime? get dataCompetencia => getField<DateTime>('data_competencia');
  set dataCompetencia(DateTime? value) =>
      setField<DateTime>('data_competencia', value);

  String? get contaDestinoId => getField<String>('conta_destino_id');
  set contaDestinoId(String? value) =>
      setField<String>('conta_destino_id', value);

  String? get modulo => getField<String>('modulo');
  set modulo(String? value) => setField<String>('modulo', value);

  String? get tipoAgendamento => getField<String>('tipo_agendamento');
  set tipoAgendamento(String? value) =>
      setField<String>('tipo_agendamento', value);

  String? get statusPrazo => getField<String>('status_prazo');
  set statusPrazo(String? value) => setField<String>('status_prazo', value);

  int? get diasDiferenca => getField<int>('dias_diferenca');
  set diasDiferenca(int? value) => setField<int>('dias_diferenca', value);

  double? get saldoProgressivo => getField<double>('saldo_progressivo');
  set saldoProgressivo(double? value) =>
      setField<double>('saldo_progressivo', value);

  double? get acumuladoDiario => getField<double>('acumulado_diario');
  set acumuladoDiario(double? value) =>
      setField<double>('acumulado_diario', value);
}
