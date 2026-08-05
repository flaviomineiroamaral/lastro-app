import '../database.dart';

class TransacoesTable extends SupabaseTable<TransacoesRow> {
  @override
  String get tableName => 'transacoes';

  @override
  TransacoesRow createRow(Map<String, dynamic> data) => TransacoesRow(data);
}

class TransacoesRow extends SupabaseDataRow {
  TransacoesRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => TransacoesTable();

  String? get id => getField<String>('id');
  set id(String? value) => setField<String>('id', value);

  String get organizationId => getField<String>('organization_id')!;
  set organizationId(String value) =>
      setField<String>('organization_id', value);

  String get descricao => getField<String>('descricao')!;
  set descricao(String value) => setField<String>('descricao', value);

  double get valor => getField<double>('valor')!;
  set valor(double value) => setField<double>('valor', value);

  DateTime? get dataPagamento => getField<DateTime>('data_pagamento');
  set dataPagamento(DateTime? value) =>
      setField<DateTime>('data_pagamento', value);

  String get tipoOperacao => getField<String>('tipo_operacao')!;
  set tipoOperacao(String value) => setField<String>('tipo_operacao', value);

  String? get status => getField<String>('status');
  set status(String? value) => setField<String>('status', value);

  String? get contaBancariaId => getField<String>('conta_bancaria_id');
  set contaBancariaId(String? value) =>
      setField<String>('conta_bancaria_id', value);

  String? get planoContasId => getField<String>('plano_contas_id');
  set planoContasId(String? value) =>
      setField<String>('plano_contas_id', value);

  String? get centroCustoId => getField<String>('centro_custo_id');
  set centroCustoId(String? value) =>
      setField<String>('centro_custo_id', value);

  String? get membroId => getField<String>('membro_id');
  set membroId(String? value) => setField<String>('membro_id', value);

  String? get comprovativoUrl => getField<String>('comprovativo_url');
  set comprovativoUrl(String? value) =>
      setField<String>('comprovativo_url', value);

  String? get observacoes => getField<String>('observacoes');
  set observacoes(String? value) => setField<String>('observacoes', value);

  String? get criadoPor => getField<String>('criado_por');
  set criadoPor(String? value) => setField<String>('criado_por', value);

  DateTime? get criadoEm => getField<DateTime>('criado_em');
  set criadoEm(DateTime? value) => setField<DateTime>('criado_em', value);

  String? get idUnicoBanco => getField<String>('id_unico_banco');
  set idUnicoBanco(String? value) => setField<String>('id_unico_banco', value);

  DateTime get dataVencimento => getField<DateTime>('data_vencimento')!;
  set dataVencimento(DateTime value) =>
      setField<DateTime>('data_vencimento', value);

  DateTime get dataCompetencia => getField<DateTime>('data_competencia')!;
  set dataCompetencia(DateTime value) =>
      setField<DateTime>('data_competencia', value);

  String? get contaDestinoId => getField<String>('conta_destino_id');
  set contaDestinoId(String? value) =>
      setField<String>('conta_destino_id', value);

  String? get grupoRecorrenciaId => getField<String>('grupo_recorrencia_id');
  set grupoRecorrenciaId(String? value) =>
      setField<String>('grupo_recorrencia_id', value);

  int? get parcelaAtual => getField<int>('parcela_atual');
  set parcelaAtual(int? value) => setField<int>('parcela_atual', value);

  int? get totalParcelas => getField<int>('total_parcelas');
  set totalParcelas(int? value) => setField<int>('total_parcelas', value);

  bool? get notificacaoVencimentoEnviada =>
      getField<bool>('notificacao_vencimento_enviada');
  set notificacaoVencimentoEnviada(bool? value) =>
      setField<bool>('notificacao_vencimento_enviada', value);

  String? get transferenciaInternaId =>
      getField<String>('transferencia_interna_id');
  set transferenciaInternaId(String? value) =>
      setField<String>('transferencia_interna_id', value);
}
