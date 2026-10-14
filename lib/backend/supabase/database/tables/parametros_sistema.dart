import '../database.dart';

class ParametrosSistemaTable extends SupabaseTable<ParametrosSistemaRow> {
  @override
  String get tableName => 'parametros_sistema';

  @override
  ParametrosSistemaRow createRow(Map<String, dynamic> data) =>
      ParametrosSistemaRow(data);
}

class ParametrosSistemaRow extends SupabaseDataRow {
  ParametrosSistemaRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => ParametrosSistemaTable();

  int? get id => getField<int>('id');
  set id(int? value) => setField<int>('id', value);

  String get chave => getField<String>('chave')!;
  set chave(String value) => setField<String>('chave', value);

  double? get valor => getField<double>('valor');
  set valor(double? value) => setField<double>('valor', value);

  String? get descricao => getField<String>('descricao');
  set descricao(String? value) => setField<String>('descricao', value);

  String? get valorTexto => getField<String>('valor_texto');
  set valorTexto(String? value) => setField<String>('valor_texto', value);
}
