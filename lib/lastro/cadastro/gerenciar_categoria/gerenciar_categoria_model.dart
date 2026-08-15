import '/backend/schema/structs/index.dart';
import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/lastro/cadastro/bs_categoria/bs_categoria_widget.dart';
import '/lastro/geral/bs_top_notificacoes/bs_top_notificacoes_widget.dart';
import 'dart:ui';
import '/custom_code/actions/index.dart' as actions;
import 'gerenciar_categoria_widget.dart' show GerenciarCategoriaWidget;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

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
