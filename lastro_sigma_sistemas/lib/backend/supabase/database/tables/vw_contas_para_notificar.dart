import '../database.dart';

class VwContasParaNotificarTable
    extends SupabaseTable<VwContasParaNotificarRow> {
  @override
  String get tableName => 'vw_contas_para_notificar';

  @override
  VwContasParaNotificarRow createRow(Map<String, dynamic> data) =>
      VwContasParaNotificarRow(data);
}

class VwContasParaNotificarRow extends SupabaseDataRow {
  VwContasParaNotificarRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => VwContasParaNotificarTable();

  String? get transacaoId => getField<String>('transacao_id');
  set transacaoId(String? value) => setField<String>('transacao_id', value);

  String? get organizationId => getField<String>('organization_id');
  set organizationId(String? value) =>
      setField<String>('organization_id', value);

  String? get nomeOrganizacao => getField<String>('nome_organizacao');
  set nomeOrganizacao(String? value) =>
      setField<String>('nome_organizacao', value);

  String? get descricao => getField<String>('descricao');
  set descricao(String? value) => setField<String>('descricao', value);

  double? get valor => getField<double>('valor');
  set valor(double? value) => setField<double>('valor', value);

  DateTime? get dataVencimento => getField<DateTime>('data_vencimento');
  set dataVencimento(DateTime? value) =>
      setField<DateTime>('data_vencimento', value);

  List<String> get adminsToNotify => getListField<String>('admins_to_notify');
  set adminsToNotify(List<String>? value) =>
      setListField<String>('admins_to_notify', value);
}
