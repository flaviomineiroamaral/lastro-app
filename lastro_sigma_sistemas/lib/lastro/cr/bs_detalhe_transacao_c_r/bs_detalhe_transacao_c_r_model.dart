import '/flutter_flow/flutter_flow_util.dart';
import 'bs_detalhe_transacao_c_r_widget.dart' show BsDetalheTransacaoCRWidget;
import 'package:flutter/material.dart';

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
