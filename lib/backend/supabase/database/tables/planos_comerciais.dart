import '../database.dart';

class PlanosComerciaisTable extends SupabaseTable<PlanosComerciaisRow> {
  @override
  String get tableName => 'planos_comerciais';

  @override
  PlanosComerciaisRow createRow(Map<String, dynamic> data) =>
      PlanosComerciaisRow(data);
}

class PlanosComerciaisRow extends SupabaseDataRow {
  PlanosComerciaisRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => PlanosComerciaisTable();

  int? get id => getField<int>('id');
  set id(int? value) => setField<int>('id', value);

  String get nome => getField<String>('nome')!;
  set nome(String value) => setField<String>('nome', value);

  String? get descricaoCurta => getField<String>('descricao_curta');
  set descricaoCurta(String? value) =>
      setField<String>('descricao_curta', value);

  int? get limiteCrs => getField<int>('limite_crs');
  set limiteCrs(int? value) => setField<int>('limite_crs', value);

  double get valorMensal => getField<double>('valor_mensal')!;
  set valorMensal(double value) => setField<double>('valor_mensal', value);

  bool? get ativo => getField<bool>('ativo');
  set ativo(bool? value) => setField<bool>('ativo', value);

  int? get ordemExibicao => getField<int>('ordem_exibicao');
  set ordemExibicao(int? value) => setField<int>('ordem_exibicao', value);

  String? get tipoPublico => getField<String>('tipo_publico');
  set tipoPublico(String? value) => setField<String>('tipo_publico', value);

  bool? get requerSetup => getField<bool>('requer_setup');
  set requerSetup(bool? value) => setField<bool>('requer_setup', value);

  bool? get requerCnpj => getField<bool>('requer_cnpj');
  set requerCnpj(bool? value) => setField<bool>('requer_cnpj', value);

  bool? get exibeNaLandingPage => getField<bool>('exibe_na_landing_page');
  set exibeNaLandingPage(bool? value) =>
      setField<bool>('exibe_na_landing_page', value);

  String? get gatewayPlanId => getField<String>('gateway_plan_id');
  set gatewayPlanId(String? value) =>
      setField<String>('gateway_plan_id', value);

  DateTime? get createdAt => getField<DateTime>('created_at');
  set createdAt(DateTime? value) => setField<DateTime>('created_at', value);

  DateTime? get updatedAt => getField<DateTime>('updated_at');
  set updatedAt(DateTime? value) => setField<DateTime>('updated_at', value);
}
