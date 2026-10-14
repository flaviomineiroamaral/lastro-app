import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/lastro/geral/bs_top_notificacoes/bs_top_notificacoes_widget.dart';
import '/custom_code/actions/index.dart' as actions;
import '/custom_code/widgets/index.dart' as custom_widgets;
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'bs_detalhe_transacao_c_r_model.dart';
export 'bs_detalhe_transacao_c_r_model.dart';

class BsDetalheTransacaoCRWidget extends StatefulWidget {
  const BsDetalheTransacaoCRWidget({
    super.key,
    this.pIdProjetoCR,
    String? pTipoTransacao,
    required this.pValorDisponivel,
    this.pValorMaximoTrans,
  }) : this.pTipoTransacao = pTipoTransacao ?? 'Alocar';

  final String? pIdProjetoCR;
  final String pTipoTransacao;
  final double? pValorDisponivel;
  final double? pValorMaximoTrans;

  @override
  State<BsDetalheTransacaoCRWidget> createState() =>
      _BsDetalheTransacaoCRWidgetState();
}

class _BsDetalheTransacaoCRWidgetState
    extends State<BsDetalheTransacaoCRWidget> {
  late BsDetalheTransacaoCRModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => BsDetalheTransacaoCRModel());

    // On component load action.
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      _model.vDataOperacao = getCurrentTimestamp;
      _model.vValorFormulario = (widget.pValorMaximoTrans!).abs();
      safeSetState(() {});
    });

    _model.observacaoTextController ??= TextEditingController();
    _model.observacaoFocusNode ??= FocusNode();

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
              padding: EdgeInsetsDirectional.fromSTEB(0.0, 12.0, 0.0, 12.0),
              child: Text(
                () {
                  if (widget.pTipoTransacao == 'Alocar') {
                    return 'Alocar Subsídio';
                  } else if (widget.pTipoTransacao == 'Devolver') {
                    return 'Devolver Subsídio';
                  } else {
                    return 'Transferir Caixa';
                  }
                }(),
                textAlign: TextAlign.center,
                style: FlutterFlowTheme.of(context).bodyMedium.override(
                      font: GoogleFonts.inter(
                        fontWeight: FontWeight.w600,
                        fontStyle:
                            FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                      ),
                      color: FlutterFlowTheme.of(context).primaryText,
                      fontSize: 16.0,
                      letterSpacing: 0.0,
                      fontWeight: FontWeight.w600,
                      fontStyle:
                          FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                    ),
              ),
            ),
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(8.0, 0.0, 0.0, 6.0),
              child: Text(
                'Data Pagamento',
                style: FlutterFlowTheme.of(context).labelMedium.override(
                      font: GoogleFonts.inter(
                        fontWeight:
                            FlutterFlowTheme.of(context).labelMedium.fontWeight,
                        fontStyle:
                            FlutterFlowTheme.of(context).labelMedium.fontStyle,
                      ),
                      color: FlutterFlowTheme.of(context).secondaryText,
                      letterSpacing: 0.0,
                      fontWeight:
                          FlutterFlowTheme.of(context).labelMedium.fontWeight,
                      fontStyle:
                          FlutterFlowTheme.of(context).labelMedium.fontStyle,
                    ),
              ),
            ),
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 12.0),
              child: InkWell(
                splashColor: Colors.transparent,
                focusColor: Colors.transparent,
                hoverColor: Colors.transparent,
                highlightColor: Colors.transparent,
                onTap: () async {
                  final _datePickedDate = await showDatePicker(
                    context: context,
                    initialDate: getCurrentTimestamp,
                    firstDate: DateTime(1900),
                    lastDate: DateTime(2050),
                    builder: (context, child) {
                      return wrapInMaterialDatePickerTheme(
                        context,
                        child!,
                        headerBackgroundColor:
                            FlutterFlowTheme.of(context).primary,
                        headerForegroundColor:
                            FlutterFlowTheme.of(context).info,
                        headerTextStyle:
                            FlutterFlowTheme.of(context).headlineLarge.override(
                                  font: GoogleFonts.interTight(
                                    fontWeight: FontWeight.w600,
                                    fontStyle: FlutterFlowTheme.of(context)
                                        .headlineLarge
                                        .fontStyle,
                                  ),
                                  fontSize: 32.0,
                                  letterSpacing: 0.0,
                                  fontWeight: FontWeight.w600,
                                  fontStyle: FlutterFlowTheme.of(context)
                                      .headlineLarge
                                      .fontStyle,
                                ),
                        pickerBackgroundColor:
                            FlutterFlowTheme.of(context).secondaryBackground,
                        pickerForegroundColor:
                            FlutterFlowTheme.of(context).primaryText,
                        selectedDateTimeBackgroundColor:
                            FlutterFlowTheme.of(context).primary,
                        selectedDateTimeForegroundColor:
                            FlutterFlowTheme.of(context).info,
                        actionButtonForegroundColor:
                            FlutterFlowTheme.of(context).primaryText,
                        iconSize: 24.0,
                      );
                    },
                  );

                  if (_datePickedDate != null) {
                    safeSetState(() {
                      _model.datePicked = DateTime(
                        _datePickedDate.year,
                        _datePickedDate.month,
                        _datePickedDate.day,
                      );
                    });
                  } else if (_model.datePicked != null) {
                    safeSetState(() {
                      _model.datePicked = getCurrentTimestamp;
                    });
                  }
                  _model.vDataOperacao = _model.datePicked;
                  safeSetState(() {});
                },
                child: Container(
                  width: double.infinity,
                  height: 40.0,
                  decoration: BoxDecoration(
                    color: Color(0xFF3D4449),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(
                            12.0, 0.0, 12.0, 0.0),
                        child: Icon(
                          Icons.edit_calendar_outlined,
                          color: FlutterFlowTheme.of(context).primary,
                          size: 16.0,
                        ),
                      ),
                      Text(
                        dateTimeFormat(
                          "dd/MM/yyyy",
                          _model.vDataOperacao,
                          locale: FFLocalizations.of(context).languageCode,
                        ),
                        style: FlutterFlowTheme.of(context).bodyMedium.override(
                              font: GoogleFonts.inter(
                                fontWeight: FlutterFlowTheme.of(context)
                                    .bodyMedium
                                    .fontWeight,
                                fontStyle: FlutterFlowTheme.of(context)
                                    .bodyMedium
                                    .fontStyle,
                              ),
                              color: FlutterFlowTheme.of(context).primaryText,
                              letterSpacing: 0.0,
                              fontWeight: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .fontWeight,
                              fontStyle: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .fontStyle,
                            ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(8.0, 0.0, 8.0, 6.0),
              child: Text(
                'Valor Total',
                style: FlutterFlowTheme.of(context).labelMedium.override(
                      font: GoogleFonts.inter(
                        fontWeight:
                            FlutterFlowTheme.of(context).labelMedium.fontWeight,
                        fontStyle:
                            FlutterFlowTheme.of(context).labelMedium.fontStyle,
                      ),
                      color: FlutterFlowTheme.of(context).secondaryText,
                      letterSpacing: 0.0,
                      fontWeight:
                          FlutterFlowTheme.of(context).labelMedium.fontWeight,
                      fontStyle:
                          FlutterFlowTheme.of(context).labelMedium.fontStyle,
                    ),
              ),
            ),
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 12.0),
              child: Container(
                width: 100.0,
                height: 60.0,
                child: custom_widgets.CampoMoedaNubank(
                  width: 100.0,
                  height: 60.0,
                  tamanhoFonte: 24.0,
                  corTexto: FlutterFlowTheme.of(context).primaryText,
                  corFundo: FlutterFlowTheme.of(context).fundoText,
                  corBorda: FlutterFlowTheme.of(context).secondaryBackground,
                  arredondamento: 8.0,
                  centralizarTexto: false,
                  valorInicial: _model.vValorFormulario,
                  acaoAoMudar: (valorDigitado) async {
                    _model.vValorFormulario = valorDigitado;
                    safeSetState(() {});
                  },
                ),
              ),
            ),
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(8.0, 0.0, 8.0, 6.0),
              child: Text(
                'Descrição',
                style: FlutterFlowTheme.of(context).labelMedium.override(
                      font: GoogleFonts.inter(
                        fontWeight:
                            FlutterFlowTheme.of(context).labelMedium.fontWeight,
                        fontStyle:
                            FlutterFlowTheme.of(context).labelMedium.fontStyle,
                      ),
                      color: FlutterFlowTheme.of(context).secondaryText,
                      letterSpacing: 0.0,
                      fontWeight:
                          FlutterFlowTheme.of(context).labelMedium.fontWeight,
                      fontStyle:
                          FlutterFlowTheme.of(context).labelMedium.fontStyle,
                    ),
              ),
            ),
            Container(
              width: 200.0,
              child: TextFormField(
                controller: _model.observacaoTextController,
                focusNode: _model.observacaoFocusNode,
                autofocus: false,
                enabled: true,
                obscureText: false,
                decoration: InputDecoration(
                  isDense: true,
                  labelStyle: FlutterFlowTheme.of(context).labelMedium.override(
                        font: GoogleFonts.inter(
                          fontWeight: FlutterFlowTheme.of(context)
                              .labelMedium
                              .fontWeight,
                          fontStyle: FlutterFlowTheme.of(context)
                              .labelMedium
                              .fontStyle,
                        ),
                        letterSpacing: 0.0,
                        fontWeight:
                            FlutterFlowTheme.of(context).labelMedium.fontWeight,
                        fontStyle:
                            FlutterFlowTheme.of(context).labelMedium.fontStyle,
                      ),
                  hintText: 'Digite a descrição...',
                  hintStyle: FlutterFlowTheme.of(context).labelMedium.override(
                        font: GoogleFonts.inter(
                          fontWeight: FlutterFlowTheme.of(context)
                              .labelMedium
                              .fontWeight,
                          fontStyle: FlutterFlowTheme.of(context)
                              .labelMedium
                              .fontStyle,
                        ),
                        letterSpacing: 0.0,
                        fontWeight:
                            FlutterFlowTheme.of(context).labelMedium.fontWeight,
                        fontStyle:
                            FlutterFlowTheme.of(context).labelMedium.fontStyle,
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
                maxLines: 6,
                cursorColor: FlutterFlowTheme.of(context).primaryText,
                enableInteractiveSelection: true,
                validator: _model.observacaoTextControllerValidator
                    .asValidator(context),
              ),
            ),
            Builder(
              builder: (context) => Padding(
                padding: EdgeInsetsDirectional.fromSTEB(0.0, 12.0, 0.0, 0.0),
                child: FFButtonWidget(
                  onPressed: () async {
                    var _shouldSetState = false;
                    if (widget.pValorDisponivel! >= _model.vValorFormulario!) {
                      if (widget.pTipoTransacao == 'Alocar') {
                        _model.retAlocar = await actions.alocarSubsidio(
                          FFAppState().currentOrganizationId,
                          widget.pIdProjetoCR!,
                          _model.vValorFormulario!,
                          _model.observacaoTextController.text,
                          _model.vDataOperacao!,
                        );
                        _shouldSetState = true;
                        if (_model.retAlocar!) {
                          Navigator.pop(context);
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
                                  pTipo: 'SUCESSO',
                                  pMensagem: 'Alocação feita com sucesso!',
                                ),
                              );
                            },
                          );
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
                                child: BsTopNotificacoesWidget(
                                  pTipo: 'ERRO',
                                  pMensagem: 'Falha ao tentar alocar subsídio.',
                                ),
                              );
                            },
                          );
                        }

                        if (_shouldSetState) safeSetState(() {});
                        return;
                      } else if (widget.pTipoTransacao == 'Devolver') {
                        if (_model.observacaoTextController.text != '') {
                          _model.retEstorno = await actions.estornarSubsidio(
                            FFAppState().currentOrganizationId,
                            widget.pIdProjetoCR!,
                            _model.vValorFormulario!,
                            _model.observacaoTextController.text,
                            _model.vDataOperacao!,
                          );
                          _shouldSetState = true;
                          if (_model.retEstorno == true) {
                            Navigator.pop(context);
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
                                    pMensagem: 'Estorno feito com sucesso!',
                                  ),
                                );
                              },
                            );

                            if (_shouldSetState) safeSetState(() {});
                            return;
                          } else {
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
                                        'Falha ao tentar estornar o subsídio.',
                                  ),
                                );
                              },
                            );

                            if (_shouldSetState) safeSetState(() {});
                            return;
                          }
                        } else {
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
                                      'Preencha o campo motivo do estorno.',
                                ),
                              );
                            },
                          );

                          if (_shouldSetState) safeSetState(() {});
                          return;
                        }
                      } else {
                        _model.retRepassar = await actions.repassarArrecadacao(
                          FFAppState().currentOrganizationId,
                          widget.pIdProjetoCR!,
                          _model.vValorFormulario!,
                          _model.observacaoTextController.text,
                          _model.vDataOperacao!,
                        );
                        _shouldSetState = true;
                        if (_model.retRepassar == true) {
                          Navigator.pop(context);
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
                                  pTipo: 'SUCESSO',
                                  pMensagem: 'Alocação feita com sucesso!',
                                ),
                              );
                            },
                          );
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
                                child: BsTopNotificacoesWidget(
                                  pTipo: 'ERRO',
                                  pMensagem: 'Falha ao tentar alocar subsídio.',
                                ),
                              );
                            },
                          );
                        }

                        if (_shouldSetState) safeSetState(() {});
                        return;
                      }
                    } else {
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
                                  'Valor insuficiente para efetuar a transação.',
                            ),
                          );
                        },
                      );

                      if (_shouldSetState) safeSetState(() {});
                      return;
                    }

                    if (_shouldSetState) safeSetState(() {});
                  },
                  text: 'Confirmar',
                  icon: Icon(
                    Icons.check,
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
                          color: FlutterFlowTheme.of(context).primaryText,
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
