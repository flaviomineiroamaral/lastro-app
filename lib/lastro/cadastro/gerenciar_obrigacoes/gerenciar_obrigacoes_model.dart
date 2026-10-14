import '/backend/schema/structs/index.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'gerenciar_obrigacoes_widget.dart' show GerenciarObrigacoesWidget;
import 'package:flutter/material.dart';

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
