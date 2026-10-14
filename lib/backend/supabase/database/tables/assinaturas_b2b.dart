import '../database.dart';

class AssinaturasB2bTable extends SupabaseTable<AssinaturasB2bRow> {
  @override
  String get tableName => 'assinaturas_b2b';

  @override
  AssinaturasB2bRow createRow(Map<String, dynamic> data) =>
      AssinaturasB2bRow(data);
}

class AssinaturasB2bRow extends SupabaseDataRow {
  AssinaturasB2bRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => AssinaturasB2bTable();

  String? get id => getField<String>('id');
  set id(String? value) => setField<String>('id', value);

  DateTime? get createdAt => getField<DateTime>('created_at');
  set createdAt(DateTime? value) => setField<DateTime>('created_at', value);

  String? get organizationId => getField<String>('organization_id');
  set organizationId(String? value) =>
      setField<String>('organization_id', value);

  int? get planoId => getField<int>('plano_id');
  set planoId(int? value) => setField<int>('plano_id', value);

  double get valorMensal => getField<double>('valor_mensal')!;
  set valorMensal(double value) => setField<double>('valor_mensal', value);

  String? get cicloCobranca => getField<String>('ciclo_cobranca');
  set cicloCobranca(String? value) => setField<String>('ciclo_cobranca', value);

  String? get metodoPagamento => getField<String>('metodo_pagamento');
  set metodoPagamento(String? value) =>
      setField<String>('metodo_pagamento', value);

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

  String? get linkPagamento => getField<String>('link_pagamento');
  set linkPagamento(String? value) => setField<String>('link_pagamento', value);

  DateTime? get ultimaCobranca => getField<DateTime>('ultima_cobranca');
  set ultimaCobranca(DateTime? value) =>
      setField<DateTime>('ultima_cobranca', value);

  DateTime? get proximaCobranca => getField<DateTime>('proxima_cobranca');
  set proximaCobranca(DateTime? value) =>
      setField<DateTime>('proxima_cobranca', value);

  String? get contratoId => getField<String>('contrato_id');
  set contratoId(String? value) => setField<String>('contrato_id', value);
}
