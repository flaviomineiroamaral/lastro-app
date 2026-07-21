import '../database.dart';

class ResumoDashboardTable extends SupabaseTable<ResumoDashboardRow> {
  @override
  String get tableName => 'resumo_dashboard';

  @override
  ResumoDashboardRow createRow(Map<String, dynamic> data) =>
      ResumoDashboardRow(data);
}

class ResumoDashboardRow extends SupabaseDataRow {
  ResumoDashboardRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => ResumoDashboardTable();

  String? get organizationId => getField<String>('organization_id');
  set organizationId(String? value) =>
      setField<String>('organization_id', value);

  double? get totalPagar => getField<double>('total_pagar');
  set totalPagar(double? value) => setField<double>('total_pagar', value);

  double? get totalPagarAtrasado => getField<double>('total_pagar_atrasado');
  set totalPagarAtrasado(double? value) =>
      setField<double>('total_pagar_atrasado', value);

  double? get totalPagarHoje => getField<double>('total_pagar_hoje');
  set totalPagarHoje(double? value) =>
      setField<double>('total_pagar_hoje', value);

  double? get totalPagarVencer => getField<double>('total_pagar_vencer');
  set totalPagarVencer(double? value) =>
      setField<double>('total_pagar_vencer', value);

  double? get totalReceber => getField<double>('total_receber');
  set totalReceber(double? value) => setField<double>('total_receber', value);

  double? get totalReceberAtrasado =>
      getField<double>('total_receber_atrasado');
  set totalReceberAtrasado(double? value) =>
      setField<double>('total_receber_atrasado', value);

  double? get totalReceberHoje => getField<double>('total_receber_hoje');
  set totalReceberHoje(double? value) =>
      setField<double>('total_receber_hoje', value);

  double? get totalReceberVencer => getField<double>('total_receber_vencer');
  set totalReceberVencer(double? value) =>
      setField<double>('total_receber_vencer', value);
}
