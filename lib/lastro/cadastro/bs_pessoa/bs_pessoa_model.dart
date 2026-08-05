import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/lastro/geral/bs_top_notificacoes/bs_top_notificacoes_widget.dart';
import 'dart:ui';
import '/custom_code/actions/index.dart' as actions;
import 'bs_pessoa_widget.dart' show BsPessoaWidget;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

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
