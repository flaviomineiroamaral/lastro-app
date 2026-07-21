import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'bs_pessoa_widget.dart' show BsPessoaWidget;
import 'package:flutter/material.dart';

class BsPessoaModel extends FlutterFlowModel<BsPessoaWidget> {
  ///  State fields for stateful widgets in this component.

  // State field(s) for NomePessoa widget.
  FocusNode? nomePessoaFocusNode;
  TextEditingController? nomePessoaTextController;
  String? Function(BuildContext, String?)? nomePessoaTextControllerValidator;
  // State field(s) for Switch widget.
  bool? switchValue;
  // Stores action output result for [Backend Call - Delete Row(s)] action in btnExcluir widget.
  List<MembrosRow>? retDeleteMembro;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    nomePessoaFocusNode?.dispose();
    nomePessoaTextController?.dispose();
  }
}
