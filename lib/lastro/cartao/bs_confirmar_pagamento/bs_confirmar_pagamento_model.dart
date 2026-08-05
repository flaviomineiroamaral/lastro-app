import '/flutter_flow/flutter_flow_drop_down.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/flutter_flow/form_field_controller.dart';
import '/lastro/geral/bs_top_notificacoes/bs_top_notificacoes_widget.dart';
import 'dart:ui';
import '/custom_code/actions/index.dart' as actions;
import '/custom_code/widgets/index.dart' as custom_widgets;
import 'bs_confirmar_pagamento_widget.dart' show BsConfirmarPagamentoWidget;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class BsConfirmarPagamentoModel
    extends FlutterFlowModel<BsConfirmarPagamentoWidget> {
  ///  Local state fields for this component.

  DateTime? vDataPagamento;

  double? vValorFormulario;

  ///  State fields for stateful widgets in this component.

  // State field(s) for ddContaOrigem widget.
  String? ddContaOrigemValue;
  FormFieldController<String>? ddContaOrigemValueController;
  DateTime? datePicked;
  // Stores action output result for [Custom Action - liquidarEGerarTransferencia] action in btnSalvar widget.
  String? resultado;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {}
}
