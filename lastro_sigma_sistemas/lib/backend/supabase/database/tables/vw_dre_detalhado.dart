import '../database.dart';

class VwDreDetalhadoTable extends SupabaseTable<VwDreDetalhadoRow> {
  @override
  String get tableName => 'vw_dre_detalhado';

  @override
  VwDreDetalhadoRow createRow(Map<String, dynamic> data) =>
      VwDreDetalhadoRow(data);
}

class VwDreDetalhadoRow extends SupabaseDataRow {
  VwDreDetalhadoRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => VwDreDetalhadoTable();

  String? get transacaoId => getField<String>('transacao_id');
  set transacaoId(String? value) => setField<String>('transacao_id', value);

  String? get organizationId => getField<String>('organization_id');
  set organizationId(String? value) =>
      setField<String>('organization_id', value);

  DateTime? get dataPagamento => getField<DateTime>('data_pagamento');
  set dataPagamento(DateTime? value) =>
      setField<DateTime>('data_pagamento', value);

  DateTime? get criadoEm => getField<DateTime>('criado_em');
  set criadoEm(DateTime? value) => setField<DateTime>('criado_em', value);

  String? get descricao => getField<String>('descricao');
  set descricao(String? value) => setField<String>('descricao', value);

  String? get tipoOperacao => getField<String>('tipo_operacao');
  set tipoOperacao(String? value) => setField<String>('tipo_operacao', value);

  String? get status => getField<String>('status');
  set status(String? value) => setField<String>('status', value);

  String? get categoriaId => getField<String>('categoria_id');
  set categoriaId(String? value) => setField<String>('categoria_id', value);

  String? get categoriaNome => getField<String>('categoria_nome');
  set categoriaNome(String? value) => setField<String>('categoria_nome', value);

  String? get codigoContabil => getField<String>('codigo_contabil');
  set codigoContabil(String? value) =>
      setField<String>('codigo_contabil', value);

  String? get centroCustoId => getField<String>('centro_custo_id');
  set centroCustoId(String? value) =>
      setField<String>('centro_custo_id', value);

  String? get centroCustoNome => getField<String>('centro_custo_nome');
  set centroCustoNome(String? value) =>
      setField<String>('centro_custo_nome', value);

  String? get membroId => getField<String>('membro_id');
  set membroId(String? value) => setField<String>('membro_id', value);

  String? get comprovativoUrl => getField<String>('comprovativo_url');
  set comprovativoUrl(String? value) =>
      setField<String>('comprovativo_url', value);

  String? get observacoes => getField<String>('observacoes');
  set observacoes(String? value) => setField<String>('observacoes', value);

  String? get idUnicoBanco => getField<String>('id_unico_banco');
  set idUnicoBanco(String? value) => setField<String>('id_unico_banco', value);

  DateTime? get dataVencimento => getField<DateTime>('data_vencimento');
  set dataVencimento(DateTime? value) =>
      setField<DateTime>('data_vencimento', value);

  DateTime? get dataCompetencia => getField<DateTime>('data_competencia');
  set dataCompetencia(DateTime? value) =>
      setField<DateTime>('data_competencia', value);

  int? get parcelaAtual => getField<int>('parcela_atual');
  set parcelaAtual(int? value) => setField<int>('parcela_atual', value);

  int? get totalParcelas => getField<int>('total_parcelas');
  set totalParcelas(int? value) => setField<int>('total_parcelas', value);

  String? get contaId => getField<String>('conta_id');
  set contaId(String? value) => setField<String>('conta_id', value);

  String? get nomeConta => getField<String>('nome_conta');
  set nomeConta(String? value) => setField<String>('nome_conta', value);

  String? get tipo => getField<String>('tipo');
  set tipo(String? value) => setField<String>('tipo', value);

  double? get valor => getField<double>('valor');
  set valor(double? value) => setField<double>('valor', value);

  double? get valorMovimento => getField<double>('valor_movimento');
  set valorMovimento(double? value) =>
      setField<double>('valor_movimento', value);

  DateTime? get dataReferenciaDre => getField<DateTime>('data_referencia_dre');
  set dataReferenciaDre(DateTime? value) =>
      setField<DateTime>('data_referencia_dre', value);

  DateTime? get dataLinhaTempo => getField<DateTime>('data_linha_tempo');
  set dataLinhaTempo(DateTime? value) =>
      setField<DateTime>('data_linha_tempo', value);
}
