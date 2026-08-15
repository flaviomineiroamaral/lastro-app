import '/backend/schema/structs/index.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/lastro/geral/bs_filtro_periodo/bs_filtro_periodo_widget.dart';
import '/lastro/geral/bs_top_notificacoes/bs_top_notificacoes_widget.dart';
import '/lastro/transacao/bs_detalhe_transacao/bs_detalhe_transacao_widget.dart';
import 'dart:ui';
import '/custom_code/actions/index.dart' as actions;
import '/flutter_flow/custom_functions.dart' as functions;
import 'bs_transacao_widget.dart' show BsTransacaoWidget;
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class BsTransacaoModel extends FlutterFlowModel<BsTransacaoWidget> {
  ///  Local state fields for this component.

  List<DTExtratoPeriodoStruct> dadosExtratoPeriodo = [];
  void addToDadosExtratoPeriodo(DTExtratoPeriodoStruct item) =>
      dadosExtratoPeriodo.add(item);
  void removeFromDadosExtratoPeriodo(DTExtratoPeriodoStruct item) =>
      dadosExtratoPeriodo.remove(item);
  void removeAtIndexFromDadosExtratoPeriodo(int index) =>
      dadosExtratoPeriodo.removeAt(index);
  void insertAtIndexInDadosExtratoPeriodo(
          int index, DTExtratoPeriodoStruct item) =>
      dadosExtratoPeriodo.insert(index, item);
  void updateDadosExtratoPeriodoAtIndex(
          int index, Function(DTExtratoPeriodoStruct) updateFn) =>
      dadosExtratoPeriodo[index] = updateFn(dadosExtratoPeriodo[index]);

  bool isProcessing = false;

  ///  State fields for stateful widgets in this component.

  // Stores action output result for [Custom Action - getExtratoPorPeriodo] action in bs_Transacao widget.
  List<DTExtratoPeriodoStruct>? retDadosExtratoPeriodo;
  // Stores action output result for [Custom Action - getExtratoPorPeriodo] action in Button widget.
  List<DTExtratoPeriodoStruct>? retDadosExtratoPeriodoFiltro;
  // Stores action output result for [Custom Action - getExtratoPorPeriodo] action in Column widget.
  List<DTExtratoPeriodoStruct>? retDadosExtratoPeriodoPull;
  // Stores action output result for [Custom Action - getExtratoPorPeriodo] action in Row widget.
  List<DTExtratoPeriodoStruct>? retDadosExtratoPeriodoDTEditar;
  // Stores action output result for [Custom Action - getExtratoPorPeriodo] action in FloatingActionButton widget.
  List<DTExtratoPeriodoStruct>? retDadosExtratoPeriodoDTNovo;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {}
}
