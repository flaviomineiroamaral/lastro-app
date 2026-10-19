import '/backend/api_requests/api_calls.dart';
import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'ativar_whatsapp_widget.dart' show AtivarWhatsappWidget;
import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class AtivarWhatsappModel extends FlutterFlowModel<AtivarWhatsappWidget> {
  ///  Local state fields for this page.

  bool isLoading = false;

  String? pairingCode;

  String? base64;

  String? conexaoStatus;

  ///  State fields for stateful widgets in this page.

  // State field(s) for tf_telefone widget.
  FocusNode? tfTelefoneFocusNode;
  TextEditingController? tfTelefoneTextController;
  late MaskTextInputFormatter tfTelefoneMask;
  String? Function(BuildContext, String?)? tfTelefoneTextControllerValidator;
  // Stores action output result for [Backend Call - Query Rows] action in btnGerarMeuCodigo widget.
  List<OrganizationsRow>? retOrganization;
  // Stores action output result for [Backend Call - API (CriarInstanciaPareamento)] action in btnGerarMeuCodigo widget.
  ApiCallResponse? respostaN8n;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    tfTelefoneFocusNode?.dispose();
    tfTelefoneTextController?.dispose();
  }
}
