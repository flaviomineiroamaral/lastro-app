import '/backend/schema/structs/index.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'bs_c_r_widget.dart' show BsCRWidget;
import 'package:flutter/material.dart';

class BsCRModel extends FlutterFlowModel<BsCRWidget> {
  ///  Local state fields for this component.

  List<DTCrAnaliticoStruct> dadosCRAnalitico = [];
  void addToDadosCRAnalitico(DTCrAnaliticoStruct item) =>
      dadosCRAnalitico.add(item);
  void removeFromDadosCRAnalitico(DTCrAnaliticoStruct item) =>
      dadosCRAnalitico.remove(item);
  void removeAtIndexFromDadosCRAnalitico(int index) =>
      dadosCRAnalitico.removeAt(index);
  void insertAtIndexInDadosCRAnalitico(int index, DTCrAnaliticoStruct item) =>
      dadosCRAnalitico.insert(index, item);
  void updateDadosCRAnaliticoAtIndex(
          int index, Function(DTCrAnaliticoStruct) updateFn) =>
      dadosCRAnalitico[index] = updateFn(dadosCRAnalitico[index]);

  DTCrSinteticoStruct? dadosCRSintetico;
  void updateDadosCRSinteticoStruct(Function(DTCrSinteticoStruct) updateFn) {
    updateFn(dadosCRSintetico ??= DTCrSinteticoStruct());
  }

  DTConciliacaoResumoStruct? estadoConciliacao;
  void updateEstadoConciliacaoStruct(
      Function(DTConciliacaoResumoStruct) updateFn) {
    updateFn(estadoConciliacao ??= DTConciliacaoResumoStruct());
  }

  ///  State fields for stateful widgets in this component.

  // Stores action output result for [Custom Action - getCrSintetico] action in bs_CR widget.
  DTCrSinteticoStruct? retDadosCrSintetico;
  // Stores action output result for [Custom Action - getCrAnalitico] action in bs_CR widget.
  List<DTCrAnaliticoStruct>? retDadosCrAnalitico;
  // Stores action output result for [Custom Action - getConciliacaoDashboard] action in bs_CR widget.
  DTConciliacaoResumoStruct? retDadosCrConciliacao;
  // Stores action output result for [Custom Action - getCrSintetico] action in Column widget.
  DTCrSinteticoStruct? retDadosCrSinteticoPull;
  // Stores action output result for [Custom Action - getCrAnalitico] action in Column widget.
  List<DTCrAnaliticoStruct>? retDadosCrAnaliticoPull;
  // Stores action output result for [Custom Action - getConciliacaoDashboard] action in Column widget.
  DTConciliacaoResumoStruct? retDadosCrConciliacaoPull;
  // Stores action output result for [Custom Action - getCrSintetico] action in Button widget.
  DTCrSinteticoStruct? retDadosCrSinteticoFiltro;
  // Stores action output result for [Custom Action - getCrAnalitico] action in Button widget.
  List<DTCrAnaliticoStruct>? retDadosCrAnaliticoFiltro;
  // Stores action output result for [Custom Action - getConciliacaoDashboard] action in Button widget.
  DTConciliacaoResumoStruct? retDadosCrConciliacaoFiltro;
  // Stores action output result for [Custom Action - getCrSintetico] action in Container widget.
  DTCrSinteticoStruct? retDadosCrSinteticoBSTapFundo;
  // Stores action output result for [Custom Action - getCrAnalitico] action in Container widget.
  List<DTCrAnaliticoStruct>? retDadosCrAnaliticoBSTapFundo;
  // Stores action output result for [Custom Action - getConciliacaoDashboard] action in Container widget.
  DTConciliacaoResumoStruct? retDadosCrConciliacaoBSTapFundo;
  // Stores action output result for [Custom Action - getCrSintetico] action in Container widget.
  DTCrSinteticoStruct? retDadosCrSinteticoBSTap;
  // Stores action output result for [Custom Action - getCrAnalitico] action in Container widget.
  List<DTCrAnaliticoStruct>? retDadosCrAnaliticoBSTap;
  // Stores action output result for [Custom Action - getConciliacaoDashboard] action in Container widget.
  DTConciliacaoResumoStruct? retDadosCrConciliacaoBSTap;
  // Stores action output result for [Custom Action - getCrSintetico] action in btnAlocar widget.
  DTCrSinteticoStruct? retDadosCrSinteticoBtnAlocar;
  // Stores action output result for [Custom Action - getCrAnalitico] action in btnAlocar widget.
  List<DTCrAnaliticoStruct>? retDadosCrAnaliticoBtnAlocar;
  // Stores action output result for [Custom Action - getConciliacaoDashboard] action in btnAlocar widget.
  DTConciliacaoResumoStruct? retDadosCrConciliacaoBtnAlocar;
  // Stores action output result for [Custom Action - getCrSintetico] action in btnDevolver widget.
  DTCrSinteticoStruct? retDadosCrSinteticoBtnDevolver;
  // Stores action output result for [Custom Action - getCrAnalitico] action in btnDevolver widget.
  List<DTCrAnaliticoStruct>? retDadosCrAnaliticoBtnDevolver;
  // Stores action output result for [Custom Action - getConciliacaoDashboard] action in btnDevolver widget.
  DTConciliacaoResumoStruct? retDadosCrConciliacaoBtnDevolver;
  // Stores action output result for [Custom Action - getCrSintetico] action in btnTransferir widget.
  DTCrSinteticoStruct? retDadosCrSinteticoBtnTransferir;
  // Stores action output result for [Custom Action - getCrAnalitico] action in btnTransferir widget.
  List<DTCrAnaliticoStruct>? retDadosCrAnaliticoBtnTransferir;
  // Stores action output result for [Custom Action - getConciliacaoDashboard] action in btnTransferir widget.
  DTConciliacaoResumoStruct? retDadosCrConciliacaoBtnTransferir;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {}
}
