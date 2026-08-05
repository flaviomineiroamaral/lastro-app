import '/backend/schema/structs/index.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/lastro/geral/bs_filtro_periodo/bs_filtro_periodo_widget.dart';
import '/lastro/transacao/bs_transacoes_por_categoria/bs_transacoes_por_categoria_widget.dart';
import 'dart:ui';
import '/custom_code/actions/index.dart' as actions;
import '/flutter_flow/custom_functions.dart' as functions;
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'bs_d_r_e_model.dart';
export 'bs_d_r_e_model.dart';

class BsDREWidget extends StatefulWidget {
  const BsDREWidget({super.key});

  @override
  State<BsDREWidget> createState() => _BsDREWidgetState();
}

class _BsDREWidgetState extends State<BsDREWidget> {
  late BsDREModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => BsDREModel());

    // On component load action.
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      _model.retDadosDREAnalitico = await actions.getDreAnalitico(
        FFAppState().currentOrganizationId,
        FFAppState().dataInicioGlob!,
        FFAppState().dataFimGlob!,
      );
      _model.dadosDREAnalitico =
          _model.retDadosDREAnalitico!.toList().cast<DTDreAnaliticoStruct>();
      safeSetState(() {});
    });

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
      alignment: AlignmentDirectional(0.0, -1.0),
      child: Container(
        width: double.infinity,
        constraints: BoxConstraints(
          maxWidth: FFAppConstants.LarguraMaxima.toDouble(),
        ),
        decoration: BoxDecoration(
          color: FlutterFlowTheme.of(context).secondaryBackground,
          borderRadius: BorderRadius.only(),
        ),
        child: Padding(
          padding: EdgeInsetsDirectional.fromSTEB(20.0, 40.0, 20.0, 20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Align(
                alignment: AlignmentDirectional(0.0, 1.0),
                child: Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 12.0),
                  child: Container(
                    width: double.infinity,
                    height: 30.0,
                    decoration: BoxDecoration(
                      color: FlutterFlowTheme.of(context).secondaryBackground,
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
                            'Demonstrativo Resultado',
                            style: FlutterFlowTheme.of(context)
                                .bodyMedium
                                .override(
                                  font: GoogleFonts.inter(
                                    fontWeight: FontWeight.bold,
                                    fontStyle: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .fontStyle,
                                  ),
                                  fontSize: 22.0,
                                  letterSpacing: 0.0,
                                  fontWeight: FontWeight.bold,
                                  fontStyle: FlutterFlowTheme.of(context)
                                      .bodyMedium
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
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Container(
                        width: double.infinity,
                        height: 40.0,
                        constraints: BoxConstraints(
                          maxWidth: FFAppConstants.LarguraMaxima.toDouble(),
                        ),
                        decoration: BoxDecoration(
                          color:
                              FlutterFlowTheme.of(context).secondaryBackground,
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  12.0, 0.0, 0.0, 0.0),
                              child: FFButtonWidget(
                                onPressed: () async {
                                  await showModalBottomSheet(
                                    isScrollControlled: true,
                                    backgroundColor: Colors.transparent,
                                    context: context,
                                    builder: (context) {
                                      return Padding(
                                        padding:
                                            MediaQuery.viewInsetsOf(context),
                                        child: Container(
                                          height: 500.0,
                                          child: BsFiltroPeriodoWidget(),
                                        ),
                                      );
                                    },
                                  ).then((value) => safeSetState(() {}));

                                  _model.retDadosDREAnaliticoFiltro =
                                      await actions.getDreAnalitico(
                                    FFAppState().currentOrganizationId,
                                    FFAppState().dataInicioGlob!,
                                    FFAppState().dataFimGlob!,
                                  );
                                  _model.dadosDREAnalitico = _model
                                      .retDadosDREAnaliticoFiltro!
                                      .toList()
                                      .cast<DTDreAnaliticoStruct>();
                                  safeSetState(() {});

                                  safeSetState(() {});
                                },
                                text: 'Período',
                                icon: Icon(
                                  Icons.keyboard_arrow_down_sharp,
                                  size: 18.0,
                                ),
                                options: FFButtonOptions(
                                  width: 130.0,
                                  height: 30.0,
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      0.0, 0.0, 0.0, 0.0),
                                  iconAlignment: IconAlignment.end,
                                  iconPadding: EdgeInsetsDirectional.fromSTEB(
                                      0.0, 0.0, 0.0, 0.0),
                                  iconColor:
                                      FlutterFlowTheme.of(context).accent4,
                                  color: FlutterFlowTheme.of(context).primary,
                                  textStyle: FlutterFlowTheme.of(context)
                                      .titleSmall
                                      .override(
                                        font: GoogleFonts.interTight(
                                          fontWeight: FontWeight.w500,
                                          fontStyle:
                                              FlutterFlowTheme.of(context)
                                                  .titleSmall
                                                  .fontStyle,
                                        ),
                                        color: FlutterFlowTheme.of(context)
                                            .accent4,
                                        fontSize: 14.0,
                                        letterSpacing: 0.0,
                                        fontWeight: FontWeight.w500,
                                        fontStyle: FlutterFlowTheme.of(context)
                                            .titleSmall
                                            .fontStyle,
                                      ),
                                  elevation: 3.0,
                                  borderSide: BorderSide(
                                    color: FlutterFlowTheme.of(context).accent2,
                                    width: 1.0,
                                  ),
                                  borderRadius: BorderRadius.circular(16.0),
                                ),
                                showLoadingIndicator: false,
                              ),
                            ),
                            Opacity(
                              opacity: 0.7,
                              child: Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    8.0, 0.0, 8.0, 0.0),
                                child: Text(
                                  '${dateTimeFormat(
                                    "dd/MM/yyyy",
                                    FFAppState().dataInicioGlob,
                                    locale: FFLocalizations.of(context)
                                        .languageCode,
                                  )}  →  ${dateTimeFormat(
                                    "dd/MM/yyyy",
                                    FFAppState().dataFimGlob,
                                    locale: FFLocalizations.of(context)
                                        .languageCode,
                                  )}',
                                  style: FlutterFlowTheme.of(context)
                                      .bodySmall
                                      .override(
                                        font: GoogleFonts.inter(
                                          fontWeight: FontWeight.normal,
                                          fontStyle:
                                              FlutterFlowTheme.of(context)
                                                  .bodySmall
                                                  .fontStyle,
                                        ),
                                        color: FlutterFlowTheme.of(context)
                                            .primaryText,
                                        fontSize: 11.0,
                                        letterSpacing: 0.0,
                                        fontWeight: FontWeight.normal,
                                        fontStyle: FlutterFlowTheme.of(context)
                                            .bodySmall
                                            .fontStyle,
                                      ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  0.0, 0.0, 12.0, 0.0),
                              child: InkWell(
                                splashColor: Colors.transparent,
                                focusColor: Colors.transparent,
                                hoverColor: Colors.transparent,
                                highlightColor: Colors.transparent,
                                onTap: () async {
                                  await actions.gerarPdfDre(
                                    FFAppState().currentOrganizationName,
                                    _model.dadosDREAnalitico.toList(),
                                    FFAppState().dataInicioGlob!,
                                    FFAppState().dataFimGlob!,
                                  );
                                },
                                child: Icon(
                                  Icons.print_outlined,
                                  color: FlutterFlowTheme.of(context).primary,
                                  size: 24.0,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Container(
                  width: 100.0,
                  height: 700.0,
                  decoration: BoxDecoration(),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Builder(
                          builder: (context) {
                            final listaItensDREAnalitico =
                                _model.dadosDREAnalitico.toList();
                            if (listaItensDREAnalitico.isEmpty) {
                              return Image.asset(
                                'assets/images/logo_desativada_e_com_fundo.png',
                              );
                            }

                            return ListView.builder(
                              padding: EdgeInsets.zero,
                              primary: false,
                              shrinkWrap: true,
                              scrollDirection: Axis.vertical,
                              itemCount: listaItensDREAnalitico.length,
                              itemBuilder:
                                  (context, listaItensDREAnaliticoIndex) {
                                final listaItensDREAnaliticoItem =
                                    listaItensDREAnalitico[
                                        listaItensDREAnaliticoIndex];
                                return Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      0.0, 0.0, 0.0, 8.0),
                                  child: Container(
                                    width: double.infinity,
                                    decoration: BoxDecoration(),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Expanded(
                                          child: Padding(
                                            padding:
                                                EdgeInsetsDirectional.fromSTEB(
                                                    valueOrDefault<double>(
                                                      valueOrDefault<double>(
                                                            listaItensDREAnaliticoItem
                                                                .nivel
                                                                .toDouble(),
                                                            0.0,
                                                          ) *
                                                          7,
                                                      0.0,
                                                    ),
                                                    0.0,
                                                    0.0,
                                                    0.0),
                                            child: Container(
                                              decoration: BoxDecoration(),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.max,
                                                children: [
                                                  if (listaItensDREAnaliticoItem
                                                          .isSintetica ==
                                                      false)
                                                    Padding(
                                                      padding:
                                                          EdgeInsetsDirectional
                                                              .fromSTEB(
                                                                  0.0,
                                                                  0.0,
                                                                  5.0,
                                                                  0.0),
                                                      child: InkWell(
                                                        splashColor:
                                                            Colors.transparent,
                                                        focusColor:
                                                            Colors.transparent,
                                                        hoverColor:
                                                            Colors.transparent,
                                                        highlightColor:
                                                            Colors.transparent,
                                                        onTap: () async {
                                                          var _shouldSetState =
                                                              false;
                                                          if (FFAppState()
                                                                  .currentFunction ==
                                                              'Leitor') {
                                                            ScaffoldMessenger
                                                                    .of(context)
                                                                .showSnackBar(
                                                              SnackBar(
                                                                content: Text(
                                                                  'Atualmente você não tem permissão!',
                                                                  style:
                                                                      TextStyle(
                                                                    color: FlutterFlowTheme.of(
                                                                            context)
                                                                        .primaryText,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600,
                                                                  ),
                                                                  textAlign:
                                                                      TextAlign
                                                                          .center,
                                                                ),
                                                                duration: Duration(
                                                                    milliseconds:
                                                                        4000),
                                                                backgroundColor:
                                                                    FlutterFlowTheme.of(
                                                                            context)
                                                                        .error,
                                                              ),
                                                            );
                                                            if (_shouldSetState)
                                                              safeSetState(
                                                                  () {});
                                                            return;
                                                          } else {
                                                            await showModalBottomSheet(
                                                              isScrollControlled:
                                                                  true,
                                                              backgroundColor:
                                                                  Colors
                                                                      .transparent,
                                                              context: context,
                                                              builder:
                                                                  (context) {
                                                                return Padding(
                                                                  padding: MediaQuery
                                                                      .viewInsetsOf(
                                                                          context),
                                                                  child:
                                                                      BsTransacoesPorCategoriaWidget(
                                                                    pTipo:
                                                                        'DRE',
                                                                    pNomeCategoria:
                                                                        listaItensDREAnaliticoItem
                                                                            .nome,
                                                                    pIdCategoria:
                                                                        listaItensDREAnaliticoItem
                                                                            .idConta,
                                                                    pTipoCategoria:
                                                                        listaItensDREAnaliticoItem
                                                                            .tipo,
                                                                    pInicioMesAno:
                                                                        FFAppState()
                                                                            .dataInicioGlob,
                                                                    pFinalMesAno:
                                                                        FFAppState()
                                                                            .dataFimGlob,
                                                                    pValorTotal:
                                                                        listaItensDREAnaliticoItem
                                                                            .valorTotal,
                                                                    pCodigoContabil:
                                                                        listaItensDREAnaliticoItem
                                                                            .codigo,
                                                                  ),
                                                                );
                                                              },
                                                            ).then((value) =>
                                                                safeSetState(
                                                                    () {}));

                                                            _model.retDadosDREAnaliticoBS =
                                                                await actions
                                                                    .getDreAnalitico(
                                                              FFAppState()
                                                                  .currentOrganizationId,
                                                              FFAppState()
                                                                  .dataInicioGlob!,
                                                              FFAppState()
                                                                  .dataFimGlob!,
                                                            );
                                                            _shouldSetState =
                                                                true;
                                                            _model.dadosDREAnalitico = _model
                                                                .retDadosDREAnaliticoBS!
                                                                .toList()
                                                                .cast<
                                                                    DTDreAnaliticoStruct>();
                                                            safeSetState(() {});
                                                            if (_shouldSetState)
                                                              safeSetState(
                                                                  () {});
                                                            return;
                                                          }

                                                          if (_shouldSetState)
                                                            safeSetState(() {});
                                                        },
                                                        child: Icon(
                                                          Icons
                                                              .add_box_outlined,
                                                          color: FlutterFlowTheme
                                                                  .of(context)
                                                              .secondaryText,
                                                          size: 16.0,
                                                        ),
                                                      ),
                                                    ),
                                                  Expanded(
                                                    child: Text(
                                                      valueOrDefault<String>(
                                                        listaItensDREAnaliticoItem
                                                            .nome,
                                                        'Sem categoria',
                                                      ),
                                                      maxLines: 1,
                                                      style: FlutterFlowTheme
                                                              .of(context)
                                                          .bodyMedium
                                                          .override(
                                                            font: GoogleFonts
                                                                .inter(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                              fontStyle:
                                                                  FlutterFlowTheme.of(
                                                                          context)
                                                                      .bodyMedium
                                                                      .fontStyle,
                                                            ),
                                                            color: listaItensDREAnaliticoItem
                                                                        .isSintetica ==
                                                                    true
                                                                ? FlutterFlowTheme.of(
                                                                        context)
                                                                    .primaryText
                                                                : FlutterFlowTheme.of(
                                                                        context)
                                                                    .secondaryText,
                                                            fontSize: () {
                                                              if (listaItensDREAnaliticoItem
                                                                      .nivel <=
                                                                  1) {
                                                                return 13.0;
                                                              } else if (listaItensDREAnaliticoItem
                                                                      .nivel ==
                                                                  2) {
                                                                return 11.0;
                                                              } else {
                                                                return 10.0;
                                                              }
                                                            }(),
                                                            letterSpacing: 0.0,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            fontStyle:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyMedium
                                                                    .fontStyle,
                                                          ),
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                        Align(
                                          alignment:
                                              AlignmentDirectional(1.0, 0.0),
                                          child: Container(
                                            width: 115.0,
                                            decoration: BoxDecoration(),
                                            alignment:
                                                AlignmentDirectional(1.0, 0.0),
                                            child: Align(
                                              alignment: AlignmentDirectional(
                                                  1.0, 0.0),
                                              child: AutoSizeText(
                                                functions.formatarMoeda(
                                                    listaItensDREAnaliticoItem
                                                        .valorTotal,
                                                    false),
                                                textAlign: TextAlign.end,
                                                maxLines: 1,
                                                minFontSize: 10.0,
                                                style: FlutterFlowTheme.of(
                                                        context)
                                                    .bodyMedium
                                                    .override(
                                                      font: GoogleFonts.inter(
                                                        fontWeight:
                                                            FontWeight.normal,
                                                        fontStyle:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .bodyMedium
                                                                .fontStyle,
                                                      ),
                                                      color:
                                                          valueOrDefault<Color>(
                                                        () {
                                                          if (listaItensDREAnaliticoItem
                                                                  .tipo ==
                                                              'RECEITA') {
                                                            return FlutterFlowTheme
                                                                    .of(context)
                                                                .secondary;
                                                          } else if (listaItensDREAnaliticoItem
                                                                  .tipo ==
                                                              'DESPESA') {
                                                            return FlutterFlowTheme
                                                                    .of(context)
                                                                .error;
                                                          } else {
                                                            return (listaItensDREAnaliticoItem
                                                                        .valorTotal >=
                                                                    0.0
                                                                ? FlutterFlowTheme.of(
                                                                        context)
                                                                    .secondary
                                                                : FlutterFlowTheme.of(
                                                                        context)
                                                                    .error);
                                                          }
                                                        }(),
                                                        FlutterFlowTheme.of(
                                                                context)
                                                            .primaryText,
                                                      ),
                                                      fontSize: () {
                                                        if (listaItensDREAnaliticoItem
                                                                .nivel <=
                                                            1) {
                                                          return 13.0;
                                                        } else if (listaItensDREAnaliticoItem
                                                                .nivel ==
                                                            2) {
                                                          return 11.0;
                                                        } else {
                                                          return 10.0;
                                                        }
                                                      }(),
                                                      letterSpacing: 0.0,
                                                      fontWeight:
                                                          FontWeight.normal,
                                                      fontStyle:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .bodyMedium
                                                              .fontStyle,
                                                    ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Align(
                                          alignment:
                                              AlignmentDirectional(1.0, 0.0),
                                          child: Container(
                                            width: 38.0,
                                            decoration: BoxDecoration(),
                                            alignment:
                                                AlignmentDirectional(1.0, 0.0),
                                            child: Align(
                                              alignment: AlignmentDirectional(
                                                  1.0, 0.0),
                                              child: AutoSizeText(
                                                formatNumber(
                                                  listaItensDREAnaliticoItem
                                                      .analiseVertical,
                                                  formatType: FormatType.custom,
                                                  format: '0%',
                                                  locale: 'pt_BR',
                                                ),
                                                textAlign: TextAlign.end,
                                                maxLines: 1,
                                                minFontSize: 10.0,
                                                style:
                                                    FlutterFlowTheme.of(context)
                                                        .bodyMedium
                                                        .override(
                                                          font:
                                                              GoogleFonts.inter(
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
                                                          fontSize: () {
                                                            if (listaItensDREAnaliticoItem
                                                                    .nivel <=
                                                                1) {
                                                              return 13.0;
                                                            } else if (listaItensDREAnaliticoItem
                                                                    .nivel ==
                                                                2) {
                                                              return 11.0;
                                                            } else {
                                                              return 10.0;
                                                            }
                                                          }(),
                                                          letterSpacing: 0.0,
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
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                        ),
                        Container(
                          width: 100.0,
                          height: 200.0,
                          decoration: BoxDecoration(),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
