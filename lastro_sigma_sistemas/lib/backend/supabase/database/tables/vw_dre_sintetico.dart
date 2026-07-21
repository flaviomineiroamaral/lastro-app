import '../database.dart';

class VwDreSinteticoTable extends SupabaseTable<VwDreSinteticoRow> {
  @override
  String get tableName => 'vw_dre_sintetico';

  @override
  VwDreSinteticoRow createRow(Map<String, dynamic> data) =>
      VwDreSinteticoRow(data);
}

class VwDreSinteticoRow extends SupabaseDataRow {
  VwDreSinteticoRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => VwDreSinteticoTable();

  String? get organizationId => getField<String>('organization_id');
  set organizationId(String? value) =>
      setField<String>('organization_id', value);

  DateTime? get dataReferencia => getField<DateTime>('data_referencia');
  set dataReferencia(DateTime? value) =>
      setField<DateTime>('data_referencia', value);

  double? get totalReceitas => getField<double>('total_receitas');
  set totalReceitas(double? value) => setField<double>('total_receitas', value);

  double? get totalDespesas => getField<double>('total_despesas');
  set totalDespesas(double? value) => setField<double>('total_despesas', value);

  double? get resultadoLiquido => getField<double>('resultado_liquido');
  set resultadoLiquido(double? value) =>
      setField<double>('resultado_liquido', value);

  double? get margemLucroPercentual =>
      getField<double>('margem_lucro_percentual');
  set margemLucroPercentual(double? value) =>
      setField<double>('margem_lucro_percentual', value);
}
