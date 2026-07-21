import '../database.dart';

class HistoricoSaldosTable extends SupabaseTable<HistoricoSaldosRow> {
  @override
  String get tableName => 'historico_saldos';

  @override
  HistoricoSaldosRow createRow(Map<String, dynamic> data) =>
      HistoricoSaldosRow(data);
}

class HistoricoSaldosRow extends SupabaseDataRow {
  HistoricoSaldosRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => HistoricoSaldosTable();

  String? get id => getField<String>('id');
  set id(String? value) => setField<String>('id', value);

  String get organizationId => getField<String>('organization_id')!;
  set organizationId(String value) =>
      setField<String>('organization_id', value);

  String get contaBancariaId => getField<String>('conta_bancaria_id')!;
  set contaBancariaId(String value) =>
      setField<String>('conta_bancaria_id', value);

  int get mes => getField<int>('mes')!;
  set mes(int value) => setField<int>('mes', value);

  int get ano => getField<int>('ano')!;
  set ano(int value) => setField<int>('ano', value);

  double get saldoFechamento => getField<double>('saldo_fechamento')!;
  set saldoFechamento(double value) =>
      setField<double>('saldo_fechamento', value);

  DateTime? get fechadoEm => getField<DateTime>('fechado_em');
  set fechadoEm(DateTime? value) => setField<DateTime>('fechado_em', value);

  String? get fechadoPor => getField<String>('fechado_por');
  set fechadoPor(String? value) => setField<String>('fechado_por', value);
}
