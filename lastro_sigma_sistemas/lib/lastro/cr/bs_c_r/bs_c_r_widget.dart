import '/backend/schema/structs/index.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/lastro/cr/bs_detalhe_transacao_c_r/bs_detalhe_transacao_c_r_widget.dart';
import '/lastro/cr/bs_transacoes_por_c_r/bs_transacoes_por_c_r_widget.dart';
import '/lastro/geral/bs_filtro_periodo/bs_filtro_periodo_widget.dart';
import '/lastro/geral/bs_top_notificacoes/bs_top_notificacoes_widget.dart';
import '/custom_code/actions/index.dart' as actions;
import '/custom_code/widgets/index.dart' as custom_widgets;
import '/flutter_flow/custom_functions.dart' as functions;
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:provider/provider.dart';
import 'bs_c_r_model.dart';
export 'bs_c_r_model.dart';

class BsCRWidget extends StatefulWidget {
  const BsCRWidget({super.key});

  @override
  State<BsCRWidget> createState() => _BsCRWidgetState();
}

class _BsCRWidgetState extends State<BsCRWidget> {
  late BsCRModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => BsCRModel());

    // On component load action.
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      await Future.wait([
        Future(() async {
          _model.retDadosCrSintetico = await actions.getCrSintetico(
            FFAppState().currentOrganizationId,
            FFAppState().dataInicioGlob!,
            FFAppState().dataFimGlob!,
          );
        }),
        Future(() async {
          _model.retDadosCrAnalitico = await actions.getCrAnalitico(
            FFAppState().currentOrganizationId,
            FFAppState().dataInicioGlob!,
            FFAppState().dataFimGlob!,
          );
        }),
        Future(() async {
          _model.retDadosCrConciliacao = await actions.getConciliacaoDashboard(
            FFAppState().currentOrganizationId,
            FFAppState().dataInicioGlob!,
            FFAppState().dataFimGlob!,
          );
        }),
      ]);
      _model.dadosCRAnalitico =
          _model.retDadosCrAnalitico!.toList().cast<DTCrAnaliticoStruct>();
      _model.dadosCRSintetico = _model.retDadosCrSintetico;
      _model.estadoConciliacao = _model.retDadosCrConciliacao;
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
      alignment: AlignmentDirectional(1.0, 1.0),
      child: Stack(
        alignment: AlignmentDirectional(1.0, 1.0),
        children: [
          if ((_model.dadosCRAnalitico.isNotEmpty) == true)
            Align(
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
                  padding:
                      EdgeInsetsDirectional.fromSTEB(20.0, 40.0, 20.0, 20.0),
                  child: RefreshIndicator(
                    onRefresh: () async {
                      await Future.wait([
                        Future(() async {
                          _model.retDadosCrSinteticoPull =
                              await actions.getCrSintetico(
                            FFAppState().currentOrganizationId,
                            FFAppState().dataInicioGlob!,
                            FFAppState().dataFimGlob!,
                          );
                        }),
                        Future(() async {
                          _model.retDadosCrAnaliticoPull =
                              await actions.getCrAnalitico(
                            FFAppState().currentOrganizationId,
                            FFAppState().dataInicioGlob!,
                            FFAppState().dataFimGlob!,
                          );
                        }),
                        Future(() async {
                          _model.retDadosCrConciliacaoPull =
                              await actions.getConciliacaoDashboard(
                            FFAppState().currentOrganizationId,
                            FFAppState().dataInicioGlob!,
                            FFAppState().dataFimGlob!,
                          );
                        }),
                      ]);
                      _model.dadosCRAnalitico = _model.retDadosCrAnaliticoPull!
                          .toList()
                          .cast<DTCrAnaliticoStruct>();
                      _model.dadosCRSintetico = _model.retDadosCrSinteticoPull;
                      _model.estadoConciliacao =
                          _model.retDadosCrConciliacaoPull;
                      safeSetState(() {});
                    },
                    child: SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Align(
                            alignment: AlignmentDirectional(0.0, 1.0),
                            child: Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  0.0, 0.0, 0.0, 12.0),
                              child: Container(
                                width: double.infinity,
                                height: 30.0,
                                decoration: BoxDecoration(
                                  color: FlutterFlowTheme.of(context)
                                      .secondaryBackground,
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
                                        color: FlutterFlowTheme.of(context)
                                            .primaryText,
                                        size: 30.0,
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          20.0, 0.0, 0.0, 0.0),
                                      child: Text(
                                        'Centro de Resultado',
                                        style: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .override(
                                              font: GoogleFonts.inter(
                                                fontWeight: FontWeight.bold,
                                                fontStyle:
                                                    FlutterFlowTheme.of(context)
                                                        .bodyMedium
                                                        .fontStyle,
                                              ),
                                              fontSize: 22.0,
                                              letterSpacing: 0.0,
                                              fontWeight: FontWeight.bold,
                                              fontStyle:
                                                  FlutterFlowTheme.of(context)
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
                            padding: EdgeInsetsDirectional.fromSTEB(
                                0.0, 0.0, 0.0, 12.0),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: Container(
                                    width: double.infinity,
                                    height: 40.0,
                                    constraints: BoxConstraints(
                                      maxWidth: FFAppConstants.LarguraMaxima
                                          .toDouble(),
                                    ),
                                    decoration: BoxDecoration(
                                      color: FlutterFlowTheme.of(context)
                                          .secondaryBackground,
                                      borderRadius: BorderRadius.circular(20.0),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Padding(
                                          padding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  12.0, 0.0, 0.0, 0.0),
                                          child: FFButtonWidget(
                                            onPressed: () async {
                                              await showModalBottomSheet(
                                                isScrollControlled: true,
                                                backgroundColor:
                                                    Colors.transparent,
                                                context: context,
                                                builder: (context) {
                                                  return Padding(
                                                    padding:
                                                        MediaQuery.viewInsetsOf(
                                                            context),
                                                    child: Container(
                                                      height: 500.0,
                                                      child:
                                                          BsFiltroPeriodoWidget(),
                                                    ),
                                                  );
                                                },
                                              ).then((value) =>
                                                  safeSetState(() {}));

                                              await Future.wait([
                                                Future(() async {
                                                  _model.retDadosCrSinteticoFiltro =
                                                      await actions
                                                          .getCrSintetico(
                                                    FFAppState()
                                                        .currentOrganizationId,
                                                    FFAppState()
                                                        .dataInicioGlob!,
                                                    FFAppState().dataFimGlob!,
                                                  );
                                                }),
                                                Future(() async {
                                                  _model.retDadosCrAnaliticoFiltro =
                                                      await actions
                                                          .getCrAnalitico(
                                                    FFAppState()
                                                        .currentOrganizationId,
                                                    FFAppState()
                                                        .dataInicioGlob!,
                                                    FFAppState().dataFimGlob!,
                                                  );
                                                }),
                                                Future(() async {
                                                  _model.retDadosCrConciliacaoFiltro =
                                                      await actions
                                                          .getConciliacaoDashboard(
                                                    FFAppState()
                                                        .currentOrganizationId,
                                                    FFAppState()
                                                        .dataInicioGlob!,
                                                    FFAppState().dataFimGlob!,
                                                  );
                                                }),
                                              ]);
                                              _model.dadosCRAnalitico = _model
                                                  .retDadosCrAnaliticoFiltro!
                                                  .toList()
                                                  .cast<DTCrAnaliticoStruct>();
                                              _model.dadosCRSintetico = _model
                                                  .retDadosCrSinteticoFiltro;
                                              _model.estadoConciliacao = _model
                                                  .retDadosCrConciliacaoFiltro;
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
                                              padding: EdgeInsetsDirectional
                                                  .fromSTEB(0.0, 0.0, 0.0, 0.0),
                                              iconAlignment: IconAlignment.end,
                                              iconPadding: EdgeInsetsDirectional
                                                  .fromSTEB(0.0, 0.0, 0.0, 0.0),
                                              iconColor:
                                                  FlutterFlowTheme.of(context)
                                                      .accent4,
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .primary,
                                              textStyle: FlutterFlowTheme.of(
                                                      context)
                                                  .titleSmall
                                                  .override(
                                                    font:
                                                        GoogleFonts.interTight(
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      fontStyle:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .titleSmall
                                                              .fontStyle,
                                                    ),
                                                    color: FlutterFlowTheme.of(
                                                            context)
                                                        .accent4,
                                                    fontSize: 14.0,
                                                    letterSpacing: 0.0,
                                                    fontWeight: FontWeight.w500,
                                                    fontStyle:
                                                        FlutterFlowTheme.of(
                                                                context)
                                                            .titleSmall
                                                            .fontStyle,
                                                  ),
                                              elevation: 3.0,
                                              borderSide: BorderSide(
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .accent2,
                                                width: 1.0,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(16.0),
                                            ),
                                            showLoadingIndicator: false,
                                          ),
                                        ),
                                        Opacity(
                                          opacity: 0.7,
                                          child: Padding(
                                            padding:
                                                EdgeInsetsDirectional.fromSTEB(
                                                    8.0, 0.0, 8.0, 0.0),
                                            child: Text(
                                              '${dateTimeFormat(
                                                "dd/MM/yyyy",
                                                FFAppState().dataInicioGlob,
                                                locale:
                                                    FFLocalizations.of(context)
                                                        .languageCode,
                                              )}  →  ${dateTimeFormat(
                                                "dd/MM/yyyy",
                                                FFAppState().dataFimGlob,
                                                locale:
                                                    FFLocalizations.of(context)
                                                        .languageCode,
                                              )}',
                                              style:
                                                  FlutterFlowTheme.of(context)
                                                      .bodySmall
                                                      .override(
                                                        font: GoogleFonts.inter(
                                                          fontWeight:
                                                              FontWeight.normal,
                                                          fontStyle:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .bodySmall
                                                                  .fontStyle,
                                                        ),
                                                        color:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .primaryText,
                                                        fontSize: 11.0,
                                                        letterSpacing: 0.0,
                                                        fontWeight:
                                                            FontWeight.normal,
                                                        fontStyle:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .bodySmall
                                                                .fontStyle,
                                                      ),
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  0.0, 0.0, 12.0, 0.0),
                                          child: InkWell(
                                            splashColor: Colors.transparent,
                                            focusColor: Colors.transparent,
                                            hoverColor: Colors.transparent,
                                            highlightColor: Colors.transparent,
                                            onTap: () async {
                                              await actions.gerarPdfBalanceteCR(
                                                FFAppState()
                                                    .currentOrganizationName,
                                                FFAppState().dataInicioGlob!,
                                                FFAppState().dataFimGlob!,
                                                _model.estadoConciliacao!
                                                    .saldoInicialHistorico,
                                                _model.estadoConciliacao!
                                                    .resultadoOperacional,
                                                _model.estadoConciliacao!
                                                    .disponibilidadeReal,
                                                _model.dadosCRSintetico!,
                                                _model.dadosCRAnalitico
                                                    .toList(),
                                              );
                                            },
                                            child: Icon(
                                              Icons.print_outlined,
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .primary,
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
                          Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(
                                0.0, 0.0, 0.0, 12.0),
                            child: Container(
                              width: double.infinity,
                              height: 110.0,
                              decoration: BoxDecoration(
                                color: FlutterFlowTheme.of(context).accent2,
                                borderRadius: BorderRadius.circular(12.0),
                              ),
                              child: Padding(
                                padding: EdgeInsets.all(16.0),
                                child: Column(
                                  mainAxisSize: MainAxisSize.max,
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    Row(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'Saldo Anterior / Reservas',
                                          style: FlutterFlowTheme.of(context)
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
                                        ),
                                        Expanded(
                                          child: Text(
                                            functions.formatarMoeda(
                                                valueOrDefault<double>(
                                                  _model.estadoConciliacao
                                                      ?.saldoInicialHistorico,
                                                  0.0,
                                                ),
                                                false),
                                            textAlign: TextAlign.end,
                                            style: FlutterFlowTheme.of(context)
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
                                      ],
                                    ),
                                    Row(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'Resultado do Exercício',
                                          style: FlutterFlowTheme.of(context)
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
                                        ),
                                        Expanded(
                                          child: Text(
                                            functions.formatarMoeda(
                                                valueOrDefault<double>(
                                                  _model.estadoConciliacao
                                                      ?.resultadoOperacional,
                                                  0.0,
                                                ),
                                                false),
                                            textAlign: TextAlign.end,
                                            style: FlutterFlowTheme.of(context)
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
                                                  color: () {
                                                    if (_model
                                                            .estadoConciliacao!
                                                            .resultadoOperacional >
                                                        0.0) {
                                                      return FlutterFlowTheme
                                                              .of(context)
                                                          .secondary;
                                                    } else if (_model
                                                            .estadoConciliacao!
                                                            .resultadoOperacional <
                                                        0.0) {
                                                      return FlutterFlowTheme
                                                              .of(context)
                                                          .error;
                                                    } else {
                                                      return FlutterFlowTheme
                                                              .of(context)
                                                          .primaryText;
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
                                      ],
                                    ),
                                    Divider(
                                      thickness: 1.0,
                                      color: FlutterFlowTheme.of(context)
                                          .secondaryText,
                                    ),
                                    Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          0.0, 8.0, 0.0, 0.0),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            'Disponibilidade em Caixa',
                                            style: FlutterFlowTheme.of(context)
                                                .bodyMedium
                                                .override(
                                                  font: GoogleFonts.inter(
                                                    fontWeight: FontWeight.bold,
                                                    fontStyle:
                                                        FlutterFlowTheme.of(
                                                                context)
                                                            .bodyMedium
                                                            .fontStyle,
                                                  ),
                                                  letterSpacing: 0.0,
                                                  fontWeight: FontWeight.bold,
                                                  fontStyle:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .bodyMedium
                                                          .fontStyle,
                                                ),
                                          ),
                                          Expanded(
                                            child: Text(
                                              functions.formatarMoeda(
                                                  valueOrDefault<double>(
                                                    _model.estadoConciliacao
                                                        ?.disponibilidadeReal,
                                                    0.0,
                                                  ),
                                                  false),
                                              textAlign: TextAlign.end,
                                              style:
                                                  FlutterFlowTheme.of(context)
                                                      .bodyMedium
                                                      .override(
                                                        font: GoogleFonts.inter(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontStyle:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .bodyMedium
                                                                  .fontStyle,
                                                        ),
                                                        fontSize: 18.0,
                                                        letterSpacing: 0.0,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontStyle:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .bodyMedium
                                                                .fontStyle,
                                                      ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          InkWell(
                            splashColor: Colors.transparent,
                            focusColor: Colors.transparent,
                            hoverColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            onTap: () async {
                              await showModalBottomSheet(
                                isScrollControlled: true,
                                backgroundColor: Colors.transparent,
                                context: context,
                                builder: (context) {
                                  return Padding(
                                    padding: MediaQuery.viewInsetsOf(context),
                                    child: BsTransacoesPorCRWidget(
                                      pNomeCR: valueOrDefault<String>(
                                        FFAppState()
                                            .cacheCentrosDeResultado
                                            .where((e) => e.isFundo == true)
                                            .toList()
                                            .firstOrNull
                                            ?.nome,
                                        'Fundo Geral / Tesouraria',
                                      ),
                                      pIdCR: valueOrDefault<String>(
                                        FFAppState()
                                            .cacheCentrosDeResultado
                                            .where((e) => e.isFundo == true)
                                            .toList()
                                            .firstOrNull
                                            ?.id,
                                        'Fundo Geral / Tesouraria',
                                      ),
                                      pInicioMesAno:
                                          FFAppState().dataInicioGlob,
                                      pFinalMesAno: FFAppState().dataFimGlob,
                                      pIsFundo: true,
                                    ),
                                  );
                                },
                              ).then((value) => safeSetState(() {}));

                              await Future.wait([
                                Future(() async {
                                  _model.retDadosCrSinteticoBSTapFundo =
                                      await actions.getCrSintetico(
                                    FFAppState().currentOrganizationId,
                                    FFAppState().dataInicioGlob!,
                                    FFAppState().dataFimGlob!,
                                  );
                                }),
                                Future(() async {
                                  _model.retDadosCrAnaliticoBSTapFundo =
                                      await actions.getCrAnalitico(
                                    FFAppState().currentOrganizationId,
                                    FFAppState().dataInicioGlob!,
                                    FFAppState().dataFimGlob!,
                                  );
                                }),
                                Future(() async {
                                  _model.retDadosCrConciliacaoBSTapFundo =
                                      await actions.getConciliacaoDashboard(
                                    FFAppState().currentOrganizationId,
                                    FFAppState().dataInicioGlob!,
                                    FFAppState().dataFimGlob!,
                                  );
                                }),
                              ]);
                              _model.dadosCRAnalitico = _model
                                  .retDadosCrAnaliticoBSTapFundo!
                                  .toList()
                                  .cast<DTCrAnaliticoStruct>();
                              _model.dadosCRSintetico =
                                  _model.retDadosCrSinteticoBSTapFundo;
                              _model.estadoConciliacao =
                                  _model.retDadosCrConciliacaoBSTapFundo;
                              safeSetState(() {});

                              safeSetState(() {});
                            },
                            child: Material(
                              color: Colors.transparent,
                              elevation: 3.0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16.0),
                              ),
                              child: Container(
                                width: double.infinity,
                                height: 240.0,
                                decoration: BoxDecoration(
                                  color: FlutterFlowTheme.of(context).accent2,
                                  borderRadius: BorderRadius.circular(16.0),
                                ),
                                alignment: AlignmentDirectional(0.0, 0.0),
                                child: Padding(
                                  padding: EdgeInsets.all(14.0),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Row(
                                        mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Expanded(
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Text(
                                                  valueOrDefault<String>(
                                                    FFAppState()
                                                        .cacheCentrosDeResultado
                                                        .where((e) =>
                                                            e.isFundo == true)
                                                        .toList()
                                                        .firstOrNull
                                                        ?.nome,
                                                    'Fundo Geral / Tesouraria',
                                                  ),
                                                  textAlign: TextAlign.start,
                                                  style: FlutterFlowTheme.of(
                                                          context)
                                                      .bodyMedium
                                                      .override(
                                                        font: GoogleFonts.inter(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontStyle:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .bodyMedium
                                                                  .fontStyle,
                                                        ),
                                                        color:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .primaryText,
                                                        fontSize: 18.0,
                                                        letterSpacing: 0.0,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontStyle:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .bodyMedium
                                                                .fontStyle,
                                                      ),
                                                  overflow: TextOverflow.clip,
                                                ),
                                                Padding(
                                                  padding: EdgeInsetsDirectional
                                                      .fromSTEB(
                                                          0.0, 12.0, 0.0, 0.0),
                                                  child: Text(
                                                    'Saldo Disponível',
                                                    style: FlutterFlowTheme.of(
                                                            context)
                                                        .bodyMedium
                                                        .override(
                                                          font:
                                                              GoogleFonts.inter(
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            fontStyle:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyMedium
                                                                    .fontStyle,
                                                          ),
                                                          letterSpacing: 0.0,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          fontStyle:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .bodyMedium
                                                                  .fontStyle,
                                                        ),
                                                  ),
                                                ),
                                                Text(
                                                  functions.formatarMoeda(
                                                      _model.dadosCRSintetico
                                                          ?.saldoDisponivel,
                                                      true),
                                                  style: FlutterFlowTheme.of(
                                                          context)
                                                      .bodyMedium
                                                      .override(
                                                        font: GoogleFonts.inter(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontStyle:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .bodyMedium
                                                                  .fontStyle,
                                                        ),
                                                        color: _model
                                                                    .dadosCRSintetico!
                                                                    .saudeOrcamentaria <
                                                                0.0
                                                            ? FlutterFlowTheme
                                                                    .of(context)
                                                                .error
                                                            : FlutterFlowTheme
                                                                    .of(context)
                                                                .primary,
                                                        fontSize: 22.0,
                                                        letterSpacing: 0.0,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontStyle:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .bodyMedium
                                                                .fontStyle,
                                                      ),
                                                ),
                                                Opacity(
                                                  opacity: 0.7,
                                                  child: Padding(
                                                    padding:
                                                        EdgeInsetsDirectional
                                                            .fromSTEB(0.0, 12.0,
                                                                0.0, 12.0),
                                                    child: Row(
                                                      mainAxisSize:
                                                          MainAxisSize.max,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceAround,
                                                      children: [
                                                        Expanded(
                                                          child: Column(
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .min,
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .start,
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .center,
                                                            children: [
                                                              Text(
                                                                'Total Arrecadado',
                                                                style: FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyMedium
                                                                    .override(
                                                                      font: GoogleFonts
                                                                          .inter(
                                                                        fontWeight:
                                                                            FontWeight.w500,
                                                                        fontStyle: FlutterFlowTheme.of(context)
                                                                            .bodyMedium
                                                                            .fontStyle,
                                                                      ),
                                                                      fontSize:
                                                                          12.0,
                                                                      letterSpacing:
                                                                          0.0,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w500,
                                                                      fontStyle: FlutterFlowTheme.of(
                                                                              context)
                                                                          .bodyMedium
                                                                          .fontStyle,
                                                                    ),
                                                              ),
                                                              Text(
                                                                functions.formatarMoeda(
                                                                    _model
                                                                        .dadosCRSintetico
                                                                        ?.totalArrecadado,
                                                                    true),
                                                                style: FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyMedium
                                                                    .override(
                                                                      font: GoogleFonts
                                                                          .inter(
                                                                        fontWeight:
                                                                            FontWeight.bold,
                                                                        fontStyle: FlutterFlowTheme.of(context)
                                                                            .bodyMedium
                                                                            .fontStyle,
                                                                      ),
                                                                      color: FlutterFlowTheme.of(
                                                                              context)
                                                                          .primaryText,
                                                                      fontSize:
                                                                          14.0,
                                                                      letterSpacing:
                                                                          0.0,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      fontStyle: FlutterFlowTheme.of(
                                                                              context)
                                                                          .bodyMedium
                                                                          .fontStyle,
                                                                    ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        Expanded(
                                                          child: Column(
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .max,
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .start,
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .center,
                                                            children: [
                                                              Text(
                                                                'Sub. Recebido',
                                                                style: FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyMedium
                                                                    .override(
                                                                      font: GoogleFonts
                                                                          .inter(
                                                                        fontWeight:
                                                                            FontWeight.w500,
                                                                        fontStyle: FlutterFlowTheme.of(context)
                                                                            .bodyMedium
                                                                            .fontStyle,
                                                                      ),
                                                                      fontSize:
                                                                          12.0,
                                                                      letterSpacing:
                                                                          0.0,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w500,
                                                                      fontStyle: FlutterFlowTheme.of(
                                                                              context)
                                                                          .bodyMedium
                                                                          .fontStyle,
                                                                    ),
                                                              ),
                                                              Text(
                                                                functions.formatarMoeda(
                                                                    _model
                                                                        .dadosCRSintetico
                                                                        ?.subsidiosRecebidos,
                                                                    true),
                                                                style: FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyMedium
                                                                    .override(
                                                                      font: GoogleFonts
                                                                          .inter(
                                                                        fontWeight:
                                                                            FontWeight.bold,
                                                                        fontStyle: FlutterFlowTheme.of(context)
                                                                            .bodyMedium
                                                                            .fontStyle,
                                                                      ),
                                                                      color: FlutterFlowTheme.of(
                                                                              context)
                                                                          .primaryText,
                                                                      fontSize:
                                                                          14.0,
                                                                      letterSpacing:
                                                                          0.0,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      fontStyle: FlutterFlowTheme.of(
                                                                              context)
                                                                          .bodyMedium
                                                                          .fontStyle,
                                                                    ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        Expanded(
                                                          child: Column(
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .max,
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .start,
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .center,
                                                            children: [
                                                              Text(
                                                                'Sub. Concedido',
                                                                style: FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyMedium
                                                                    .override(
                                                                      font: GoogleFonts
                                                                          .inter(
                                                                        fontWeight:
                                                                            FontWeight.w500,
                                                                        fontStyle: FlutterFlowTheme.of(context)
                                                                            .bodyMedium
                                                                            .fontStyle,
                                                                      ),
                                                                      fontSize:
                                                                          12.0,
                                                                      letterSpacing:
                                                                          0.0,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w500,
                                                                      fontStyle: FlutterFlowTheme.of(
                                                                              context)
                                                                          .bodyMedium
                                                                          .fontStyle,
                                                                    ),
                                                              ),
                                                              Text(
                                                                functions.formatarMoeda(
                                                                    _model
                                                                        .dadosCRSintetico
                                                                        ?.subsidiosConcedidos,
                                                                    true),
                                                                style: FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyMedium
                                                                    .override(
                                                                      font: GoogleFonts
                                                                          .inter(
                                                                        fontWeight:
                                                                            FontWeight.bold,
                                                                        fontStyle: FlutterFlowTheme.of(context)
                                                                            .bodyMedium
                                                                            .fontStyle,
                                                                      ),
                                                                      color: FlutterFlowTheme.of(
                                                                              context)
                                                                          .primaryText,
                                                                      fontSize:
                                                                          14.0,
                                                                      letterSpacing:
                                                                          0.0,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      fontStyle: FlutterFlowTheme.of(
                                                                              context)
                                                                          .bodyMedium
                                                                          .fontStyle,
                                                                    ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                      Expanded(
                                        child: Align(
                                          alignment:
                                              AlignmentDirectional(0.0, 0.0),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.stretch,
                                            children: [
                                              Padding(
                                                padding: EdgeInsetsDirectional
                                                    .fromSTEB(
                                                        0.0, 0.0, 0.0, 6.0),
                                                child: Container(
                                                  width: double.infinity,
                                                  height: 30.0,
                                                  child: custom_widgets
                                                      .ProgressBarFundoGeral(
                                                    width: double.infinity,
                                                    height: 30.0,
                                                    arrecadado:
                                                        valueOrDefault<double>(
                                                      _model.dadosCRSintetico
                                                          ?.totalArrecadado,
                                                      0.0,
                                                    ),
                                                    repassado:
                                                        valueOrDefault<double>(
                                                      _model.dadosCRSintetico
                                                          ?.subsidiosAlocados,
                                                      0.0,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Text(
                                                'Taxa de Distribuição de Capital',
                                                textAlign: TextAlign.center,
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
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  0.0, 12.0, 0.0, 0.0),
                              child: Container(
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: FlutterFlowTheme.of(context)
                                      .secondaryBackground,
                                ),
                                child: SingleChildScrollView(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      Builder(
                                        builder: (context) {
                                          final listaItensCRAnalitico = _model
                                              .dadosCRAnalitico
                                              .where((e) =>
                                                  (e.isFundo == false) &&
                                                  (e.isAtivo == true))
                                              .toList();
                                          if (listaItensCRAnalitico.isEmpty) {
                                            return Image.asset(
                                              'assets/images/logo_desativada_e_com_fundo.png',
                                            );
                                          }

                                          return ListView.builder(
                                            padding: EdgeInsets.zero,
                                            primary: false,
                                            shrinkWrap: true,
                                            scrollDirection: Axis.vertical,
                                            itemCount:
                                                listaItensCRAnalitico.length,
                                            itemBuilder: (context,
                                                listaItensCRAnaliticoIndex) {
                                              final listaItensCRAnaliticoItem =
                                                  listaItensCRAnalitico[
                                                      listaItensCRAnaliticoIndex];
                                              return Padding(
                                                padding: EdgeInsetsDirectional
                                                    .fromSTEB(
                                                        0.0, 0.0, 0.0, 12.0),
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
                                                    await showModalBottomSheet(
                                                      isScrollControlled: true,
                                                      backgroundColor:
                                                          Colors.transparent,
                                                      context: context,
                                                      builder: (context) {
                                                        return Padding(
                                                          padding: MediaQuery
                                                              .viewInsetsOf(
                                                                  context),
                                                          child:
                                                              BsTransacoesPorCRWidget(
                                                            pNomeCR:
                                                                listaItensCRAnaliticoItem
                                                                    .crNome,
                                                            pIdCR:
                                                                listaItensCRAnaliticoItem
                                                                    .crId,
                                                            pInicioMesAno:
                                                                FFAppState()
                                                                    .dataInicioGlob,
                                                            pFinalMesAno:
                                                                FFAppState()
                                                                    .dataFimGlob,
                                                            pIsFundo: false,
                                                          ),
                                                        );
                                                      },
                                                    ).then((value) =>
                                                        safeSetState(() {}));

                                                    await Future.wait([
                                                      Future(() async {
                                                        _model.retDadosCrSinteticoBSTap =
                                                            await actions
                                                                .getCrSintetico(
                                                          FFAppState()
                                                              .currentOrganizationId,
                                                          FFAppState()
                                                              .dataInicioGlob!,
                                                          FFAppState()
                                                              .dataFimGlob!,
                                                        );
                                                      }),
                                                      Future(() async {
                                                        _model.retDadosCrAnaliticoBSTap =
                                                            await actions
                                                                .getCrAnalitico(
                                                          FFAppState()
                                                              .currentOrganizationId,
                                                          FFAppState()
                                                              .dataInicioGlob!,
                                                          FFAppState()
                                                              .dataFimGlob!,
                                                        );
                                                      }),
                                                      Future(() async {
                                                        _model.retDadosCrConciliacaoBSTap =
                                                            await actions
                                                                .getConciliacaoDashboard(
                                                          FFAppState()
                                                              .currentOrganizationId,
                                                          FFAppState()
                                                              .dataInicioGlob!,
                                                          FFAppState()
                                                              .dataFimGlob!,
                                                        );
                                                      }),
                                                    ]);
                                                    _model.dadosCRAnalitico = _model
                                                        .retDadosCrAnaliticoBSTap!
                                                        .toList()
                                                        .cast<
                                                            DTCrAnaliticoStruct>();
                                                    _model.dadosCRSintetico = _model
                                                        .retDadosCrSinteticoBSTap;
                                                    _model.estadoConciliacao =
                                                        _model
                                                            .retDadosCrConciliacaoBSTap;
                                                    safeSetState(() {});

                                                    safeSetState(() {});
                                                  },
                                                  child: Container(
                                                    width: double.infinity,
                                                    height: 185.0,
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              16.0),
                                                    ),
                                                    child: Row(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Container(
                                                          width: 4.0,
                                                          height: 175.0,
                                                          decoration:
                                                              BoxDecoration(
                                                            color: functions
                                                                .hexToColor(
                                                                    listaItensCRAnaliticoItem
                                                                        .corHex),
                                                          ),
                                                        ),
                                                        Expanded(
                                                          child: Padding(
                                                            padding:
                                                                EdgeInsets.all(
                                                                    6.0),
                                                            child: Column(
                                                              mainAxisSize:
                                                                  MainAxisSize
                                                                      .max,
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .start,
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Row(
                                                                  mainAxisSize:
                                                                      MainAxisSize
                                                                          .min,
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .spaceBetween,
                                                                  children: [
                                                                    Expanded(
                                                                      child:
                                                                          Text(
                                                                        valueOrDefault<
                                                                            String>(
                                                                          listaItensCRAnaliticoItem
                                                                              .crNome,
                                                                          'Nome Departamento',
                                                                        ),
                                                                        maxLines:
                                                                            1,
                                                                        style: FlutterFlowTheme.of(context)
                                                                            .bodyMedium
                                                                            .override(
                                                                              font: GoogleFonts.inter(
                                                                                fontWeight: FontWeight.bold,
                                                                                fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                                                                              ),
                                                                              fontSize: 18.0,
                                                                              letterSpacing: 0.0,
                                                                              fontWeight: FontWeight.bold,
                                                                              fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                                                                            ),
                                                                        overflow:
                                                                            TextOverflow.ellipsis,
                                                                      ),
                                                                    ),
                                                                    if (listaItensCRAnaliticoItem
                                                                            .permiteAcumulo ==
                                                                        true)
                                                                      Padding(
                                                                        padding: EdgeInsetsDirectional.fromSTEB(
                                                                            10.0,
                                                                            0.0,
                                                                            0.0,
                                                                            0.0),
                                                                        child:
                                                                            Icon(
                                                                          Icons
                                                                              .savings_rounded,
                                                                          color:
                                                                              FlutterFlowTheme.of(context).secondary,
                                                                          size:
                                                                              24.0,
                                                                        ),
                                                                      ),
                                                                  ],
                                                                ),
                                                                Text(
                                                                  'Saldo Caixa',
                                                                  style: FlutterFlowTheme.of(
                                                                          context)
                                                                      .bodyMedium
                                                                      .override(
                                                                        font: GoogleFonts
                                                                            .inter(
                                                                          fontWeight: FlutterFlowTheme.of(context)
                                                                              .bodyMedium
                                                                              .fontWeight,
                                                                          fontStyle: FlutterFlowTheme.of(context)
                                                                              .bodyMedium
                                                                              .fontStyle,
                                                                        ),
                                                                        fontSize:
                                                                            10.0,
                                                                        letterSpacing:
                                                                            0.0,
                                                                        fontWeight: FlutterFlowTheme.of(context)
                                                                            .bodyMedium
                                                                            .fontWeight,
                                                                        fontStyle: FlutterFlowTheme.of(context)
                                                                            .bodyMedium
                                                                            .fontStyle,
                                                                      ),
                                                                ),
                                                                Text(
                                                                  valueOrDefault<
                                                                      String>(
                                                                    functions.formatarMoeda(
                                                                        listaItensCRAnaliticoItem
                                                                            .saldoCaixa,
                                                                        false),
                                                                    'R\$ 1.234,56',
                                                                  ),
                                                                  style: FlutterFlowTheme.of(
                                                                          context)
                                                                      .bodyMedium
                                                                      .override(
                                                                        font: GoogleFonts
                                                                            .inter(
                                                                          fontWeight:
                                                                              FontWeight.bold,
                                                                          fontStyle: FlutterFlowTheme.of(context)
                                                                              .bodyMedium
                                                                              .fontStyle,
                                                                        ),
                                                                        color: listaItensCRAnaliticoItem.saldoCaixa <
                                                                                0.0
                                                                            ? FlutterFlowTheme.of(context).error
                                                                            : FlutterFlowTheme.of(context).secondaryText,
                                                                        fontSize:
                                                                            14.0,
                                                                        letterSpacing:
                                                                            0.0,
                                                                        fontWeight:
                                                                            FontWeight.bold,
                                                                        fontStyle: FlutterFlowTheme.of(context)
                                                                            .bodyMedium
                                                                            .fontStyle,
                                                                      ),
                                                                ),
                                                                Row(
                                                                  mainAxisSize:
                                                                      MainAxisSize
                                                                          .max,
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .spaceAround,
                                                                  children: [
                                                                    Column(
                                                                      mainAxisSize:
                                                                          MainAxisSize
                                                                              .min,
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .center,
                                                                      children: [
                                                                        Padding(
                                                                          padding: EdgeInsetsDirectional.fromSTEB(
                                                                              0.0,
                                                                              8.0,
                                                                              0.0,
                                                                              0.0),
                                                                          child:
                                                                              Text(
                                                                            'Arrecadado',
                                                                            style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                  font: GoogleFonts.inter(
                                                                                    fontWeight: FlutterFlowTheme.of(context).bodyMedium.fontWeight,
                                                                                    fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                                                                                  ),
                                                                                  color: FlutterFlowTheme.of(context).secondary,
                                                                                  fontSize: 12.0,
                                                                                  letterSpacing: 0.0,
                                                                                  fontWeight: FlutterFlowTheme.of(context).bodyMedium.fontWeight,
                                                                                  fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                                                                                ),
                                                                          ),
                                                                        ),
                                                                        Text(
                                                                          valueOrDefault<
                                                                              String>(
                                                                            functions.formatarMoeda(listaItensCRAnaliticoItem.receitaPropria,
                                                                                false),
                                                                            'R\$ 1.234,56',
                                                                          ),
                                                                          style: FlutterFlowTheme.of(context)
                                                                              .bodyMedium
                                                                              .override(
                                                                                font: GoogleFonts.inter(
                                                                                  fontWeight: FlutterFlowTheme.of(context).bodyMedium.fontWeight,
                                                                                  fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                                                                                ),
                                                                                fontSize: 12.0,
                                                                                letterSpacing: 0.0,
                                                                                fontWeight: FlutterFlowTheme.of(context).bodyMedium.fontWeight,
                                                                                fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                                                                              ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                    Column(
                                                                      mainAxisSize:
                                                                          MainAxisSize
                                                                              .min,
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .center,
                                                                      children: [
                                                                        Padding(
                                                                          padding: EdgeInsetsDirectional.fromSTEB(
                                                                              0.0,
                                                                              8.0,
                                                                              0.0,
                                                                              0.0),
                                                                          child:
                                                                              Text(
                                                                            'Subsídio Rec.',
                                                                            style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                  font: GoogleFonts.inter(
                                                                                    fontWeight: FlutterFlowTheme.of(context).bodyMedium.fontWeight,
                                                                                    fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                                                                                  ),
                                                                                  color: Color(0xFF0082FF),
                                                                                  fontSize: 12.0,
                                                                                  letterSpacing: 0.0,
                                                                                  fontWeight: FlutterFlowTheme.of(context).bodyMedium.fontWeight,
                                                                                  fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                                                                                ),
                                                                          ),
                                                                        ),
                                                                        Text(
                                                                          valueOrDefault<
                                                                              String>(
                                                                            functions.formatarMoeda(listaItensCRAnaliticoItem.subsidioRecebido,
                                                                                false),
                                                                            'R\$ 1.234,56',
                                                                          ),
                                                                          style: FlutterFlowTheme.of(context)
                                                                              .bodyMedium
                                                                              .override(
                                                                                font: GoogleFonts.inter(
                                                                                  fontWeight: FlutterFlowTheme.of(context).bodyMedium.fontWeight,
                                                                                  fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                                                                                ),
                                                                                fontSize: 12.0,
                                                                                letterSpacing: 0.0,
                                                                                fontWeight: FlutterFlowTheme.of(context).bodyMedium.fontWeight,
                                                                                fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                                                                              ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                    Column(
                                                                      mainAxisSize:
                                                                          MainAxisSize
                                                                              .min,
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .center,
                                                                      children: [
                                                                        Padding(
                                                                          padding: EdgeInsetsDirectional.fromSTEB(
                                                                              0.0,
                                                                              8.0,
                                                                              0.0,
                                                                              0.0),
                                                                          child:
                                                                              Text(
                                                                            'Subsídio Conc.',
                                                                            style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                  font: GoogleFonts.inter(
                                                                                    fontWeight: FlutterFlowTheme.of(context).bodyMedium.fontWeight,
                                                                                    fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                                                                                  ),
                                                                                  color: Color(0xFF0082FF),
                                                                                  fontSize: 12.0,
                                                                                  letterSpacing: 0.0,
                                                                                  fontWeight: FlutterFlowTheme.of(context).bodyMedium.fontWeight,
                                                                                  fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                                                                                ),
                                                                          ),
                                                                        ),
                                                                        Text(
                                                                          valueOrDefault<
                                                                              String>(
                                                                            functions.formatarMoeda(listaItensCRAnaliticoItem.subsidioConcedido,
                                                                                false),
                                                                            'R\$ 1.234,56',
                                                                          ),
                                                                          style: FlutterFlowTheme.of(context)
                                                                              .bodyMedium
                                                                              .override(
                                                                                font: GoogleFonts.inter(
                                                                                  fontWeight: FlutterFlowTheme.of(context).bodyMedium.fontWeight,
                                                                                  fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                                                                                ),
                                                                                fontSize: 12.0,
                                                                                letterSpacing: 0.0,
                                                                                fontWeight: FlutterFlowTheme.of(context).bodyMedium.fontWeight,
                                                                                fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                                                                              ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                    Column(
                                                                      mainAxisSize:
                                                                          MainAxisSize
                                                                              .min,
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .center,
                                                                      children: [
                                                                        Padding(
                                                                          padding: EdgeInsetsDirectional.fromSTEB(
                                                                              0.0,
                                                                              8.0,
                                                                              0.0,
                                                                              0.0),
                                                                          child:
                                                                              Text(
                                                                            'Despesa',
                                                                            style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                  font: GoogleFonts.inter(
                                                                                    fontWeight: FlutterFlowTheme.of(context).bodyMedium.fontWeight,
                                                                                    fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                                                                                  ),
                                                                                  color: FlutterFlowTheme.of(context).error,
                                                                                  fontSize: 12.0,
                                                                                  letterSpacing: 0.0,
                                                                                  fontWeight: FlutterFlowTheme.of(context).bodyMedium.fontWeight,
                                                                                  fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                                                                                ),
                                                                          ),
                                                                        ),
                                                                        Text(
                                                                          valueOrDefault<
                                                                              String>(
                                                                            functions.formatarMoeda(listaItensCRAnaliticoItem.despesaRealizada,
                                                                                false),
                                                                            'R\$ 1.234,56',
                                                                          ),
                                                                          style: FlutterFlowTheme.of(context)
                                                                              .bodyMedium
                                                                              .override(
                                                                                font: GoogleFonts.inter(
                                                                                  fontWeight: FlutterFlowTheme.of(context).bodyMedium.fontWeight,
                                                                                  fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                                                                                ),
                                                                                fontSize: 12.0,
                                                                                letterSpacing: 0.0,
                                                                                fontWeight: FlutterFlowTheme.of(context).bodyMedium.fontWeight,
                                                                                fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                                                                              ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ],
                                                                ),
                                                                Align(
                                                                  alignment:
                                                                      AlignmentDirectional(
                                                                          0.0,
                                                                          0.0),
                                                                  child: Column(
                                                                    mainAxisSize:
                                                                        MainAxisSize
                                                                            .min,
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .center,
                                                                    children: [
                                                                      Padding(
                                                                        padding: EdgeInsetsDirectional.fromSTEB(
                                                                            0.0,
                                                                            6.0,
                                                                            0.0,
                                                                            0.0),
                                                                        child:
                                                                            Container(
                                                                          width:
                                                                              double.infinity,
                                                                          height:
                                                                              20.0,
                                                                          child:
                                                                              custom_widgets.ProgressBarAutossuficiencia(
                                                                            width:
                                                                                double.infinity,
                                                                            height:
                                                                                20.0,
                                                                            valorAutossuficiencia:
                                                                                valueOrDefault<double>(
                                                                              listaItensCRAnaliticoItem.autossuficiencia,
                                                                              0.0,
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                                Padding(
                                                                  padding: EdgeInsetsDirectional
                                                                      .fromSTEB(
                                                                          0.0,
                                                                          8.0,
                                                                          0.0,
                                                                          0.0),
                                                                  child: Row(
                                                                    mainAxisSize:
                                                                        MainAxisSize
                                                                            .max,
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .spaceAround,
                                                                    children: [
                                                                      Builder(
                                                                        builder:
                                                                            (context) =>
                                                                                FFButtonWidget(
                                                                          onPressed:
                                                                              () async {
                                                                            var _shouldSetState =
                                                                                false;
                                                                            if ((FFAppState().currentFunction == 'Leitor') ||
                                                                                (FFAppState().currentFunction == '')) {
                                                                              await showDialog(
                                                                                context: context,
                                                                                builder: (dialogContext) {
                                                                                  return Dialog(
                                                                                    elevation: 0,
                                                                                    insetPadding: EdgeInsets.zero,
                                                                                    backgroundColor: Colors.transparent,
                                                                                    alignment: AlignmentDirectional(-1.0, 0.0).resolve(Directionality.of(context)),
                                                                                    child: BsTopNotificacoesWidget(
                                                                                      pTipo: 'AVISO',
                                                                                      pMensagem: 'Atualmente você não tem permissão!',
                                                                                    ),
                                                                                  );
                                                                                },
                                                                              );

                                                                              if (_shouldSetState)
                                                                                safeSetState(() {});
                                                                              return;
                                                                            } else {
                                                                              await showModalBottomSheet(
                                                                                isScrollControlled: true,
                                                                                backgroundColor: Colors.transparent,
                                                                                context: context,
                                                                                builder: (context) {
                                                                                  return Padding(
                                                                                    padding: MediaQuery.viewInsetsOf(context),
                                                                                    child: Container(
                                                                                      height: 520.0,
                                                                                      child: BsDetalheTransacaoCRWidget(
                                                                                        pTipoTransacao: 'Alocar',
                                                                                        pValorDisponivel: valueOrDefault<double>(
                                                                                              _model.dadosCRSintetico?.saldoDisponivel,
                                                                                              0.0,
                                                                                            ) +
                                                                                            _model.estadoConciliacao!.saldoInicialHistorico,
                                                                                        pIdProjetoCR: listaItensCRAnaliticoItem.crId,
                                                                                        pValorMaximoTrans: listaItensCRAnaliticoItem.saldoCaixa < 0.0 ? listaItensCRAnaliticoItem.saldoCaixa : 0.0,
                                                                                      ),
                                                                                    ),
                                                                                  );
                                                                                },
                                                                              ).then((value) => safeSetState(() {}));

                                                                              await Future.wait([
                                                                                Future(() async {
                                                                                  _model.retDadosCrSinteticoBtnAlocar = await actions.getCrSintetico(
                                                                                    FFAppState().currentOrganizationId,
                                                                                    FFAppState().dataInicioGlob!,
                                                                                    FFAppState().dataFimGlob!,
                                                                                  );
                                                                                  _shouldSetState = true;
                                                                                }),
                                                                                Future(() async {
                                                                                  _model.retDadosCrAnaliticoBtnAlocar = await actions.getCrAnalitico(
                                                                                    FFAppState().currentOrganizationId,
                                                                                    FFAppState().dataInicioGlob!,
                                                                                    FFAppState().dataFimGlob!,
                                                                                  );
                                                                                  _shouldSetState = true;
                                                                                }),
                                                                                Future(() async {
                                                                                  _model.retDadosCrConciliacaoBtnAlocar = await actions.getConciliacaoDashboard(
                                                                                    FFAppState().currentOrganizationId,
                                                                                    FFAppState().dataInicioGlob!,
                                                                                    FFAppState().dataFimGlob!,
                                                                                  );
                                                                                  _shouldSetState = true;
                                                                                }),
                                                                              ]);
                                                                              _model.dadosCRAnalitico = _model.retDadosCrAnaliticoBtnAlocar!.toList().cast<DTCrAnaliticoStruct>();
                                                                              _model.dadosCRSintetico = _model.retDadosCrSinteticoBtnAlocar;
                                                                              _model.estadoConciliacao = _model.retDadosCrConciliacaoBtnAlocar;
                                                                              safeSetState(() {});
                                                                              if (_shouldSetState)
                                                                                safeSetState(() {});
                                                                              return;
                                                                            }

                                                                            if (_shouldSetState)
                                                                              safeSetState(() {});
                                                                          },
                                                                          text:
                                                                              'Alocar',
                                                                          options:
                                                                              FFButtonOptions(
                                                                            height:
                                                                                30.0,
                                                                            padding: EdgeInsetsDirectional.fromSTEB(
                                                                                16.0,
                                                                                0.0,
                                                                                16.0,
                                                                                0.0),
                                                                            iconPadding: EdgeInsetsDirectional.fromSTEB(
                                                                                0.0,
                                                                                0.0,
                                                                                0.0,
                                                                                0.0),
                                                                            color:
                                                                                FlutterFlowTheme.of(context).primary,
                                                                            textStyle: FlutterFlowTheme.of(context).titleSmall.override(
                                                                                  font: GoogleFonts.interTight(
                                                                                    fontWeight: FontWeight.normal,
                                                                                    fontStyle: FlutterFlowTheme.of(context).titleSmall.fontStyle,
                                                                                  ),
                                                                                  color: Colors.white,
                                                                                  fontSize: 14.0,
                                                                                  letterSpacing: 0.0,
                                                                                  fontWeight: FontWeight.normal,
                                                                                  fontStyle: FlutterFlowTheme.of(context).titleSmall.fontStyle,
                                                                                ),
                                                                            elevation:
                                                                                0.0,
                                                                            borderRadius:
                                                                                BorderRadius.circular(8.0),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      Builder(
                                                                        builder:
                                                                            (context) =>
                                                                                FFButtonWidget(
                                                                          onPressed:
                                                                              () async {
                                                                            var _shouldSetState =
                                                                                false;
                                                                            if ((FFAppState().currentFunction == 'Leitor') ||
                                                                                (FFAppState().currentFunction == '')) {
                                                                              await showDialog(
                                                                                context: context,
                                                                                builder: (dialogContext) {
                                                                                  return Dialog(
                                                                                    elevation: 0,
                                                                                    insetPadding: EdgeInsets.zero,
                                                                                    backgroundColor: Colors.transparent,
                                                                                    alignment: AlignmentDirectional(-1.0, 0.0).resolve(Directionality.of(context)),
                                                                                    child: BsTopNotificacoesWidget(
                                                                                      pTipo: 'AVISO',
                                                                                      pMensagem: 'Atualmente você não tem permissão!',
                                                                                    ),
                                                                                  );
                                                                                },
                                                                              );

                                                                              if (_shouldSetState)
                                                                                safeSetState(() {});
                                                                              return;
                                                                            } else {
                                                                              await showModalBottomSheet(
                                                                                isScrollControlled: true,
                                                                                backgroundColor: Colors.transparent,
                                                                                context: context,
                                                                                builder: (context) {
                                                                                  return Padding(
                                                                                    padding: MediaQuery.viewInsetsOf(context),
                                                                                    child: Container(
                                                                                      height: 520.0,
                                                                                      child: BsDetalheTransacaoCRWidget(
                                                                                        pTipoTransacao: 'Devolver',
                                                                                        pValorDisponivel: valueOrDefault<double>(
                                                                                          listaItensCRAnaliticoItem.subsidioRecebido,
                                                                                          0.0,
                                                                                        ),
                                                                                        pIdProjetoCR: listaItensCRAnaliticoItem.crId,
                                                                                        pValorMaximoTrans: valueOrDefault<double>(
                                                                                          listaItensCRAnaliticoItem.subsidioRecebido,
                                                                                          0.0,
                                                                                        ),
                                                                                      ),
                                                                                    ),
                                                                                  );
                                                                                },
                                                                              ).then((value) => safeSetState(() {}));

                                                                              await Future.wait([
                                                                                Future(() async {
                                                                                  _model.retDadosCrSinteticoBtnDevolver = await actions.getCrSintetico(
                                                                                    FFAppState().currentOrganizationId,
                                                                                    FFAppState().dataInicioGlob!,
                                                                                    FFAppState().dataFimGlob!,
                                                                                  );
                                                                                  _shouldSetState = true;
                                                                                }),
                                                                                Future(() async {
                                                                                  _model.retDadosCrAnaliticoBtnDevolver = await actions.getCrAnalitico(
                                                                                    FFAppState().currentOrganizationId,
                                                                                    FFAppState().dataInicioGlob!,
                                                                                    FFAppState().dataFimGlob!,
                                                                                  );
                                                                                  _shouldSetState = true;
                                                                                }),
                                                                                Future(() async {
                                                                                  _model.retDadosCrConciliacaoBtnDevolver = await actions.getConciliacaoDashboard(
                                                                                    FFAppState().currentOrganizationId,
                                                                                    FFAppState().dataInicioGlob!,
                                                                                    FFAppState().dataFimGlob!,
                                                                                  );
                                                                                  _shouldSetState = true;
                                                                                }),
                                                                              ]);
                                                                              _model.dadosCRAnalitico = _model.retDadosCrAnaliticoBtnDevolver!.toList().cast<DTCrAnaliticoStruct>();
                                                                              _model.dadosCRSintetico = _model.retDadosCrSinteticoBtnDevolver;
                                                                              _model.estadoConciliacao = _model.retDadosCrConciliacaoBtnDevolver;
                                                                              safeSetState(() {});
                                                                              if (_shouldSetState)
                                                                                safeSetState(() {});
                                                                              return;
                                                                            }

                                                                            if (_shouldSetState)
                                                                              safeSetState(() {});
                                                                          },
                                                                          text:
                                                                              'Devolver',
                                                                          options:
                                                                              FFButtonOptions(
                                                                            height:
                                                                                30.0,
                                                                            padding: EdgeInsetsDirectional.fromSTEB(
                                                                                16.0,
                                                                                0.0,
                                                                                16.0,
                                                                                0.0),
                                                                            iconPadding: EdgeInsetsDirectional.fromSTEB(
                                                                                0.0,
                                                                                0.0,
                                                                                0.0,
                                                                                0.0),
                                                                            color:
                                                                                FlutterFlowTheme.of(context).primary,
                                                                            textStyle: FlutterFlowTheme.of(context).titleSmall.override(
                                                                                  font: GoogleFonts.interTight(
                                                                                    fontWeight: FontWeight.normal,
                                                                                    fontStyle: FlutterFlowTheme.of(context).titleSmall.fontStyle,
                                                                                  ),
                                                                                  color: Colors.white,
                                                                                  fontSize: 14.0,
                                                                                  letterSpacing: 0.0,
                                                                                  fontWeight: FontWeight.normal,
                                                                                  fontStyle: FlutterFlowTheme.of(context).titleSmall.fontStyle,
                                                                                ),
                                                                            elevation:
                                                                                0.0,
                                                                            borderRadius:
                                                                                BorderRadius.circular(8.0),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      Builder(
                                                                        builder:
                                                                            (context) =>
                                                                                FFButtonWidget(
                                                                          onPressed:
                                                                              () async {
                                                                            var _shouldSetState =
                                                                                false;
                                                                            if ((FFAppState().currentFunction == 'Leitor') ||
                                                                                (FFAppState().currentFunction == '')) {
                                                                              await showDialog(
                                                                                context: context,
                                                                                builder: (dialogContext) {
                                                                                  return Dialog(
                                                                                    elevation: 0,
                                                                                    insetPadding: EdgeInsets.zero,
                                                                                    backgroundColor: Colors.transparent,
                                                                                    alignment: AlignmentDirectional(-1.0, 0.0).resolve(Directionality.of(context)),
                                                                                    child: BsTopNotificacoesWidget(
                                                                                      pTipo: 'AVISO',
                                                                                      pMensagem: 'Atualmente você não tem permissão!',
                                                                                    ),
                                                                                  );
                                                                                },
                                                                              );

                                                                              if (_shouldSetState)
                                                                                safeSetState(() {});
                                                                              return;
                                                                            } else {
                                                                              await showModalBottomSheet(
                                                                                isScrollControlled: true,
                                                                                backgroundColor: Colors.transparent,
                                                                                context: context,
                                                                                builder: (context) {
                                                                                  return Padding(
                                                                                    padding: MediaQuery.viewInsetsOf(context),
                                                                                    child: Container(
                                                                                      height: 520.0,
                                                                                      child: BsDetalheTransacaoCRWidget(
                                                                                        pIdProjetoCR: listaItensCRAnaliticoItem.crId,
                                                                                        pTipoTransacao: 'Transferir',
                                                                                        pValorDisponivel: valueOrDefault<double>(
                                                                                                  listaItensCRAnaliticoItem.saldoCaixa,
                                                                                                  0.0,
                                                                                                ) >
                                                                                                0.0
                                                                                            ? valueOrDefault<double>(
                                                                                                listaItensCRAnaliticoItem.saldoCaixa,
                                                                                                0.0,
                                                                                              )
                                                                                            : 0.0,
                                                                                        pValorMaximoTrans: valueOrDefault<double>(
                                                                                                  listaItensCRAnaliticoItem.saldoCaixa,
                                                                                                  0.0,
                                                                                                ) >
                                                                                                0.0
                                                                                            ? valueOrDefault<double>(
                                                                                                listaItensCRAnaliticoItem.saldoCaixa,
                                                                                                0.0,
                                                                                              )
                                                                                            : 0.0,
                                                                                      ),
                                                                                    ),
                                                                                  );
                                                                                },
                                                                              ).then((value) => safeSetState(() {}));

                                                                              await Future.wait([
                                                                                Future(() async {
                                                                                  _model.retDadosCrSinteticoBtnTransferir = await actions.getCrSintetico(
                                                                                    FFAppState().currentOrganizationId,
                                                                                    FFAppState().dataInicioGlob!,
                                                                                    FFAppState().dataFimGlob!,
                                                                                  );
                                                                                  _shouldSetState = true;
                                                                                }),
                                                                                Future(() async {
                                                                                  _model.retDadosCrAnaliticoBtnTransferir = await actions.getCrAnalitico(
                                                                                    FFAppState().currentOrganizationId,
                                                                                    FFAppState().dataInicioGlob!,
                                                                                    FFAppState().dataFimGlob!,
                                                                                  );
                                                                                  _shouldSetState = true;
                                                                                }),
                                                                                Future(() async {
                                                                                  _model.retDadosCrConciliacaoBtnTransferir = await actions.getConciliacaoDashboard(
                                                                                    FFAppState().currentOrganizationId,
                                                                                    FFAppState().dataInicioGlob!,
                                                                                    FFAppState().dataFimGlob!,
                                                                                  );
                                                                                  _shouldSetState = true;
                                                                                }),
                                                                              ]);
                                                                              _model.dadosCRAnalitico = _model.retDadosCrAnaliticoBtnTransferir!.toList().cast<DTCrAnaliticoStruct>();
                                                                              _model.dadosCRSintetico = _model.retDadosCrSinteticoBtnTransferir;
                                                                              _model.estadoConciliacao = _model.retDadosCrConciliacaoBtnTransferir;
                                                                              safeSetState(() {});
                                                                              if (_shouldSetState)
                                                                                safeSetState(() {});
                                                                              return;
                                                                            }

                                                                            if (_shouldSetState)
                                                                              safeSetState(() {});
                                                                          },
                                                                          text:
                                                                              'Transferir',
                                                                          options:
                                                                              FFButtonOptions(
                                                                            height:
                                                                                30.0,
                                                                            padding: EdgeInsetsDirectional.fromSTEB(
                                                                                16.0,
                                                                                0.0,
                                                                                16.0,
                                                                                0.0),
                                                                            iconPadding: EdgeInsetsDirectional.fromSTEB(
                                                                                0.0,
                                                                                0.0,
                                                                                0.0,
                                                                                0.0),
                                                                            color:
                                                                                FlutterFlowTheme.of(context).primary,
                                                                            textStyle: FlutterFlowTheme.of(context).titleSmall.override(
                                                                                  font: GoogleFonts.interTight(
                                                                                    fontWeight: FontWeight.normal,
                                                                                    fontStyle: FlutterFlowTheme.of(context).titleSmall.fontStyle,
                                                                                  ),
                                                                                  color: Colors.white,
                                                                                  fontSize: 14.0,
                                                                                  letterSpacing: 0.0,
                                                                                  fontWeight: FontWeight.normal,
                                                                                  fontStyle: FlutterFlowTheme.of(context).titleSmall.fontStyle,
                                                                                ),
                                                                            elevation:
                                                                                0.0,
                                                                            borderRadius:
                                                                                BorderRadius.circular(8.0),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              );
                                            },
                                          );
                                        },
                                      ),
                                      Container(
                                        width: 100.0,
                                        height: 100.0,
                                        decoration: BoxDecoration(
                                          color: FlutterFlowTheme.of(context)
                                              .secondaryBackground,
                                        ),
                                      ),
                                    ],
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
          if ((_model.dadosCRAnalitico.isNotEmpty) == false)
            Align(
              alignment: AlignmentDirectional(0.0, 0.0),
              child: CircularPercentIndicator(
                percent: 0.75,
                radius: 60.0,
                lineWidth: 12.0,
                animation: true,
                animateFromLastPercent: true,
                progressColor: FlutterFlowTheme.of(context).primary,
                backgroundColor: FlutterFlowTheme.of(context).accent4,
                center: Text(
                  '75%',
                  style: FlutterFlowTheme.of(context).headlineSmall.override(
                        font: GoogleFonts.interTight(
                          fontWeight: FlutterFlowTheme.of(context)
                              .headlineSmall
                              .fontWeight,
                          fontStyle: FlutterFlowTheme.of(context)
                              .headlineSmall
                              .fontStyle,
                        ),
                        letterSpacing: 0.0,
                        fontWeight: FlutterFlowTheme.of(context)
                            .headlineSmall
                            .fontWeight,
                        fontStyle: FlutterFlowTheme.of(context)
                            .headlineSmall
                            .fontStyle,
                      ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
