import '../database.dart';

class VwReceitasPorCategoriaTable
    extends SupabaseTable<VwReceitasPorCategoriaRow> {
  @override
  String get tableName => 'vw_receitas_por_categoria';

  @override
  VwReceitasPorCategoriaRow createRow(Map<String, dynamic> data) =>
      VwReceitasPorCategoriaRow(data);
}

class VwReceitasPorCategoriaRow extends SupabaseDataRow {
  VwReceitasPorCategoriaRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => VwReceitasPorCategoriaTable();

  String? get organizationId => getField<String>('organization_id');
  set organizationId(String? value) =>
      setField<String>('organization_id', value);

  DateTime? get mesReferencia => getField<DateTime>('mes_referencia');
  set mesReferencia(DateTime? value) =>
      setField<DateTime>('mes_referencia', value);

  String? get categoriaNome => getField<String>('categoria_nome');
  set categoriaNome(String? value) => setField<String>('categoria_nome', value);

  double? get totalRecebido => getField<double>('total_recebido');
  set totalRecebido(double? value) => setField<double>('total_recebido', value);
}
