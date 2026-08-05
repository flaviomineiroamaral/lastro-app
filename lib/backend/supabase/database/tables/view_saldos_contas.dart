import '../database.dart';

class ViewSaldosContasTable extends SupabaseTable<ViewSaldosContasRow> {
  @override
  String get tableName => 'view_saldos_contas';

  @override
  ViewSaldosContasRow createRow(Map<String, dynamic> data) =>
      ViewSaldosContasRow(data);
}

class ViewSaldosContasRow extends SupabaseDataRow {
  ViewSaldosContasRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => ViewSaldosContasTable();

  String? get organizationId => getField<String>('organization_id');
  set organizationId(String? value) =>
      setField<String>('organization_id', value);

  String? get contaId => getField<String>('conta_id');
  set contaId(String? value) => setField<String>('conta_id', value);

  String? get nomeConta => getField<String>('nome_conta');
  set nomeConta(String? value) => setField<String>('nome_conta', value);

  String? get tipoConta => getField<String>('tipo_conta');
  set tipoConta(String? value) => setField<String>('tipo_conta', value);

  double? get saldoInicial => getField<double>('saldo_inicial');
  set saldoInicial(double? value) => setField<double>('saldo_inicial', value);

  double? get totalEntradas => getField<double>('total_entradas');
  set totalEntradas(double? value) => setField<double>('total_entradas', value);

  double? get totalSaidas => getField<double>('total_saidas');
  set totalSaidas(double? value) => setField<double>('total_saidas', value);

  double? get saldoAtual => getField<double>('saldo_atual');
  set saldoAtual(double? value) => setField<double>('saldo_atual', value);

  int? get diaFechamento => getField<int>('dia_fechamento');
  set diaFechamento(int? value) => setField<int>('dia_fechamento', value);

  int? get diaVencimento => getField<int>('dia_vencimento');
  set diaVencimento(int? value) => setField<int>('dia_vencimento', value);
}
