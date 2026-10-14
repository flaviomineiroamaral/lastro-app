import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/form_field_controller.dart';
import 'bs_obrigacoes_widget.dart' show BsObrigacoesWidget;
import 'package:flutter/material.dart';

class BsObrigacoesModel extends FlutterFlowModel<BsObrigacoesWidget> {
  ///  Local state fields for this component.

  String? vDescricao;

  double? vValorEstimado;

  String? vCategoriaId;

  String? vCentroResultadoId;

  String? vContaId;

  String? vPeriodicidade = 'MENSAL';

  int? vDiaVencimento;

  int? vMesVencimento;

  int vDiaAntecedencia = 20;

  bool vAtivo = true;

  ///  State fields for stateful widgets in this component.

  // State field(s) for inputDescricao widget.
  FocusNode? inputDescricaoFocusNode;
  TextEditingController? inputDescricaoTextController;
  String? Function(BuildContext, String?)?
      inputDescricaoTextControllerValidator;
  // State field(s) for ddCategoria widget.
  String? ddCategoriaValue;
  FormFieldController<String>? ddCategoriaValueController;
  // State field(s) for ddCentroDeCusto widget.
  String? ddCentroDeCustoValue;
  FormFieldController<String>? ddCentroDeCustoValueController;
  // State field(s) for ddContaOrigem widget.
  String? ddContaOrigemValue;
  FormFieldController<String>? ddContaOrigemValueController;
  // State field(s) for choTipo widget.
  FormFieldController<List<String>>? choTipoValueController;
  String? get choTipoValue => choTipoValueController?.value?.firstOrNull;
  set choTipoValue(String? val) =>
      choTipoValueController?.value = val != null ? [val] : [];
  // State field(s) for ddDia widget.
  int? ddDiaValue;
  FormFieldController<int>? ddDiaValueController;
  // State field(s) for ddMes widget.
  int? ddMesValue;
  FormFieldController<int>? ddMesValueController;
  // State field(s) for ddAntecedencia widget.
  int? ddAntecedenciaValue;
  FormFieldController<int>? ddAntecedenciaValueController;
  // State field(s) for swtStatus widget.
  bool? swtStatusValue;
  // Stores action output result for [Backend Call - Insert Row] action in btnSalvar widget.
  ObrigacoesRecorrentesRow? retInsertObrigacoes;
  // Stores action output result for [Custom Action - acionarGeradorRecorrencias] action in btnSalvar widget.
  bool? retStatusInsert;
  // Stores action output result for [Backend Call - Update Row(s)] action in btnSalvar widget.
  List<ObrigacoesRecorrentesRow>? retUpdateObrigacoes1;
  // Stores action output result for [Backend Call - Update Row(s)] action in btnSalvar widget.
  List<ObrigacoesRecorrentesRow>? retUpdateObrigacoes2;
  // Stores action output result for [Custom Action - acionarGeradorRecorrencias] action in btnSalvar widget.
  bool? retStatusUpdate;
  // Stores action output result for [Backend Call - Delete Row(s)] action in btnExcluir widget.
  List<ObrigacoesRecorrentesRow>? retDeleteObrigacoes;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    inputDescricaoFocusNode?.dispose();
    inputDescricaoTextController?.dispose();
  }
}
