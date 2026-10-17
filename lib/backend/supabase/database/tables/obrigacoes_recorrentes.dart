import '../database.dart';

class ObrigacoesRecorrentesTable
    extends SupabaseTable<ObrigacoesRecorrentesRow> {
  @override
  String get tableName => 'obrigacoes_recorrentes';

  @override
  ObrigacoesRecorrentesRow createRow(Map<String, dynamic> data) =>
      ObrigacoesRecorrentesRow(data);
}

class ObrigacoesRecorrentesRow extends SupabaseDataRow {
  ObrigacoesRecorrentesRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => ObrigacoesRecorrentesTable();

  String? get id => getField<String>('id');
  set id(String? value) => setField<String>('id', value);

  String get organizationId => getField<String>('organization_id')!;
  set organizationId(String value) =>
      setField<String>('organization_id', value);

  String get descricao => getField<String>('descricao')!;
  set descricao(String value) => setField<String>('descricao', value);

  String? get categoriaId => getField<String>('categoria_id');
  set categoriaId(String? value) => setField<String>('categoria_id', value);

  String? get centroCustoId => getField<String>('centro_custo_id');
  set centroCustoId(String? value) =>
      setField<String>('centro_custo_id', value);

  String? get contaBancariaId => getField<String>('conta_bancaria_id');
  set contaBancariaId(String? value) =>
      setField<String>('conta_bancaria_id', value);

  String get periodicidade => getField<String>('periodicidade')!;
  set periodicidade(String value) => setField<String>('periodicidade', value);

  int get diaVencimento => getField<int>('dia_vencimento')!;
  set diaVencimento(int value) => setField<int>('dia_vencimento', value);

  int? get mesVencimento => getField<int>('mes_vencimento');
  set mesVencimento(int? value) => setField<int>('mes_vencimento', value);

  int? get diasAntecedencia => getField<int>('dias_antecedencia');
  set diasAntecedencia(int? value) => setField<int>('dias_antecedencia', value);

  double? get valorEstimado => getField<double>('valor_estimado');
  set valorEstimado(double? value) => setField<double>('valor_estimado', value);

  bool? get ativo => getField<bool>('ativo');
  set ativo(bool? value) => setField<bool>('ativo', value);

  DateTime? get ultimaCompetenciaGerada =>
      getField<DateTime>('ultima_competencia_gerada');
  set ultimaCompetenciaGerada(DateTime? value) =>
      setField<DateTime>('ultima_competencia_gerada', value);

  DateTime? get criadoEm => getField<DateTime>('criado_em');
  set criadoEm(DateTime? value) => setField<DateTime>('criado_em', value);

  String? get tipoOperacao => getField<String>('tipo_operacao');
  set tipoOperacao(String? value) => setField<String>('tipo_operacao', value);

  String? get membroId => getField<String>('membro_id');
  set membroId(String? value) => setField<String>('membro_id', value);

  String? get regraCompetencia => getField<String>('regra_competencia');
  set regraCompetencia(String? value) =>
      setField<String>('regra_competencia', value);

  bool? get manterCompetenciaFixa => getField<bool>('manter_competencia_fixa');
  set manterCompetenciaFixa(bool? value) =>
      setField<bool>('manter_competencia_fixa', value);

  DateTime? get dataInicio => getField<DateTime>('data_inicio');
  set dataInicio(DateTime? value) => setField<DateTime>('data_inicio', value);

  DateTime? get dataFim => getField<DateTime>('data_fim');
  set dataFim(DateTime? value) => setField<DateTime>('data_fim', value);

  int? get janelaMeses => getField<int>('janela_meses');
  set janelaMeses(int? value) => setField<int>('janela_meses', value);
}
