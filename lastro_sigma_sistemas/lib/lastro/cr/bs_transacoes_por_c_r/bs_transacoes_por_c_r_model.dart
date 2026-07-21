import '/backend/schema/structs/index.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'bs_transacoes_por_c_r_widget.dart' show BsTransacoesPorCRWidget;
import 'package:flutter/material.dart';

class BsTransacoesPorCRModel extends FlutterFlowModel<BsTransacoesPorCRWidget> {
  ///  Local state fields for this component.

  List<DTDetalheCRStruct> listaDetalheCR = [];
  void addToListaDetalheCR(DTDetalheCRStruct item) => listaDetalheCR.add(item);
  void removeFromListaDetalheCR(DTDetalheCRStruct item) =>
      listaDetalheCR.remove(item);
  void removeAtIndexFromListaDetalheCR(int index) =>
      listaDetalheCR.removeAt(index);
  void insertAtIndexInListaDetalheCR(int index, DTDetalheCRStruct item) =>
      listaDetalheCR.insert(index, item);
  void updateListaDetalheCRAtIndex(
          int index, Function(DTDetalheCRStruct) updateFn) =>
      listaDetalheCR[index] = updateFn(listaDetalheCR[index]);

  double? totalCR;

  double totalArrecadado = 0.0;

  double totalSubsidioRecebido = 0.0;

  double totalSubsidioConcedido = 0.0;

  double totalDespesas = 0.0;

  ///  State fields for stateful widgets in this component.

  // Stores action output result for [Custom Action - getCrSinteticoPorId] action in bs_TransacoesPorCR widget.
  DTCrSinteticoStruct? retDadosSintericoCRPorId;
  // Stores action output result for [Custom Action - getDetalheCR] action in bs_TransacoesPorCR widget.
  List<DTDetalheCRStruct>? retListaDetalheCR;
  // Stores action output result for [Custom Action - getCrSinteticoPorId] action in Column widget.
  DTCrSinteticoStruct? retDadosSintericoCRPorIdPull;
  // Stores action output result for [Custom Action - getDetalheCR] action in Column widget.
  List<DTDetalheCRStruct>? retListaDetalheCRPull;
  // Stores action output result for [Custom Action - getCrSinteticoPorId] action in Row widget.
  DTCrSinteticoStruct? retDadosSinteticoCRPorIdBS;
  // Stores action output result for [Custom Action - getDetalheCR] action in Row widget.
  List<DTDetalheCRStruct>? retListaDetalheCRBS;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {}
}
