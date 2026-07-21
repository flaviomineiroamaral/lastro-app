import '../database.dart';

class OrganizationsTable extends SupabaseTable<OrganizationsRow> {
  @override
  String get tableName => 'organizations';

  @override
  OrganizationsRow createRow(Map<String, dynamic> data) =>
      OrganizationsRow(data);
}

class OrganizationsRow extends SupabaseDataRow {
  OrganizationsRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => OrganizationsTable();

  String? get id => getField<String>('id');
  set id(String? value) => setField<String>('id', value);

  String get nome => getField<String>('nome')!;
  set nome(String value) => setField<String>('nome', value);

  String? get tipo => getField<String>('tipo');
  set tipo(String? value) => setField<String>('tipo', value);

  String? get documentoCnpj => getField<String>('documento_cnpj');
  set documentoCnpj(String? value) => setField<String>('documento_cnpj', value);

  String? get plano => getField<String>('plano');
  set plano(String? value) => setField<String>('plano', value);

  bool? get ativo => getField<bool>('ativo');
  set ativo(bool? value) => setField<bool>('ativo', value);

  DateTime? get criadoEm => getField<DateTime>('criado_em');
  set criadoEm(DateTime? value) => setField<DateTime>('criado_em', value);
}
