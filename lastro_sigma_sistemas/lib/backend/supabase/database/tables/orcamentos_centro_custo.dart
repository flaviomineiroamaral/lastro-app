import '../database.dart';

class OrcamentosCentroCustoTable
    extends SupabaseTable<OrcamentosCentroCustoRow> {
  @override
  String get tableName => 'orcamentos_centro_custo';

  @override
  OrcamentosCentroCustoRow createRow(Map<String, dynamic> data) =>
      OrcamentosCentroCustoRow(data);
}

class OrcamentosCentroCustoRow extends SupabaseDataRow {
  OrcamentosCentroCustoRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => OrcamentosCentroCustoTable();

  String? get id => getField<String>('id');
  set id(String? value) => setField<String>('id', value);

  String get organizationId => getField<String>('organization_id')!;
  set organizationId(String value) =>
      setField<String>('organization_id', value);

  String get centroCustoId => getField<String>('centro_custo_id')!;
  set centroCustoId(String value) => setField<String>('centro_custo_id', value);

  String get identificadorProjeto => getField<String>('identificador_projeto')!;
  set identificadorProjeto(String value) =>
      setField<String>('identificador_projeto', value);

  DateTime get dataInicio => getField<DateTime>('data_inicio')!;
  set dataInicio(DateTime value) => setField<DateTime>('data_inicio', value);

  DateTime get dataFim => getField<DateTime>('data_fim')!;
  set dataFim(DateTime value) => setField<DateTime>('data_fim', value);

  double? get valorOrcado => getField<double>('valor_orcado');
  set valorOrcado(double? value) => setField<double>('valor_orcado', value);

  DateTime? get criadoEm => getField<DateTime>('criado_em');
  set criadoEm(DateTime? value) => setField<DateTime>('criado_em', value);
}
