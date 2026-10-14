import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'gerenciar_categoria_widget.dart' show GerenciarCategoriaWidget;
import 'package:flutter/material.dart';

class GerenciarCategoriaModel
    extends FlutterFlowModel<GerenciarCategoriaWidget> {
  ///  State fields for stateful widgets in this page.

  // Stores action output result for [Custom Action - chamarRpcVerificarPai] action in IconAdd widget.
  bool? paiTemLancamentos;
  // Stores action output result for [Custom Action - chamarRpcGerarProximoCodigo] action in IconAdd widget.
  String? novoCodigoGerado;
  // Stores action output result for [Backend Call - Delete Row(s)] action in IconDel widget.
  List<PlanoContasRow>? resultadoDelete;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {}
}
