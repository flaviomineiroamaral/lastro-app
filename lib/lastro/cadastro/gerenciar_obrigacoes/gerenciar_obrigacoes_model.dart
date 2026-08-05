import '/backend/schema/structs/index.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/lastro/cadastro/bs_obrigacoes/bs_obrigacoes_widget.dart';
import '/lastro/geral/bs_top_notificacoes/bs_top_notificacoes_widget.dart';
import 'dart:ui';
import '/custom_code/actions/index.dart' as actions;
import '/flutter_flow/custom_functions.dart' as functions;
import 'gerenciar_obrigacoes_widget.dart' show GerenciarObrigacoesWidget;
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class GerenciarObrigacoesModel
    extends FlutterFlowModel<GerenciarObrigacoesWidget> {
  ///  Local state fields for this page.

  List<DTObrigacaoRecorrenteStruct> dadosObrigacoesRecorrentes = [];
  void addToDadosObrigacoesRecorrentes(DTObrigacaoRecorrenteStruct item) =>
      dadosObrigacoesRecorrentes.add(item);
  void removeFromDadosObrigacoesRecorrentes(DTObrigacaoRecorrenteStruct item) =>
      dadosObrigacoesRecorrentes.remove(item);
  void removeAtIndexFromDadosObrigacoesRecorrentes(int index) =>
      dadosObrigacoesRecorrentes.removeAt(index);
  void insertAtIndexInDadosObrigacoesRecorrentes(
          int index, DTObrigacaoRecorrenteStruct item) =>
      dadosObrigacoesRecorrentes.insert(index, item);
  void updateDadosObrigacoesRecorrentesAtIndex(
          int index, Function(DTObrigacaoRecorrenteStruct) updateFn) =>
      dadosObrigacoesRecorrentes[index] =
          updateFn(dadosObrigacoesRecorrentes[index]);

  ///  State fields for stateful widgets in this page.

  // Stores action output result for [Custom Action - getObrigacoesRecorrentes] action in GerenciarObrigacoes widget.
  List<DTObrigacaoRecorrenteStruct>? retDadosObrigacoesRecorrentes;
  // Stores action output result for [Custom Action - getObrigacoesRecorrentes] action in Icon widget.
  List<DTObrigacaoRecorrenteStruct>? retDadosObrigacoesRecorrentesEdit;
  // Stores action output result for [Custom Action - getObrigacoesRecorrentes] action in FloatingActionButton widget.
  List<DTObrigacaoRecorrenteStruct>? retDadosObrigacoesRecorrentesFab;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {}
}
