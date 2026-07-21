import '/backend/api_requests/api_calls.dart';
import '/backend/schema/structs/index.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'importar_widget.dart' show ImportarWidget;
import 'package:flutter/material.dart';

class ImportarModel extends FlutterFlowModel<ImportarWidget> {
  ///  State fields for stateful widgets in this page.

  bool isDataUploading_arquivoOfx = false;
  FFUploadedFile uploadedLocalFile_arquivoOfx =
      FFUploadedFile(bytes: Uint8List.fromList([]), originalFilename: '');

  // Stores action output result for [Custom Action - parseOfxFile] action in ListTile widget.
  List<OfxTransactionStruct>? resultadoProcessado;
  bool isDataUploading_pdfCarregado = false;
  FFUploadedFile uploadedLocalFile_pdfCarregado =
      FFUploadedFile(bytes: Uint8List.fromList([]), originalFilename: '');

  // Stores action output result for [Custom Action - extrairTextoPDF] action in ListTile widget.
  String? textoBruto;
  // Stores action output result for [Custom Action - pdfParaBase64] action in ListTile widget.
  String? base64Gerado0;
  // Stores action output result for [Backend Call - API (LerFaturaGeminiVisual)] action in ListTile widget.
  ApiCallResponse? respostaIAVisual0;
  // Stores action output result for [Backend Call - API (LerFaturaGemini)] action in ListTile widget.
  ApiCallResponse? respostaIA;
  // Stores action output result for [Custom Action - pdfParaBase64] action in ListTile widget.
  String? base64Gerado;
  // Stores action output result for [Backend Call - API (LerFaturaGeminiVisual)] action in ListTile widget.
  ApiCallResponse? respostaIAVisual;
  bool isDataUploading_meuCsv = false;
  FFUploadedFile uploadedLocalFile_meuCsv =
      FFUploadedFile(bytes: Uint8List.fromList([]), originalFilename: '');

  DateTime? datePicked;
  // Stores action output result for [Custom Action - processarCSV] action in ListTile widget.
  List<OfxTransactionStruct>? listaDeComprasCsv;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {}
}
