import '../database.dart';

class CentrosCustoTable extends SupabaseTable<CentrosCustoRow> {
  @override
  String get tableName => 'centros_custo';

  @override
  CentrosCustoRow createRow(Map<String, dynamic> data) => CentrosCustoRow(data);
}

class CentrosCustoRow extends SupabaseDataRow {
  CentrosCustoRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => CentrosCustoTable();

  String? get id => getField<String>('id');
  set id(String? value) => setField<String>('id', value);

  String get organizationId => getField<String>('organization_id')!;
  set organizationId(String value) =>
      setField<String>('organization_id', value);

  String get nome => getField<String>('nome')!;
  set nome(String value) => setField<String>('nome', value);

  String? get descricao => getField<String>('descricao');
  set descricao(String? value) => setField<String>('descricao', value);

  bool? get ativo => getField<bool>('ativo');
  set ativo(bool? value) => setField<bool>('ativo', value);

  DateTime? get criadoEm => getField<DateTime>('criado_em');
  set criadoEm(DateTime? value) => setField<DateTime>('criado_em', value);

  bool? get isPadrao => getField<bool>('is_padrao');
  set isPadrao(bool? value) => setField<bool>('is_padrao', value);

  String? get corHex => getField<String>('cor_hex');
  set corHex(String? value) => setField<String>('cor_hex', value);

  bool? get isFundo => getField<bool>('is_fundo');
  set isFundo(bool? value) => setField<bool>('is_fundo', value);

  bool? get permiteAcumulo => getField<bool>('permite_acumulo');
  set permiteAcumulo(bool? value) => setField<bool>('permite_acumulo', value);
}
