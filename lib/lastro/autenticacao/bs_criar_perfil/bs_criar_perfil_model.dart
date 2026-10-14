import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'bs_criar_perfil_widget.dart' show BsCriarPerfilWidget;
import 'package:flutter/material.dart';

class BsCriarPerfilModel extends FlutterFlowModel<BsCriarPerfilWidget> {
  ///  Local state fields for this component.

  String selectedType = 'Família';

  ///  State fields for stateful widgets in this component.

  // State field(s) for nomeOrganizacao widget.
  FocusNode? nomeOrganizacaoFocusNode;
  TextEditingController? nomeOrganizacaoTextController;
  String? Function(BuildContext, String?)?
      nomeOrganizacaoTextControllerValidator;
  // Stores action output result for [Custom Action - createOrganizationRPC] action in Button widget.
  dynamic resultadoRPC;
  // Stores action output result for [Backend Call - Query Rows] action in Button widget.
  List<ViewMembrosEquipeRow>? minhaOrganizacao;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    nomeOrganizacaoFocusNode?.dispose();
    nomeOrganizacaoTextController?.dispose();
  }
}
