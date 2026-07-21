import '/backend/schema/structs/index.dart';
import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/form_field_controller.dart';
import 'bs_detalhe_transacao_widget.dart' show BsDetalheTransacaoWidget;
import 'package:flutter/material.dart';

class BsDetalheTransacaoModel
    extends FlutterFlowModel<BsDetalheTransacaoWidget> {
  ///  Local state fields for this component.

  String? vUrlComprovante;

  DateTime? vDataPagamento;

  String? vNomeDaConta;

  DateTime? vDataVencimento;

  DateTime? vDataCompetencia;

  bool vMostrarAvancadas = false;

  String? vIdCategoria;

  String? vIdContaOrigem;

  String? vIdContaDestino;

  String? vIdCentroCusto;

  String? vIdMembro;

  String? vDescricao;

  double? vValorFormulario = 0.0;

  String vTipoOperacao = 'RECEITA';

  bool? vStatus = true;

  String? vIdTransacao;

  int? vDiaFechFatura;

  int? vDiaVencCartao;

  String? vTipoConta;

  String? vDescricaoCategoria;

  ///  State fields for stateful widgets in this component.

  // Stores action output result for [Custom Action - getDetalheTransacao] action in bs_DetalheTransacao widget.
  DTDetalheTransacaoStruct? retBSDetalheTransacao;
  // State field(s) for choTipo widget.
  FormFieldController<List<String>>? choTipoValueController;
  String? get choTipoValue => choTipoValueController?.value?.firstOrNull;
  set choTipoValue(String? val) =>
      choTipoValueController?.value = val != null ? [val] : [];
  // State field(s) for inputDescricao widget.
  FocusNode? inputDescricaoFocusNode;
  TextEditingController? inputDescricaoTextController;
  String? Function(BuildContext, String?)?
      inputDescricaoTextControllerValidator;
  // State field(s) for ddCategoria widget.
  String? ddCategoriaValue;
  FormFieldController<String>? ddCategoriaValueController;
  DateTime? datePicked1;
  // State field(s) for swtStatus widget.
  bool? swtStatusValue;
  DateTime? datePicked2;
  // State field(s) for ddContaOrigem widget.
  String? ddContaOrigemValue;
  FormFieldController<String>? ddContaOrigemValueController;
  // State field(s) for ddContaDestino widget.
  String? ddContaDestinoValue;
  FormFieldController<String>? ddContaDestinoValueController;
  // State field(s) for ddCentroDeCusto widget.
  String? ddCentroDeCustoValue;
  FormFieldController<String>? ddCentroDeCustoValueController;
  // State field(s) for ddMembro widget.
  String? ddMembroValue;
  FormFieldController<String>? ddMembroValueController;
  DateTime? datePicked3;
  bool isDataUploading_outComprovanteBS = false;
  FFUploadedFile uploadedLocalFile_outComprovanteBS =
      FFUploadedFile(bytes: Uint8List.fromList([]), originalFilename: '');
  String uploadedFileUrl_outComprovanteBS = '';

  // Stores action output result for [Backend Call - Insert Row] action in btnSalvar widget.
  TransacoesRow? retStatusInsert;
  // Stores action output result for [Backend Call - Update Row(s)] action in btnSalvar widget.
  List<TransacoesRow>? retStatusUpdate;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    inputDescricaoFocusNode?.dispose();
    inputDescricaoTextController?.dispose();
  }
}
