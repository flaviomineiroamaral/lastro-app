import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'bloqueio_financeiro_widget.dart' show BloqueioFinanceiroWidget;
import 'package:flutter/material.dart';

class BloqueioFinanceiroModel
    extends FlutterFlowModel<BloqueioFinanceiroWidget> {
  ///  Local state fields for this page.

  String? urlCobranca;

  ///  State fields for stateful widgets in this page.

  // Stores action output result for [Backend Call - Query Rows] action in Bloqueio_Financeiro widget.
  List<ViewMembrosEquipeRow>? retViewEquipe;
  // Stores action output result for [Backend Call - Query Rows] action in Bloqueio_Financeiro widget.
  List<AssinaturasB2cRow>? retAssinaturaB2C;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {}
}
