import '../database.dart';

class AssinaturasB2cTable extends SupabaseTable<AssinaturasB2cRow> {
  @override
  String get tableName => 'assinaturas_b2c';

  @override
  AssinaturasB2cRow createRow(Map<String, dynamic> data) =>
      AssinaturasB2cRow(data);
}

class AssinaturasB2cRow extends SupabaseDataRow {
  AssinaturasB2cRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => AssinaturasB2cTable();

  String? get id => getField<String>('id');
  set id(String? value) => setField<String>('id', value);

  DateTime? get createdAt => getField<DateTime>('created_at');
  set createdAt(DateTime? value) => setField<DateTime>('created_at', value);

  String? get userId => getField<String>('user_id');
  set userId(String? value) => setField<String>('user_id', value);

  int? get planoId => getField<int>('plano_id');
  set planoId(int? value) => setField<int>('plano_id', value);

  String get nomeCompleto => getField<String>('nome_completo')!;
  set nomeCompleto(String value) => setField<String>('nome_completo', value);

  String get cpf => getField<String>('cpf')!;
  set cpf(String value) => setField<String>('cpf', value);

  String get email => getField<String>('email')!;
  set email(String value) => setField<String>('email', value);

  String? get whatsapp => getField<String>('whatsapp');
  set whatsapp(String? value) => setField<String>('whatsapp', value);

  double get valorMensal => getField<double>('valor_mensal')!;
  set valorMensal(double value) => setField<double>('valor_mensal', value);

  String? get cicloCobranca => getField<String>('ciclo_cobranca');
  set cicloCobranca(String? value) => setField<String>('ciclo_cobranca', value);

  String? get statusAssinatura => getField<String>('status_assinatura');
  set statusAssinatura(String? value) =>
      setField<String>('status_assinatura', value);

  String? get gatewayCustomerId => getField<String>('gateway_customer_id');
  set gatewayCustomerId(String? value) =>
      setField<String>('gateway_customer_id', value);

  String? get gatewaySubscriptionId =>
      getField<String>('gateway_subscription_id');
  set gatewaySubscriptionId(String? value) =>
      setField<String>('gateway_subscription_id', value);

  String? get metodoPagamento => getField<String>('metodo_pagamento');
  set metodoPagamento(String? value) =>
      setField<String>('metodo_pagamento', value);

  DateTime? get ultimaCobranca => getField<DateTime>('ultima_cobranca');
  set ultimaCobranca(DateTime? value) =>
      setField<DateTime>('ultima_cobranca', value);

  DateTime? get proximaCobranca => getField<DateTime>('proxima_cobranca');
  set proximaCobranca(DateTime? value) =>
      setField<DateTime>('proxima_cobranca', value);

  bool? get termosAceites => getField<bool>('termos_aceites');
  set termosAceites(bool? value) => setField<bool>('termos_aceites', value);

  String? get ipAceite => getField<String>('ip_aceite');
  set ipAceite(String? value) => setField<String>('ip_aceite', value);

  DateTime? get dataAceite => getField<DateTime>('data_aceite');
  set dataAceite(DateTime? value) => setField<DateTime>('data_aceite', value);

  String? get serialAtivacao => getField<String>('serial_ativacao');
  set serialAtivacao(String? value) =>
      setField<String>('serial_ativacao', value);

  bool? get serialUtilizado => getField<bool>('serial_utilizado');
  set serialUtilizado(bool? value) => setField<bool>('serial_utilizado', value);

  String? get linkPagamento => getField<String>('link_pagamento');
  set linkPagamento(String? value) => setField<String>('link_pagamento', value);

  String? get codigoParceria => getField<String>('codigo_parceria');
  set codigoParceria(String? value) =>
      setField<String>('codigo_parceria', value);

  String? get codigoParceriaStatus =>
      getField<String>('codigo_parceria_status');
  set codigoParceriaStatus(String? value) =>
      setField<String>('codigo_parceria_status', value);

  String? get organizationId => getField<String>('organization_id');
  set organizationId(String? value) =>
      setField<String>('organization_id', value);
}
