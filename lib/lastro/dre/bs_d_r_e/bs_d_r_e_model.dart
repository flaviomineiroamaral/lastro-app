import '/backend/schema/structs/index.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'bs_d_r_e_widget.dart' show BsDREWidget;
import 'package:flutter/material.dart';

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
