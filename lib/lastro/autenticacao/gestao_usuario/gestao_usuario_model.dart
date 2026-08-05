import '/auth/supabase_auth/auth_util.dart';
import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_drop_down.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/flutter_flow/form_field_controller.dart';
import 'dart:ui';
import '/custom_code/actions/index.dart' as actions;
import '/flutter_flow/custom_functions.dart' as functions;
import 'gestao_usuario_widget.dart' show GestaoUsuarioWidget;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

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
  dynamic? resultadoRPCAddMembrer;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    txtEmailMemberFocusNode?.dispose();
    txtEmailMemberTextController?.dispose();
  }
}
