import '../database.dart';

class RegrasCategoriacaoTable extends SupabaseTable<RegrasCategoriacaoRow> {
  @override
  String get tableName => 'regras_categorizacao';

  @override
  RegrasCategoriacaoRow createRow(Map<String, dynamic> data) =>
      RegrasCategoriacaoRow(data);
}

class RegrasCategoriacaoRow extends SupabaseDataRow {
  RegrasCategoriacaoRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => RegrasCategoriacaoTable();

  String? get id => getField<String>('id');
  set id(String? value) => setField<String>('id', value);

  String get organizationId => getField<String>('organization_id')!;
  set organizationId(String value) =>
      setField<String>('organization_id', value);

  String get padraoDescricao => getField<String>('padrao_descricao')!;
  set padraoDescricao(String value) =>
      setField<String>('padrao_descricao', value);

  String? get planoContasId => getField<String>('plano_contas_id');
  set planoContasId(String? value) =>
      setField<String>('plano_contas_id', value);

  String? get centroCustoId => getField<String>('centro_custo_id');
  set centroCustoId(String? value) =>
      setField<String>('centro_custo_id', value);

  String? get tipoOperacao => getField<String>('tipo_operacao');
  set tipoOperacao(String? value) => setField<String>('tipo_operacao', value);

  int get contagemUsos => getField<int>('contagem_usos') ?? 1;
  set contagemUsos(int value) => setField<int>('contagem_usos', value);

  DateTime? get criadoEm => getField<DateTime>('criado_em');
  set criadoEm(DateTime? value) => setField<DateTime>('criado_em', value);

  DateTime? get atualizadoEm => getField<DateTime>('atualizado_em');
  set atualizadoEm(DateTime? value) =>
      setField<DateTime>('atualizado_em', value);
}
