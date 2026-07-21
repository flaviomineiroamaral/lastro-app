import '../database.dart';

class PlanoContasTable extends SupabaseTable<PlanoContasRow> {
  @override
  String get tableName => 'plano_contas';

  @override
  PlanoContasRow createRow(Map<String, dynamic> data) => PlanoContasRow(data);
}

class PlanoContasRow extends SupabaseDataRow {
  PlanoContasRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => PlanoContasTable();

  String? get id => getField<String>('id');
  set id(String? value) => setField<String>('id', value);

  String get organizationId => getField<String>('organization_id')!;
  set organizationId(String value) =>
      setField<String>('organization_id', value);

  String get codigoContabil => getField<String>('codigo_contabil')!;
  set codigoContabil(String value) =>
      setField<String>('codigo_contabil', value);

  String get nome => getField<String>('nome')!;
  set nome(String value) => setField<String>('nome', value);

  String get tipo => getField<String>('tipo')!;
  set tipo(String value) => setField<String>('tipo', value);

  DateTime? get criadoEm => getField<DateTime>('criado_em');
  set criadoEm(DateTime? value) => setField<DateTime>('criado_em', value);

  String? get naturezaFluxo => getField<String>('natureza_fluxo');
  set naturezaFluxo(String? value) => setField<String>('natureza_fluxo', value);

  bool? get permiteLancamento => getField<bool>('permite_lancamento');
  set permiteLancamento(bool? value) =>
      setField<bool>('permite_lancamento', value);

  String? get instrucaoUso => getField<String>('instrucao_uso');
  set instrucaoUso(String? value) => setField<String>('instrucao_uso', value);

  bool? get isContaImplantacao => getField<bool>('is_conta_implantacao');
  set isContaImplantacao(bool? value) =>
      setField<bool>('is_conta_implantacao', value);
}
