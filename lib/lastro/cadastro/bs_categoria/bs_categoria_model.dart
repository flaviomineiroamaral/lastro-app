import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/form_field_controller.dart';
import 'bs_categoria_widget.dart' show BsCategoriaWidget;
import 'package:flutter/material.dart';

class BsCategoriaModel extends FlutterFlowModel<BsCategoriaWidget> {
  ///  State fields for stateful widgets in this component.

  // State field(s) for ddTipo widget.
  String? ddTipoValue;
  FormFieldController<String>? ddTipoValueController;
  // State field(s) for CodigoContabil widget.
  FocusNode? codigoContabilFocusNode;
  TextEditingController? codigoContabilTextController;
  String? Function(BuildContext, String?)?
      codigoContabilTextControllerValidator;
  // State field(s) for NomeCategoria widget.
  FocusNode? nomeCategoriaFocusNode;
  TextEditingController? nomeCategoriaTextController;
  String? Function(BuildContext, String?)? nomeCategoriaTextControllerValidator;
  // State field(s) for ddNaturezaFluxo widget.
  String? ddNaturezaFluxoValue;
  FormFieldController<String>? ddNaturezaFluxoValueController;
  // State field(s) for InstrucaoUso widget.
  FocusNode? instrucaoUsoFocusNode;
  TextEditingController? instrucaoUsoTextController;
  String? Function(BuildContext, String?)? instrucaoUsoTextControllerValidator;
  // State field(s) for swPermiteLancamento widget.
  bool? swPermiteLancamentoValue;
  // Stores action output result for [Backend Call - Query Rows] action in btnSalvar widget.
  List<PlanoContasRow>? codigosExistentes;
  // Stores action output result for [Custom Action - validarCodigoContabil] action in btnSalvar widget.
  String? erroInterface;
  // Stores action output result for [Custom Action - chamarRpcVerificarPai] action in btnSalvar widget.
  bool? paiInvalido;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    codigoContabilFocusNode?.dispose();
    codigoContabilTextController?.dispose();

    nomeCategoriaFocusNode?.dispose();
    nomeCategoriaTextController?.dispose();

    instrucaoUsoFocusNode?.dispose();
    instrucaoUsoTextController?.dispose();
  }
}
