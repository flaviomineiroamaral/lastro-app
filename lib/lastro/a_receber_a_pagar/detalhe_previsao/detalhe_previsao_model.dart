import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/form_field_controller.dart';
import '/index.dart';
import 'detalhe_previsao_widget.dart' show DetalhePrevisaoWidget;
import 'package:flutter/material.dart';

class DetalhePrevisaoModel extends FlutterFlowModel<DetalhePrevisaoWidget> {
  ///  Local state fields for this page.

  String? vUrlComprovante;

  DateTime? vDataPagamento;

  DateTime? vDataVencimento;

  DateTime? vDataCompetencia;

  bool mostrarAvancadas = false;

  String? vDescricaoCategoria;

  String? vIdCategoria;

  String? vIdContaOrigem;

  String? vIdCentroCusto;

  String? vIdMembro;

  String? vDescricao;

  double vValorFormulario = 0.0;

  String vTipoOperacao = 'A Pagar';

  bool? vStatus = false;

  String? vIdTransacao;

  String? vTipoConta;

  ///  State fields for stateful widgets in this page.

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
  // State field(s) for swtRecorrente widget.
  bool? swtRecorrenteValue;
  // State field(s) for chipTipoRecorrencia widget.
  FormFieldController<List<String>>? chipTipoRecorrenciaValueController;
  String? get chipTipoRecorrenciaValue =>
      chipTipoRecorrenciaValueController?.value?.firstOrNull;
  set chipTipoRecorrenciaValue(String? val) =>
      chipTipoRecorrenciaValueController?.value = val != null ? [val] : [];
  // State field(s) for contadorMeses widget.
  int? contadorMesesValue;
  // State field(s) for ddMesDeReferencia widget.
  String? ddMesDeReferenciaValue;
  FormFieldController<String>? ddMesDeReferenciaValueController;
  // State field(s) for swtManterCompFixa widget.
  bool? swtManterCompFixaValue;
  // State field(s) for swtStatus widget.
  bool? swtStatusValue;
  DateTime? datePicked2;
  // State field(s) for ddContaOrigem widget.
  String? ddContaOrigemValue;
  FormFieldController<String>? ddContaOrigemValueController;
  // State field(s) for ddCentroDeCusto widget.
  String? ddCentroDeCustoValue;
  FormFieldController<String>? ddCentroDeCustoValueController;
  // State field(s) for ddMembro widget.
  String? ddMembroValue;
  FormFieldController<String>? ddMembroValueController;
  DateTime? datePicked3;
  bool isDataUploading_outComprovanteAgendamento = false;
  FFUploadedFile uploadedLocalFile_outComprovanteAgendamento =
      FFUploadedFile(bytes: Uint8List.fromList([]), originalFilename: '');
  String uploadedFileUrl_outComprovanteAgendamento = '';

  // Stores action output result for [Custom Action - gerarLancamentosRecorrentes] action in btnSalvar widget.
  bool? bolGerarLancRecorrente;
  // Stores action output result for [Backend Call - Insert Row] action in btnSalvar widget.
  TransacoesRow? rowNovoRegistro;
  // Stores action output result for [Backend Call - Update Row(s)] action in btnSalvar widget.
  List<TransacoesRow>? rowUpdateRegistro;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    inputDescricaoFocusNode?.dispose();
    inputDescricaoTextController?.dispose();
  }
}
