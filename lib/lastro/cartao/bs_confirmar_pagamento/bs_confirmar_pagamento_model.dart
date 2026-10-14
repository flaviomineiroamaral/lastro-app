import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/form_field_controller.dart';
import 'bs_confirmar_pagamento_widget.dart' show BsConfirmarPagamentoWidget;
import 'package:flutter/material.dart';

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
