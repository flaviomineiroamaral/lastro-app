import '../database.dart';

class VwTransacoesCompetenciaTable
    extends SupabaseTable<VwTransacoesCompetenciaRow> {
  @override
  String get tableName => 'vw_transacoes_competencia';

  @override
  VwTransacoesCompetenciaRow createRow(Map<String, dynamic> data) =>
      VwTransacoesCompetenciaRow(data);
}

class VwTransacoesCompetenciaRow extends SupabaseDataRow {
  VwTransacoesCompetenciaRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => VwTransacoesCompetenciaTable();

  String? get id => getField<String>('id');
  set id(String? value) => setField<String>('id', value);

  String? get organizationId => getField<String>('organization_id');
  set organizationId(String? value) =>
      setField<String>('organization_id', value);

  String? get planoContasId => getField<String>('plano_contas_id');
  set planoContasId(String? value) =>
      setField<String>('plano_contas_id', value);

  String? get status => getField<String>('status');
  set status(String? value) => setField<String>('status', value);

  DateTime? get dataCompetenciaReal =>
      getField<DateTime>('data_competencia_real');
  set dataCompetenciaReal(DateTime? value) =>
      setField<DateTime>('data_competencia_real', value);

  String? get codigoContabil => getField<String>('codigo_contabil');
  set codigoContabil(String? value) =>
      setField<String>('codigo_contabil', value);

  String? get tipoConta => getField<String>('tipo_conta');
  set tipoConta(String? value) => setField<String>('tipo_conta', value);

  double? get valorAbsoluto => getField<double>('valor_absoluto');
  set valorAbsoluto(double? value) => setField<double>('valor_absoluto', value);

  double? get valorLiquido => getField<double>('valor_liquido');
  set valorLiquido(double? value) => setField<double>('valor_liquido', value);
}
