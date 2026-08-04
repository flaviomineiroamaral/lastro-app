import '/backend/schema/structs/index.dart';
import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/form_field_controller.dart';
import 'selecionar_transacoes_widget.dart' show SelecionarTransacoesWidget;
import 'package:flutter/material.dart';

class SelecionarTransacoesModel
    extends FlutterFlowModel<SelecionarTransacoesWidget> {
  ///  Local state fields for this page.

  int contadorDuplicados = 0;

  bool statusSelecaoGeral = false;

  String? tipoConta;

  int? diaVencimento;

  int? diaFechamento;

  /// Resultado da RPC de importação em lote
  int contadorImportados = 0;
  int contadorConciliados = 0;

  /// Mapa de categoria selecionada por índice (substitui o dropdown global)
  Map<int, String?> categoriasPorItem = {};
  Map<int, String?> centrosCustoPorItem = {};

  /// Se true, sugestões já foram carregadas
  bool sugestoesCarregadas = false;

  ///  State fields for stateful widgets in this page.

  // State field(s) for ddContaOrigem widget.
  String? ddContaOrigemValue;
  FormFieldController<String>? ddContaOrigemValueController;
  // State field(s) for ddCategoria widget.
  String? ddCategoriaValue;
  FormFieldController<String>? ddCategoriaValueController;
  // State field(s) for ddCentroDeCusto widget.
  String? ddCentroDeCustoValue;
  FormFieldController<String>? ddCentroDeCustoValueController;
  // Stores action output result for [Custom Action - marcarDesmarcarTudo] action in IconButton widget.
  List<OfxTransactionStruct>? listaProcessada;
  // State field(s) for chkSelecao widget.
  Map<OfxTransactionStruct, bool> chkSelecaoValueMap = {};
  List<OfxTransactionStruct> get chkSelecaoCheckedItems =>
      chkSelecaoValueMap.entries
          .where((e) => e.value)
          .map((e) => e.key)
          .toList();

  // Stores action output result for [Backend Call - Query Rows] action in btnSalvar widget.
  List<TransacoesRow>? checkExistencia;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {}
}
