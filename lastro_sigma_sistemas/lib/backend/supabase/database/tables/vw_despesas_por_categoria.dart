import '../database.dart';

class VwDespesasPorCategoriaTable
    extends SupabaseTable<VwDespesasPorCategoriaRow> {
  @override
  String get tableName => 'vw_despesas_por_categoria';

  @override
  VwDespesasPorCategoriaRow createRow(Map<String, dynamic> data) =>
      VwDespesasPorCategoriaRow(data);
}

class VwDespesasPorCategoriaRow extends SupabaseDataRow {
  VwDespesasPorCategoriaRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => VwDespesasPorCategoriaTable();

  String? get organizationId => getField<String>('organization_id');
  set organizationId(String? value) =>
      setField<String>('organization_id', value);

  DateTime? get mesReferencia => getField<DateTime>('mes_referencia');
  set mesReferencia(DateTime? value) =>
      setField<DateTime>('mes_referencia', value);

  String? get categoriaNome => getField<String>('categoria_nome');
  set categoriaNome(String? value) => setField<String>('categoria_nome', value);

  double? get totalGasto => getField<double>('total_gasto');
  set totalGasto(double? value) => setField<double>('total_gasto', value);
}
