import '../database.dart';

class VwConsolidadoLastroTable extends SupabaseTable<VwConsolidadoLastroRow> {
  @override
  String get tableName => 'vw_consolidado_lastro';

  @override
  VwConsolidadoLastroRow createRow(Map<String, dynamic> data) =>
      VwConsolidadoLastroRow(data);
}

class VwConsolidadoLastroRow extends SupabaseDataRow {
  VwConsolidadoLastroRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => VwConsolidadoLastroTable();

  String? get id => getField<String>('id');
  set id(String? value) => setField<String>('id', value);

  double? get valor => getField<double>('valor');
  set valor(double? value) => setField<double>('valor', value);

  DateTime? get dataCompetencia => getField<DateTime>('data_competencia');
  set dataCompetencia(DateTime? value) =>
      setField<DateTime>('data_competencia', value);

  DateTime? get dataVencimento => getField<DateTime>('data_vencimento');
  set dataVencimento(DateTime? value) =>
      setField<DateTime>('data_vencimento', value);

  DateTime? get dataPagamento => getField<DateTime>('data_pagamento');
  set dataPagamento(DateTime? value) =>
      setField<DateTime>('data_pagamento', value);

  DateTime? get dataFluxo => getField<DateTime>('data_fluxo');
  set dataFluxo(DateTime? value) => setField<DateTime>('data_fluxo', value);

  String? get statusFinanceiro => getField<String>('status_financeiro');
  set statusFinanceiro(String? value) =>
      setField<String>('status_financeiro', value);
}
