import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/lastro/geral/bs_top_notificacoes/bs_top_notificacoes_widget.dart';
import 'dart:ui';
import '/custom_code/actions/index.dart' as actions;
import '/custom_code/widgets/index.dart' as custom_widgets;
import 'bs_detalhe_transacao_c_r_widget.dart' show BsDetalheTransacaoCRWidget;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class BsDetalheTransacaoCRModel
    extends FlutterFlowModel<BsDetalheTransacaoCRWidget> {
  ///  Local state fields for this component.

  DateTime? vDataOperacao;

  double? vValorFormulario;

  ///  State fields for stateful widgets in this component.

  DateTime? datePicked;
  // State field(s) for Observacao widget.
  FocusNode? observacaoFocusNode;
  TextEditingController? observacaoTextController;
  String? Function(BuildContext, String?)? observacaoTextControllerValidator;
  // Stores action output result for [Custom Action - alocarSubsidio] action in btnSalvar widget.
  bool? retAlocar;
  // Stores action output result for [Custom Action - estornarSubsidio] action in btnSalvar widget.
  bool? retEstorno;
  // Stores action output result for [Custom Action - repassarArrecadacao] action in btnSalvar widget.
  bool? retRepassar;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    observacaoFocusNode?.dispose();
    observacaoTextController?.dispose();
  }
}
