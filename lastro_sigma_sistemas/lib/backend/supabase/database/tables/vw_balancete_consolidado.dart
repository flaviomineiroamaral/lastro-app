import '../database.dart';

class VwBalanceteConsolidadoTable
    extends SupabaseTable<VwBalanceteConsolidadoRow> {
  @override
  String get tableName => 'vw_balancete_consolidado';

  @override
  VwBalanceteConsolidadoRow createRow(Map<String, dynamic> data) =>
      VwBalanceteConsolidadoRow(data);
}

class VwBalanceteConsolidadoRow extends SupabaseDataRow {
  VwBalanceteConsolidadoRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => VwBalanceteConsolidadoTable();

  String? get id => getField<String>('id');
  set id(String? value) => setField<String>('id', value);

  String? get organizationId => getField<String>('organization_id');
  set organizationId(String? value) =>
      setField<String>('organization_id', value);

  String? get codigoContabil => getField<String>('codigo_contabil');
  set codigoContabil(String? value) =>
      setField<String>('codigo_contabil', value);

  String? get nome => getField<String>('nome');
  set nome(String? value) => setField<String>('nome', value);

  String? get categoriaConta => getField<String>('categoria_conta');
  set categoriaConta(String? value) =>
      setField<String>('categoria_conta', value);

  bool? get permiteLancamento => getField<bool>('permite_lancamento');
  set permiteLancamento(bool? value) =>
      setField<bool>('permite_lancamento', value);

  double? get saldoConsolidado => getField<double>('saldo_consolidado');
  set saldoConsolidado(double? value) =>
      setField<double>('saldo_consolidado', value);
}
