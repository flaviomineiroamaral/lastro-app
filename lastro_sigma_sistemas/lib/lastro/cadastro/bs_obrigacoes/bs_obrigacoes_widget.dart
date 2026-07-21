import '/backend/schema/structs/index.dart';
import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_choice_chips.dart';
import '/flutter_flow/flutter_flow_drop_down.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/flutter_flow/form_field_controller.dart';
import '/lastro/geral/bs_top_notificacoes/bs_top_notificacoes_widget.dart';
import '/custom_code/actions/index.dart' as actions;
import '/custom_code/widgets/index.dart' as custom_widgets;
import '/flutter_flow/custom_functions.dart' as functions;
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'bs_obrigacoes_model.dart';
export 'bs_obrigacoes_model.dart';

class BsObrigacoesWidget extends StatefulWidget {
  const BsObrigacoesWidget({
    super.key,
    required this.pIdObrigacao,
    this.pItemDadosObrigacoes,
  });

  final String? pIdObrigacao;
  final DTObrigacaoRecorrenteStruct? pItemDadosObrigacoes;

  @override
  State<BsObrigacoesWidget> createState() => _BsObrigacoesWidgetState();
}

class _BsObrigacoesWidgetState extends State<BsObrigacoesWidget> {
  late BsObrigacoesModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => BsObrigacoesModel());

    // On component load action.
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      if (widget.pIdObrigacao != null && widget.pIdObrigacao != '') {
        _model.vDescricao = widget.pItemDadosObrigacoes?.descricao;
        _model.vValorEstimado = widget.pItemDadosObrigacoes?.valorEstimado;
        _model.vCategoriaId = widget.pItemDadosObrigacoes?.categoriaId;
        _model.vCentroResultadoId = widget.pItemDadosObrigacoes?.centroCustoId;
        _model.vContaId = widget.pItemDadosObrigacoes?.contaBancariaId;
        _model.vPeriodicidade = widget.pItemDadosObrigacoes?.periodicidade;
        _model.vDiaVencimento = widget.pItemDadosObrigacoes?.diaVencimento;
        _model.vMesVencimento = widget.pItemDadosObrigacoes?.mesVencimento;
        _model.vDiaAntecedencia =
            widget.pItemDadosObrigacoes!.diasAntecedencia;
        _model.vAtivo = widget.pItemDadosObrigacoes!.ativo;
        safeSetState(() {});
        safeSetState(() {
          _model.inputDescricaoTextController?.text =
              widget.pItemDadosObrigacoes!.descricao;
        });
        safeSetState(() {
          _model.ddCategoriaValueController?.value =
              widget.pItemDadosObrigacoes!.categoriaId;
          _model.ddCategoriaValue = widget.pItemDadosObrigacoes!.categoriaId;
        });
        safeSetState(() {
          _model.ddCentroDeCustoValueController?.value =
              widget.pItemDadosObrigacoes!.centroCustoId;
          _model.ddCentroDeCustoValue =
              widget.pItemDadosObrigacoes!.centroCustoId;
        });
        safeSetState(() {
          _model.ddContaOrigemValueController?.value =
              widget.pItemDadosObrigacoes!.contaBancariaId;
          _model.ddContaOrigemValue =
              widget.pItemDadosObrigacoes!.contaBancariaId;
        });
        safeSetState(() {
          _model.choTipoValueController?.value = [
            widget.pItemDadosObrigacoes!.periodicidade
          ];
        });
        safeSetState(() {
          _model.ddDiaValueController?.value =
              widget.pItemDadosObrigacoes!.diaVencimento;
          _model.ddDiaValue = widget.pItemDadosObrigacoes!.diaVencimento;
        });
        safeSetState(() {
          _model.ddMesValueController?.value =
              widget.pItemDadosObrigacoes!.mesVencimento;
          _model.ddMesValue = widget.pItemDadosObrigacoes!.mesVencimento;
        });
        safeSetState(() {
          _model.ddAntecedenciaValueController?.value =
              widget.pItemDadosObrigacoes!.diasAntecedencia;
          _model.ddAntecedenciaValue =
              widget.pItemDadosObrigacoes!.diasAntecedencia;
        });
        safeSetState(() {
          _model.swtStatusValue = widget.pItemDadosObrigacoes!.ativo;
        });
        return;
      } else {
        _model.vDiaVencimento = 1;
        _model.vDiaAntecedencia = 20;
        safeSetState(() {});
        safeSetState(() {
          _model.ddDiaValueController?.value = 1;
          _model.ddDiaValue = 1;
        });
        return;
      }
    });

    _model.inputDescricaoTextController ??=
        TextEditingController(text: _model.vDescricao);
    _model.inputDescricaoFocusNode ??= FocusNode();

    _model.swtStatusValue = _model.vAtivo;
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

    return Align(
      alignment: AlignmentDirectional(0.0, 1.0),
      child: Container(
        width: double.infinity,
        constraints: BoxConstraints(
          maxWidth: FFAppConstants.LarguraMaxima.toDouble(),
        ),
        decoration: BoxDecoration(
          color: FlutterFlowTheme.of(context).primaryBackground,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20.0),
            topRight: Radius.circular(20.0),
          ),
        ),
        child: Padding(
          padding: EdgeInsetsDirectional.fromSTEB(20.0, 20.0, 20.0, 40.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.max,
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
                Align(
                  alignment: AlignmentDirectional(0.0, 1.0),
                  child: Padding(
                    padding:
                        EdgeInsetsDirectional.fromSTEB(0.0, 20.0, 0.0, 20.0),
                    child: Container(
                      width: double.infinity,
                      height: 30.0,
                      decoration: BoxDecoration(
                        color: FlutterFlowTheme.of(context).primaryBackground,
                        borderRadius: BorderRadius.circular(0.0),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          InkWell(
                            splashColor: Colors.transparent,
                            focusColor: Colors.transparent,
                            hoverColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            onTap: () async {
                              Navigator.pop(context);
                            },
                            child: Icon(
                              Icons.arrow_back,
                              color: FlutterFlowTheme.of(context).primaryText,
                              size: 30.0,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(
                                20.0, 0.0, 0.0, 0.0),
                            child: Text(
                              widget.pIdObrigacao == null ||
                                      widget.pIdObrigacao == ''
                                  ? 'Nova Obrigação'
                                  : 'Editar Obrigação',
                              style: FlutterFlowTheme.of(context)
                                  .headlineMedium
                                  .override(
                                    font: GoogleFonts.interTight(
                                      fontWeight: FlutterFlowTheme.of(context)
                                          .headlineMedium
                                          .fontWeight,
                                      fontStyle: FlutterFlowTheme.of(context)
                                          .headlineMedium
                                          .fontStyle,
                                    ),
                                    color: FlutterFlowTheme.of(context)
                                        .primaryText,
                                    fontSize: 22.0,
                                    letterSpacing: 0.0,
                                    fontWeight: FlutterFlowTheme.of(context)
                                        .headlineMedium
                                        .fontWeight,
                                    fontStyle: FlutterFlowTheme.of(context)
                                        .headlineMedium
                                        .fontStyle,
                                  ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 12.0),
                  child: Container(
                    width: double.infinity,
                    height: 160.0,
                    decoration: BoxDecoration(
                      color: FlutterFlowTheme.of(context).secondaryBackground,
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(12.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(
                                4.0, 0.0, 0.0, 6.0),
                            child: Text(
                              'Descrição da Obrigação',
                              style: FlutterFlowTheme.of(context)
                                  .labelMedium
                                  .override(
                                    font: GoogleFonts.inter(
                                      fontWeight: FlutterFlowTheme.of(context)
                                          .labelMedium
                                          .fontWeight,
                                      fontStyle: FlutterFlowTheme.of(context)
                                          .labelMedium
                                          .fontStyle,
                                    ),
                                    color: FlutterFlowTheme.of(context)
                                        .secondaryText,
                                    letterSpacing: 0.0,
                                    fontWeight: FlutterFlowTheme.of(context)
                                        .labelMedium
                                        .fontWeight,
                                    fontStyle: FlutterFlowTheme.of(context)
                                        .labelMedium
                                        .fontStyle,
                                  ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(
                                0.0, 0.0, 0.0, 6.0),
                            child: Container(
                              width: 200.0,
                              child: TextFormField(
                                controller: _model.inputDescricaoTextController,
                                focusNode: _model.inputDescricaoFocusNode,
                                onChanged: (_) => EasyDebounce.debounce(
                                  '_model.inputDescricaoTextController',
                                  Duration(milliseconds: 2000),
                                  () async {
                                    _model.vDescricao = _model
                                        .inputDescricaoTextController.text;
                                    safeSetState(() {});
                                  },
                                ),
                                autofocus: false,
                                enabled: true,
                                obscureText: false,
                                decoration: InputDecoration(
                                  isDense: true,
                                  labelStyle: FlutterFlowTheme.of(context)
                                      .labelMedium
                                      .override(
                                        font: GoogleFonts.inter(
                                          fontWeight:
                                              FlutterFlowTheme.of(context)
                                                  .labelMedium
                                                  .fontWeight,
                                          fontStyle:
                                              FlutterFlowTheme.of(context)
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
                                  alignLabelWithHint: true,
                                  hintText: 'Digite aqui suas contas fixas...',
                                  hintStyle: FlutterFlowTheme.of(context)
                                      .labelMedium
                                      .override(
                                        font: GoogleFonts.inter(
                                          fontWeight:
                                              FlutterFlowTheme.of(context)
                                                  .labelMedium
                                                  .fontWeight,
                                          fontStyle:
                                              FlutterFlowTheme.of(context)
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
                                  fillColor: FlutterFlowTheme.of(context)
                                      .primaryBackground,
                                  prefixIcon: Icon(
                                    Icons.description_outlined,
                                    color: FlutterFlowTheme.of(context).primary,
                                  ),
                                ),
                                style: FlutterFlowTheme.of(context)
                                    .bodyMedium
                                    .override(
                                      font: GoogleFonts.inter(
                                        fontWeight: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .fontWeight,
                                        fontStyle: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .fontStyle,
                                      ),
                                      color: FlutterFlowTheme.of(context)
                                          .secondaryText,
                                      letterSpacing: 0.0,
                                      fontWeight: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .fontWeight,
                                      fontStyle: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .fontStyle,
                                    ),
                                cursorColor:
                                    FlutterFlowTheme.of(context).primaryText,
                                enableInteractiveSelection: true,
                                validator: _model
                                    .inputDescricaoTextControllerValidator
                                    .asValidator(context),
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(
                                4.0, 0.0, 0.0, 6.0),
                            child: Text(
                              'Valor (R\$)',
                              style: FlutterFlowTheme.of(context)
                                  .labelMedium
                                  .override(
                                    font: GoogleFonts.inter(
                                      fontWeight: FlutterFlowTheme.of(context)
                                          .labelMedium
                                          .fontWeight,
                                      fontStyle: FlutterFlowTheme.of(context)
                                          .labelMedium
                                          .fontStyle,
                                    ),
                                    color: FlutterFlowTheme.of(context)
                                        .secondaryText,
                                    letterSpacing: 0.0,
                                    fontWeight: FlutterFlowTheme.of(context)
                                        .labelMedium
                                        .fontWeight,
                                    fontStyle: FlutterFlowTheme.of(context)
                                        .labelMedium
                                        .fontStyle,
                                  ),
                            ),
                          ),
                          Container(
                            width: 100.0,
                            height: 40.0,
                            child: custom_widgets.CampoMoedaNubank(
                              width: 100.0,
                              height: 40.0,
                              tamanhoFonte: 14.0,
                              corTexto:
                                  FlutterFlowTheme.of(context).secondaryText,
                              corFundo: FlutterFlowTheme.of(context)
                                  .primaryBackground,
                              corBorda: FlutterFlowTheme.of(context)
                                  .secondaryBackground,
                              arredondamento: 8.0,
                              centralizarTexto: false,
                              valorInicial: _model.vValorEstimado,
                              acaoAoMudar: (valorDigitado) async {
                                _model.vValorEstimado = valorDigitado;
                                safeSetState(() {});
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 12.0),
                  child: Container(
                    width: double.infinity,
                    height: 210.0,
                    decoration: BoxDecoration(
                      color: FlutterFlowTheme.of(context).secondaryBackground,
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(12.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(
                                4.0, 0.0, 0.0, 6.0),
                            child: Text(
                              'Categoria',
                              style: FlutterFlowTheme.of(context)
                                  .labelMedium
                                  .override(
                                    font: GoogleFonts.inter(
                                      fontWeight: FlutterFlowTheme.of(context)
                                          .labelMedium
                                          .fontWeight,
                                      fontStyle: FlutterFlowTheme.of(context)
                                          .labelMedium
                                          .fontStyle,
                                    ),
                                    color: FlutterFlowTheme.of(context)
                                        .secondaryText,
                                    letterSpacing: 0.0,
                                    fontWeight: FlutterFlowTheme.of(context)
                                        .labelMedium
                                        .fontWeight,
                                    fontStyle: FlutterFlowTheme.of(context)
                                        .labelMedium
                                        .fontStyle,
                                  ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(
                                0.0, 0.0, 0.0, 6.0),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: FlutterFlowDropDown<String>(
                                    controller:
                                        _model.ddCategoriaValueController ??=
                                            FormFieldController<String>(
                                      _model.ddCategoriaValue ??=
                                          _model.vCategoriaId,
                                    ),
                                    options: List<String>.from(FFAppState()
                                        .cachePlanoContas
                                        .where((e) =>
                                            (e.permiteLancamento == true) &&
                                            (e.naturezaFluxo == 'SAIDA'))
                                        .toList()
                                        .map((e) => e.id)
                                        .toList()),
                                    optionLabels: functions
                                        .formatarDropdownContas(FFAppState()
                                            .cachePlanoContas
                                            .where((e) =>
                                                (e.permiteLancamento == true) &&
                                                (e.naturezaFluxo == 'SAIDA'))
                                            .toList()),
                                    onChanged: (val) async {
                                      safeSetState(
                                          () => _model.ddCategoriaValue = val);
                                      _model.vCategoriaId =
                                          _model.ddCategoriaValue;
                                      safeSetState(() {});
                                    },
                                    width: 200.0,
                                    height: 35.0,
                                    textStyle: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .override(
                                          font: GoogleFonts.inter(
                                            fontWeight:
                                                FlutterFlowTheme.of(context)
                                                    .bodyMedium
                                                    .fontWeight,
                                            fontStyle:
                                                FlutterFlowTheme.of(context)
                                                    .bodyMedium
                                                    .fontStyle,
                                          ),
                                          color: FlutterFlowTheme.of(context)
                                              .secondaryText,
                                          letterSpacing: 0.0,
                                          fontWeight:
                                              FlutterFlowTheme.of(context)
                                                  .bodyMedium
                                                  .fontWeight,
                                          fontStyle:
                                              FlutterFlowTheme.of(context)
                                                  .bodyMedium
                                                  .fontStyle,
                                        ),
                                    hintText: 'Selecione a categoria...',
                                    icon: Icon(
                                      Icons.keyboard_arrow_down_rounded,
                                      color: FlutterFlowTheme.of(context)
                                          .secondaryText,
                                      size: 24.0,
                                    ),
                                    fillColor: FlutterFlowTheme.of(context)
                                        .primaryBackground,
                                    elevation: 2.0,
                                    borderColor: Colors.transparent,
                                    borderWidth: 0.0,
                                    borderRadius: 8.0,
                                    margin: EdgeInsetsDirectional.fromSTEB(
                                        12.0, 0.0, 12.0, 0.0),
                                    hidesUnderline: true,
                                    isOverButton: false,
                                    isSearchable: false,
                                    isMultiSelect: false,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(
                                4.0, 0.0, 0.0, 6.0),
                            child: Text(
                              'Centro de Custo',
                              style: FlutterFlowTheme.of(context)
                                  .labelMedium
                                  .override(
                                    font: GoogleFonts.inter(
                                      fontWeight: FlutterFlowTheme.of(context)
                                          .labelMedium
                                          .fontWeight,
                                      fontStyle: FlutterFlowTheme.of(context)
                                          .labelMedium
                                          .fontStyle,
                                    ),
                                    color: FlutterFlowTheme.of(context)
                                        .secondaryText,
                                    letterSpacing: 0.0,
                                    fontWeight: FlutterFlowTheme.of(context)
                                        .labelMedium
                                        .fontWeight,
                                    fontStyle: FlutterFlowTheme.of(context)
                                        .labelMedium
                                        .fontStyle,
                                  ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(
                                0.0, 0.0, 0.0, 6.0),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: FlutterFlowDropDown<String>(
                                    controller: _model
                                            .ddCentroDeCustoValueController ??=
                                        FormFieldController<String>(
                                      _model.ddCentroDeCustoValue ??=
                                          _model.vCentroResultadoId,
                                    ),
                                    options: List<String>.from(FFAppState()
                                        .cacheCentrosDeResultado
                                        .where((e) => e.ativo == true)
                                        .toList()
                                        .map((e) => e.id)
                                        .toList()),
                                    optionLabels: FFAppState()
                                        .cacheCentrosDeResultado
                                        .where((e) => e.ativo == true)
                                        .toList()
                                        .map((e) => e.nome)
                                        .toList(),
                                    onChanged: (val) async {
                                      safeSetState(() =>
                                          _model.ddCentroDeCustoValue = val);
                                      _model.vCentroResultadoId =
                                          _model.ddCentroDeCustoValue == null ||
                                                  _model.ddCentroDeCustoValue ==
                                                      ''
                                              ? null
                                              : _model.ddCentroDeCustoValue;
                                      safeSetState(() {});
                                    },
                                    width: 200.0,
                                    height: 35.0,
                                    textStyle: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .override(
                                          font: GoogleFonts.inter(
                                            fontWeight:
                                                FlutterFlowTheme.of(context)
                                                    .bodyMedium
                                                    .fontWeight,
                                            fontStyle:
                                                FlutterFlowTheme.of(context)
                                                    .bodyMedium
                                                    .fontStyle,
                                          ),
                                          color: FlutterFlowTheme.of(context)
                                              .secondaryText,
                                          letterSpacing: 0.0,
                                          fontWeight:
                                              FlutterFlowTheme.of(context)
                                                  .bodyMedium
                                                  .fontWeight,
                                          fontStyle:
                                              FlutterFlowTheme.of(context)
                                                  .bodyMedium
                                                  .fontStyle,
                                        ),
                                    hintText: 'Selecione o centro de custo...',
                                    icon: Icon(
                                      Icons.keyboard_arrow_down_rounded,
                                      color: FlutterFlowTheme.of(context)
                                          .secondaryText,
                                      size: 24.0,
                                    ),
                                    fillColor: FlutterFlowTheme.of(context)
                                        .primaryBackground,
                                    elevation: 2.0,
                                    borderColor: Colors.transparent,
                                    borderWidth: 0.0,
                                    borderRadius: 8.0,
                                    margin: EdgeInsetsDirectional.fromSTEB(
                                        12.0, 0.0, 12.0, 0.0),
                                    hidesUnderline: true,
                                    isOverButton: false,
                                    isSearchable: false,
                                    isMultiSelect: false,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(
                                4.0, 0.0, 0.0, 6.0),
                            child: Text(
                              'Conta Corrente',
                              style: FlutterFlowTheme.of(context)
                                  .labelMedium
                                  .override(
                                    font: GoogleFonts.inter(
                                      fontWeight: FlutterFlowTheme.of(context)
                                          .labelMedium
                                          .fontWeight,
                                      fontStyle: FlutterFlowTheme.of(context)
                                          .labelMedium
                                          .fontStyle,
                                    ),
                                    color: FlutterFlowTheme.of(context)
                                        .secondaryText,
                                    letterSpacing: 0.0,
                                    fontWeight: FlutterFlowTheme.of(context)
                                        .labelMedium
                                        .fontWeight,
                                    fontStyle: FlutterFlowTheme.of(context)
                                        .labelMedium
                                        .fontStyle,
                                  ),
                            ),
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: FlutterFlowDropDown<String>(
                                  controller:
                                      _model.ddContaOrigemValueController ??=
                                          FormFieldController<String>(
                                    _model.ddContaOrigemValue ??=
                                        _model.vContaId,
                                  ),
                                  options: List<String>.from(FFAppState()
                                      .cacheContasBancarias
                                      .where((e) => e.ativo == true)
                                      .toList()
                                      .map((e) => e.id)
                                      .toList()),
                                  optionLabels: FFAppState()
                                      .cacheContasBancarias
                                      .where((e) => e.ativo == true)
                                      .toList()
                                      .map((e) => e.nome)
                                      .toList(),
                                  onChanged: (val) async {
                                    safeSetState(
                                        () => _model.ddContaOrigemValue = val);
                                    _model.vContaId =
                                        _model.ddContaOrigemValue != null &&
                                                _model.ddContaOrigemValue != ''
                                            ? null
                                            : _model.ddContaOrigemValue;
                                    safeSetState(() {});
                                  },
                                  width: 200.0,
                                  height: 35.0,
                                  textStyle: FlutterFlowTheme.of(context)
                                      .bodyMedium
                                      .override(
                                        font: GoogleFonts.inter(
                                          fontWeight:
                                              FlutterFlowTheme.of(context)
                                                  .bodyMedium
                                                  .fontWeight,
                                          fontStyle:
                                              FlutterFlowTheme.of(context)
                                                  .bodyMedium
                                                  .fontStyle,
                                        ),
                                        color: FlutterFlowTheme.of(context)
                                            .secondaryText,
                                        letterSpacing: 0.0,
                                        fontWeight: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .fontWeight,
                                        fontStyle: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .fontStyle,
                                      ),
                                  hintText:
                                      'Deixe em branco se a conta só for decidida no dia do pagamento...',
                                  icon: Icon(
                                    Icons.keyboard_arrow_down_rounded,
                                    color: FlutterFlowTheme.of(context)
                                        .secondaryText,
                                    size: 24.0,
                                  ),
                                  fillColor: FlutterFlowTheme.of(context)
                                      .primaryBackground,
                                  elevation: 2.0,
                                  borderColor: Colors.transparent,
                                  borderWidth: 0.0,
                                  borderRadius: 8.0,
                                  margin: EdgeInsetsDirectional.fromSTEB(
                                      12.0, 0.0, 12.0, 0.0),
                                  hidesUnderline: true,
                                  isOverButton: false,
                                  isSearchable: false,
                                  isMultiSelect: false,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 12.0),
                  child: Container(
                    width: double.infinity,
                    height: 130.0,
                    decoration: BoxDecoration(
                      color: FlutterFlowTheme.of(context).secondaryBackground,
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(12.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(
                                0.0, 0.0, 0.0, 6.0),
                            child: FlutterFlowChoiceChips(
                              options: [ChipData('MENSAL'), ChipData('ANUAL')],
                              onChanged: (widget.pIdObrigacao != null &&
                                      widget.pIdObrigacao != '')
                                  ? null
                                  : (val) async {
                                      safeSetState(() => _model.choTipoValue =
                                          val?.firstOrNull);
                                      _model.vPeriodicidade =
                                          _model.choTipoValue;
                                      safeSetState(() {});
                                    },
                              selectedChipStyle: ChipStyle(
                                backgroundColor:
                                    FlutterFlowTheme.of(context).primary,
                                textStyle: FlutterFlowTheme.of(context)
                                    .bodyMedium
                                    .override(
                                      font: GoogleFonts.inter(
                                        fontWeight: FontWeight.w600,
                                        fontStyle: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .fontStyle,
                                      ),
                                      color: FlutterFlowTheme.of(context)
                                          .primaryText,
                                      letterSpacing: 0.0,
                                      fontWeight: FontWeight.w600,
                                      fontStyle: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .fontStyle,
                                    ),
                                iconColor:
                                    FlutterFlowTheme.of(context).alternate,
                                iconSize: 16.0,
                                elevation: 0.0,
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              unselectedChipStyle: ChipStyle(
                                backgroundColor: FlutterFlowTheme.of(context)
                                    .secondaryBackground,
                                textStyle: FlutterFlowTheme.of(context)
                                    .bodyMedium
                                    .override(
                                      font: GoogleFonts.inter(
                                        fontWeight: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .fontWeight,
                                        fontStyle: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .fontStyle,
                                      ),
                                      color: FlutterFlowTheme.of(context)
                                          .primaryText,
                                      letterSpacing: 0.0,
                                      fontWeight: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .fontWeight,
                                      fontStyle: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .fontStyle,
                                    ),
                                iconColor:
                                    FlutterFlowTheme.of(context).secondaryText,
                                iconSize: 16.0,
                                elevation: 2.0,
                                borderColor:
                                    FlutterFlowTheme.of(context).alternate,
                                borderWidth: 1.0,
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              chipSpacing: 8.0,
                              rowSpacing: 8.0,
                              multiselect: false,
                              initialized: _model.choTipoValue != null,
                              alignment: WrapAlignment.start,
                              controller: _model.choTipoValueController ??=
                                  FormFieldController<List<String>>(
                                [_model.vPeriodicidade!],
                              ),
                              wrapped: false,
                            ),
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      0.0, 0.0, 6.0, 0.0),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.max,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                            4.0, 0.0, 0.0, 6.0),
                                        child: Text(
                                          'Dia Vencimento',
                                          style: FlutterFlowTheme.of(context)
                                              .labelMedium
                                              .override(
                                                font: GoogleFonts.inter(
                                                  fontWeight:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .labelMedium
                                                          .fontWeight,
                                                  fontStyle:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .labelMedium
                                                          .fontStyle,
                                                ),
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .secondaryText,
                                                letterSpacing: 0.0,
                                                fontWeight:
                                                    FlutterFlowTheme.of(context)
                                                        .labelMedium
                                                        .fontWeight,
                                                fontStyle:
                                                    FlutterFlowTheme.of(context)
                                                        .labelMedium
                                                        .fontStyle,
                                              ),
                                        ),
                                      ),
                                      FlutterFlowDropDown<int>(
                                        controller:
                                            _model.ddDiaValueController ??=
                                                FormFieldController<int>(
                                          _model.ddDiaValue ??=
                                              _model.vDiaVencimento,
                                        ),
                                        options: List<int>.from([
                                          1,
                                          2,
                                          3,
                                          4,
                                          5,
                                          6,
                                          7,
                                          8,
                                          9,
                                          10,
                                          11,
                                          12,
                                          13,
                                          14,
                                          15,
                                          16,
                                          17,
                                          18,
                                          19,
                                          20,
                                          21,
                                          22,
                                          23,
                                          24,
                                          25,
                                          26,
                                          27,
                                          28,
                                          29,
                                          30,
                                          31
                                        ]),
                                        optionLabels: [
                                          '1',
                                          '2',
                                          '3',
                                          '4',
                                          '5',
                                          '6',
                                          '7',
                                          '8',
                                          '9',
                                          '10',
                                          '11',
                                          '12',
                                          '13',
                                          '14',
                                          '15',
                                          '16',
                                          '17',
                                          '18',
                                          '19',
                                          '20',
                                          '21',
                                          '22',
                                          '23',
                                          '24',
                                          '25',
                                          '26',
                                          '27',
                                          '28',
                                          '29',
                                          '30',
                                          '31'
                                        ],
                                        onChanged: (val) async {
                                          safeSetState(
                                              () => _model.ddDiaValue = val);
                                          _model.vDiaVencimento =
                                              _model.ddDiaValue;
                                          safeSetState(() {});
                                        },
                                        width: 200.0,
                                        height: 40.0,
                                        textStyle: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .override(
                                              font: GoogleFonts.inter(
                                                fontWeight:
                                                    FlutterFlowTheme.of(context)
                                                        .bodyMedium
                                                        .fontWeight,
                                                fontStyle:
                                                    FlutterFlowTheme.of(context)
                                                        .bodyMedium
                                                        .fontStyle,
                                              ),
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .secondaryText,
                                              letterSpacing: 0.0,
                                              fontWeight:
                                                  FlutterFlowTheme.of(context)
                                                      .bodyMedium
                                                      .fontWeight,
                                              fontStyle:
                                                  FlutterFlowTheme.of(context)
                                                      .bodyMedium
                                                      .fontStyle,
                                            ),
                                        hintText: 'Selecione o Dia...',
                                        icon: Icon(
                                          Icons.keyboard_arrow_down_rounded,
                                          color: FlutterFlowTheme.of(context)
                                              .secondaryText,
                                          size: 24.0,
                                        ),
                                        fillColor: FlutterFlowTheme.of(context)
                                            .primaryBackground,
                                        elevation: 2.0,
                                        borderColor: Colors.transparent,
                                        borderWidth: 0.0,
                                        borderRadius: 8.0,
                                        margin: EdgeInsetsDirectional.fromSTEB(
                                            12.0, 0.0, 12.0, 0.0),
                                        hidesUnderline: true,
                                        isOverButton: false,
                                        isSearchable: false,
                                        isMultiSelect: false,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              if (_model.choTipoValue == 'ANUAL')
                                Expanded(
                                  child: Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        6.0, 0.0, 0.0, 0.0),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.max,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  4.0, 0.0, 0.0, 6.0),
                                          child: Text(
                                            'Mês Vencimento',
                                            style: FlutterFlowTheme.of(context)
                                                .labelMedium
                                                .override(
                                                  font: GoogleFonts.inter(
                                                    fontWeight:
                                                        FlutterFlowTheme.of(
                                                                context)
                                                            .labelMedium
                                                            .fontWeight,
                                                    fontStyle:
                                                        FlutterFlowTheme.of(
                                                                context)
                                                            .labelMedium
                                                            .fontStyle,
                                                  ),
                                                  color: FlutterFlowTheme.of(
                                                          context)
                                                      .secondaryText,
                                                  letterSpacing: 0.0,
                                                  fontWeight:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .labelMedium
                                                          .fontWeight,
                                                  fontStyle:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .labelMedium
                                                          .fontStyle,
                                                ),
                                          ),
                                        ),
                                        FlutterFlowDropDown<int>(
                                          controller:
                                              _model.ddMesValueController ??=
                                                  FormFieldController<int>(
                                            _model.ddMesValue ??=
                                                _model.vMesVencimento,
                                          ),
                                          options: List<int>.from([
                                            1,
                                            2,
                                            3,
                                            4,
                                            5,
                                            6,
                                            7,
                                            8,
                                            9,
                                            10,
                                            11,
                                            12
                                          ]),
                                          optionLabels: [
                                            'JAN',
                                            'FEV',
                                            'MAR',
                                            'ABR',
                                            'MAI',
                                            'JUN',
                                            'JUL',
                                            'AGO',
                                            'SET',
                                            'OUT',
                                            'NOV',
                                            'DEZ'
                                          ],
                                          onChanged: (val) async {
                                            safeSetState(
                                                () => _model.ddMesValue = val);
                                            _model.vMesVencimento =
                                                _model.ddMesValue == null
                                                    ? null
                                                    : _model.ddMesValue;
                                            safeSetState(() {});
                                          },
                                          width: 200.0,
                                          height: 40.0,
                                          textStyle: FlutterFlowTheme.of(
                                                  context)
                                              .bodyMedium
                                              .override(
                                                font: GoogleFonts.inter(
                                                  fontWeight:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .bodyMedium
                                                          .fontWeight,
                                                  fontStyle:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .bodyMedium
                                                          .fontStyle,
                                                ),
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .secondaryText,
                                                letterSpacing: 0.0,
                                                fontWeight:
                                                    FlutterFlowTheme.of(context)
                                                        .bodyMedium
                                                        .fontWeight,
                                                fontStyle:
                                                    FlutterFlowTheme.of(context)
                                                        .bodyMedium
                                                        .fontStyle,
                                              ),
                                          hintText: 'Selecione o Mês...',
                                          icon: Icon(
                                            Icons.keyboard_arrow_down_rounded,
                                            color: FlutterFlowTheme.of(context)
                                                .secondaryText,
                                            size: 24.0,
                                          ),
                                          fillColor:
                                              FlutterFlowTheme.of(context)
                                                  .primaryBackground,
                                          elevation: 2.0,
                                          borderColor: Colors.transparent,
                                          borderWidth: 0.0,
                                          borderRadius: 8.0,
                                          margin:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  12.0, 0.0, 12.0, 0.0),
                                          hidesUnderline: true,
                                          isOverButton: false,
                                          isSearchable: false,
                                          isMultiSelect: false,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Container(
                  width: double.infinity,
                  height: 90.0,
                  decoration: BoxDecoration(
                    color: FlutterFlowTheme.of(context).secondaryBackground,
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                  child: Align(
                    alignment: AlignmentDirectional(-1.0, 0.0),
                    child: Padding(
                      padding: EdgeInsets.all(12.0),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  0.0, 0.0, 12.0, 0.0),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        4.0, 0.0, 0.0, 6.0),
                                    child: Text(
                                      'Gerar pendência quantos dias antes?',
                                      style: FlutterFlowTheme.of(context)
                                          .labelMedium
                                          .override(
                                            font: GoogleFonts.inter(
                                              fontWeight:
                                                  FlutterFlowTheme.of(context)
                                                      .labelMedium
                                                      .fontWeight,
                                              fontStyle:
                                                  FlutterFlowTheme.of(context)
                                                      .labelMedium
                                                      .fontStyle,
                                            ),
                                            color: FlutterFlowTheme.of(context)
                                                .secondaryText,
                                            letterSpacing: 0.0,
                                            fontWeight:
                                                FlutterFlowTheme.of(context)
                                                    .labelMedium
                                                    .fontWeight,
                                            fontStyle:
                                                FlutterFlowTheme.of(context)
                                                    .labelMedium
                                                    .fontStyle,
                                          ),
                                    ),
                                  ),
                                  FlutterFlowDropDown<int>(
                                    controller:
                                        _model.ddAntecedenciaValueController ??=
                                            FormFieldController<int>(
                                      _model.ddAntecedenciaValue ??=
                                          _model.vDiaAntecedencia,
                                    ),
                                    options: List<int>.from([
                                      1,
                                      2,
                                      3,
                                      4,
                                      5,
                                      6,
                                      7,
                                      8,
                                      9,
                                      10,
                                      11,
                                      12,
                                      13,
                                      14,
                                      15,
                                      16,
                                      17,
                                      18,
                                      19,
                                      20,
                                      21,
                                      22,
                                      23,
                                      24,
                                      25,
                                      26,
                                      27,
                                      28,
                                      29,
                                      30,
                                      31
                                    ]),
                                    optionLabels: [
                                      '1',
                                      '2',
                                      '3',
                                      '4',
                                      '5',
                                      '6',
                                      '7',
                                      '8',
                                      '9',
                                      '10',
                                      '11',
                                      '12',
                                      '13',
                                      '14',
                                      '15',
                                      '16',
                                      '17',
                                      '18',
                                      '19',
                                      '20',
                                      '21',
                                      '22',
                                      '23',
                                      '24',
                                      '25',
                                      '26',
                                      '27',
                                      '28',
                                      '29',
                                      '30',
                                      '31'
                                    ],
                                    onChanged: (val) async {
                                      safeSetState(() =>
                                          _model.ddAntecedenciaValue = val);
                                      _model.vDiaAntecedencia =
                                          _model.ddAntecedenciaValue!;
                                      safeSetState(() {});
                                    },
                                    width: 200.0,
                                    height: 40.0,
                                    textStyle: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .override(
                                          font: GoogleFonts.inter(
                                            fontWeight:
                                                FlutterFlowTheme.of(context)
                                                    .bodyMedium
                                                    .fontWeight,
                                            fontStyle:
                                                FlutterFlowTheme.of(context)
                                                    .bodyMedium
                                                    .fontStyle,
                                          ),
                                          color: FlutterFlowTheme.of(context)
                                              .secondaryText,
                                          letterSpacing: 0.0,
                                          fontWeight:
                                              FlutterFlowTheme.of(context)
                                                  .bodyMedium
                                                  .fontWeight,
                                          fontStyle:
                                              FlutterFlowTheme.of(context)
                                                  .bodyMedium
                                                  .fontStyle,
                                        ),
                                    hintText: 'Selecione o Dia...',
                                    icon: Icon(
                                      Icons.keyboard_arrow_down_rounded,
                                      color: FlutterFlowTheme.of(context)
                                          .secondaryText,
                                      size: 24.0,
                                    ),
                                    fillColor: FlutterFlowTheme.of(context)
                                        .primaryBackground,
                                    elevation: 2.0,
                                    borderColor: Colors.transparent,
                                    borderWidth: 0.0,
                                    borderRadius: 8.0,
                                    margin: EdgeInsetsDirectional.fromSTEB(
                                        12.0, 0.0, 12.0, 0.0),
                                    hidesUnderline: true,
                                    isOverButton: false,
                                    isSearchable: false,
                                    isMultiSelect: false,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    4.0, 0.0, 8.0, 6.0),
                                child: Text(
                                  'Ativo',
                                  style: FlutterFlowTheme.of(context)
                                      .labelMedium
                                      .override(
                                        font: GoogleFonts.inter(
                                          fontWeight:
                                              FlutterFlowTheme.of(context)
                                                  .labelMedium
                                                  .fontWeight,
                                          fontStyle:
                                              FlutterFlowTheme.of(context)
                                                  .labelMedium
                                                  .fontStyle,
                                        ),
                                        color: FlutterFlowTheme.of(context)
                                            .secondaryText,
                                        letterSpacing: 0.0,
                                        fontWeight: FlutterFlowTheme.of(context)
                                            .labelMedium
                                            .fontWeight,
                                        fontStyle: FlutterFlowTheme.of(context)
                                            .labelMedium
                                            .fontStyle,
                                      ),
                                ),
                              ),
                              Switch.adaptive(
                                value: _model.swtStatusValue!,
                                onChanged: (newValue) async {
                                  safeSetState(
                                      () => _model.swtStatusValue = newValue);
                                  if (newValue) {
                                    _model.vAtivo = !_model.vAtivo;
                                    safeSetState(() {});
                                  } else {
                                    _model.vAtivo = !_model.vAtivo;
                                    safeSetState(() {});
                                  }
                                },
                                activeColor:
                                    FlutterFlowTheme.of(context).primary,
                                activeTrackColor:
                                    FlutterFlowTheme.of(context).fundoText,
                                inactiveTrackColor:
                                    FlutterFlowTheme.of(context).primary,
                                inactiveThumbColor:
                                    FlutterFlowTheme.of(context).fundoText,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Align(
                  alignment: AlignmentDirectional(0.0, -1.0),
                  child: Padding(
                    padding:
                        EdgeInsetsDirectional.fromSTEB(0.0, 30.0, 0.0, 0.0),
                    child: SafeArea(
                      child: Container(
                        width: double.infinity,
                        height: 60.0,
                        decoration: BoxDecoration(
                          color: FlutterFlowTheme.of(context).primaryBackground,
                          borderRadius: BorderRadius.only(),
                        ),
                        alignment: AlignmentDirectional(0.0, -1.0),
                        child: Align(
                          alignment: AlignmentDirectional(0.0, -1.0),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Align(
                                  alignment: AlignmentDirectional(0.0, 0.0),
                                  child: Builder(
                                    builder: (context) => FFButtonWidget(
                                      onPressed: () async {
                                        var _shouldSetState = false;
                                        if ((_model.inputDescricaoTextController
                                                        .text ==
                                                    '') ||
                                            (_model.vValorEstimado! <= 0.0) ||
                                            (_model.ddCategoriaValue == null ||
                                                _model.ddCategoriaValue ==
                                                    '')) {
                                          await showDialog(
                                            context: context,
                                            builder: (dialogContext) {
                                              return Dialog(
                                                elevation: 0,
                                                insetPadding: EdgeInsets.zero,
                                                backgroundColor:
                                                    Colors.transparent,
                                                alignment: AlignmentDirectional(
                                                        0.0, 0.0)
                                                    .resolve(Directionality.of(
                                                        context)),
                                                child: BsTopNotificacoesWidget(
                                                  pTipo: 'ERRO',
                                                  pMensagem:
                                                      'Preencha os campos: Descrição/Valor Estimado/Categoria.',
                                                ),
                                              );
                                            },
                                          );

                                          if (_shouldSetState)
                                            safeSetState(() {});
                                          return;
                                        } else {
                                          if (widget.pIdObrigacao == null ||
                                              widget.pIdObrigacao == '') {
                                            _model.retInsertObrigacoes =
                                                await ObrigacoesRecorrentesTable()
                                                    .insert({
                                              'organization_id': FFAppState()
                                                  .currentOrganizationId,
                                              'descricao':
                                                  valueOrDefault<String>(
                                                _model.vDescricao,
                                                'Sem descrição',
                                              ),
                                              'categoria_id':
                                                  _model.vCategoriaId,
                                              'centro_custo_id':
                                                  _model.vCentroResultadoId,
                                              'conta_bancaria_id':
                                                  _model.vContaId,
                                              'periodicidade':
                                                  _model.vPeriodicidade,
                                              'dia_vencimento':
                                                  _model.vDiaVencimento,
                                              'mes_vencimento':
                                                  _model.vMesVencimento,
                                              'dias_antecedencia':
                                                  _model.vDiaAntecedencia,
                                              'ativo': _model.vAtivo,
                                              'valor_estimado':
                                                  _model.vValorEstimado,
                                            });
                                            _shouldSetState = true;
                                            _model.retStatusInsert = await actions
                                                .acionarGeradorRecorrencias();
                                            _shouldSetState = true;
                                            await showDialog(
                                              context: context,
                                              builder: (dialogContext) {
                                                return Dialog(
                                                  elevation: 0,
                                                  insetPadding: EdgeInsets.zero,
                                                  backgroundColor:
                                                      Colors.transparent,
                                                  alignment:
                                                      AlignmentDirectional(
                                                              0.0, 0.0)
                                                          .resolve(
                                                              Directionality.of(
                                                                  context)),
                                                  child:
                                                      BsTopNotificacoesWidget(
                                                    pTipo: 'SUCESSO',
                                                    pMensagem:
                                                        'Obragação inserida com sucesso!',
                                                  ),
                                                );
                                              },
                                            );

                                            Navigator.pop(context);
                                            if (_shouldSetState)
                                              safeSetState(() {});
                                            return;
                                          } else {
                                            var confirmDialogResponse =
                                                await showDialog<bool>(
                                                      context: context,
                                                      builder:
                                                          (alertDialogContext) {
                                                        return AlertDialog(
                                                          title:
                                                              Text('Atenção!'),
                                                          content: Text(
                                                              'Deseja reiniciar os lançamentos?'),
                                                          actions: [
                                                            TextButton(
                                                              onPressed: () =>
                                                                  Navigator.pop(
                                                                      alertDialogContext,
                                                                      false),
                                                              child:
                                                                  Text('Não'),
                                                            ),
                                                            TextButton(
                                                              onPressed: () =>
                                                                  Navigator.pop(
                                                                      alertDialogContext,
                                                                      true),
                                                              child:
                                                                  Text('Sim'),
                                                            ),
                                                          ],
                                                        );
                                                      },
                                                    ) ??
                                                    false;
                                            if (confirmDialogResponse) {
                                              await ObrigacoesRecorrentesTable()
                                                  .update(
                                                data: {
                                                  'descricao':
                                                      valueOrDefault<String>(
                                                    _model.vDescricao,
                                                    'Sem descrição',
                                                  ),
                                                  'categoria_id':
                                                      _model.vCategoriaId,
                                                  'centro_custo_id':
                                                      _model.vCentroResultadoId ==
                                                                  null ||
                                                              _model.vCentroResultadoId ==
                                                                  ''
                                                          ? null
                                                          : _model
                                                              .vCentroResultadoId,
                                                  'conta_bancaria_id':
                                                      _model.vContaId == null ||
                                                              _model.vContaId ==
                                                                  ''
                                                          ? null
                                                          : _model.vContaId,
                                                  'periodicidade':
                                                      _model.vPeriodicidade,
                                                  'dia_vencimento':
                                                      _model.vDiaVencimento,
                                                  'mes_vencimento':
                                                      (_model.vMesVencimento! >=
                                                                  1) &&
                                                              (_model.vMesVencimento! <=
                                                                  12)
                                                          ? _model
                                                              .vMesVencimento
                                                          : null,
                                                  'dias_antecedencia':
                                                      _model.vDiaAntecedencia,
                                                  'ativo': _model.vAtivo,
                                                  'valor_estimado':
                                                      _model.vValorEstimado,
                                                  'ultima_competencia_gerada':
                                                      supaSerialize<DateTime>(
                                                          null),
                                                },
                                                matchingRows: (rows) => rows
                                                    .eqOrNull(
                                                      'organization_id',
                                                      FFAppState()
                                                          .currentOrganizationId,
                                                    )
                                                    .eqOrNull(
                                                      'id',
                                                      widget.pIdObrigacao,
                                                    ),
                                              );
                                              _shouldSetState = true;
                                            } else {
                                              await ObrigacoesRecorrentesTable()
                                                  .update(
                                                data: {
                                                  'descricao':
                                                      valueOrDefault<String>(
                                                    _model.vDescricao,
                                                    'Sem descrição',
                                                  ),
                                                  'categoria_id':
                                                      _model.vCategoriaId,
                                                  'centro_custo_id':
                                                      _model.vCentroResultadoId ==
                                                                  null ||
                                                              _model.vCentroResultadoId ==
                                                                  ''
                                                          ? null
                                                          : _model
                                                              .vCentroResultadoId,
                                                  'conta_bancaria_id':
                                                      _model.vContaId == null ||
                                                              _model.vContaId ==
                                                                  ''
                                                          ? null
                                                          : _model.vContaId,
                                                  'periodicidade':
                                                      _model.vPeriodicidade,
                                                  'dia_vencimento':
                                                      _model.vDiaVencimento,
                                                  'mes_vencimento':
                                                      (_model.vMesVencimento! >=
                                                                  1) &&
                                                              (_model.vMesVencimento! <=
                                                                  12)
                                                          ? _model
                                                              .vMesVencimento
                                                          : null,
                                                  'dias_antecedencia':
                                                      _model.vDiaAntecedencia,
                                                  'ativo': _model.vAtivo,
                                                  'valor_estimado':
                                                      _model.vValorEstimado,
                                                },
                                                matchingRows: (rows) => rows
                                                    .eqOrNull(
                                                      'organization_id',
                                                      FFAppState()
                                                          .currentOrganizationId,
                                                    )
                                                    .eqOrNull(
                                                      'id',
                                                      widget.pIdObrigacao,
                                                    ),
                                              );
                                              _shouldSetState = true;
                                            }

                                            _model.retStatusUpdate = await actions
                                                .acionarGeradorRecorrencias();
                                            _shouldSetState = true;
                                            await showDialog(
                                              context: context,
                                              builder: (dialogContext) {
                                                return Dialog(
                                                  elevation: 0,
                                                  insetPadding: EdgeInsets.zero,
                                                  backgroundColor:
                                                      Colors.transparent,
                                                  alignment:
                                                      AlignmentDirectional(
                                                              0.0, 0.0)
                                                          .resolve(
                                                              Directionality.of(
                                                                  context)),
                                                  child:
                                                      BsTopNotificacoesWidget(
                                                    pTipo: 'SUCESSO',
                                                    pMensagem:
                                                        'Obragação inserida com sucesso!',
                                                  ),
                                                );
                                              },
                                            );

                                            Navigator.pop(context);
                                            if (_shouldSetState)
                                              safeSetState(() {});
                                            return;
                                          }
                                        }

                                        if (_shouldSetState)
                                          safeSetState(() {});
                                      },
                                      text: 'SALVAR',
                                      icon: Icon(
                                        Icons.save,
                                        size: 15.0,
                                      ),
                                      options: FFButtonOptions(
                                        width: double.infinity,
                                        height: 50.0,
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                            0.0, 0.0, 0.0, 0.0),
                                        iconPadding:
                                            EdgeInsetsDirectional.fromSTEB(
                                                0.0, 0.0, 0.0, 0.0),
                                        color: FlutterFlowTheme.of(context)
                                            .primary,
                                        textStyle: FlutterFlowTheme.of(context)
                                            .titleSmall
                                            .override(
                                              font: GoogleFonts.interTight(
                                                fontWeight:
                                                    FlutterFlowTheme.of(context)
                                                        .titleSmall
                                                        .fontWeight,
                                                fontStyle:
                                                    FlutterFlowTheme.of(context)
                                                        .titleSmall
                                                        .fontStyle,
                                              ),
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .primaryText,
                                              letterSpacing: 0.0,
                                              fontWeight:
                                                  FlutterFlowTheme.of(context)
                                                      .titleSmall
                                                      .fontWeight,
                                              fontStyle:
                                                  FlutterFlowTheme.of(context)
                                                      .titleSmall
                                                      .fontStyle,
                                            ),
                                        borderSide: BorderSide(
                                          width: 1.0,
                                        ),
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              if (widget.pIdObrigacao != null &&
                                  widget.pIdObrigacao != '')
                                Expanded(
                                  child: Align(
                                    alignment: AlignmentDirectional(0.0, 0.0),
                                    child: Builder(
                                      builder: (context) => Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                            8.0, 0.0, 0.0, 0.0),
                                        child: FFButtonWidget(
                                          onPressed: () async {
                                            var _shouldSetState = false;
                                            var confirmDialogResponse =
                                                await showDialog<bool>(
                                                      context: context,
                                                      builder:
                                                          (alertDialogContext) {
                                                        return AlertDialog(
                                                          title:
                                                              Text('Atenção!'),
                                                          content: Text(
                                                              'Confirma a exclusão desta obrigação?'),
                                                          actions: [
                                                            TextButton(
                                                              onPressed: () =>
                                                                  Navigator.pop(
                                                                      alertDialogContext,
                                                                      false),
                                                              child:
                                                                  Text('Não'),
                                                            ),
                                                            TextButton(
                                                              onPressed: () =>
                                                                  Navigator.pop(
                                                                      alertDialogContext,
                                                                      true),
                                                              child:
                                                                  Text('Sim'),
                                                            ),
                                                          ],
                                                        );
                                                      },
                                                    ) ??
                                                    false;
                                            if (confirmDialogResponse) {
                                              await ObrigacoesRecorrentesTable()
                                                  .delete(
                                                matchingRows: (rows) => rows
                                                    .eqOrNull(
                                                      'organization_id',
                                                      FFAppState()
                                                          .currentOrganizationId,
                                                    )
                                                    .eqOrNull(
                                                      'id',
                                                      widget.pIdObrigacao,
                                                    ),
                                              );
                                              _shouldSetState = true;
                                              await showDialog(
                                                context: context,
                                                builder: (dialogContext) {
                                                  return Dialog(
                                                    elevation: 0,
                                                    insetPadding:
                                                        EdgeInsets.zero,
                                                    backgroundColor:
                                                        Colors.transparent,
                                                    alignment:
                                                        AlignmentDirectional(
                                                                0.0, 0.0)
                                                            .resolve(
                                                                Directionality.of(
                                                                    context)),
                                                    child:
                                                        BsTopNotificacoesWidget(
                                                      pTipo: 'SUCESSO',
                                                      pMensagem:
                                                          'Obrigação excluída com sucesso!',
                                                    ),
                                                  );
                                                },
                                              );

                                              Navigator.pop(context);
                                              if (_shouldSetState)
                                                safeSetState(() {});
                                              return;
                                            } else {
                                              await showDialog(
                                                context: context,
                                                builder: (dialogContext) {
                                                  return Dialog(
                                                    elevation: 0,
                                                    insetPadding:
                                                        EdgeInsets.zero,
                                                    backgroundColor:
                                                        Colors.transparent,
                                                    alignment:
                                                        AlignmentDirectional(
                                                                0.0, 0.0)
                                                            .resolve(
                                                                Directionality.of(
                                                                    context)),
                                                    child:
                                                        BsTopNotificacoesWidget(
                                                      pTipo: 'ERRO',
                                                      pMensagem:
                                                          'Não foi possível realizar a exclusão.',
                                                    ),
                                                  );
                                                },
                                              );

                                              if (_shouldSetState)
                                                safeSetState(() {});
                                              return;
                                            }

                                            if (_shouldSetState)
                                              safeSetState(() {});
                                          },
                                          text: 'Excluir',
                                          icon: Icon(
                                            Icons.delete,
                                            size: 15.0,
                                          ),
                                          options: FFButtonOptions(
                                            width: double.infinity,
                                            height: 50.0,
                                            padding:
                                                EdgeInsetsDirectional.fromSTEB(
                                                    0.0, 0.0, 0.0, 0.0),
                                            iconPadding:
                                                EdgeInsetsDirectional.fromSTEB(
                                                    0.0, 0.0, 0.0, 0.0),
                                            color: FlutterFlowTheme.of(context)
                                                .primaryBackground,
                                            textStyle: FlutterFlowTheme.of(
                                                    context)
                                                .titleSmall
                                                .override(
                                                  font: GoogleFonts.interTight(
                                                    fontWeight:
                                                        FlutterFlowTheme.of(
                                                                context)
                                                            .titleSmall
                                                            .fontWeight,
                                                    fontStyle:
                                                        FlutterFlowTheme.of(
                                                                context)
                                                            .titleSmall
                                                            .fontStyle,
                                                  ),
                                                  color: FlutterFlowTheme.of(
                                                          context)
                                                      .error,
                                                  letterSpacing: 0.0,
                                                  fontWeight:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .titleSmall
                                                          .fontWeight,
                                                  fontStyle:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .titleSmall
                                                          .fontStyle,
                                                ),
                                            borderSide: BorderSide(
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .error,
                                              width: 1.0,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(8.0),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
