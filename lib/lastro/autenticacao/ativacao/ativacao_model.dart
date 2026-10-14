import '/backend/schema/structs/index.dart';
import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'ativacao_widget.dart' show AtivacaoWidget;
import 'package:flutter/material.dart';

class AtivacaoModel extends FlutterFlowModel<AtivacaoWidget> {
  ///  Local state fields for this page.

  String? nomeOrganizacao;

  String? nomeUsuario;

  String? email;

  ///  State fields for stateful widgets in this page.

  // Stores action output result for [Custom Action - getContratoB2BBySerial] action in Ativacao widget.
  DTAtivacaoSerialStruct? retOnPageDTAtivacaoSerial;
  // State field(s) for serialAtivacao widget.
  FocusNode? serialAtivacaoFocusNode;
  TextEditingController? serialAtivacaoTextController;
  String? Function(BuildContext, String?)?
      serialAtivacaoTextControllerValidator;
  // Stores action output result for [Custom Action - getContratoB2BBySerial] action in serialAtivacao widget.
  DTAtivacaoSerialStruct? retOnSubmitDTAtivacaoSerial;
  // State field(s) for nomeOrganizacao widget.
  FocusNode? nomeOrganizacaoFocusNode;
  TextEditingController? nomeOrganizacaoTextController;
  String? Function(BuildContext, String?)?
      nomeOrganizacaoTextControllerValidator;
  // State field(s) for nomeCadastro widget.
  FocusNode? nomeCadastroFocusNode;
  TextEditingController? nomeCadastroTextController;
  String? Function(BuildContext, String?)? nomeCadastroTextControllerValidator;
  // State field(s) for emailCadastro widget.
  FocusNode? emailCadastroFocusNode;
  TextEditingController? emailCadastroTextController;
  String? Function(BuildContext, String?)? emailCadastroTextControllerValidator;
  // State field(s) for senhaCadastro widget.
  FocusNode? senhaCadastroFocusNode;
  TextEditingController? senhaCadastroTextController;
  late bool senhaCadastroVisibility;
  String? Function(BuildContext, String?)? senhaCadastroTextControllerValidator;
  // State field(s) for confirmaSenha widget.
  FocusNode? confirmaSenhaFocusNode;
  TextEditingController? confirmaSenhaTextController;
  late bool confirmaSenhaVisibility;
  String? Function(BuildContext, String?)? confirmaSenhaTextControllerValidator;
  // Stores action output result for [Custom Action - createAccountSupabase] action in criarConta widget.
  String? authErrorMessage;
  // Stores action output result for [Backend Call - Update Row(s)] action in criarConta widget.
  List<ProfilesRow>? resultado;
  // Stores action output result for [Custom Action - ativarSerialCustomAction] action in criarConta widget.
  dynamic retAtivacao;

  @override
  void initState(BuildContext context) {
    senhaCadastroVisibility = false;
    confirmaSenhaVisibility = false;
  }

  @override
  void dispose() {
    serialAtivacaoFocusNode?.dispose();
    serialAtivacaoTextController?.dispose();

    nomeOrganizacaoFocusNode?.dispose();
    nomeOrganizacaoTextController?.dispose();

    nomeCadastroFocusNode?.dispose();
    nomeCadastroTextController?.dispose();

    emailCadastroFocusNode?.dispose();
    emailCadastroTextController?.dispose();

    senhaCadastroFocusNode?.dispose();
    senhaCadastroTextController?.dispose();

    confirmaSenhaFocusNode?.dispose();
    confirmaSenhaTextController?.dispose();
  }
}
