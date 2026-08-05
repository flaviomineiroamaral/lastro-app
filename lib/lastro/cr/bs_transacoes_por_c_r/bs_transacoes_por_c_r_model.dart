import '/backend/schema/structs/index.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/lastro/geral/bs_top_notificacoes/bs_top_notificacoes_widget.dart';
import '/lastro/transacao/bs_detalhe_transacao/bs_detalhe_transacao_widget.dart';
import 'dart:ui';
import '/custom_code/actions/index.dart' as actions;
import '/flutter_flow/custom_functions.dart' as functions;
import 'bs_transacoes_por_c_r_widget.dart' show BsTransacoesPorCRWidget;
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

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
