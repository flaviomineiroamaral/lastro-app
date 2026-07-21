import '../database.dart';

class VwDreAnaliticoTable extends SupabaseTable<VwDreAnaliticoRow> {
  @override
  String get tableName => 'vw_dre_analitico';

  @override
  VwDreAnaliticoRow createRow(Map<String, dynamic> data) =>
      VwDreAnaliticoRow(data);
}

class VwDreAnaliticoRow extends SupabaseDataRow {
  VwDreAnaliticoRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => VwDreAnaliticoTable();

  String? get organizationId => getField<String>('organization_id');
  set organizationId(String? value) =>
      setField<String>('organization_id', value);

  DateTime? get dataReferencia => getField<DateTime>('data_referencia');
  set dataReferencia(DateTime? value) =>
      setField<DateTime>('data_referencia', value);

  String? get natureza => getField<String>('natureza');
  set natureza(String? value) => setField<String>('natureza', value);

  String? get categoriaId => getField<String>('categoria_id');
  set categoriaId(String? value) => setField<String>('categoria_id', value);

  String? get categoria => getField<String>('categoria');
  set categoria(String? value) => setField<String>('categoria', value);

  String? get codigoContabil => getField<String>('codigo_contabil');
  set codigoContabil(String? value) =>
      setField<String>('codigo_contabil', value);

  double? get valorTotal => getField<double>('valor_total');
  set valorTotal(double? value) => setField<double>('valor_total', value);

  int? get qtdLancamentos => getField<int>('qtd_lancamentos');
  set qtdLancamentos(int? value) => setField<int>('qtd_lancamentos', value);
}
