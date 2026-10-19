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

  String? get razaoSocialOficial => getField<String>('razao_social_oficial');
  set razaoSocialOficial(String? value) =>
      setField<String>('razao_social_oficial', value);

  String? get documentoCnpj => getField<String>('documento_cnpj');
  set documentoCnpj(String? value) => setField<String>('documento_cnpj', value);

  bool? get organizacaoAtiva => getField<bool>('organizacao_ativa');
  set organizacaoAtiva(bool? value) =>
      setField<bool>('organizacao_ativa', value);

  String? get profileId => getField<String>('profile_id');
  set profileId(String? value) => setField<String>('profile_id', value);

  String? get nomeUtilizador => getField<String>('nome_utilizador');
  set nomeUtilizador(String? value) =>
      setField<String>('nome_utilizador', value);

  String? get email => getField<String>('email');
  set email(String? value) => setField<String>('email', value);

  String? get whatsapp => getField<String>('whatsapp');
  set whatsapp(String? value) => setField<String>('whatsapp', value);

  String? get funcao => getField<String>('funcao');
  set funcao(String? value) => setField<String>('funcao', value);

  String? get tipoOrganizacao => getField<String>('tipo_organizacao');
  set tipoOrganizacao(String? value) =>
      setField<String>('tipo_organizacao', value);

  String? get planoOrganizacao => getField<String>('plano_organizacao');
  set planoOrganizacao(String? value) =>
      setField<String>('plano_organizacao', value);

  int? get limiteCrsPlano => getField<int>('limite_crs_plano');
  set limiteCrsPlano(int? value) => setField<int>('limite_crs_plano', value);

  int? get limiteCrsAtual => getField<int>('limite_crs_atual');
  set limiteCrsAtual(int? value) => setField<int>('limite_crs_atual', value);

  bool? get isPlanoGratuito => getField<bool>('is_plano_gratuito');
  set isPlanoGratuito(bool? value) =>
      setField<bool>('is_plano_gratuito', value);

  String? get statusPagamentoSetup =>
      getField<String>('status_pagamento_setup');
  set statusPagamentoSetup(String? value) =>
      setField<String>('status_pagamento_setup', value);

  bool? get isInadimplenteSetup => getField<bool>('is_inadimplente_setup');
  set isInadimplenteSetup(bool? value) =>
      setField<bool>('is_inadimplente_setup', value);

  String? get contratoId => getField<String>('contrato_id');
  set contratoId(String? value) => setField<String>('contrato_id', value);

  String? get linkBoletoSetup => getField<String>('link_boleto_setup');
  set linkBoletoSetup(String? value) =>
      setField<String>('link_boleto_setup', value);

  String? get assinaturaB2bId => getField<String>('assinatura_b2b_id');
  set assinaturaB2bId(String? value) =>
      setField<String>('assinatura_b2b_id', value);

  String? get linkMensalidadeB2b => getField<String>('link_mensalidade_b2b');
  set linkMensalidadeB2b(String? value) =>
      setField<String>('link_mensalidade_b2b', value);

  String? get statusAssinaturaB2b => getField<String>('status_assinatura_b2b');
  set statusAssinaturaB2b(String? value) =>
      setField<String>('status_assinatura_b2b', value);

  String? get statusAssinaturaB2c => getField<String>('status_assinatura_b2c');
  set statusAssinaturaB2c(String? value) =>
      setField<String>('status_assinatura_b2c', value);

  bool? get isBloqueadoFinanceiro => getField<bool>('is_bloqueado_financeiro');
  set isBloqueadoFinanceiro(bool? value) =>
      setField<bool>('is_bloqueado_financeiro', value);
}
