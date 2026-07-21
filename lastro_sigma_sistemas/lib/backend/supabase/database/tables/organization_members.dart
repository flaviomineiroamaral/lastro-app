import '../database.dart';

class OrganizationMembersTable extends SupabaseTable<OrganizationMembersRow> {
  @override
  String get tableName => 'organization_members';

  @override
  OrganizationMembersRow createRow(Map<String, dynamic> data) =>
      OrganizationMembersRow(data);
}

class OrganizationMembersRow extends SupabaseDataRow {
  OrganizationMembersRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => OrganizationMembersTable();

  String? get id => getField<String>('id');
  set id(String? value) => setField<String>('id', value);

  String get organizationId => getField<String>('organization_id')!;
  set organizationId(String value) =>
      setField<String>('organization_id', value);

  String get profileId => getField<String>('profile_id')!;
  set profileId(String value) => setField<String>('profile_id', value);

  String? get funcao => getField<String>('funcao');
  set funcao(String? value) => setField<String>('funcao', value);

  DateTime? get entradaEm => getField<DateTime>('entrada_em');
  set entradaEm(DateTime? value) => setField<DateTime>('entrada_em', value);
}
