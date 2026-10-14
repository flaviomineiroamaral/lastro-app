import '/backend/schema/structs/index.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/lastro/geral/bs_filtro_periodo/bs_filtro_periodo_widget.dart';
import '/lastro/geral/bs_top_notificacoes/bs_top_notificacoes_widget.dart';
import '/lastro/transacao/bs_detalhe_transacao/bs_detalhe_transacao_widget.dart';
import '/custom_code/actions/index.dart' as actions;
import '/flutter_flow/custom_functions.dart' as functions;
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'bs_transacao_model.dart';
export 'bs_transacao_model.dart';

class BsTransacaoWidget extends StatefulWidget {
  const BsTransacaoWidget({
    super.key,
    required this.pNomeConta,
    this.pIdConta,
    this.pTipoConta,
    this.pDiaVencCartao,
    this.pDiaFechFatura,
  });

  final String? pNomeConta;
  final String? pIdConta;
  final String? pTipoConta;
  final int? pDiaVencCartao;
  final int? pDiaFechFatura;

  @override
  State<BsTransacaoWidget> createState() => _BsTransacaoWidgetState();
}

class _BsTransacaoWidgetState extends State<BsTransacaoWidget> {
  late BsTransacaoModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => BsTransacaoModel());

    // On component load action.
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      _model.isProcessing = true;
      safeSetState(() {});
      _model.retDadosExtratoPeriodo = await actions.getExtratoPorPeriodo(
        FFAppState().currentOrganizationId,
        widget.pIdConta!,
        FFAppState().dataInicioGlob!,
        FFAppState().dataFimGlob!,
      );
      _model.dadosExtratoPeriodo = _model.retDadosExtratoPeriodo!
          .toList()
          .cast<DTExtratoPeriodoStruct>();
      safeSetState(() {});
      _model.isProcessing = false;
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
      child: Stack(
        alignment: AlignmentDirectional(1.0, 1.0),
        children: [
          Align(
            alignment: AlignmentDirectional(0.0, -1.0),
            child: SafeArea(
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
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Align(
                        alignment: AlignmentDirectional(0.0, 0.0),
                        child: Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(
                              0.0, 0.0, 0.0, 12.0),
                          child: Container(
                            width: double.infinity,
                            height: 30.0,
                            decoration: BoxDecoration(
                              color: FlutterFlowTheme.of(context)
                                  .secondaryBackground,
                              borderRadius: BorderRadius.circular(2.0),
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
                                    'Extrato Transações',
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
                      Container(
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

                                  _model.retDadosExtratoPeriodoFiltro =
                                      await actions.getExtratoPorPeriodo(
                                    FFAppState().currentOrganizationId,
                                    widget.pIdConta!,
                                    FFAppState().dataInicioGlob!,
                                    FFAppState().dataFimGlob!,
                                  );
                                  _model.dadosExtratoPeriodo = _model
                                      .retDadosExtratoPeriodoFiltro!
                                      .toList()
                                      .cast<DTExtratoPeriodoStruct>();
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
                            InkWell(
                              splashColor: Colors.transparent,
                              focusColor: Colors.transparent,
                              hoverColor: Colors.transparent,
                              highlightColor: Colors.transparent,
                              onTap: () async {
                                await actions.gerarPdfExtrato(
                                  FFAppState().currentOrganizationName,
                                  _model.dadosExtratoPeriodo.toList(),
                                  widget.pNomeConta,
                                  FFAppState().dataInicioGlob,
                                  FFAppState().dataFimGlob,
                                );
                              },
                              child: Icon(
                                Icons.print,
                                color: FlutterFlowTheme.of(context).primary,
                                size: 24.0,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Align(
                        alignment: AlignmentDirectional(-1.0, 0.0),
                        child: Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(
                              4.0, 12.0, 0.0, 20.0),
                          child: Text(
                            'Conta: ${widget.pNomeConta}',
                            textAlign: TextAlign.center,
                            style: FlutterFlowTheme.of(context)
                                .bodyMedium
                                .override(
                                  font: GoogleFonts.inter(
                                    fontWeight: FontWeight.bold,
                                    fontStyle: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .fontStyle,
                                  ),
                                  color:
                                      FlutterFlowTheme.of(context).primaryText,
                                  fontSize: 14.0,
                                  letterSpacing: 0.0,
                                  fontWeight: FontWeight.bold,
                                  fontStyle: FlutterFlowTheme.of(context)
                                      .bodyMedium
                                      .fontStyle,
                                ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          width: 100.0,
                          decoration: BoxDecoration(),
                          child: RefreshIndicator(
                            onRefresh: () async {
                              _model.retDadosExtratoPeriodoPull =
                                  await actions.getExtratoPorPeriodo(
                                FFAppState().currentOrganizationId,
                                widget.pIdConta!,
                                FFAppState().dataInicioGlob!,
                                FFAppState().dataFimGlob!,
                              );
                              _model.dadosExtratoPeriodo = _model
                                  .retDadosExtratoPeriodoPull!
                                  .toList()
                                  .cast<DTExtratoPeriodoStruct>();
                              safeSetState(() {});
                            },
                            child: SingleChildScrollView(
                              physics: const AlwaysScrollableScrollPhysics(),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Builder(
                                    builder: (context) {
                                      final listaExtrato =
                                          _model.dadosExtratoPeriodo.toList();

                                      return ListView.builder(
                                        padding: EdgeInsets.zero,
                                        primary: false,
                                        shrinkWrap: true,
                                        scrollDirection: Axis.vertical,
                                        itemCount: listaExtrato.length,
                                        itemBuilder:
                                            (context, listaExtratoIndex) {
                                          final listaExtratoItem =
                                              listaExtrato[listaExtratoIndex];
                                          return Column(
                                            mainAxisSize: MainAxisSize.min,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.stretch,
                                            children: [
                                              if (functions.devoMostrarAData(
                                                  listaExtratoIndex,
                                                  _model.dadosExtratoPeriodo
                                                      .toList()))
                                                Container(
                                                  width: 100.0,
                                                  height: 40.0,
                                                  decoration: BoxDecoration(),
                                                  child: Padding(
                                                    padding:
                                                        EdgeInsetsDirectional
                                                            .fromSTEB(0.0, 12.0,
                                                                0.0, 0.0),
                                                    child: Row(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Opacity(
                                                          opacity: 0.7,
                                                          child: Padding(
                                                            padding:
                                                                EdgeInsetsDirectional
                                                                    .fromSTEB(
                                                                        8.0,
                                                                        0.0,
                                                                        0.0,
                                                                        0.0),
                                                            child: Text(
                                                              dateTimeFormat(
                                                                "EEE, dd/MM/yyyy",
                                                                listaExtratoItem
                                                                    .dataLinhaTempo!,
                                                                locale: FFLocalizations.of(
                                                                        context)
                                                                    .languageCode,
                                                              ),
                                                              style: FlutterFlowTheme
                                                                      .of(context)
                                                                  .bodyMedium
                                                                  .override(
                                                                    font: GoogleFonts
                                                                        .inter(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w600,
                                                                      fontStyle: FlutterFlowTheme.of(
                                                                              context)
                                                                          .bodyMedium
                                                                          .fontStyle,
                                                                    ),
                                                                    letterSpacing:
                                                                        0.0,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600,
                                                                    fontStyle: FlutterFlowTheme.of(
                                                                            context)
                                                                        .bodyMedium
                                                                        .fontStyle,
                                                                  ),
                                                            ),
                                                          ),
                                                        ),
                                                        Padding(
                                                          padding:
                                                              EdgeInsetsDirectional
                                                                  .fromSTEB(
                                                                      0.0,
                                                                      0.0,
                                                                      8.0,
                                                                      0.0),
                                                          child: Text(
                                                            'Saldo ${functions.formatarMoeda(listaExtratoItem.saldoProgressivo, false)}',
                                                            style: FlutterFlowTheme
                                                                    .of(context)
                                                                .bodyMedium
                                                                .override(
                                                                  font:
                                                                      GoogleFonts
                                                                          .inter(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600,
                                                                    fontStyle: FlutterFlowTheme.of(
                                                                            context)
                                                                        .bodyMedium
                                                                        .fontStyle,
                                                                  ),
                                                                  color: listaExtratoItem
                                                                              .saldoProgressivo >=
                                                                          0.0
                                                                      ? FlutterFlowTheme.of(
                                                                              context)
                                                                          .primaryText
                                                                      : FlutterFlowTheme.of(
                                                                              context)
                                                                          .error,
                                                                  fontSize:
                                                                      14.0,
                                                                  letterSpacing:
                                                                      0.0,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
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
                                                ),
                                              if (functions.devoMostrarAData(
                                                  listaExtratoIndex,
                                                  _model.dadosExtratoPeriodo
                                                      .toList()))
                                                Divider(
                                                  color: FlutterFlowTheme.of(
                                                          context)
                                                      .alternate,
                                                ),
                                              Padding(
                                                padding: EdgeInsetsDirectional
                                                    .fromSTEB(
                                                        0.0, 0.0, 0.0, 4.0),
                                                child: Container(
                                                  width: double.infinity,
                                                  height: 60.0,
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            16.0),
                                                  ),
                                                  child: Builder(
                                                    builder: (context) =>
                                                        InkWell(
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
                                                        if ((FFAppState()
                                                                    .currentFunction ==
                                                                'Leitor') ||
                                                            (FFAppState()
                                                                        .currentFunction ==
                                                                    '')) {
                                                          await showDialog(
                                                            context: context,
                                                            builder:
                                                                (dialogContext) {
                                                              return Dialog(
                                                                elevation: 0,
                                                                insetPadding:
                                                                    EdgeInsets
                                                                        .zero,
                                                                backgroundColor:
                                                                    Colors
                                                                        .transparent,
                                                                alignment: AlignmentDirectional(
                                                                        0.0,
                                                                        0.0)
                                                                    .resolve(
                                                                        Directionality.of(
                                                                            context)),
                                                                child:
                                                                    BsTopNotificacoesWidget(
                                                                  pTipo:
                                                                      'AVISO',
                                                                  pMensagem:
                                                                      'Atualmente você não tem permissão!',
                                                                ),
                                                              );
                                                            },
                                                          );

                                                          if (_shouldSetState)
                                                            safeSetState(() {});
                                                          return;
                                                        } else {
                                                          if ((widget.pTipoConta !=
                                                                  'VIRTUAL') &&
                                                              (listaExtratoItem
                                                                      .status ==
                                                                  'CONCILIADO')) {
                                                            await showModalBottomSheet(
                                                              isScrollControlled:
                                                                  true,
                                                              backgroundColor:
                                                                  Colors
                                                                      .transparent,
                                                              enableDrag: false,
                                                              context: context,
                                                              builder:
                                                                  (context) {
                                                                return Padding(
                                                                  padding: MediaQuery
                                                                      .viewInsetsOf(
                                                                          context),
                                                                  child:
                                                                      BsDetalheTransacaoWidget(
                                                                    pIdTransacao:
                                                                        listaExtratoItem
                                                                            .transacaoId,
                                                                    pIdConta:
                                                                        widget
                                                                            .pIdConta,
                                                                    pTipoConta:
                                                                        widget
                                                                            .pTipoConta,
                                                                  ),
                                                                );
                                                              },
                                                            ).then((value) =>
                                                                safeSetState(
                                                                    () {}));

                                                            _model.retDadosExtratoPeriodoDTEditar =
                                                                await actions
                                                                    .getExtratoPorPeriodo(
                                                              FFAppState()
                                                                  .currentOrganizationId,
                                                              widget.pIdConta!,
                                                              FFAppState()
                                                                  .dataInicioGlob!,
                                                              FFAppState()
                                                                  .dataFimGlob!,
                                                            );
                                                            _shouldSetState =
                                                                true;
                                                            _model.dadosExtratoPeriodo = _model
                                                                .retDadosExtratoPeriodoDTEditar!
                                                                .toList()
                                                                .cast<
                                                                    DTExtratoPeriodoStruct>();
                                                            safeSetState(() {});
                                                            if (_shouldSetState)
                                                              safeSetState(
                                                                  () {});
                                                            return;
                                                          } else {
                                                            await showDialog(
                                                              context: context,
                                                              builder:
                                                                  (dialogContext) {
                                                                return Dialog(
                                                                  elevation: 0,
                                                                  insetPadding:
                                                                      EdgeInsets
                                                                          .zero,
                                                                  backgroundColor:
                                                                      Colors
                                                                          .transparent,
                                                                  alignment: AlignmentDirectional(
                                                                          0.0,
                                                                          0.0)
                                                                      .resolve(
                                                                          Directionality.of(
                                                                              context)),
                                                                  child:
                                                                      BsTopNotificacoesWidget(
                                                                    pTipo:
                                                                        'AVISO',
                                                                    pMensagem:
                                                                        'Este registro não pode ser alterado.',
                                                                  ),
                                                                );
                                                              },
                                                            );

                                                            if (_shouldSetState)
                                                              safeSetState(
                                                                  () {});
                                                            return;
                                                          }
                                                        }

                                                        if (_shouldSetState)
                                                          safeSetState(() {});
                                                      },
                                                      child: Row(
                                                        mainAxisSize:
                                                            MainAxisSize.min,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        children: [
                                                          Padding(
                                                            padding:
                                                                EdgeInsetsDirectional
                                                                    .fromSTEB(
                                                                        10.0,
                                                                        10.0,
                                                                        10.0,
                                                                        10.0),
                                                            child: Container(
                                                              width: 40.0,
                                                              height: 40.0,
                                                              decoration:
                                                                  BoxDecoration(
                                                                color: FlutterFlowTheme.of(
                                                                        context)
                                                                    .alternate,
                                                                shape: BoxShape
                                                                    .circle,
                                                              ),
                                                              child: Stack(
                                                                alignment:
                                                                    AlignmentDirectional(
                                                                        0.0,
                                                                        0.0),
                                                                children: [
                                                                  if (listaExtratoItem
                                                                          .tipoOperacao ==
                                                                      'DEBITO')
                                                                    Icon(
                                                                      Icons
                                                                          .call_made_outlined,
                                                                      color: FlutterFlowTheme.of(
                                                                              context)
                                                                          .error,
                                                                      size:
                                                                          24.0,
                                                                    ),
                                                                  if (listaExtratoItem
                                                                          .tipoOperacao ==
                                                                      'CREDITO')
                                                                    Icon(
                                                                      Icons
                                                                          .call_received_outlined,
                                                                      color: FlutterFlowTheme.of(
                                                                              context)
                                                                          .secondary,
                                                                      size:
                                                                          24.0,
                                                                    ),
                                                                  if (listaExtratoItem
                                                                          .tipoOperacao ==
                                                                      'TRANSFERENCIA')
                                                                    Icon(
                                                                      Icons
                                                                          .sync_alt_outlined,
                                                                      color: FlutterFlowTheme.of(
                                                                              context)
                                                                          .accent4,
                                                                      size:
                                                                          24.0,
                                                                    ),
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                          Expanded(
                                                            child: Column(
                                                              mainAxisSize:
                                                                  MainAxisSize
                                                                      .min,
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Row(
                                                                  mainAxisSize:
                                                                      MainAxisSize
                                                                          .max,
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .spaceBetween,
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    Expanded(
                                                                      child:
                                                                          Padding(
                                                                        padding: EdgeInsetsDirectional.fromSTEB(
                                                                            0.0,
                                                                            0.0,
                                                                            8.0,
                                                                            0.0),
                                                                        child:
                                                                            Text(
                                                                          valueOrDefault<
                                                                              String>(
                                                                            listaExtratoItem.descricao,
                                                                            'Sem descrição',
                                                                          ),
                                                                          maxLines:
                                                                              2,
                                                                          style: FlutterFlowTheme.of(context)
                                                                              .bodyMedium
                                                                              .override(
                                                                                font: GoogleFonts.inter(
                                                                                  fontWeight: FontWeight.normal,
                                                                                  fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                                                                                ),
                                                                                color: FlutterFlowTheme.of(context).primaryText,
                                                                                fontSize: 12.0,
                                                                                letterSpacing: 0.0,
                                                                                fontWeight: FontWeight.normal,
                                                                                fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                                                                              ),
                                                                          overflow:
                                                                              TextOverflow.ellipsis,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    Opacity(
                                                                      opacity:
                                                                          0.8,
                                                                      child:
                                                                          Text(
                                                                        functions.formatarMoeda(
                                                                            listaExtratoItem.valorMovimento,
                                                                            false),
                                                                        style: FlutterFlowTheme.of(context)
                                                                            .bodyMedium
                                                                            .override(
                                                                              font: GoogleFonts.inter(
                                                                                fontWeight: FontWeight.w600,
                                                                                fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                                                                              ),
                                                                              color: () {
                                                                                if (listaExtratoItem.tipoOperacao == 'CREDITO') {
                                                                                  return FlutterFlowTheme.of(context).secondary;
                                                                                } else if (listaExtratoItem.tipoOperacao == 'DEBITO') {
                                                                                  return FlutterFlowTheme.of(context).primaryText;
                                                                                } else {
                                                                                  return FlutterFlowTheme.of(context).primaryText;
                                                                                }
                                                                              }(),
                                                                              fontSize: 12.0,
                                                                              letterSpacing: 0.0,
                                                                              fontWeight: FontWeight.w600,
                                                                              fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                                                                            ),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                                Row(
                                                                  mainAxisSize:
                                                                      MainAxisSize
                                                                          .max,
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .end,
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    Expanded(
                                                                      child:
                                                                          Padding(
                                                                        padding: EdgeInsetsDirectional.fromSTEB(
                                                                            0.0,
                                                                            0.0,
                                                                            8.0,
                                                                            0.0),
                                                                        child:
                                                                            Text(
                                                                          valueOrDefault<
                                                                              String>(
                                                                            listaExtratoItem.categoriaNome,
                                                                            'Sem categoria',
                                                                          ),
                                                                          maxLines:
                                                                              3,
                                                                          style: FlutterFlowTheme.of(context)
                                                                              .bodyMedium
                                                                              .override(
                                                                                font: GoogleFonts.inter(
                                                                                  fontWeight: FontWeight.w300,
                                                                                  fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                                                                                ),
                                                                                color: FlutterFlowTheme.of(context).secondaryText,
                                                                                fontSize: 12.0,
                                                                                letterSpacing: 0.0,
                                                                                fontWeight: FontWeight.w300,
                                                                                fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                                                                              ),
                                                                          overflow:
                                                                              TextOverflow.ellipsis,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                                if (listaExtratoItem
                                                                        .tipoOperacao ==
                                                                    'CARTAO')
                                                                  Row(
                                                                    mainAxisSize:
                                                                        MainAxisSize
                                                                            .max,
                                                                    children: [
                                                                      if (listaExtratoItem
                                                                              .tipoOperacao ==
                                                                          'CARTAO')
                                                                        Text(
                                                                          'Aconteceu: ${dateTimeFormat(
                                                                            "EEE, dd/MM/yyy",
                                                                            listaExtratoItem.dataCompetencia,
                                                                            locale:
                                                                                FFLocalizations.of(context).languageCode,
                                                                          )}',
                                                                          style: FlutterFlowTheme.of(context)
                                                                              .bodyMedium
                                                                              .override(
                                                                                font: GoogleFonts.inter(
                                                                                  fontWeight: FontWeight.w300,
                                                                                  fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                                                                                ),
                                                                                color: FlutterFlowTheme.of(context).secondaryText,
                                                                                fontSize: 12.0,
                                                                                letterSpacing: 0.0,
                                                                                fontWeight: FontWeight.w300,
                                                                                fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                                                                              ),
                                                                        ),
                                                                    ],
                                                                  ),
                                                              ],
                                                            ),
                                                          ),
                                                          Align(
                                                            alignment:
                                                                AlignmentDirectional(
                                                                    1.0, 0.0),
                                                            child: Padding(
                                                              padding:
                                                                  EdgeInsetsDirectional
                                                                      .fromSTEB(
                                                                          8.0,
                                                                          0.0,
                                                                          8.0,
                                                                          0.0),
                                                              child: Icon(
                                                                Icons
                                                                    .arrow_forward_ios,
                                                                color: FlutterFlowTheme.of(
                                                                        context)
                                                                    .secondaryText,
                                                                size: 16.0,
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                    },
                                  ),
                                  Container(
                                    width: 100.0,
                                    height: 100.0,
                                    decoration: BoxDecoration(),
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
          Opacity(
            opacity: 0.5,
            child: Builder(
              builder: (context) => Padding(
                padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 17.0, 65.0),
                child: FloatingActionButton(
                  onPressed: () async {
                    var _shouldSetState = false;
                    if ((FFAppState().currentFunction == 'Leitor') ||
                        (FFAppState().currentFunction == '')) {
                      await showDialog(
                        context: context,
                        builder: (dialogContext) {
                          return Dialog(
                            elevation: 0,
                            insetPadding: EdgeInsets.zero,
                            backgroundColor: Colors.transparent,
                            alignment: AlignmentDirectional(0.0, 0.0)
                                .resolve(Directionality.of(context)),
                            child: BsTopNotificacoesWidget(
                              pTipo: 'AVISO',
                              pMensagem: 'Atualmente você não tem permissão!',
                            ),
                          );
                        },
                      );

                      if (_shouldSetState) safeSetState(() {});
                      return;
                    } else {
                      await showModalBottomSheet(
                        isScrollControlled: true,
                        backgroundColor: Colors.transparent,
                        enableDrag: false,
                        context: context,
                        builder: (context) {
                          return Padding(
                            padding: MediaQuery.viewInsetsOf(context),
                            child: BsDetalheTransacaoWidget(
                              pIdTransacao: '',
                              pIdConta: widget.pIdConta,
                              pTipoConta: widget.pTipoConta,
                              pDataVencimentoSugerida:
                                  widget.pTipoConta == 'CARTAO'
                                      ? functions.calcularVencimentoFatura(
                                          getCurrentTimestamp,
                                          widget.pDiaFechFatura!,
                                          widget.pDiaVencCartao!)
                                      : getCurrentTimestamp,
                            ),
                          );
                        },
                      ).then((value) => safeSetState(() {}));

                      _model.retDadosExtratoPeriodoDTNovo =
                          await actions.getExtratoPorPeriodo(
                        FFAppState().currentOrganizationId,
                        widget.pIdConta!,
                        FFAppState().dataInicioGlob!,
                        FFAppState().dataFimGlob!,
                      );
                      _shouldSetState = true;
                      _model.dadosExtratoPeriodo = _model
                          .retDadosExtratoPeriodoDTNovo!
                          .toList()
                          .cast<DTExtratoPeriodoStruct>();
                      safeSetState(() {});
                    }

                    if (_shouldSetState) safeSetState(() {});
                  },
                  backgroundColor: FlutterFlowTheme.of(context).primary,
                  elevation: 8.0,
                  child: Icon(
                    Icons.add_rounded,
                    color: FlutterFlowTheme.of(context).info,
                    size: 24.0,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
