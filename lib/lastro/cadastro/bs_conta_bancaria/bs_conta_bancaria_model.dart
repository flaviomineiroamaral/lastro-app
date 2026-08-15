import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_drop_down.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/flutter_flow/form_field_controller.dart';
import '/lastro/geral/bs_top_notificacoes/bs_top_notificacoes_widget.dart';
import 'dart:ui';
import '/custom_code/actions/index.dart' as actions;
import '/custom_code/widgets/index.dart' as custom_widgets;
import 'bs_conta_bancaria_widget.dart' show BsContaBancariaWidget;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:provider/provider.dart';

class BsContaBancariaModel extends FlutterFlowModel<BsContaBancariaWidget> {
  ///  Local state fields for this component.

  double vValorSaldoInicial = 0.0;

  double? vValorLimite;

  ///  State fields for stateful widgets in this component.

  // State field(s) for NomeConta widget.
  FocusNode? nomeContaFocusNode;
  TextEditingController? nomeContaTextController;
  String? Function(BuildContext, String?)? nomeContaTextControllerValidator;
  // State field(s) for ddTipo widget.
  String? ddTipoValue;
  FormFieldController<String>? ddTipoValueController;
  // State field(s) for DiaFatura widget.
  FocusNode? diaFaturaFocusNode;
  TextEditingController? diaFaturaTextController;
  late MaskTextInputFormatter diaFaturaMask;
  String? Function(BuildContext, String?)? diaFaturaTextControllerValidator;
  // State field(s) for DiaFechamento widget.
  FocusNode? diaFechamentoFocusNode;
  TextEditingController? diaFechamentoTextController;
  late MaskTextInputFormatter diaFechamentoMask;
  String? Function(BuildContext, String?)? diaFechamentoTextControllerValidator;
  // State field(s) for Switch widget.
  bool? switchValue;
  // Stores action output result for [Backend Call - Delete Row(s)] action in btnExcluir widget.
  List<ContasBancariasRow>? retDeleteConta;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    nomeContaFocusNode?.dispose();
    nomeContaTextController?.dispose();

    diaFaturaFocusNode?.dispose();
    diaFaturaTextController?.dispose();

    diaFechamentoFocusNode?.dispose();
    diaFechamentoTextController?.dispose();
  }
}
