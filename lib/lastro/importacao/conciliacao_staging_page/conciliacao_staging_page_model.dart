import '/backend/schema/structs/index.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/form_field_controller.dart';
import 'conciliacao_staging_page_widget.dart' show ConciliacaoStagingPageWidget;
import 'package:flutter/material.dart';

class ConciliacaoStagingPageModel
    extends FlutterFlowModel<ConciliacaoStagingPageWidget> {
  ///  Local state fields for this page.

  int contadorDuplicados = 0;

  bool statusSelecaoGeral = false;

  String? tipoConta;

  int? diaVencimento;

  int? diaFechamento;

  ///  State fields for stateful widgets in this page.

  // State field(s) for ddContaOrigem widget.
  String? ddContaOrigemValue;
  FormFieldController<String>? ddContaOrigemValueController;
  // State field(s) for ddCategoria widget.
  String? ddCategoriaValue;
  FormFieldController<String>? ddCategoriaValueController;
  // State field(s) for ddCentroDeCusto widget.
  String? ddCentroDeCustoValue;
  FormFieldController<String>? ddCentroDeCustoValueController;
  // Stores action output result for [Custom Action - marcarDesmarcarTudo] action in IconButton widget.
  List<OfxTransactionStruct>? listaProcessada;
  // State field(s) for chkSelecao widget.
  bool? chkSelecaoValue;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {}
}
