import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/form_field_controller.dart';
import 'liquidar_cartao_widget.dart' show LiquidarCartaoWidget;
import 'package:flutter/material.dart';

class LiquidarCartaoModel extends FlutterFlowModel<LiquidarCartaoWidget> {
  ///  Local state fields for this page.

  List<String> itensSelecionados = [];
  void addToItensSelecionados(String item) => itensSelecionados.add(item);
  void removeFromItensSelecionados(String item) =>
      itensSelecionados.remove(item);
  void removeAtIndexFromItensSelecionados(int index) =>
      itensSelecionados.removeAt(index);
  void insertAtIndexInItensSelecionados(int index, String item) =>
      itensSelecionados.insert(index, item);
  void updateItensSelecionadosAtIndex(int index, Function(String) updateFn) =>
      itensSelecionados[index] = updateFn(itensSelecionados[index]);

  String? contaFiltro;

  DateTime? dataFiltro;

  bool statusSelecaoGeral = false;

  double? vSomaSelecionado;

  ///  State fields for stateful widgets in this page.

  // State field(s) for ddContaOrigem widget.
  String? ddContaOrigemValue;
  FormFieldController<String>? ddContaOrigemValueController;
  // Stores action output result for [Custom Action - pickDateWithCancel] action in ctnDataPgto widget.
  DateTime? retornoData;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {}
}
