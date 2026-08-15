import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import '/flutter_flow/custom_functions.dart' as functions;
import 'bs_filtro_periodo_widget.dart' show BsFiltroPeriodoWidget;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

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
