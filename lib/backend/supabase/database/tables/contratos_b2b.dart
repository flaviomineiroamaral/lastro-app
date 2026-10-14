import '../database.dart';

class ContratosB2bTable extends SupabaseTable<ContratosB2bRow> {
  @override
  String get tableName => 'contratos_b2b';

  @override
  ContratosB2bRow createRow(Map<String, dynamic> data) => ContratosB2bRow(data);
}

class ContratosB2bRow extends SupabaseDataRow {
  ContratosB2bRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => ContratosB2bTable();

  String? get id => getField<String>('id');
  set id(String? value) => setField<String>('id', value);

  DateTime? get createdAt => getField<DateTime>('created_at');
  set createdAt(DateTime? value) => setField<DateTime>('created_at', value);

  String? get cnpj => getField<String>('cnpj');
  set cnpj(String? value) => setField<String>('cnpj', value);

  String? get razaoSocial => getField<String>('razao_social');
  set razaoSocial(String? value) => setField<String>('razao_social', value);

  String? get cep => getField<String>('cep');
  set cep(String? value) => setField<String>('cep', value);

  String? get logradouro => getField<String>('logradouro');
  set logradouro(String? value) => setField<String>('logradouro', value);

  String? get numero => getField<String>('numero');
  set numero(String? value) => setField<String>('numero', value);

  String? get bairro => getField<String>('bairro');
  set bairro(String? value) => setField<String>('bairro', value);

  String? get cidade => getField<String>('cidade');
  set cidade(String? value) => setField<String>('cidade', value);

  String? get uf => getField<String>('uf');
  set uf(String? value) => setField<String>('uf', value);

  String get responsavel => getField<String>('responsavel')!;
  set responsavel(String value) => setField<String>('responsavel', value);

  String get cpfResponsavel => getField<String>('cpf_responsavel')!;
  set cpfResponsavel(String value) =>
      setField<String>('cpf_responsavel', value);

  String get email => getField<String>('email')!;
  set email(String value) => setField<String>('email', value);

  String? get whatsapp => getField<String>('whatsapp');
  set whatsapp(String? value) => setField<String>('whatsapp', value);

  String get nomePlano => getField<String>('nome_plano')!;
  set nomePlano(String value) => setField<String>('nome_plano', value);

  double? get valorPlano => getField<double>('valor_plano');
  set valorPlano(double? value) => setField<double>('valor_plano', value);

  bool? get isencaoSetup => getField<bool>('isencao_setup');
  set isencaoSetup(bool? value) => setField<bool>('isencao_setup', value);

  double? get valorSetupBase => getField<double>('valor_setup_base');
  set valorSetupBase(double? value) =>
      setField<double>('valor_setup_base', value);

  double? get valorSetupCobrado => getField<double>('valor_setup_cobrado');
  set valorSetupCobrado(double? value) =>
      setField<double>('valor_setup_cobrado', value);

  int? get diaVencimento => getField<int>('dia_vencimento');
  set diaVencimento(int? value) => setField<int>('dia_vencimento', value);

  String? get codigoParceria => getField<String>('codigo_parceria');
  set codigoParceria(String? value) =>
      setField<String>('codigo_parceria', value);

  String? get codigoParceriaStatus =>
      getField<String>('codigo_parceria_status');
  set codigoParceriaStatus(String? value) =>
      setField<String>('codigo_parceria_status', value);

  String? get statusContrato => getField<String>('status_contrato');
  set statusContrato(String? value) =>
      setField<String>('status_contrato', value);

  String? get assinafyDocumentId => getField<String>('assinafy_document_id');
  set assinafyDocumentId(String? value) =>
      setField<String>('assinafy_document_id', value);

  String? get assinafySignerUrl => getField<String>('assinafy_signer_url');
  set assinafySignerUrl(String? value) =>
      setField<String>('assinafy_signer_url', value);

  DateTime? get dataAssinatura => getField<DateTime>('data_assinatura');
  set dataAssinatura(DateTime? value) =>
      setField<DateTime>('data_assinatura', value);

  String? get idCobrancaSetup => getField<String>('id_cobranca_setup');
  set idCobrancaSetup(String? value) =>
      setField<String>('id_cobranca_setup', value);

  String? get statusPagamentoSetup =>
      getField<String>('status_pagamento_setup');
  set statusPagamentoSetup(String? value) =>
      setField<String>('status_pagamento_setup', value);

  String? get linkBoletoSetup => getField<String>('link_boleto_setup');
  set linkBoletoSetup(String? value) =>
      setField<String>('link_boleto_setup', value);

  String? get tipoPerfil => getField<String>('tipo_perfil');
  set tipoPerfil(String? value) => setField<String>('tipo_perfil', value);

  String? get serialAtivacao => getField<String>('serial_ativacao');
  set serialAtivacao(String? value) =>
      setField<String>('serial_ativacao', value);

  bool? get serialUtilizado => getField<bool>('serial_utilizado');
  set serialUtilizado(bool? value) => setField<bool>('serial_utilizado', value);

  String? get leadId => getField<String>('lead_id');
  set leadId(String? value) => setField<String>('lead_id', value);

  String? get organizationId => getField<String>('organization_id');
  set organizationId(String? value) =>
      setField<String>('organization_id', value);

  String? get userId => getField<String>('user_id');
  set userId(String? value) => setField<String>('user_id', value);

  int? get planoId => getField<int>('plano_id');
  set planoId(int? value) => setField<int>('plano_id', value);
}
