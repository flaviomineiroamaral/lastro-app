import '/backend/schema/structs/index.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/lastro/geral/bs_filtro_periodo/bs_filtro_periodo_widget.dart';
import '/lastro/transacao/bs_transacoes_por_categoria/bs_transacoes_por_categoria_widget.dart';
import 'dart:ui';
import '/custom_code/actions/index.dart' as actions;
import '/flutter_flow/custom_functions.dart' as functions;
import 'bs_d_r_e_widget.dart' show BsDREWidget;
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class BsDREModel extends FlutterFlowModel<BsDREWidget> {
  ///  Local state fields for this component.

  List<DTDreAnaliticoStruct> dadosDREAnalitico = [];
  void addToDadosDREAnalitico(DTDreAnaliticoStruct item) =>
      dadosDREAnalitico.add(item);
  void removeFromDadosDREAnalitico(DTDreAnaliticoStruct item) =>
      dadosDREAnalitico.remove(item);
  void removeAtIndexFromDadosDREAnalitico(int index) =>
      dadosDREAnalitico.removeAt(index);
  void insertAtIndexInDadosDREAnalitico(int index, DTDreAnaliticoStruct item) =>
      dadosDREAnalitico.insert(index, item);
  void updateDadosDREAnaliticoAtIndex(
          int index, Function(DTDreAnaliticoStruct) updateFn) =>
      dadosDREAnalitico[index] = updateFn(dadosDREAnalitico[index]);

  ///  State fields for stateful widgets in this component.

  // Stores action output result for [Custom Action - getDreAnalitico] action in bs_DRE widget.
  List<DTDreAnaliticoStruct>? retDadosDREAnalitico;
  // Stores action output result for [Custom Action - getDreAnalitico] action in Button widget.
  List<DTDreAnaliticoStruct>? retDadosDREAnaliticoFiltro;
  // Stores action output result for [Custom Action - getDreAnalitico] action in Icon widget.
  List<DTDreAnaliticoStruct>? retDadosDREAnaliticoBS;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {}
}
