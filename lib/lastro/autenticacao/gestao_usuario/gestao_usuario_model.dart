import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/form_field_controller.dart';
import 'gestao_usuario_widget.dart' show GestaoUsuarioWidget;
import 'package:flutter/material.dart';

class GestaoUsuarioModel extends FlutterFlowModel<GestaoUsuarioWidget> {
  ///  State fields for stateful widgets in this page.

  // State field(s) for txtEmailMember widget.
  FocusNode? txtEmailMemberFocusNode;
  TextEditingController? txtEmailMemberTextController;
  String? Function(BuildContext, String?)?
      txtEmailMemberTextControllerValidator;
  // State field(s) for ddFuncaoMember widget.
  String? ddFuncaoMemberValue;
  FormFieldController<String>? ddFuncaoMemberValueController;
  // Stores action output result for [Custom Action - addOrganizationMemberRPC] action in bntAddMember widget.
  dynamic resultadoRPCAddMembrer;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    txtEmailMemberFocusNode?.dispose();
    txtEmailMemberTextController?.dispose();
  }
}
