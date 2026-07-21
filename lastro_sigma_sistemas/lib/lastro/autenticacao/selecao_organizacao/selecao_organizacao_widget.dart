import '/auth/supabase_auth/auth_util.dart';
import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/custom_code/actions/index.dart' as actions;
import '/flutter_flow/custom_functions.dart' as functions;
import '/index.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'selecao_organizacao_model.dart';
export 'selecao_organizacao_model.dart';

class SelecaoOrganizacaoWidget extends StatefulWidget {
  const SelecaoOrganizacaoWidget({super.key});

  static String routeName = 'selecaoOrganizacao';
  static String routePath = '/selecaoOrganizacao';

  @override
  State<SelecaoOrganizacaoWidget> createState() =>
      _SelecaoOrganizacaoWidgetState();
}

class _SelecaoOrganizacaoWidgetState extends State<SelecaoOrganizacaoWidget> {
  late SelecaoOrganizacaoModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => SelecaoOrganizacaoModel());

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
        title: 'selecaoOrganizacao',
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
                  'Selecionar Organização',
                  style: FlutterFlowTheme.of(context).headlineMedium.override(
                        font: GoogleFonts.interTight(
                          fontWeight: FlutterFlowTheme.of(context)
                              .headlineMedium
                              .fontWeight,
                          fontStyle: FlutterFlowTheme.of(context)
                              .headlineMedium
                              .fontStyle,
                        ),
                        color: Colors.white,
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
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Expanded(
                            child: Container(
                              height: double.infinity,
                              child: FutureBuilder<List<ViewMembrosEquipeRow>>(
                                future: ViewMembrosEquipeTable().queryRows(
                                  queryFn: (q) => q.eqOrNull(
                                    'profile_id',
                                    currentUserUid,
                                  ),
                                ),
                                builder: (context, snapshot) {
                                  // Customize what your widget looks like when it's loading.
                                  if (!snapshot.hasData) {
                                    return Center(
                                      child: SizedBox(
                                        width: 50.0,
                                        height: 50.0,
                                        child: CircularProgressIndicator(
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                            FlutterFlowTheme.of(context)
                                                .primary,
                                          ),
                                        ),
                                      ),
                                    );
                                  }
                                  List<ViewMembrosEquipeRow>
                                      listViewViewMembrosEquipeRowList =
                                      snapshot.data!;

                                  return ListView.builder(
                                    padding: EdgeInsets.zero,
                                    primary: false,
                                    shrinkWrap: true,
                                    scrollDirection: Axis.vertical,
                                    itemCount:
                                        listViewViewMembrosEquipeRowList.length,
                                    itemBuilder: (context, listViewIndex) {
                                      final listViewViewMembrosEquipeRow =
                                          listViewViewMembrosEquipeRowList[
                                              listViewIndex];
                                      return Row(
                                        mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                            child: Padding(
                                              padding: EdgeInsetsDirectional
                                                  .fromSTEB(
                                                      0.0, 0.0, 0.0, 12.0),
                                              child: FFButtonWidget(
                                                onPressed: () async {
                                                  FFAppState()
                                                          .currentOrganizationId =
                                                      listViewViewMembrosEquipeRow
                                                          .organizationId!;
                                                  FFAppState()
                                                          .currentOrganizationType =
                                                      listViewViewMembrosEquipeRow
                                                          .tipoOrganizacao!;
                                                  FFAppState()
                                                          .currentOrganizationName =
                                                      listViewViewMembrosEquipeRow
                                                          .nomeOrganizacao!;
                                                  FFAppState()
                                                      .tempImportacaoOFX = [];
                                                  FFAppState().currentUser =
                                                      listViewViewMembrosEquipeRow
                                                          .nomeUtilizador!;
                                                  FFAppState().currentFunction =
                                                      listViewViewMembrosEquipeRow
                                                          .funcao!;
                                                  FFAppState().currentPlanName =
                                                      listViewViewMembrosEquipeRow
                                                          .planoOrganizacao!;
                                                  safeSetState(() {});
                                                  FFAppState()
                                                      .dataFimGlob = FFAppState()
                                                              .dataFimGlob ==
                                                          null
                                                      ? functions
                                                          .getUltimoDiaDoMesAtual()
                                                      : FFAppState()
                                                          .dataFimGlob;
                                                  FFAppState()
                                                      .dataInicioGlob = FFAppState()
                                                              .dataInicioGlob ==
                                                          null
                                                      ? functions
                                                          .getPrimeiroDiaDoMesAtual()
                                                      : FFAppState()
                                                          .dataInicioGlob;
                                                  safeSetState(() {});
                                                  await actions.syncMasterCache(
                                                    listViewViewMembrosEquipeRow
                                                        .organizationId!,
                                                    true,
                                                    true,
                                                    true,
                                                    true,
                                                  );

                                                  context.pushNamed(
                                                      DashboardWidget
                                                          .routeName);
                                                },
                                                text:
                                                    listViewViewMembrosEquipeRow
                                                        .nomeOrganizacao!,
                                                options: FFButtonOptions(
                                                  height: 60.0,
                                                  padding: EdgeInsetsDirectional
                                                      .fromSTEB(
                                                          16.0, 0.0, 16.0, 0.0),
                                                  iconPadding:
                                                      EdgeInsetsDirectional
                                                          .fromSTEB(0.0, 0.0,
                                                              0.0, 0.0),
                                                  color: FlutterFlowTheme.of(
                                                          context)
                                                      .secondaryBackground,
                                                  textStyle: FlutterFlowTheme
                                                          .of(context)
                                                      .titleSmall
                                                      .override(
                                                        font: GoogleFonts
                                                            .interTight(
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
                                                        color:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .secondaryText,
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
                                                  elevation: 0.0,
                                                  borderSide: BorderSide(
                                                    width: 1.0,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          8.0),
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
                            ),
                          ),
                        ],
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
