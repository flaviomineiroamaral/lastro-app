import '../database.dart';

class ViewMembrosEquipeTable extends SupabaseTable<ViewMembrosEquipeRow> {
  @override
  String get tableName => 'view_membros_equipe';

  @override
  ViewMembrosEquipeRow createRow(Map<String, dynamic> data) =>
      ViewMembrosEquipeRow(data);
}

class ViewMembrosEquipeRow extends SupabaseDataRow {
  ViewMembrosEquipeRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => ViewMembrosEquipeTable();

  String? get vinculoId => getField<String>('vinculo_id');
  set vinculoId(String? value) => setField<String>('vinculo_id', value);

  String? get organizationId => getField<String>('organization_id');
  set organizationId(String? value) =>
      setField<String>('organization_id', value);

  String? get nomeOrganizacao => getField<String>('nome_organizacao');
  set nomeOrganizacao(String? value) =>
      setField<String>('nome_organizacao', value);

  String? get profileId => getField<String>('profile_id');
  set profileId(String? value) => setField<String>('profile_id', value);

  String? get nomeUtilizador => getField<String>('nome_utilizador');
  set nomeUtilizador(String? value) =>
      setField<String>('nome_utilizador', value);

  String? get email => getField<String>('email');
  set email(String? value) => setField<String>('email', value);

  String? get funcao => getField<String>('funcao');
  set funcao(String? value) => setField<String>('funcao', value);

  String? get tipoOrganizacao => getField<String>('tipo_organizacao');
  set tipoOrganizacao(String? value) =>
      setField<String>('tipo_organizacao', value);

  String? get planoOrganizacao => getField<String>('plano_organizacao');
  set planoOrganizacao(String? value) =>
      setField<String>('plano_organizacao', value);
}
