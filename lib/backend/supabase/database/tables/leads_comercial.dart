import '../database.dart';

class LeadsComercialTable extends SupabaseTable<LeadsComercialRow> {
  @override
  String get tableName => 'leads_comercial';

  @override
  LeadsComercialRow createRow(Map<String, dynamic> data) =>
      LeadsComercialRow(data);
}

class LeadsComercialRow extends SupabaseDataRow {
  LeadsComercialRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => LeadsComercialTable();

  String? get id => getField<String>('id');
  set id(String? value) => setField<String>('id', value);

  String? get documentoIdentificacao =>
      getField<String>('documento_identificacao');
  set documentoIdentificacao(String? value) =>
      setField<String>('documento_identificacao', value);

  String get nome => getField<String>('nome')!;
  set nome(String value) => setField<String>('nome', value);

  String get instituicao => getField<String>('instituicao')!;
  set instituicao(String value) => setField<String>('instituicao', value);

  String get whatsapp => getField<String>('whatsapp')!;
  set whatsapp(String value) => setField<String>('whatsapp', value);

  String? get status => getField<String>('status');
  set status(String? value) => setField<String>('status', value);

  DateTime? get createdAt => getField<DateTime>('created_at');
  set createdAt(DateTime? value) => setField<DateTime>('created_at', value);

  String? get email => getField<String>('email');
  set email(String? value) => setField<String>('email', value);

  String? get tipoPerfil => getField<String>('tipo_perfil');
  set tipoPerfil(String? value) => setField<String>('tipo_perfil', value);

  DateTime? get ultimaInteracao => getField<DateTime>('ultima_interacao');
  set ultimaInteracao(DateTime? value) =>
      setField<DateTime>('ultima_interacao', value);

  int? get quantidadeConversoes => getField<int>('quantidade_conversoes');
  set quantidadeConversoes(int? value) =>
      setField<int>('quantidade_conversoes', value);
}
