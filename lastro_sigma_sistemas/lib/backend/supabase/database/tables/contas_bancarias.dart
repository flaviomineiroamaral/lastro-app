import '../database.dart';

class ContasBancariasTable extends SupabaseTable<ContasBancariasRow> {
  @override
  String get tableName => 'contas_bancarias';

  @override
  ContasBancariasRow createRow(Map<String, dynamic> data) =>
      ContasBancariasRow(data);
}

class ContasBancariasRow extends SupabaseDataRow {
  ContasBancariasRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => ContasBancariasTable();

  String? get id => getField<String>('id');
  set id(String? value) => setField<String>('id', value);

  String get organizationId => getField<String>('organization_id')!;
  set organizationId(String value) =>
      setField<String>('organization_id', value);

  String get nome => getField<String>('nome')!;
  set nome(String value) => setField<String>('nome', value);

  String get tipo => getField<String>('tipo')!;
  set tipo(String value) => setField<String>('tipo', value);

  String? get bancoCodigo => getField<String>('banco_codigo');
  set bancoCodigo(String? value) => setField<String>('banco_codigo', value);

  String? get agenciaConta => getField<String>('agencia_conta');
  set agenciaConta(String? value) => setField<String>('agencia_conta', value);

  double? get saldoInicial => getField<double>('saldo_inicial');
  set saldoInicial(double? value) => setField<double>('saldo_inicial', value);

  bool? get ativo => getField<bool>('ativo');
  set ativo(bool? value) => setField<bool>('ativo', value);

  DateTime? get criadoEm => getField<DateTime>('criado_em');
  set criadoEm(DateTime? value) => setField<DateTime>('criado_em', value);

  double? get limiteCredito => getField<double>('limite_credito');
  set limiteCredito(double? value) => setField<double>('limite_credito', value);

  int? get diaVencimento => getField<int>('dia_vencimento');
  set diaVencimento(int? value) => setField<int>('dia_vencimento', value);

  int? get diaFechamento => getField<int>('dia_fechamento');
  set diaFechamento(int? value) => setField<int>('dia_fechamento', value);
}
