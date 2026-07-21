import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'bs_centro_de_resultado_widget.dart' show BsCentroDeResultadoWidget;
import 'package:flutter/material.dart';

class BsCentroDeResultadoModel
    extends FlutterFlowModel<BsCentroDeResultadoWidget> {
  ///  Local state fields for this component.

  String corSelecionada = '#9E9E9E';

  List<String> listaCoresPadrao = [
    '#D32F2F',
    '#C2185B',
    '#7B1FA2',
    '#512DA8',
    '#303F9F',
    '#1976D2',
    '#0288D1',
    '#0097A7',
    '#00796B',
    '#388E3C',
    '#689F38',
    '#AFB42B',
    '#F57C00',
    '#E64A19',
    '#5D4037',
    '#8E949D'
  ];
  void addToListaCoresPadrao(String item) => listaCoresPadrao.add(item);
  void removeFromListaCoresPadrao(String item) => listaCoresPadrao.remove(item);
  void removeAtIndexFromListaCoresPadrao(int index) =>
      listaCoresPadrao.removeAt(index);
  void insertAtIndexInListaCoresPadrao(int index, String item) =>
      listaCoresPadrao.insert(index, item);
  void updateListaCoresPadraoAtIndex(int index, Function(String) updateFn) =>
      listaCoresPadrao[index] = updateFn(listaCoresPadrao[index]);

  ///  State fields for stateful widgets in this component.

  // State field(s) for NomeCentroDeResultado widget.
  FocusNode? nomeCentroDeResultadoFocusNode;
  TextEditingController? nomeCentroDeResultadoTextController;
  String? Function(BuildContext, String?)?
      nomeCentroDeResultadoTextControllerValidator;
  // State field(s) for swtIsFundo widget.
  bool? swtIsFundoValue;
  // State field(s) for swtIsPadrao widget.
  bool? swtIsPadraoValue;
  // State field(s) for swtAcumulo widget.
  bool? swtAcumuloValue;
  // State field(s) for swtAtivo widget.
  bool? swtAtivoValue;
  // Stores action output result for [Backend Call - Delete Row(s)] action in btnExcluir widget.
  List<CentrosCustoRow>? retDeleteCR;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    nomeCentroDeResultadoFocusNode?.dispose();
    nomeCentroDeResultadoTextController?.dispose();
  }
}
