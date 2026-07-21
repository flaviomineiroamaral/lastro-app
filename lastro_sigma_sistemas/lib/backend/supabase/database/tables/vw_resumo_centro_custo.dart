import '../database.dart';

class VwResumoCentroCustoTable extends SupabaseTable<VwResumoCentroCustoRow> {
  @override
  String get tableName => 'vw_resumo_centro_custo';

  @override
  VwResumoCentroCustoRow createRow(Map<String, dynamic> data) =>
      VwResumoCentroCustoRow(data);
}

class VwResumoCentroCustoRow extends SupabaseDataRow {
  VwResumoCentroCustoRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => VwResumoCentroCustoTable();

  String? get organizationId => getField<String>('organization_id');
  set organizationId(String? value) =>
      setField<String>('organization_id', value);

  String? get centroCustoNome => getField<String>('centro_custo_nome');
  set centroCustoNome(String? value) =>
      setField<String>('centro_custo_nome', value);

  String? get corHex => getField<String>('cor_hex');
  set corHex(String? value) => setField<String>('cor_hex', value);

  int? get ano => getField<int>('ano');
  set ano(int? value) => setField<int>('ano', value);

  int? get mes => getField<int>('mes');
  set mes(int? value) => setField<int>('mes', value);

  double? get totalReceitas => getField<double>('total_receitas');
  set totalReceitas(double? value) => setField<double>('total_receitas', value);

  double? get totalDespesas => getField<double>('total_despesas');
  set totalDespesas(double? value) => setField<double>('total_despesas', value);

  double? get saldoCentroCusto => getField<double>('saldo_centro_custo');
  set saldoCentroCusto(double? value) =>
      setField<double>('saldo_centro_custo', value);
}
