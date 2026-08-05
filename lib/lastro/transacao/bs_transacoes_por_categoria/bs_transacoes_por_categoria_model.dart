import '/backend/schema/structs/index.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/lastro/geral/bs_top_notificacoes/bs_top_notificacoes_widget.dart';
import '/lastro/transacao/bs_detalhe_transacao/bs_detalhe_transacao_widget.dart';
import 'dart:ui';
import '/custom_code/actions/index.dart' as actions;
import '/flutter_flow/custom_functions.dart' as functions;
import 'bs_transacoes_por_categoria_widget.dart'
    show BsTransacoesPorCategoriaWidget;
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class BsTransacoesPorCategoriaModel
    extends FlutterFlowModel<BsTransacoesPorCategoriaWidget> {
  ///  Local state fields for this component.

  List<DTDetalheDfcCategoriaStruct> listaDetalheDfcCategoria = [];
  void addToListaDetalheDfcCategoria(DTDetalheDfcCategoriaStruct item) =>
      listaDetalheDfcCategoria.add(item);
  void removeFromListaDetalheDfcCategoria(DTDetalheDfcCategoriaStruct item) =>
      listaDetalheDfcCategoria.remove(item);
  void removeAtIndexFromListaDetalheDfcCategoria(int index) =>
      listaDetalheDfcCategoria.removeAt(index);
  void insertAtIndexInListaDetalheDfcCategoria(
          int index, DTDetalheDfcCategoriaStruct item) =>
      listaDetalheDfcCategoria.insert(index, item);
  void updateListaDetalheDfcCategoriaAtIndex(
          int index, Function(DTDetalheDfcCategoriaStruct) updateFn) =>
      listaDetalheDfcCategoria[index] =
          updateFn(listaDetalheDfcCategoria[index]);

  List<DTDetalheDreCategoriaStruct> listaDetalheDreCategoria = [];
  void addToListaDetalheDreCategoria(DTDetalheDreCategoriaStruct item) =>
      listaDetalheDreCategoria.add(item);
  void removeFromListaDetalheDreCategoria(DTDetalheDreCategoriaStruct item) =>
      listaDetalheDreCategoria.remove(item);
  void removeAtIndexFromListaDetalheDreCategoria(int index) =>
      listaDetalheDreCategoria.removeAt(index);
  void insertAtIndexInListaDetalheDreCategoria(
          int index, DTDetalheDreCategoriaStruct item) =>
      listaDetalheDreCategoria.insert(index, item);
  void updateListaDetalheDreCategoriaAtIndex(
          int index, Function(DTDetalheDreCategoriaStruct) updateFn) =>
      listaDetalheDreCategoria[index] =
          updateFn(listaDetalheDreCategoria[index]);

  double? totalCategoria;

  ///  State fields for stateful widgets in this component.

  // Stores action output result for [Custom Action - getDetalhesCategoriaDRE] action in bs_TransacoesPorCategoria widget.
  List<DTDetalheDreCategoriaStruct>? retListaDetalheCategoriaDRE;
  // Stores action output result for [Custom Action - getDetalhesCategoriaDFC] action in bs_TransacoesPorCategoria widget.
  List<DTDetalheDfcCategoriaStruct>? retListaDetalheCategoriaDFC;
  // Stores action output result for [Custom Action - getDetalhesCategoriaDFC] action in Column widget.
  List<DTDetalheDfcCategoriaStruct>? retListaDetalheCategoriaDFCPull;
  // Stores action output result for [Custom Action - somarDetalhesDfc] action in Column widget.
  double? retSomaListaDetalheCategoriaDFCPull;
  // Stores action output result for [Custom Action - getDetalhesCategoriaDRE] action in Column widget.
  List<DTDetalheDreCategoriaStruct>? retListaDetalheCategoriaDREPull;
  // Stores action output result for [Custom Action - somarDetalhesDre] action in Column widget.
  double? retSomaListaDetalheCategoriaDREPull;
  // Stores action output result for [Custom Action - getDetalhesCategoriaDFC] action in Row widget.
  List<DTDetalheDfcCategoriaStruct>? retListaDetalheCategoriaDFCBS;
  // Stores action output result for [Custom Action - somarDetalhesDfc] action in Row widget.
  double? retSomaListaDetalheCategoriaDFCBS;
  // Stores action output result for [Custom Action - getDetalhesCategoriaDRE] action in Row widget.
  List<DTDetalheDreCategoriaStruct>? retListaDetalheCategoriaDREBS;
  // Stores action output result for [Custom Action - somarDetalhesDre] action in Row widget.
  double? retSomaListaDetalheCategoriaDREBS;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {}
}
