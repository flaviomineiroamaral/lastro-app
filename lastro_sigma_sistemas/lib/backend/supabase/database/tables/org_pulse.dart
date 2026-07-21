import '../database.dart';

class OrgPulseTable extends SupabaseTable<OrgPulseRow> {
  @override
  String get tableName => 'org_pulse';

  @override
  OrgPulseRow createRow(Map<String, dynamic> data) => OrgPulseRow(data);
}

class OrgPulseRow extends SupabaseDataRow {
  OrgPulseRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => OrgPulseTable();

  String get organizationId => getField<String>('organization_id')!;
  set organizationId(String value) =>
      setField<String>('organization_id', value);

  DateTime? get ultimaAtualizacao => getField<DateTime>('ultima_atualizacao');
  set ultimaAtualizacao(DateTime? value) =>
      setField<DateTime>('ultima_atualizacao', value);
}
