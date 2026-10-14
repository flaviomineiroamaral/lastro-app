import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/lastro/cadastro/bs_centro_de_resultado/bs_centro_de_resultado_widget.dart';
import '/lastro/geral/bs_top_notificacoes/bs_top_notificacoes_widget.dart';
import '/custom_code/actions/index.dart' as actions;
import '/flutter_flow/custom_functions.dart' as functions;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'gerenciar_centro_de_resultado_model.dart';
export 'gerenciar_centro_de_resultado_model.dart';

class GerenciarCentroDeResultadoWidget extends StatefulWidget {
  const GerenciarCentroDeResultadoWidget({super.key});

  static String routeName = 'GerenciarCentroDeResultado';
  static String routePath = '/GerenciarCentroDeResultado';

  @override
  State<GerenciarCentroDeResultadoWidget> createState() =>
      _GerenciarCentroDeResultadoWidgetState();
}

class _GerenciarCentroDeResultadoWidgetState
    extends State<GerenciarCentroDeResultadoWidget> {
  late GerenciarCentroDeResultadoModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => GerenciarCentroDeResultadoModel());

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    context.watch<FFAppState>();

    return Title(
        title: 'GerenciarCentroDeResultado',
        color: FlutterFlowTheme.of(context).primary.withAlpha(0XFF),
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
            FocusManager.instance.primaryFocus?.unfocus();
          },
          child: PopScope(
            canPop: false,
            child: Scaffold(
              key: scaffoldKey,
              backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
              floatingActionButton: Opacity(
                opacity: 0.5,
                child: Builder(
                  builder: (context) => FloatingActionButton(
                    onPressed: () async {
                      if ((FFAppState().currentFunction == 'Leitor') ||
                          (FFAppState().currentFunction == '')) {
                        await showDialog(
                          context: context,
                          builder: (dialogContext) {
                            return Dialog(
                              elevation: 0,
                              insetPadding: EdgeInsets.zero,
                              backgroundColor: Colors.transparent,
                              alignment: AlignmentDirectional(-1.0, 0.0)
                                  .resolve(Directionality.of(context)),
                              child: GestureDetector(
                                onTap: () {
                                  FocusScope.of(dialogContext).unfocus();
                                  FocusManager.instance.primaryFocus?.unfocus();
                                },
                                child: BsTopNotificacoesWidget(
                                  pTipo: 'AVISO',
                                  pMensagem:
                                      'Atualmente você não tem permissão!',
                                ),
                              ),
                            );
                          },
                        );

                        return;
                      } else {
                        await showModalBottomSheet(
                          isScrollControlled: true,
                          backgroundColor: FlutterFlowTheme.of(context).accent3,
                          context: context,
                          builder: (context) {
                            return GestureDetector(
                              onTap: () {
                                FocusScope.of(context).unfocus();
                                FocusManager.instance.primaryFocus?.unfocus();
                              },
                              child: Padding(
                                padding: MediaQuery.viewInsetsOf(context),
                                child: Container(
                                  height: 500.0,
                                  child: BsCentroDeResultadoWidget(
                                    pIdCentroResultado: '',
                                    pNome: '',
                                    pCorSelecionada: null,
                                    pAtivo: true,
                                    pIsPadrao: false,
                                    pIsFundo: false,
                                    pPermiteAcumulo: false,
                                  ),
                                ),
                              ),
                            );
                          },
                        ).then((value) => safeSetState(() {}));

                        await actions.syncMasterCache(
                          FFAppState().currentOrganizationId,
                          false,
                          false,
                          true,
                          false,
                        );
                        return;
                      }
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
              appBar: AppBar(
                backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
                automaticallyImplyLeading: false,
                leading: FlutterFlowIconButton(
                  borderColor: Colors.transparent,
                  borderRadius: 30.0,
                  borderWidth: 1.0,
                  buttonSize: 60.0,
                  icon: Icon(
                    Icons.arrow_back_rounded,
                    color: Colors.white,
                    size: 30.0,
                  ),
                  onPressed: () async {
                    context.pop();
                  },
                ),
                title: Text(
                  'Gerenciar Centro de Resultado',
                  style: FlutterFlowTheme.of(context).headlineMedium.override(
                        font: GoogleFonts.interTight(
                          fontWeight: FlutterFlowTheme.of(context)
                              .headlineMedium
                              .fontWeight,
                          fontStyle: FlutterFlowTheme.of(context)
                              .headlineMedium
                              .fontStyle,
                        ),
                        color: FlutterFlowTheme.of(context).primaryText,
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
                actions: [],
                centerTitle: false,
                elevation: 2.0,
              ),
              body: SafeArea(
                top: true,
                child: Align(
                  alignment: AlignmentDirectional(0.0, -1.0),
                  child: Container(
                    constraints: BoxConstraints(
                      maxWidth: FFAppConstants.LarguraMaxima.toDouble(),
                    ),
                    decoration: BoxDecoration(),
                    child: Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(
                          20.0, 20.0, 20.0, 20.0),
                      child: SingleChildScrollView(
                        primary: false,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Builder(
                              builder: (context) {
                                final listaCentroResultado = FFAppState()
                                    .cacheCentrosDeResultado
                                    .toList();

                                return ListView.builder(
                                  padding: EdgeInsets.zero,
                                  primary: false,
                                  shrinkWrap: true,
                                  scrollDirection: Axis.vertical,
                                  itemCount: listaCentroResultado.length,
                                  itemBuilder:
                                      (context, listaCentroResultadoIndex) {
                                    final listaCentroResultadoItem =
                                        listaCentroResultado[
                                            listaCentroResultadoIndex];
                                    return Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          0.0, 0.0, 0.0, 12.0),
                                      child: Container(
                                        width: double.infinity,
                                        decoration: BoxDecoration(
                                          color: FlutterFlowTheme.of(context)
                                              .secondaryBackground,
                                          borderRadius:
                                              BorderRadius.circular(12.0),
                                        ),
                                        child: Padding(
                                          padding: EdgeInsets.all(10.0),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Padding(
                                                padding: EdgeInsetsDirectional
                                                    .fromSTEB(
                                                        0.0, 0.0, 10.0, 0.0),
                                                child: Container(
                                                  width: 35.0,
                                                  height: 35.0,
                                                  decoration: BoxDecoration(
                                                    color:
                                                        valueOrDefault<Color>(
                                                      functions.hexToColor(
                                                          listaCentroResultadoItem
                                                              .corHex),
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .primary,
                                                    ),
                                                    shape: BoxShape.circle,
                                                  ),
                                                ),
                                              ),
                                              Expanded(
                                                child: Padding(
                                                  padding: EdgeInsetsDirectional
                                                      .fromSTEB(
                                                          0.0, 0.0, 8.0, 0.0),
                                                  child: Text(
                                                    listaCentroResultadoItem
                                                        .nome,
                                                    style: FlutterFlowTheme.of(
                                                            context)
                                                        .bodyMedium
                                                        .override(
                                                          font:
                                                              GoogleFonts.inter(
                                                            fontWeight:
                                                                FontWeight
                                                                    .normal,
                                                            fontStyle:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyMedium
                                                                    .fontStyle,
                                                          ),
                                                          letterSpacing: 0.0,
                                                          fontWeight:
                                                              FontWeight.normal,
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
                                              ),
                                              Builder(
                                                builder: (context) => InkWell(
                                                  splashColor:
                                                      Colors.transparent,
                                                  focusColor:
                                                      Colors.transparent,
                                                  hoverColor:
                                                      Colors.transparent,
                                                  highlightColor:
                                                      Colors.transparent,
                                                  onTap: () async {
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
                                                                EdgeInsets.zero,
                                                            backgroundColor:
                                                                Colors
                                                                    .transparent,
                                                            alignment: AlignmentDirectional(
                                                                    -1.0, 0.0)
                                                                .resolve(
                                                                    Directionality.of(
                                                                        context)),
                                                            child:
                                                                GestureDetector(
                                                              onTap: () {
                                                                FocusScope.of(
                                                                        dialogContext)
                                                                    .unfocus();
                                                                FocusManager
                                                                    .instance
                                                                    .primaryFocus
                                                                    ?.unfocus();
                                                              },
                                                              child:
                                                                  BsTopNotificacoesWidget(
                                                                pTipo: 'AVISO',
                                                                pMensagem:
                                                                    'Atualmente você não tem permissão!',
                                                              ),
                                                            ),
                                                          );
                                                        },
                                                      );

                                                      return;
                                                    } else {
                                                      await showModalBottomSheet(
                                                        isScrollControlled:
                                                            true,
                                                        backgroundColor:
                                                            Colors.transparent,
                                                        context: context,
                                                        builder: (context) {
                                                          return GestureDetector(
                                                            onTap: () {
                                                              FocusScope.of(
                                                                      context)
                                                                  .unfocus();
                                                              FocusManager
                                                                  .instance
                                                                  .primaryFocus
                                                                  ?.unfocus();
                                                            },
                                                            child: Padding(
                                                              padding: MediaQuery
                                                                  .viewInsetsOf(
                                                                      context),
                                                              child: Container(
                                                                height: 500.0,
                                                                child:
                                                                    BsCentroDeResultadoWidget(
                                                                  pIdCentroResultado:
                                                                      listaCentroResultadoItem
                                                                          .id,
                                                                  pNome:
                                                                      listaCentroResultadoItem
                                                                          .nome,
                                                                  pCorSelecionada:
                                                                      listaCentroResultadoItem
                                                                          .corHex,
                                                                  pAtivo:
                                                                      listaCentroResultadoItem
                                                                          .ativo,
                                                                  pIsPadrao:
                                                                      listaCentroResultadoItem
                                                                          .isPadrao,
                                                                  pIsFundo:
                                                                      listaCentroResultadoItem
                                                                          .isFundo,
                                                                  pPermiteAcumulo:
                                                                      listaCentroResultadoItem
                                                                          .permiteAcumulo,
                                                                ),
                                                              ),
                                                            ),
                                                          );
                                                        },
                                                      ).then((value) =>
                                                          safeSetState(() {}));

                                                      await actions
                                                          .syncMasterCache(
                                                        FFAppState()
                                                            .currentOrganizationId,
                                                        false,
                                                        false,
                                                        true,
                                                        false,
                                                      );
                                                      return;
                                                    }
                                                  },
                                                  child: Icon(
                                                    Icons.edit,
                                                    color: FlutterFlowTheme.of(
                                                            context)
                                                        .primaryText,
                                                    size: 24.0,
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
                              decoration: BoxDecoration(),
                            ),
                          ].addToStart(SizedBox(height: 10.0)),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ));
  }
}
