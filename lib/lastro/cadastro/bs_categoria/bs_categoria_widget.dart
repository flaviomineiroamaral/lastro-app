import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_drop_down.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/flutter_flow/form_field_controller.dart';
import '/lastro/geral/bs_top_notificacoes/bs_top_notificacoes_widget.dart';
import 'dart:ui';
import '/custom_code/actions/index.dart' as actions;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'bs_categoria_model.dart';
export 'bs_categoria_model.dart';

class BsCategoriaWidget extends StatefulWidget {
  const BsCategoriaWidget({
    super.key,
    this.pIdCategoria,
    required this.pTipo,
    this.pCodigoContabil,
    this.pNomeCategoria,
    bool? pPermitirLancamento,
    required this.pNaturezaFluxo,
    this.pInstrucaoUso,
  }) : this.pPermitirLancamento = pPermitirLancamento ?? true;

  final String? pIdCategoria;
  final String? pTipo;
  final String? pCodigoContabil;
  final String? pNomeCategoria;
  final bool pPermitirLancamento;
  final String? pNaturezaFluxo;
  final String? pInstrucaoUso;

  @override
  State<BsCategoriaWidget> createState() => _BsCategoriaWidgetState();
}

class _BsCategoriaWidgetState extends State<BsCategoriaWidget> {
  late BsCategoriaModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => BsCategoriaModel());

    _model.codigoContabilTextController ??=
        TextEditingController(text: widget!.pCodigoContabil);
    _model.codigoContabilFocusNode ??= FocusNode();

    _model.nomeCategoriaTextController ??= TextEditingController(
        text: widget!.pIdCategoria != null && widget!.pIdCategoria != ''
            ? widget!.pNomeCategoria
            : '');
    _model.nomeCategoriaFocusNode ??= FocusNode();

    _model.instrucaoUsoTextController ??= TextEditingController(
        text: widget!.pIdCategoria != null && widget!.pIdCategoria != ''
            ? widget!.pInstrucaoUso
            : '');
    _model.instrucaoUsoFocusNode ??= FocusNode();

    _model.swPermiteLancamentoValue = widget!.pPermitirLancamento;
    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    context.watch<FFAppState>();

    return Container(
      width: double.infinity,
      height: double.infinity,
      constraints: BoxConstraints(
        maxWidth: FFAppConstants.LarguraMaxima.toDouble(),
      ),
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context).secondaryBackground,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.0),
          topRight: Radius.circular(20.0),
        ),
      ),
      child: Padding(
        padding: EdgeInsetsDirectional.fromSTEB(20.0, 20.0, 20.0, 20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Align(
              alignment: AlignmentDirectional(0.0, 1.0),
              child: Container(
                width: 40.0,
                height: 4.0,
                decoration: BoxDecoration(
                  color: FlutterFlowTheme.of(context).fundoText,
                  borderRadius: BorderRadius.circular(2.0),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(0.0, 12.0, 0.0, 0.0),
              child: Text(
                widget!.pIdCategoria == null || widget!.pIdCategoria == ''
                    ? 'Nova Categoria'
                    : 'Editar Categoria',
                textAlign: TextAlign.center,
                style: FlutterFlowTheme.of(context).bodyMedium.override(
                      font: GoogleFonts.inter(
                        fontWeight: FontWeight.w600,
                        fontStyle:
                            FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                      ),
                      fontSize: 16.0,
                      letterSpacing: 0.0,
                      fontWeight: FontWeight.w600,
                      fontStyle:
                          FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                    ),
              ),
            ),
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(6.0, 20.0, 6.0, 0.0),
              child: FlutterFlowDropDown<String>(
                controller: _model.ddTipoValueController ??=
                    FormFieldController<String>(
                  _model.ddTipoValue ??= widget!.pTipo,
                ),
                options: ['RECEITA', 'DESPESA', 'ATIVO', 'PASSIVO', 'PL'],
                onChanged: (val) =>
                    safeSetState(() => _model.ddTipoValue = val),
                width: 200.0,
                height: 40.0,
                textStyle: FlutterFlowTheme.of(context).bodyMedium.override(
                      font: GoogleFonts.inter(
                        fontWeight:
                            FlutterFlowTheme.of(context).bodyMedium.fontWeight,
                        fontStyle:
                            FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                      ),
                      letterSpacing: 0.0,
                      fontWeight:
                          FlutterFlowTheme.of(context).bodyMedium.fontWeight,
                      fontStyle:
                          FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                    ),
                hintText: 'Selecione o tipo da categoria...',
                icon: Icon(
                  Icons.keyboard_arrow_down_rounded,
                  color: FlutterFlowTheme.of(context).secondaryText,
                  size: 24.0,
                ),
                fillColor: Color(0xFF3D4449),
                elevation: 2.0,
                borderColor: Colors.transparent,
                borderWidth: 0.0,
                borderRadius: 8.0,
                margin: EdgeInsetsDirectional.fromSTEB(12.0, 0.0, 12.0, 0.0),
                hidesUnderline: true,
                disabled: true,
                isOverButton: false,
                isSearchable: false,
                isMultiSelect: false,
              ),
            ),
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(6.0, 12.0, 6.0, 0.0),
              child: Container(
                width: 200.0,
                child: TextFormField(
                  controller: _model.codigoContabilTextController,
                  focusNode: _model.codigoContabilFocusNode,
                  autofocus: false,
                  enabled: true,
                  readOnly: true,
                  obscureText: false,
                  decoration: InputDecoration(
                    isDense: true,
                    labelText: 'Código Contábil',
                    labelStyle:
                        FlutterFlowTheme.of(context).labelMedium.override(
                              font: GoogleFonts.inter(
                                fontWeight: FlutterFlowTheme.of(context)
                                    .labelMedium
                                    .fontWeight,
                                fontStyle: FlutterFlowTheme.of(context)
                                    .labelMedium
                                    .fontStyle,
                              ),
                              letterSpacing: 0.0,
                              fontWeight: FlutterFlowTheme.of(context)
                                  .labelMedium
                                  .fontWeight,
                              fontStyle: FlutterFlowTheme.of(context)
                                  .labelMedium
                                  .fontStyle,
                            ),
                    hintText: 'Digite o código contábil...',
                    hintStyle:
                        FlutterFlowTheme.of(context).labelMedium.override(
                              font: GoogleFonts.inter(
                                fontWeight: FlutterFlowTheme.of(context)
                                    .labelMedium
                                    .fontWeight,
                                fontStyle: FlutterFlowTheme.of(context)
                                    .labelMedium
                                    .fontStyle,
                              ),
                              letterSpacing: 0.0,
                              fontWeight: FlutterFlowTheme.of(context)
                                  .labelMedium
                                  .fontWeight,
                              fontStyle: FlutterFlowTheme.of(context)
                                  .labelMedium
                                  .fontStyle,
                            ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Color(0x00000000),
                        width: 1.0,
                      ),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Color(0x00000000),
                        width: 1.0,
                      ),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: FlutterFlowTheme.of(context).error,
                        width: 1.0,
                      ),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: FlutterFlowTheme.of(context).error,
                        width: 1.0,
                      ),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    filled: true,
                    fillColor: FlutterFlowTheme.of(context).fundoText,
                  ),
                  style: FlutterFlowTheme.of(context).bodyMedium.override(
                        font: GoogleFonts.inter(
                          fontWeight: FlutterFlowTheme.of(context)
                              .bodyMedium
                              .fontWeight,
                          fontStyle:
                              FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                        ),
                        letterSpacing: 0.0,
                        fontWeight:
                            FlutterFlowTheme.of(context).bodyMedium.fontWeight,
                        fontStyle:
                            FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                      ),
                  maxLines: null,
                  cursorColor: FlutterFlowTheme.of(context).primaryText,
                  enableInteractiveSelection: true,
                  validator: _model.codigoContabilTextControllerValidator
                      .asValidator(context),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(6.0, 12.0, 6.0, 0.0),
              child: Container(
                width: 200.0,
                child: TextFormField(
                  controller: _model.nomeCategoriaTextController,
                  focusNode: _model.nomeCategoriaFocusNode,
                  autofocus: false,
                  enabled: true,
                  obscureText: false,
                  decoration: InputDecoration(
                    isDense: true,
                    labelText: 'Descrição da Categoria',
                    labelStyle:
                        FlutterFlowTheme.of(context).labelMedium.override(
                              font: GoogleFonts.inter(
                                fontWeight: FlutterFlowTheme.of(context)
                                    .labelMedium
                                    .fontWeight,
                                fontStyle: FlutterFlowTheme.of(context)
                                    .labelMedium
                                    .fontStyle,
                              ),
                              letterSpacing: 0.0,
                              fontWeight: FlutterFlowTheme.of(context)
                                  .labelMedium
                                  .fontWeight,
                              fontStyle: FlutterFlowTheme.of(context)
                                  .labelMedium
                                  .fontStyle,
                            ),
                    hintText: 'Digite o nome da categoria...',
                    hintStyle:
                        FlutterFlowTheme.of(context).labelMedium.override(
                              font: GoogleFonts.inter(
                                fontWeight: FlutterFlowTheme.of(context)
                                    .labelMedium
                                    .fontWeight,
                                fontStyle: FlutterFlowTheme.of(context)
                                    .labelMedium
                                    .fontStyle,
                              ),
                              letterSpacing: 0.0,
                              fontWeight: FlutterFlowTheme.of(context)
                                  .labelMedium
                                  .fontWeight,
                              fontStyle: FlutterFlowTheme.of(context)
                                  .labelMedium
                                  .fontStyle,
                            ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Color(0x00000000),
                        width: 1.0,
                      ),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Color(0x00000000),
                        width: 1.0,
                      ),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: FlutterFlowTheme.of(context).error,
                        width: 1.0,
                      ),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: FlutterFlowTheme.of(context).error,
                        width: 1.0,
                      ),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    filled: true,
                    fillColor: FlutterFlowTheme.of(context).fundoText,
                  ),
                  style: FlutterFlowTheme.of(context).bodyMedium.override(
                        font: GoogleFonts.inter(
                          fontWeight: FlutterFlowTheme.of(context)
                              .bodyMedium
                              .fontWeight,
                          fontStyle:
                              FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                        ),
                        letterSpacing: 0.0,
                        fontWeight:
                            FlutterFlowTheme.of(context).bodyMedium.fontWeight,
                        fontStyle:
                            FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                      ),
                  cursorColor: FlutterFlowTheme.of(context).primaryText,
                  enableInteractiveSelection: true,
                  validator: _model.nomeCategoriaTextControllerValidator
                      .asValidator(context),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(6.0, 12.0, 6.0, 0.0),
              child: FlutterFlowDropDown<String>(
                controller: _model.ddNaturezaFluxoValueController ??=
                    FormFieldController<String>(
                  _model.ddNaturezaFluxoValue ??=
                      widget!.pIdCategoria != null && widget!.pIdCategoria != ''
                          ? widget!.pNaturezaFluxo
                          : '',
                ),
                options: ['ENTRADA', 'SAIDA'],
                onChanged: (val) =>
                    safeSetState(() => _model.ddNaturezaFluxoValue = val),
                width: 200.0,
                height: 40.0,
                textStyle: FlutterFlowTheme.of(context).bodyMedium.override(
                      font: GoogleFonts.inter(
                        fontWeight:
                            FlutterFlowTheme.of(context).bodyMedium.fontWeight,
                        fontStyle:
                            FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                      ),
                      letterSpacing: 0.0,
                      fontWeight:
                          FlutterFlowTheme.of(context).bodyMedium.fontWeight,
                      fontStyle:
                          FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                    ),
                hintText: 'Selecione a natureza do fluxo...',
                icon: Icon(
                  Icons.keyboard_arrow_down_rounded,
                  color: FlutterFlowTheme.of(context).secondaryText,
                  size: 24.0,
                ),
                fillColor: Color(0xFF3D4449),
                elevation: 2.0,
                borderColor: Colors.transparent,
                borderWidth: 0.0,
                borderRadius: 8.0,
                margin: EdgeInsetsDirectional.fromSTEB(12.0, 0.0, 12.0, 0.0),
                hidesUnderline: true,
                isOverButton: false,
                isSearchable: false,
                isMultiSelect: false,
              ),
            ),
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(6.0, 12.0, 6.0, 0.0),
              child: Container(
                width: 200.0,
                child: TextFormField(
                  controller: _model.instrucaoUsoTextController,
                  focusNode: _model.instrucaoUsoFocusNode,
                  autofocus: false,
                  enabled: true,
                  obscureText: false,
                  decoration: InputDecoration(
                    isDense: true,
                    labelText: 'Instrução de Uso',
                    labelStyle:
                        FlutterFlowTheme.of(context).labelMedium.override(
                              font: GoogleFonts.inter(
                                fontWeight: FlutterFlowTheme.of(context)
                                    .labelMedium
                                    .fontWeight,
                                fontStyle: FlutterFlowTheme.of(context)
                                    .labelMedium
                                    .fontStyle,
                              ),
                              letterSpacing: 0.0,
                              fontWeight: FlutterFlowTheme.of(context)
                                  .labelMedium
                                  .fontWeight,
                              fontStyle: FlutterFlowTheme.of(context)
                                  .labelMedium
                                  .fontStyle,
                            ),
                    hintText: 'Digite a instrução de quando usar...',
                    hintStyle:
                        FlutterFlowTheme.of(context).labelMedium.override(
                              font: GoogleFonts.inter(
                                fontWeight: FlutterFlowTheme.of(context)
                                    .labelMedium
                                    .fontWeight,
                                fontStyle: FlutterFlowTheme.of(context)
                                    .labelMedium
                                    .fontStyle,
                              ),
                              letterSpacing: 0.0,
                              fontWeight: FlutterFlowTheme.of(context)
                                  .labelMedium
                                  .fontWeight,
                              fontStyle: FlutterFlowTheme.of(context)
                                  .labelMedium
                                  .fontStyle,
                            ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Color(0x00000000),
                        width: 1.0,
                      ),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Color(0x00000000),
                        width: 1.0,
                      ),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: FlutterFlowTheme.of(context).error,
                        width: 1.0,
                      ),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: FlutterFlowTheme.of(context).error,
                        width: 1.0,
                      ),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    filled: true,
                    fillColor: FlutterFlowTheme.of(context).fundoText,
                  ),
                  style: FlutterFlowTheme.of(context).bodyMedium.override(
                        font: GoogleFonts.inter(
                          fontWeight: FlutterFlowTheme.of(context)
                              .bodyMedium
                              .fontWeight,
                          fontStyle:
                              FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                        ),
                        letterSpacing: 0.0,
                        fontWeight:
                            FlutterFlowTheme.of(context).bodyMedium.fontWeight,
                        fontStyle:
                            FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                      ),
                  maxLines: 6,
                  cursorColor: FlutterFlowTheme.of(context).primaryText,
                  enableInteractiveSelection: true,
                  validator: _model.instrucaoUsoTextControllerValidator
                      .asValidator(context),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(8.0, 12.0, 0.0, 0.0),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(4.0, 0.0, 0.0, 0.0),
                    child: Text(
                      'Permite lançamento',
                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                            font: GoogleFonts.inter(
                              fontWeight: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .fontWeight,
                              fontStyle: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .fontStyle,
                            ),
                            letterSpacing: 0.0,
                            fontWeight: FlutterFlowTheme.of(context)
                                .bodyMedium
                                .fontWeight,
                            fontStyle: FlutterFlowTheme.of(context)
                                .bodyMedium
                                .fontStyle,
                          ),
                    ),
                  ),
                  Padding(
                    padding:
                        EdgeInsetsDirectional.fromSTEB(4.0, 12.0, 0.0, 0.0),
                    child: Switch.adaptive(
                      value: _model.swPermiteLancamentoValue!,
                      onChanged: (newValue) async {
                        safeSetState(
                            () => _model.swPermiteLancamentoValue = newValue!);
                      },
                      activeColor: FlutterFlowTheme.of(context).primary,
                      activeTrackColor: FlutterFlowTheme.of(context).fundoText,
                      inactiveTrackColor: FlutterFlowTheme.of(context).primary,
                      inactiveThumbColor:
                          FlutterFlowTheme.of(context).fundoText,
                    ),
                  ),
                ],
              ),
            ),
            Builder(
              builder: (context) => Padding(
                padding: EdgeInsetsDirectional.fromSTEB(12.0, 12.0, 12.0, 0.0),
                child: FFButtonWidget(
                  onPressed: () async {
                    var _shouldSetState = false;
                    if ((_model.ddTipoValue == null ||
                            _model.ddTipoValue == '') &&
                        (_model.nomeCategoriaTextController.text == null ||
                            _model.nomeCategoriaTextController.text == '') &&
                        (_model.codigoContabilTextController.text == null ||
                            _model.codigoContabilTextController.text == '')) {
                      await showDialog(
                        context: context,
                        builder: (dialogContext) {
                          return Dialog(
                            elevation: 0,
                            insetPadding: EdgeInsets.zero,
                            backgroundColor: Colors.transparent,
                            alignment: AlignmentDirectional(-1.0, 0.0)
                                .resolve(Directionality.of(context)),
                            child: BsTopNotificacoesWidget(
                              pTipo: 'ERRO',
                              pMensagem: 'Preencha dos os campos!',
                            ),
                          );
                        },
                      );

                      if (_shouldSetState) safeSetState(() {});
                      return;
                    } else {
                      if (widget!.pIdCategoria != null &&
                          widget!.pIdCategoria != '') {
                        await PlanoContasTable().update(
                          data: {
                            'nome': _model.nomeCategoriaTextController.text,
                            'permite_lancamento':
                                _model.swPermiteLancamentoValue,
                            'natureza_fluxo': _model.ddNaturezaFluxoValue,
                            'instrucao_uso':
                                _model.instrucaoUsoTextController.text,
                          },
                          matchingRows: (rows) => rows
                              .eqOrNull(
                                'id',
                                widget!.pIdCategoria,
                              )
                              .eqOrNull(
                                'organization_id',
                                FFAppState().currentOrganizationId,
                              ),
                        );
                        await showDialog(
                          context: context,
                          builder: (dialogContext) {
                            return Dialog(
                              elevation: 0,
                              insetPadding: EdgeInsets.zero,
                              backgroundColor: Colors.transparent,
                              alignment: AlignmentDirectional(-1.0, 0.0)
                                  .resolve(Directionality.of(context)),
                              child: BsTopNotificacoesWidget(
                                pTipo: 'SUCESSO',
                                pMensagem: 'Categoria atualizada com sucesso!',
                              ),
                            );
                          },
                        );
                      } else {
                        _model.codigosExistentes =
                            await PlanoContasTable().queryRows(
                          queryFn: (q) => q
                              .eqOrNull(
                                'organization_id',
                                FFAppState().currentOrganizationId,
                              )
                              .order('codigo_contabil', ascending: true),
                        );
                        _shouldSetState = true;
                        _model.erroInterface =
                            await actions.validarCodigoContabil(
                          _model.codigoContabilTextController.text,
                          _model.ddTipoValue!,
                          _model.codigosExistentes!
                              .map((e) => e.codigoContabil)
                              .toList(),
                        );
                        _shouldSetState = true;
                        if (_model.erroInterface != null &&
                            _model.erroInterface != '') {
                          await showDialog(
                            context: context,
                            builder: (dialogContext) {
                              return Dialog(
                                elevation: 0,
                                insetPadding: EdgeInsets.zero,
                                backgroundColor: Colors.transparent,
                                alignment: AlignmentDirectional(-1.0, 0.0)
                                    .resolve(Directionality.of(context)),
                                child: BsTopNotificacoesWidget(
                                  pTipo: 'ERRO',
                                  pMensagem: _model.erroInterface,
                                ),
                              );
                            },
                          );

                          if (_shouldSetState) safeSetState(() {});
                          return;
                        } else {
                          _model.paiInvalido =
                              await actions.chamarRpcVerificarPai(
                            FFAppState().currentOrganizationId,
                            _model.codigoContabilTextController.text,
                          );
                          _shouldSetState = true;
                          if (_model.paiInvalido == true) {
                            await showDialog(
                              context: context,
                              builder: (dialogContext) {
                                return Dialog(
                                  elevation: 0,
                                  insetPadding: EdgeInsets.zero,
                                  backgroundColor: Colors.transparent,
                                  alignment: AlignmentDirectional(-1.0, 0.0)
                                      .resolve(Directionality.of(context)),
                                  child: BsTopNotificacoesWidget(
                                    pTipo: 'ERRO',
                                    pMensagem:
                                        'O grupo Pai já possui lançamentos...',
                                  ),
                                );
                              },
                            );

                            if (_shouldSetState) safeSetState(() {});
                            return;
                          } else {
                            await PlanoContasTable().insert({
                              'organization_id':
                                  FFAppState().currentOrganizationId,
                              'codigo_contabil':
                                  _model.codigoContabilTextController.text,
                              'nome': _model.nomeCategoriaTextController.text,
                              'permite_lancamento':
                                  _model.swPermiteLancamentoValue,
                              'tipo': _model.ddTipoValue,
                              'natureza_fluxo': _model.ddNaturezaFluxoValue,
                              'instrucao_uso':
                                  _model.instrucaoUsoTextController.text,
                            });
                            await showDialog(
                              context: context,
                              builder: (dialogContext) {
                                return Dialog(
                                  elevation: 0,
                                  insetPadding: EdgeInsets.zero,
                                  backgroundColor: Colors.transparent,
                                  alignment: AlignmentDirectional(-1.0, 0.0)
                                      .resolve(Directionality.of(context)),
                                  child: BsTopNotificacoesWidget(
                                    pTipo: 'SUCESSO',
                                    pMensagem: 'Categoria criada com sucesso!',
                                  ),
                                );
                              },
                            );
                          }
                        }
                      }

                      await actions.syncMasterCache(
                        FFAppState().currentOrganizationId,
                        true,
                        false,
                        false,
                        false,
                      );
                      Navigator.pop(context);
                      if (_shouldSetState) safeSetState(() {});
                      return;
                    }

                    if (_shouldSetState) safeSetState(() {});
                  },
                  text: 'Salvar',
                  icon: Icon(
                    Icons.save,
                    size: 15.0,
                  ),
                  options: FFButtonOptions(
                    height: 40.0,
                    padding:
                        EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 16.0, 0.0),
                    iconPadding:
                        EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                    color: FlutterFlowTheme.of(context).primary,
                    textStyle: FlutterFlowTheme.of(context).titleSmall.override(
                          font: GoogleFonts.interTight(
                            fontWeight: FlutterFlowTheme.of(context)
                                .titleSmall
                                .fontWeight,
                            fontStyle: FlutterFlowTheme.of(context)
                                .titleSmall
                                .fontStyle,
                          ),
                          color: Colors.white,
                          letterSpacing: 0.0,
                          fontWeight: FlutterFlowTheme.of(context)
                              .titleSmall
                              .fontWeight,
                          fontStyle:
                              FlutterFlowTheme.of(context).titleSmall.fontStyle,
                        ),
                    elevation: 0.0,
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
