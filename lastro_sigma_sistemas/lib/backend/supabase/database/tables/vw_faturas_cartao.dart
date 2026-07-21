import '../database.dart';

class VwFaturasCartaoTable extends SupabaseTable<VwFaturasCartaoRow> {
  @override
  String get tableName => 'vw_faturas_cartao';

  @override
  VwFaturasCartaoRow createRow(Map<String, dynamic> data) =>
      VwFaturasCartaoRow(data);
}

class VwFaturasCartaoRow extends SupabaseDataRow {
  VwFaturasCartaoRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => VwFaturasCartaoTable();

  String? get organizationId => getField<String>('organization_id');
  set organizationId(String? value) =>
      setField<String>('organization_id', value);

  String? get contaId => getField<String>('conta_id');
  set contaId(String? value) => setField<String>('conta_id', value);

  String? get nomeCartao => getField<String>('nome_cartao');
  set nomeCartao(String? value) => setField<String>('nome_cartao', value);

  DateTime? get mesReferencia => getField<DateTime>('mes_referencia');
  set mesReferencia(DateTime? value) =>
      setField<DateTime>('mes_referencia', value);

  double? get valorTotalFatura => getField<double>('valor_total_fatura');
  set valorTotalFatura(double? value) =>
      setField<double>('valor_total_fatura', value);

  String? get statusFatura => getField<String>('status_fatura');
  set statusFatura(String? value) => setField<String>('status_fatura', value);
}
