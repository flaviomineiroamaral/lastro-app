import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'bs_pessoa_widget.dart' show BsPessoaWidget;
import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class BsPessoaModel extends FlutterFlowModel<BsPessoaWidget> {
  ///  State fields for stateful widgets in this component.

  // State field(s) for NomePessoa widget.
  FocusNode? nomePessoaFocusNode;
  TextEditingController? nomePessoaTextController;
  String? Function(BuildContext, String?)? nomePessoaTextControllerValidator;
  // State field(s) for CPF widget.
  FocusNode? cpfFocusNode;
  TextEditingController? cpfTextController;
  late MaskTextInputFormatter cpfMask;
  String? Function(BuildContext, String?)? cpfTextControllerValidator;
  // State field(s) for Whatsapp widget.
  FocusNode? whatsappFocusNode;
  TextEditingController? whatsappTextController;
  late MaskTextInputFormatter whatsappMask;
  String? Function(BuildContext, String?)? whatsappTextControllerValidator;
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

    cpfFocusNode?.dispose();
    cpfTextController?.dispose();

    whatsappFocusNode?.dispose();
    whatsappTextController?.dispose();
  }
}
