import '../database.dart';

class VwSaldoTotalOrgTable extends SupabaseTable<VwSaldoTotalOrgRow> {
  @override
  String get tableName => 'vw_saldo_total_org';

  @override
  VwSaldoTotalOrgRow createRow(Map<String, dynamic> data) =>
      VwSaldoTotalOrgRow(data);
}

class VwSaldoTotalOrgRow extends SupabaseDataRow {
  VwSaldoTotalOrgRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => VwSaldoTotalOrgTable();

  String? get organizationId => getField<String>('organization_id');
  set organizationId(String? value) =>
      setField<String>('organization_id', value);

  double? get totalSaldoInicial => getField<double>('total_saldo_inicial');
  set totalSaldoInicial(double? value) =>
      setField<double>('total_saldo_inicial', value);

  double? get totalEntradasGeral => getField<double>('total_entradas_geral');
  set totalEntradasGeral(double? value) =>
      setField<double>('total_entradas_geral', value);

  double? get totalSaidasGeral => getField<double>('total_saidas_geral');
  set totalSaidasGeral(double? value) =>
      setField<double>('total_saidas_geral', value);

  double? get saldoLiquidoGeral => getField<double>('saldo_liquido_geral');
  set saldoLiquidoGeral(double? value) =>
      setField<double>('saldo_liquido_geral', value);

  double? get saldoDisponivelReal => getField<double>('saldo_disponivel_real');
  set saldoDisponivelReal(double? value) =>
      setField<double>('saldo_disponivel_real', value);

  double? get totalFaturasCartao => getField<double>('total_faturas_cartao');
  set totalFaturasCartao(double? value) =>
      setField<double>('total_faturas_cartao', value);
}
