import '/backend/schema/structs/index.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/lastro/geral/bs_filtro_periodo/bs_filtro_periodo_widget.dart';
import '/lastro/transacao/bs_transacoes_por_categoria/bs_transacoes_por_categoria_widget.dart';
import '/custom_code/actions/index.dart' as actions;
import '/flutter_flow/custom_functions.dart' as functions;
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'bs_d_f_c_model.dart';
export 'bs_d_f_c_model.dart';

class BsDFCWidget extends StatefulWidget {
  const BsDFCWidget({super.key});

  @override
  State<BsDFCWidget> createState() => _BsDFCWidgetState();
}

class _BsDFCWidgetState extends State<BsDFCWidget> {
  late BsDFCModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => BsDFCModel());

    // On component load action.
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      _model.retDadosDFCAnalitico = await actions.getDfcAnalitico(
        FFAppState().currentOrganizationId,
        FFAppState().dataInicioGlob!,
        FFAppState().dataFimGlob!,
      );
      _model.dadosDFCAnalitico =
          _model.retDadosDFCAnalitico!.toList().cast<DTDfcAnaliticoStruct>();
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
                            'Fluxo de Caixa',
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

                                  _model.retDadosDFCAnaliticoFiltro =
                                      await actions.getDfcAnalitico(
                                    FFAppState().currentOrganizationId,
                                    FFAppState().dataInicioGlob!,
                                    FFAppState().dataFimGlob!,
                                  );
                                  _model.dadosDFCAnalitico = _model
                                      .retDadosDFCAnaliticoFiltro!
                                      .toList()
                                      .cast<DTDfcAnaliticoStruct>();
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
                                  await actions.gerarPdfDfc(
                                    FFAppState().currentOrganizationName,
                                    _model.dadosDFCAnalitico.toList(),
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
                  child: RefreshIndicator(
                    onRefresh: () async {
                      _model.retDadosDFCAnaliticoPull =
                          await actions.getDfcAnalitico(
                        FFAppState().currentOrganizationId,
                        FFAppState().dataInicioGlob!,
                        FFAppState().dataFimGlob!,
                      );
                      _model.dadosDFCAnalitico = _model
                          .retDadosDFCAnaliticoPull!
                          .toList()
                          .cast<DTDfcAnaliticoStruct>();
                      safeSetState(() {});
                    },
                    child: SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Builder(
                            builder: (context) {
                              final listaItensDFCEstruturado =
                                  _model.dadosDFCAnalitico.toList();
                              if (listaItensDFCEstruturado.isEmpty) {
                                return Image.asset(
                                  'assets/images/logo_desativada_e_com_fundo.png',
                                );
                              }

                              return ListView.builder(
                                padding: EdgeInsets.zero,
                                primary: false,
                                shrinkWrap: true,
                                scrollDirection: Axis.vertical,
                                itemCount: listaItensDFCEstruturado.length,
                                itemBuilder:
                                    (context, listaItensDFCEstruturadoIndex) {
                                  final listaItensDFCEstruturadoItem =
                                      listaItensDFCEstruturado[
                                          listaItensDFCEstruturadoIndex];
                                  return Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        0.0,
                                        0.0,
                                        0.0,
                                        valueOrDefault<double>(
                                          listaItensDFCEstruturadoItem
                                                      .tipoLinha !=
                                                  'CATEGORIA'
                                              ? 12.0
                                              : 0.0,
                                          0.0,
                                        )),
                                    child: Container(
                                      width: double.infinity,
                                      height: listaItensDFCEstruturadoItem
                                                  .tipoLinha !=
                                              'CATEGORIA'
                                          ? 35.0
                                          : 30.0,
                                      decoration: BoxDecoration(
                                        color: () {
                                          if ((listaItensDFCEstruturadoItem
                                                      .tipoLinha ==
                                                  'CABECALHO') ||
                                              (listaItensDFCEstruturadoItem
                                                      .tipoLinha ==
                                                  'TOTAL')) {
                                            return Color(0xFF15263F);
                                          } else if (listaItensDFCEstruturadoItem
                                                  .tipoLinha ==
                                              'SALDO') {
                                            return Color(0xFF2D6725);
                                          } else {
                                            return Colors.transparent;
                                          }
                                        }(),
                                        borderRadius:
                                            BorderRadius.circular(16.0),
                                        border: Border.all(
                                          color: () {
                                            if ((listaItensDFCEstruturadoItem
                                                        .tipoLinha ==
                                                    'CABECALHO') ||
                                                (listaItensDFCEstruturadoItem
                                                        .tipoLinha ==
                                                    'TOTAL')) {
                                              return FlutterFlowTheme.of(
                                                      context)
                                                  .primaryBackground;
                                            } else if (listaItensDFCEstruturadoItem
                                                    .tipoLinha ==
                                                'SALDO') {
                                              return FlutterFlowTheme.of(
                                                      context)
                                                  .primaryBackground;
                                            } else {
                                              return Colors.transparent;
                                            }
                                          }(),
                                          width: 0.0,
                                        ),
                                      ),
                                      child: Padding(
                                        padding: EdgeInsets.all(6.0),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.max,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Padding(
                                              padding: EdgeInsetsDirectional
                                                  .fromSTEB(
                                                      valueOrDefault<double>(
                                                        listaItensDFCEstruturadoItem
                                                                    .tipoLinha ==
                                                                'CATEGORIA'
                                                            ? 20.0
                                                            : 5.0,
                                                        0.0,
                                                      ),
                                                      0.0,
                                                      0.0,
                                                      0.0),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.max,
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  if (listaItensDFCEstruturadoItem
                                                          .tipoLinha ==
                                                      'CATEGORIA')
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
                                                                        'DFC',
                                                                    pNomeCategoria:
                                                                        listaItensDFCEstruturadoItem
                                                                            .contaNome,
                                                                    pIdCategoria:
                                                                        listaItensDFCEstruturadoItem
                                                                            .contaId,
                                                                    pTipoCategoria:
                                                                        listaItensDFCEstruturadoItem
                                                                            .contaTipo,
                                                                    pInicioMesAno:
                                                                        FFAppState()
                                                                            .dataInicioGlob,
                                                                    pFinalMesAno:
                                                                        FFAppState()
                                                                            .dataFimGlob,
                                                                    pValorTotal:
                                                                        listaItensDFCEstruturadoItem
                                                                            .saldo,
                                                                    pCodigoContabil:
                                                                        listaItensDFCEstruturadoItem
                                                                            .contaCodigo,
                                                                  ),
                                                                );
                                                              },
                                                            ).then((value) =>
                                                                safeSetState(
                                                                    () {}));

                                                            _model.retDadosDFCAnaliticoBS =
                                                                await actions
                                                                    .getDfcAnalitico(
                                                              FFAppState()
                                                                  .currentOrganizationId,
                                                              FFAppState()
                                                                  .dataInicioGlob!,
                                                              FFAppState()
                                                                  .dataFimGlob!,
                                                            );
                                                            _shouldSetState =
                                                                true;
                                                            _model.dadosDFCAnalitico = _model
                                                                .retDadosDFCAnaliticoBS!
                                                                .toList()
                                                                .cast<
                                                                    DTDfcAnaliticoStruct>();
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
                                                      listaItensDFCEstruturadoItem
                                                          .descricao,
                                                      maxLines: 1,
                                                      style:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .bodyMedium
                                                              .override(
                                                                font:
                                                                    GoogleFonts
                                                                        .inter(
                                                                  fontWeight: FlutterFlowTheme.of(
                                                                          context)
                                                                      .bodyMedium
                                                                      .fontWeight,
                                                                  fontStyle: FlutterFlowTheme.of(
                                                                          context)
                                                                      .bodyMedium
                                                                      .fontStyle,
                                                                ),
                                                                fontSize: listaItensDFCEstruturadoItem
                                                                            .tipoLinha !=
                                                                        'CATEGORIA'
                                                                    ? 12.0
                                                                    : 10.0,
                                                                letterSpacing:
                                                                    0.0,
                                                                fontWeight: FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyMedium
                                                                    .fontWeight,
                                                                fontStyle: FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyMedium
                                                                    .fontStyle,
                                                              ),
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                  ),
                                                  if (listaItensDFCEstruturadoItem
                                                          .tipoLinha !=
                                                      'CABECALHO')
                                                    Padding(
                                                      padding:
                                                          EdgeInsetsDirectional
                                                              .fromSTEB(
                                                                  12.0,
                                                                  0.0,
                                                                  12.0,
                                                                  0.0),
                                                      child: Text(
                                                        functions.formatarMoeda(
                                                            listaItensDFCEstruturadoItem
                                                                .saldo,
                                                            false),
                                                        style:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .bodyMedium
                                                                .override(
                                                                  font:
                                                                      GoogleFonts
                                                                          .inter(
                                                                    fontWeight: FlutterFlowTheme.of(
                                                                            context)
                                                                        .bodyMedium
                                                                        .fontWeight,
                                                                    fontStyle: FlutterFlowTheme.of(
                                                                            context)
                                                                        .bodyMedium
                                                                        .fontStyle,
                                                                  ),
                                                                  fontSize: listaItensDFCEstruturadoItem
                                                                              .tipoLinha !=
                                                                          'CATEGORIA'
                                                                      ? 12.0
                                                                      : 10.0,
                                                                  letterSpacing:
                                                                      0.0,
                                                                  fontWeight: FlutterFlowTheme.of(
                                                                          context)
                                                                      .bodyMedium
                                                                      .fontWeight,
                                                                  fontStyle: FlutterFlowTheme.of(
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
                                  );
                                },
                              );
                            },
                          ),
                          Container(
                            width: double.infinity,
                            height: 200.0,
                            decoration: BoxDecoration(
                              color: FlutterFlowTheme.of(context)
                                  .secondaryBackground,
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      12.0, 12.0, 12.0, 12.0),
                                  child: FFButtonWidget(
                                    onPressed: () async {
                                      await actions.gerarCsvDfc(
                                        FFAppState().currentOrganizationName,
                                        _model.dadosDFCAnalitico.toList(),
                                        FFAppState().dataInicioGlob!,
                                        FFAppState().dataFimGlob!,
                                      );
                                    },
                                    text: 'Exportar CSV',
                                    icon: Icon(
                                      Icons.import_export,
                                      size: 24.0,
                                    ),
                                    options: FFButtonOptions(
                                      width: 200.0,
                                      height: 40.0,
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          16.0, 0.0, 16.0, 0.0),
                                      iconPadding:
                                          EdgeInsetsDirectional.fromSTEB(
                                              0.0, 0.0, 0.0, 0.0),
                                      color:
                                          FlutterFlowTheme.of(context).primary,
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
                                            color: Colors.white,
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
                                      elevation: 0.0,
                                      borderRadius: BorderRadius.circular(8.0),
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}
