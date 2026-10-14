import '/flutter_flow/flutter_flow_util.dart';
import 'bs_senha_p_d_f_widget.dart' show BsSenhaPDFWidget;
import 'package:flutter/material.dart';

class BsSenhaPDFModel extends FlutterFlowModel<BsSenhaPDFWidget> {
  ///  State fields for stateful widgets in this component.

  // State field(s) for Senha widget.
  FocusNode? senhaFocusNode;
  TextEditingController? senhaTextController;
  late bool senhaVisibility;
  String? Function(BuildContext, String?)? senhaTextControllerValidator;

  @override
  void initState(BuildContext context) {
    senhaVisibility = false;
  }

  @override
  void dispose() {
    senhaFocusNode?.dispose();
    senhaTextController?.dispose();
  }
}
