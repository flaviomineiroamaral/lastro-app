import '/auth/supabase_auth/auth_util.dart';
import '/backend/supabase/supabase.dart';
import '/flutter_flow/ff_builtin_enums.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/lastro/geral/bs_top_notificacoes/bs_top_notificacoes_widget.dart';
import '/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'bloqueio_financeiro_model.dart';
export 'bloqueio_financeiro_model.dart';

class BloqueioFinanceiroWidget extends StatefulWidget {
  const BloqueioFinanceiroWidget({super.key});

  static String routeName = 'Bloqueio_Financeiro';
  static String routePath = '/bloqueioFinanceiro';

  @override
  State<BloqueioFinanceiroWidget> createState() =>
      _BloqueioFinanceiroWidgetState();
}

class _BloqueioFinanceiroWidgetState extends State<BloqueioFinanceiroWidget> {
  late BloqueioFinanceiroModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => BloqueioFinanceiroModel());

    // On page load action.
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      _model.retViewEquipe = await ViewMembrosEquipeTable().queryRows(
        queryFn: (q) => q.eqOrNull(
          'organization_id',
          FFAppState().currentOrganizationId,
        ),
      );
      if ((_model.retViewEquipe != null &&
              (_model.retViewEquipe)!.isNotEmpty) ==
          false) {
        if (_model.retViewEquipe?.firstOrNull?.tipoOrganizacao == 'Família') {
          _model.retAssinaturaB2C = await AssinaturasB2cTable().queryRows(
            queryFn: (q) => q
                .eqOrNull(
              'user_id',
              currentUserUid,
            )
                .inFilterOrNull(
              'status_assinatura',
              ['atrasada', 'pendente'],
            ),
          );
          if (_model.retAssinaturaB2C!.length > 0) {
            _model.urlCobranca =
                _model.retAssinaturaB2C?.firstOrNull?.linkPagamento;
            safeSetState(() {});
            return;
          } else {
            await showDialog(
              context: context,
              builder: (dialogContext) {
                return Dialog(
                  elevation: 0,
                  insetPadding: EdgeInsets.zero,
                  backgroundColor: Colors.transparent,
                  alignment: AlignmentDirectional(0.0, 0.0)
                      .resolve(Directionality.of(context)),
                  child: GestureDetector(
                    onTap: () {
                      FocusScope.of(dialogContext).unfocus();
                      FocusManager.instance.primaryFocus?.unfocus();
                    },
                    child: BsTopNotificacoesWidget(
                      pTipo: 'Erro',
                      pMensagem:
                          'Faça contato com suporte. Pois não foi possível encontrar sua assinatura.',
                    ),
                  ),
                );
              },
            );

            return;
          }
        } else {
          if (_model.retViewEquipe?.firstOrNull?.isInadimplenteSetup == true) {
            if (_model.retViewEquipe?.firstOrNull?.linkBoletoSetup != null &&
                _model.retViewEquipe?.firstOrNull?.linkBoletoSetup != '') {
              _model.urlCobranca =
                  _model.retViewEquipe?.firstOrNull?.linkBoletoSetup;
              safeSetState(() {});
              return;
            } else {
              await showDialog(
                context: context,
                builder: (dialogContext) {
                  return Dialog(
                    elevation: 0,
                    insetPadding: EdgeInsets.zero,
                    backgroundColor: Colors.transparent,
                    alignment: AlignmentDirectional(0.0, 0.0)
                        .resolve(Directionality.of(context)),
                    child: GestureDetector(
                      onTap: () {
                        FocusScope.of(dialogContext).unfocus();
                        FocusManager.instance.primaryFocus?.unfocus();
                      },
                      child: BsTopNotificacoesWidget(
                        pTipo: 'Erro',
                        pMensagem:
                            'Faça contato com suporte. Pois não foi possível encontrar o link de pagamento.',
                      ),
                    ),
                  );
                },
              );

              return;
            }
          } else {
            if (_model.retViewEquipe?.firstOrNull?.linkMensalidadeB2b != null &&
                _model.retViewEquipe?.firstOrNull?.linkMensalidadeB2b != '') {
              _model.urlCobranca =
                  _model.retViewEquipe?.firstOrNull?.linkMensalidadeB2b;
              safeSetState(() {});
              return;
            } else {
              await showDialog(
                context: context,
                builder: (dialogContext) {
                  return Dialog(
                    elevation: 0,
                    insetPadding: EdgeInsets.zero,
                    backgroundColor: Colors.transparent,
                    alignment: AlignmentDirectional(0.0, 0.0)
                        .resolve(Directionality.of(context)),
                    child: GestureDetector(
                      onTap: () {
                        FocusScope.of(dialogContext).unfocus();
                        FocusManager.instance.primaryFocus?.unfocus();
                      },
                      child: BsTopNotificacoesWidget(
                        pTipo: 'Erro',
                        pMensagem:
                            'Faça contato com suporte. Pois não foi possível encontrar o link de pagamento.',
                      ),
                    ),
                  );
                },
              );

              return;
            }
          }
        }
      } else {
        await showDialog(
          context: context,
          builder: (dialogContext) {
            return Dialog(
              elevation: 0,
              insetPadding: EdgeInsets.zero,
              backgroundColor: Colors.transparent,
              alignment: AlignmentDirectional(0.0, 0.0)
                  .resolve(Directionality.of(context)),
              child: GestureDetector(
                onTap: () {
                  FocusScope.of(dialogContext).unfocus();
                  FocusManager.instance.primaryFocus?.unfocus();
                },
                child: BsTopNotificacoesWidget(
                  pTipo: 'Erro',
                  pMensagem:
                      'Faça contato com suporte. Pois não foi possível encontrar seu perfil.',
                ),
              ),
            );
          },
        );

        return;
      }
    });

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

    return Builder(
      builder: (context) => Title(
          title: 'Bloqueio_Financeiro',
          color: FlutterFlowTheme.of(context).primary.withAlpha(0XFF),
          child: GestureDetector(
            onTap: () {
              FocusScope.of(context).unfocus();
              FocusManager.instance.primaryFocus?.unfocus();
            },
            child: Scaffold(
              key: scaffoldKey,
              backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
              body: SafeArea(
                top: true,
                child: Container(
                  width: double.infinity,
                  height: double.infinity,
                  decoration: BoxDecoration(),
                  child: Padding(
                    padding:
                        EdgeInsetsDirectional.fromSTEB(24.0, 24.0, 24.0, 24.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment:
                          (FFCrossAxisAlignment.center).flutterValue,
                      textBaseline: TextBaseline.alphabetic,
                      children: [
                        Icon(
                          Icons.lock_person_sharp,
                          color: FlutterFlowTheme.of(context).primary,
                          size: 128.0,
                        ),
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(
                              0.0, 24.0, 0.0, 0.0),
                          child: Text(
                            'Acesso Suspenso',
                            style: FlutterFlowTheme.of(context)
                                .headlineSmall
                                .override(
                                  font: GoogleFonts.interTight(
                                    fontWeight: FontWeight.bold,
                                    fontStyle: FlutterFlowTheme.of(context)
                                        .headlineSmall
                                        .fontStyle,
                                  ),
                                  letterSpacing: 0.0,
                                  fontWeight: FontWeight.bold,
                                  fontStyle: FlutterFlowTheme.of(context)
                                      .headlineSmall
                                      .fontStyle,
                                ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(
                              0.0, 16.0, 0.0, 0.0),
                          child: Text(
                            FFAppState().currentOrganizationType == 'Família'
                                ? 'Identificámos uma pendência na assinatura do LASTRO Família. Regularize para retomar a gestão da sua casa.'
                                : 'O acesso da sua instituição está temporariamente suspenso devido a pendências financeiras atreladas à organização ${FFAppState().currentOrganizationName}.',
                            textAlign: TextAlign.center,
                            style: FlutterFlowTheme.of(context)
                                .labelLarge
                                .override(
                                  font: GoogleFonts.inter(
                                    fontWeight: FlutterFlowTheme.of(context)
                                        .labelLarge
                                        .fontWeight,
                                    fontStyle: FlutterFlowTheme.of(context)
                                        .labelLarge
                                        .fontStyle,
                                  ),
                                  letterSpacing: 0.0,
                                  fontWeight: FlutterFlowTheme.of(context)
                                      .labelLarge
                                      .fontWeight,
                                  fontStyle: FlutterFlowTheme.of(context)
                                      .labelLarge
                                      .fontStyle,
                                ),
                          ),
                        ),
                        Spacer(),
                        Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment:
                              (FFMainAxisAlignment.spaceEvenly).flutterValue,
                          children: [
                            Builder(
                              builder: (context) => Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    0.0, 0.0, 10.0, 0.0),
                                child: FFButtonWidget(
                                  onPressed: () async {
                                    if (_model.urlCobranca != null &&
                                        _model.urlCobranca != '') {
                                      await launchURL(_model.urlCobranca!);
                                      await showDialog(
                                        context: context,
                                        builder: (dialogContext) {
                                          return Dialog(
                                            elevation: 0,
                                            insetPadding: EdgeInsets.zero,
                                            backgroundColor: Colors.transparent,
                                            alignment: AlignmentDirectional(
                                                    0.0, 0.0)
                                                .resolve(
                                                    Directionality.of(context)),
                                            child: GestureDetector(
                                              onTap: () {
                                                FocusScope.of(dialogContext)
                                                    .unfocus();
                                                FocusManager
                                                    .instance.primaryFocus
                                                    ?.unfocus();
                                              },
                                              child: BsTopNotificacoesWidget(
                                                pTipo: 'Sucesso',
                                                pMensagem:
                                                    'A abrir o ambiente seguro de pagamento...',
                                              ),
                                            ),
                                          );
                                        },
                                      );

                                      return;
                                    } else {
                                      await showDialog(
                                        context: context,
                                        builder: (dialogContext) {
                                          return Dialog(
                                            elevation: 0,
                                            insetPadding: EdgeInsets.zero,
                                            backgroundColor: Colors.transparent,
                                            alignment: AlignmentDirectional(
                                                    0.0, 0.0)
                                                .resolve(
                                                    Directionality.of(context)),
                                            child: GestureDetector(
                                              onTap: () {
                                                FocusScope.of(dialogContext)
                                                    .unfocus();
                                                FocusManager
                                                    .instance.primaryFocus
                                                    ?.unfocus();
                                              },
                                              child: BsTopNotificacoesWidget(
                                                pTipo: 'Erro',
                                                pMensagem:
                                                    'Entre em contato com o suporte. Pois não foi possível encontrar link para pagamento.',
                                              ),
                                            ),
                                          );
                                        },
                                      );

                                      return;
                                    }
                                  },
                                  text: 'Pagar Agora',
                                  icon: Icon(
                                    Icons.credit_card_sharp,
                                    size: 15.0,
                                  ),
                                  options: FFButtonOptions(
                                    height: 40.0,
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        16.0, 0.0, 16.0, 0.0),
                                    iconPadding: EdgeInsetsDirectional.fromSTEB(
                                        0.0, 0.0, 0.0, 0.0),
                                    color: FlutterFlowTheme.of(context).primary,
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
                            ),
                            FFButtonWidget(
                              onPressed: () async {
                                await launchURL(
                                    'https://wa.me/556285043025?text=Olá!%20Preciso%20de%20ajuda%20financeira%20com%20o%20acesso%20do%20LASTRO.%20A%20minha%20organização%20é:%20${FFAppState().currentOrganizationName}');
                              },
                              text: 'Falar com Suporte',
                              icon: Icon(
                                Icons.phone_sharp,
                                size: 15.0,
                              ),
                              options: FFButtonOptions(
                                height: 40.0,
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    16.0, 0.0, 16.0, 0.0),
                                iconPadding: EdgeInsetsDirectional.fromSTEB(
                                    0.0, 0.0, 0.0, 0.0),
                                color:
                                    FlutterFlowTheme.of(context).darkMutedColor,
                                textStyle: FlutterFlowTheme.of(context)
                                    .titleSmall
                                    .override(
                                      font: GoogleFonts.interTight(
                                        fontWeight: FlutterFlowTheme.of(context)
                                            .titleSmall
                                            .fontWeight,
                                        fontStyle: FlutterFlowTheme.of(context)
                                            .titleSmall
                                            .fontStyle,
                                      ),
                                      color: FlutterFlowTheme.of(context).error,
                                      letterSpacing: 0.0,
                                      fontWeight: FlutterFlowTheme.of(context)
                                          .titleSmall
                                          .fontWeight,
                                      fontStyle: FlutterFlowTheme.of(context)
                                          .titleSmall
                                          .fontStyle,
                                    ),
                                elevation: 0.0,
                                borderSide: BorderSide(
                                  color: FlutterFlowTheme.of(context).error,
                                ),
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                            ),
                          ],
                        ),
                        Align(
                          alignment: AlignmentDirectional(1.0, 0.0),
                          child: Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(
                                0.0, 5.0, 8.0, 0.0),
                            child: InkWell(
                              splashColor: Colors.transparent,
                              focusColor: Colors.transparent,
                              hoverColor: Colors.transparent,
                              highlightColor: Colors.transparent,
                              onTap: () async {
                                context.goNamed(AuthPageWidget.routeName);
                              },
                              child: Text(
                                'Já paguei!',
                                textAlign: TextAlign.end,
                                style: FlutterFlowTheme.of(context)
                                    .bodyMedium
                                    .override(
                                      font: GoogleFonts.inter(
                                        fontWeight: FontWeight.bold,
                                        fontStyle: FontStyle.italic,
                                      ),
                                      color:
                                          FlutterFlowTheme.of(context).primary,
                                      letterSpacing: 0.0,
                                      fontWeight: FontWeight.bold,
                                      fontStyle: FontStyle.italic,
                                      decoration: TextDecoration.underline,
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
          )),
    );
  }
}
