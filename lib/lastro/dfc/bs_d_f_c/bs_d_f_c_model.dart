import '/backend/schema/structs/index.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/lastro/geral/bs_filtro_periodo/bs_filtro_periodo_widget.dart';
import '/lastro/transacao/bs_transacoes_por_categoria/bs_transacoes_por_categoria_widget.dart';
import 'dart:ui';
import '/custom_code/actions/index.dart' as actions;
import '/flutter_flow/custom_functions.dart' as functions;
import 'bs_d_f_c_widget.dart' show BsDFCWidget;
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class BsDFCModel extends FlutterFlowModel<BsDFCWidget> {
  ///  Local state fields for this component.

  List<DTDfcAnaliticoStruct> dadosDFCAnalitico = [];
  void addToDadosDFCAnalitico(DTDfcAnaliticoStruct item) =>
      dadosDFCAnalitico.add(item);
  void removeFromDadosDFCAnalitico(DTDfcAnaliticoStruct item) =>
      dadosDFCAnalitico.remove(item);
  void removeAtIndexFromDadosDFCAnalitico(int index) =>
      dadosDFCAnalitico.removeAt(index);
  void insertAtIndexInDadosDFCAnalitico(int index, DTDfcAnaliticoStruct item) =>
      dadosDFCAnalitico.insert(index, item);
  void updateDadosDFCAnaliticoAtIndex(
          int index, Function(DTDfcAnaliticoStruct) updateFn) =>
      dadosDFCAnalitico[index] = updateFn(dadosDFCAnalitico[index]);

  ///  State fields for stateful widgets in this component.

  // Stores action output result for [Custom Action - getDfcAnalitico] action in bs_DFC widget.
  List<DTDfcAnaliticoStruct>? retDadosDFCAnalitico;
  // Stores action output result for [Custom Action - getDfcAnalitico] action in Button widget.
  List<DTDfcAnaliticoStruct>? retDadosDFCAnaliticoFiltro;
  // Stores action output result for [Custom Action - getDfcAnalitico] action in Column widget.
  List<DTDfcAnaliticoStruct>? retDadosDFCAnaliticoPull;
  // Stores action output result for [Custom Action - getDfcAnalitico] action in Icon widget.
  List<DTDfcAnaliticoStruct>? retDadosDFCAnaliticoBS;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {}
}
