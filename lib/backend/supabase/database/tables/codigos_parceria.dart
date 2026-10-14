import '../database.dart';

class CodigosParceriaTable extends SupabaseTable<CodigosParceriaRow> {
  @override
  String get tableName => 'codigos_parceria';

  @override
  CodigosParceriaRow createRow(Map<String, dynamic> data) =>
      CodigosParceriaRow(data);
}

class CodigosParceriaRow extends SupabaseDataRow {
  CodigosParceriaRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => CodigosParceriaTable();

  String get codigo => getField<String>('codigo')!;
  set codigo(String value) => setField<String>('codigo', value);

  double get percentualDesconto => getField<double>('percentual_desconto')!;
  set percentualDesconto(double value) =>
      setField<double>('percentual_desconto', value);

  bool? get ativo => getField<bool>('ativo');
  set ativo(bool? value) => setField<bool>('ativo', value);

  String? get descricao => getField<String>('descricao');
  set descricao(String? value) => setField<String>('descricao', value);

  String? get tipoDesconto => getField<String>('tipo_desconto');
  set tipoDesconto(String? value) => setField<String>('tipo_desconto', value);

  double? get valorDescontoFixo => getField<double>('valor_desconto_fixo');
  set valorDescontoFixo(double? value) =>
      setField<double>('valor_desconto_fixo', value);

  String? get aplicaEm => getField<String>('aplica_em');
  set aplicaEm(String? value) => setField<String>('aplica_em', value);

  DateTime? get dataValidade => getField<DateTime>('data_validade');
  set dataValidade(DateTime? value) =>
      setField<DateTime>('data_validade', value);

  int? get limiteUsos => getField<int>('limite_usos');
  set limiteUsos(int? value) => setField<int>('limite_usos', value);
}
