import '/flutter_flow/flutter_flow_util.dart';
import 'bs_filtro_periodo_widget.dart' show BsFiltroPeriodoWidget;
import 'package:flutter/material.dart';

class BsFiltroPeriodoModel extends FlutterFlowModel<BsFiltroPeriodoWidget> {
  ///  Local state fields for this component.

  DateTime? dataInicialTemp;

  DateTime? dataFinalTemp;

  String periodoAtivo = 'Mês Atual';

  ///  State fields for stateful widgets in this component.

  // State field(s) for Row widget.
  ScrollController? rowController;
  DateTime? datePicked1;
  DateTime? datePicked2;

  @override
  void initState(BuildContext context) {
    rowController = ScrollController();
  }

  @override
  void dispose() {
    rowController?.dispose();
  }
}
