import '../database.dart';

class VwLembretesWhatsappTable extends SupabaseTable<VwLembretesWhatsappRow> {
  @override
  String get tableName => 'vw_lembretes_whatsapp';

  @override
  VwLembretesWhatsappRow createRow(Map<String, dynamic> data) =>
      VwLembretesWhatsappRow(data);
}

class VwLembretesWhatsappRow extends SupabaseDataRow {
  VwLembretesWhatsappRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => VwLembretesWhatsappTable();

  String? get transacaoId => getField<String>('transacao_id');
  set transacaoId(String? value) => setField<String>('transacao_id', value);

  String? get organizationId => getField<String>('organization_id');
  set organizationId(String? value) =>
      setField<String>('organization_id', value);

  String? get organizacaoNome => getField<String>('organizacao_nome');
  set organizacaoNome(String? value) =>
      setField<String>('organizacao_nome', value);

  String? get nomeInstanciaWhatsapp =>
      getField<String>('nome_instancia_whatsapp');
  set nomeInstanciaWhatsapp(String? value) =>
      setField<String>('nome_instancia_whatsapp', value);

  String? get descricao => getField<String>('descricao');
  set descricao(String? value) => setField<String>('descricao', value);

  double? get valor => getField<double>('valor');
  set valor(double? value) => setField<double>('valor', value);

  DateTime? get dataVencimento => getField<DateTime>('data_vencimento');
  set dataVencimento(DateTime? value) =>
      setField<DateTime>('data_vencimento', value);

  String? get tipoOperacao => getField<String>('tipo_operacao');
  set tipoOperacao(String? value) => setField<String>('tipo_operacao', value);

  String? get status => getField<String>('status');
  set status(String? value) => setField<String>('status', value);

  String? get membroId => getField<String>('membro_id');
  set membroId(String? value) => setField<String>('membro_id', value);

  String? get membroNome => getField<String>('membro_nome');
  set membroNome(String? value) => setField<String>('membro_nome', value);

  String? get membroTelefone => getField<String>('membro_telefone');
  set membroTelefone(String? value) =>
      setField<String>('membro_telefone', value);

  int? get diasParaVencimento => getField<int>('dias_para_vencimento');
  set diasParaVencimento(int? value) =>
      setField<int>('dias_para_vencimento', value);

  String? get tipoNotificacao => getField<String>('tipo_notificacao');
  set tipoNotificacao(String? value) =>
      setField<String>('tipo_notificacao', value);
}
