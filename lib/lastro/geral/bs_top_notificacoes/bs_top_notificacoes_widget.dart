import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'bs_top_notificacoes_model.dart';
export 'bs_top_notificacoes_model.dart';

class BsTopNotificacoesWidget extends StatefulWidget {
  const BsTopNotificacoesWidget({
    super.key,
    this.pMensagem,
    String? pTipo,
  }) : this.pTipo = pTipo ?? 'SUCESSO';

  final String? pMensagem;
  final String pTipo;

  @override
  State<BsTopNotificacoesWidget> createState() =>
      _BsTopNotificacoesWidgetState();
}

class _BsTopNotificacoesWidgetState extends State<BsTopNotificacoesWidget> {
  late BsTopNotificacoesModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => BsTopNotificacoesModel());

    // On component load action.
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      await Future.delayed(
        Duration(
          milliseconds: 3000,
        ),
      );
      Navigator.pop(context);
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
    return Align(
      alignment: AlignmentDirectional(0.0, 0.0),
      child: Padding(
        padding: EdgeInsets.all(12.0),
        child: AnimatedContainer(
          duration: Duration(milliseconds: 100),
          curve: Curves.easeInOut,
          width: double.infinity,
          constraints: BoxConstraints(
            minHeight: 30.0,
            maxWidth: 530.0,
            maxHeight: 60.0,
          ),
          decoration: BoxDecoration(
            color: () {
              if (widget!.pTipo == 'SUCESSO') {
                return FlutterFlowTheme.of(context).secondary;
              } else if (widget!.pTipo == 'ERRO') {
                return FlutterFlowTheme.of(context).error;
              } else {
                return FlutterFlowTheme.of(context).primary;
              }
            }(),
            boxShadow: [
              BoxShadow(
                blurRadius: 3.0,
                color: FlutterFlowTheme.of(context).secondaryText,
                offset: Offset(
                  0.0,
                  1.0,
                ),
              )
            ],
            borderRadius: BorderRadius.circular(24.0),
          ),
          alignment: AlignmentDirectional(0.0, 0.0),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(12.0, 8.0, 12.0, 8.0),
                  child: AutoSizeText(
                    valueOrDefault<String>(
                      widget!.pMensagem,
                      'Processo concluído com sucesso!',
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    minFontSize: 10.0,
                    style: FlutterFlowTheme.of(context).labelMedium.override(
                          font: GoogleFonts.inter(
                            fontWeight: FontWeight.w600,
                            fontStyle: FlutterFlowTheme.of(context)
                                .labelMedium
                                .fontStyle,
                          ),
                          color: FlutterFlowTheme.of(context).primaryText,
                          letterSpacing: 0.0,
                          fontWeight: FontWeight.w600,
                          fontStyle: FlutterFlowTheme.of(context)
                              .labelMedium
                              .fontStyle,
                        ),
                    overflow: TextOverflow.ellipsis,
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
