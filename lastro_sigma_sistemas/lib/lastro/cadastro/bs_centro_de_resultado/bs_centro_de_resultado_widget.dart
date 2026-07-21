import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/lastro/geral/bs_top_notificacoes/bs_top_notificacoes_widget.dart';
import '/custom_code/actions/index.dart' as actions;
import '/flutter_flow/custom_functions.dart' as functions;
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'bs_centro_de_resultado_model.dart';
export 'bs_centro_de_resultado_model.dart';

class BsCentroDeResultadoWidget extends StatefulWidget {
  const BsCentroDeResultadoWidget({
    super.key,
    this.pIdCentroResultado,
    this.pNome,
    this.pCorSelecionada,
    this.pAtivo,
    this.pIsPadrao,
    bool? pIsFundo,
    bool? pPermiteAcumulo,
  })  : this.pIsFundo = pIsFundo ?? false,
        this.pPermiteAcumulo = pPermiteAcumulo ?? false;

  final String? pIdCentroResultado;
  final String? pNome;
  final String? pCorSelecionada;
  final bool? pAtivo;
  final bool? pIsPadrao;
  final bool pIsFundo;
  final bool pPermiteAcumulo;

  @override
  State<BsCentroDeResultadoWidget> createState() =>
      _BsCentroDeResultadoWidgetState();
}

class _BsCentroDeResultadoWidgetState extends State<BsCentroDeResultadoWidget> {
  late BsCentroDeResultadoModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => BsCentroDeResultadoModel());

    // On component load action.
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      _model.corSelecionada = widget.pCorSelecionada!;
      safeSetState(() {});
    });

    _model.nomeCentroDeResultadoTextController ??= TextEditingController(
        text: widget.pIdCentroResultado != null &&
                widget.pIdCentroResultado != ''
            ? widget.pNome
            : '');
    _model.nomeCentroDeResultadoFocusNode ??= FocusNode();

    _model.swtIsFundoValue = widget.pIsFundo;
    _model.swtIsPadraoValue = widget.pIsPadrao!;
    _model.swtAcumuloValue = widget.pPermiteAcumulo;
    _model.swtAtivoValue = widget.pAtivo!;
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
              padding: EdgeInsetsDirectional.fromSTEB(0.0, 12.0, 0.0, 0.0),
              child: Text(
                widget.pIdCentroResultado == null ||
                        widget.pIdCentroResultado == ''
                    ? 'Novo Centro de Resultado'
                    : 'Editar Centro de Resultado',
                textAlign: TextAlign.center,
                style: FlutterFlowTheme.of(context).bodyMedium.override(
                      font: GoogleFonts.inter(
                        fontWeight: FontWeight.w600,
                        fontStyle:
                            FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                      ),
                      fontSize: 16.0,
                      letterSpacing: 0.0,
                      fontWeight: FontWeight.w600,
                      fontStyle:
                          FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                    ),
              ),
            ),
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(6.0, 24.0, 6.0, 0.0),
              child: Container(
                width: 200.0,
                child: TextFormField(
                  controller: _model.nomeCentroDeResultadoTextController,
                  focusNode: _model.nomeCentroDeResultadoFocusNode,
                  autofocus: false,
                  enabled: true,
                  obscureText: false,
                  decoration: InputDecoration(
                    isDense: true,
                    labelText: 'Nome do Centro de Custo',
                    labelStyle:
                        FlutterFlowTheme.of(context).labelMedium.override(
                              font: GoogleFonts.inter(
                                fontWeight: FlutterFlowTheme.of(context)
                                    .labelMedium
                                    .fontWeight,
                                fontStyle: FlutterFlowTheme.of(context)
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
                    hintText: 'Digite o nome do centro de custo...',
                    hintStyle:
                        FlutterFlowTheme.of(context).labelMedium.override(
                              font: GoogleFonts.inter(
                                fontWeight: FlutterFlowTheme.of(context)
                                    .labelMedium
                                    .fontWeight,
                                fontStyle: FlutterFlowTheme.of(context)
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
                    fillColor: FlutterFlowTheme.of(context).fundoText,
                  ),
                  style: FlutterFlowTheme.of(context).bodyMedium.override(
                        font: GoogleFonts.inter(
                          fontWeight: FlutterFlowTheme.of(context)
                              .bodyMedium
                              .fontWeight,
                          fontStyle:
                              FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                        ),
                        letterSpacing: 0.0,
                        fontWeight:
                            FlutterFlowTheme.of(context).bodyMedium.fontWeight,
                        fontStyle:
                            FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                      ),
                  cursorColor: FlutterFlowTheme.of(context).primaryText,
                  enableInteractiveSelection: true,
                  validator: _model.nomeCentroDeResultadoTextControllerValidator
                      .asValidator(context),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(8.0, 12.0, 0.0, 4.0),
              child: Text(
                'Cor de Identificação',
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
              ),
            ),
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(8.0, 0.0, 0.0, 0.0),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Container(
                      width: 100.0,
                      height: 50.0,
                      decoration: BoxDecoration(
                        color: FlutterFlowTheme.of(context).secondaryBackground,
                      ),
                      child: Padding(
                        padding:
                            EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 8.0),
                        child: Builder(
                          builder: (context) {
                            final itemCor = _model.listaCoresPadrao.toList();

                            return ListView.builder(
                              padding: EdgeInsets.zero,
                              primary: false,
                              shrinkWrap: true,
                              scrollDirection: Axis.horizontal,
                              itemCount: itemCor.length,
                              itemBuilder: (context, itemCorIndex) {
                                final itemCorItem = itemCor[itemCorIndex];
                                return Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      0.0, 0.0, 5.0, 0.0),
                                  child: InkWell(
                                    splashColor: Colors.transparent,
                                    focusColor: Colors.transparent,
                                    hoverColor: Colors.transparent,
                                    highlightColor: Colors.transparent,
                                    onTap: () async {
                                      _model.corSelecionada = itemCorItem;
                                      safeSetState(() {});
                                    },
                                    child: Container(
                                      width: 35.0,
                                      height: 35.0,
                                      decoration: BoxDecoration(
                                        color: valueOrDefault<Color>(
                                          widget.pIdCentroResultado != null &&
                                                  widget.pIdCentroResultado !=
                                                      ''
                                              ? valueOrDefault<Color>(
                                                  functions
                                                      .hexToColor(itemCorItem),
                                                  FlutterFlowTheme.of(context)
                                                      .primary,
                                                )
                                              : valueOrDefault<Color>(
                                                  functions
                                                      .hexToColor(itemCorItem),
                                                  FlutterFlowTheme.of(context)
                                                      .primary,
                                                ),
                                          FlutterFlowTheme.of(context).primary,
                                        ),
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          color: _model.corSelecionada ==
                                                  itemCorItem
                                              ? FlutterFlowTheme.of(context)
                                                  .primaryText
                                              : Color(0x00000000),
                                          width: 3.0,
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(8.0, 0.0, 0.0, 8.0),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Padding(
                      padding:
                          EdgeInsetsDirectional.fromSTEB(4.0, 0.0, 0.0, 0.0),
                      child: Text(
                        'Fundo Geral da organização?',
                        style: FlutterFlowTheme.of(context).bodyMedium.override(
                              font: GoogleFonts.inter(
                                fontWeight: FlutterFlowTheme.of(context)
                                    .bodyMedium
                                    .fontWeight,
                                fontStyle: FlutterFlowTheme.of(context)
                                    .bodyMedium
                                    .fontStyle,
                              ),
                              letterSpacing: 0.0,
                              fontWeight: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .fontWeight,
                              fontStyle: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .fontStyle,
                            ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(4.0, 0.0, 0.0, 0.0),
                    child: Switch.adaptive(
                      value: _model.swtIsFundoValue!,
                      onChanged: !_model.swtAtivoValue!
                          ? null
                          : (newValue) async {
                              safeSetState(
                                  () => _model.swtIsFundoValue = newValue);
                              if (newValue) {
                                safeSetState(() {
                                  _model.swtIsPadraoValue = widget.pIsPadrao!;
                                });
                              }
                            },
                      activeColor: FlutterFlowTheme.of(context).primary,
                      activeTrackColor: FlutterFlowTheme.of(context).fundoText,
                      inactiveTrackColor: FlutterFlowTheme.of(context).primary,
                      inactiveThumbColor:
                          FlutterFlowTheme.of(context).fundoText,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(8.0, 0.0, 0.0, 8.0),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Padding(
                      padding:
                          EdgeInsetsDirectional.fromSTEB(4.0, 0.0, 0.0, 0.0),
                      child: Text(
                        'Padrão para despesas?',
                        style: FlutterFlowTheme.of(context).bodyMedium.override(
                              font: GoogleFonts.inter(
                                fontWeight: FlutterFlowTheme.of(context)
                                    .bodyMedium
                                    .fontWeight,
                                fontStyle: FlutterFlowTheme.of(context)
                                    .bodyMedium
                                    .fontStyle,
                              ),
                              letterSpacing: 0.0,
                              fontWeight: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .fontWeight,
                              fontStyle: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .fontStyle,
                            ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(4.0, 0.0, 0.0, 0.0),
                    child: Switch.adaptive(
                      value: _model.swtIsPadraoValue!,
                      onChanged: !_model.swtAtivoValue!
                          ? null
                          : (newValue) async {
                              safeSetState(
                                  () => _model.swtIsPadraoValue = newValue);
                              if (newValue) {
                                safeSetState(() {
                                  _model.swtIsFundoValue = widget.pIsFundo;
                                });
                              }
                            },
                      activeColor: FlutterFlowTheme.of(context).primary,
                      activeTrackColor: FlutterFlowTheme.of(context).fundoText,
                      inactiveTrackColor: FlutterFlowTheme.of(context).primary,
                      inactiveThumbColor:
                          FlutterFlowTheme.of(context).fundoText,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(8.0, 0.0, 0.0, 8.0),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Expanded(
                    child: Padding(
                      padding:
                          EdgeInsetsDirectional.fromSTEB(4.0, 0.0, 0.0, 0.0),
                      child: Text(
                        'Acumulo anual de caixa?',
                        style: FlutterFlowTheme.of(context).bodyMedium.override(
                              font: GoogleFonts.inter(
                                fontWeight: FlutterFlowTheme.of(context)
                                    .bodyMedium
                                    .fontWeight,
                                fontStyle: FlutterFlowTheme.of(context)
                                    .bodyMedium
                                    .fontStyle,
                              ),
                              letterSpacing: 0.0,
                              fontWeight: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .fontWeight,
                              fontStyle: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .fontStyle,
                            ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(4.0, 0.0, 0.0, 0.0),
                    child: Switch.adaptive(
                      value: _model.swtAcumuloValue!,
                      onChanged: (newValue) async {
                        safeSetState(() => _model.swtAcumuloValue = newValue);

                        if (!newValue) {
                          safeSetState(() {
                            _model.swtIsFundoValue = widget.pIsFundo;
                            _model.swtIsPadraoValue = widget.pIsPadrao!;
                          });
                        }
                      },
                      activeColor: FlutterFlowTheme.of(context).primary,
                      activeTrackColor: FlutterFlowTheme.of(context).fundoText,
                      inactiveTrackColor: FlutterFlowTheme.of(context).primary,
                      inactiveThumbColor:
                          FlutterFlowTheme.of(context).fundoText,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(8.0, 0.0, 0.0, 8.0),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Expanded(
                    child: Padding(
                      padding:
                          EdgeInsetsDirectional.fromSTEB(4.0, 0.0, 0.0, 0.0),
                      child: Text(
                        'Esta ativo?',
                        style: FlutterFlowTheme.of(context).bodyMedium.override(
                              font: GoogleFonts.inter(
                                fontWeight: FlutterFlowTheme.of(context)
                                    .bodyMedium
                                    .fontWeight,
                                fontStyle: FlutterFlowTheme.of(context)
                                    .bodyMedium
                                    .fontStyle,
                              ),
                              letterSpacing: 0.0,
                              fontWeight: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .fontWeight,
                              fontStyle: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .fontStyle,
                            ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(4.0, 0.0, 0.0, 0.0),
                    child: Switch.adaptive(
                      value: _model.swtAtivoValue!,
                      onChanged: (newValue) async {
                        safeSetState(() => _model.swtAtivoValue = newValue);

                        if (!newValue) {
                          safeSetState(() {
                            _model.swtIsFundoValue = widget.pIsFundo;
                            _model.swtIsPadraoValue = widget.pIsPadrao!;
                          });
                        }
                      },
                      activeColor: FlutterFlowTheme.of(context).primary,
                      activeTrackColor: FlutterFlowTheme.of(context).fundoText,
                      inactiveTrackColor: FlutterFlowTheme.of(context).primary,
                      inactiveThumbColor:
                          FlutterFlowTheme.of(context).fundoText,
                    ),
                  ),
                ],
              ),
            ),
            Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                Expanded(
                  child: Builder(
                    builder: (context) => Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(
                          12.0, 12.0, 12.0, 12.0),
                      child: FFButtonWidget(
                        onPressed: () async {
                          if (widget.pIdCentroResultado != null &&
                              widget.pIdCentroResultado != '') {
                            await CentrosCustoTable().update(
                              data: {
                                'nome': _model
                                    .nomeCentroDeResultadoTextController.text,
                                'ativo': _model.swtAtivoValue,
                                'cor_hex': _model.corSelecionada,
                                'is_padrao': _model.swtIsPadraoValue,
                                'is_fundo': _model.swtIsFundoValue,
                                'permite_acumulo': _model.swtAcumuloValue,
                              },
                              matchingRows: (rows) => rows
                                  .eqOrNull(
                                    'id',
                                    widget.pIdCentroResultado,
                                  )
                                  .eqOrNull(
                                    'organization_id',
                                    FFAppState().currentOrganizationId,
                                  ),
                            );
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
                                    pMensagem:
                                        'Centro de resultado atualizado com sucesso!',
                                  ),
                                );
                              },
                            );
                          } else {
                            await CentrosCustoTable().insert({
                              'organization_id':
                                  FFAppState().currentOrganizationId,
                              'nome': _model
                                  .nomeCentroDeResultadoTextController.text,
                              'ativo': _model.swtAtivoValue,
                              'cor_hex': _model.corSelecionada,
                              'is_padrao': _model.swtIsPadraoValue,
                              'is_fundo': _model.swtIsFundoValue,
                              'permite_acumulo': _model.swtAcumuloValue,
                            });
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
                                    pMensagem:
                                        'Centro de resultado criado com sucesso!',
                                  ),
                                );
                              },
                            );
                          }

                          await actions.syncMasterCache(
                            FFAppState().currentOrganizationId,
                            false,
                            false,
                            true,
                            false,
                          );
                          Navigator.pop(context);
                        },
                        text: 'Salvar',
                        icon: Icon(
                          Icons.save,
                          size: 15.0,
                        ),
                        options: FFButtonOptions(
                          width: double.infinity,
                          height: 40.0,
                          padding: EdgeInsetsDirectional.fromSTEB(
                              16.0, 0.0, 16.0, 0.0),
                          iconPadding: EdgeInsetsDirectional.fromSTEB(
                              0.0, 0.0, 0.0, 0.0),
                          color: FlutterFlowTheme.of(context).primary,
                          textStyle:
                              FlutterFlowTheme.of(context).titleSmall.override(
                                    font: GoogleFonts.interTight(
                                      fontWeight: FlutterFlowTheme.of(context)
                                          .titleSmall
                                          .fontWeight,
                                      fontStyle: FlutterFlowTheme.of(context)
                                          .titleSmall
                                          .fontStyle,
                                    ),
                                    color: Colors.white,
                                    letterSpacing: 0.0,
                                    fontWeight: FlutterFlowTheme.of(context)
                                        .titleSmall
                                        .fontWeight,
                                    fontStyle: FlutterFlowTheme.of(context)
                                        .titleSmall
                                        .fontStyle,
                                  ),
                          elevation: 0.0,
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                    ),
                  ),
                ),
                if (widget.pIdCentroResultado != null &&
                    widget.pIdCentroResultado != '')
                  Expanded(
                    child: Align(
                      alignment: AlignmentDirectional(0.0, 0.0),
                      child: Builder(
                        builder: (context) => Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(
                              12.0, 12.0, 12.0, 12.0),
                          child: FFButtonWidget(
                            onPressed: () async {
                              var _shouldSetState = false;
                              var confirmDialogResponse =
                                  await showDialog<bool>(
                                        context: context,
                                        builder: (alertDialogContext) {
                                          return AlertDialog(
                                            title: Text('Atenção!'),
                                            content: Text(
                                                'Confirma a exclusão deste CR?'),
                                            actions: [
                                              TextButton(
                                                onPressed: () => Navigator.pop(
                                                    alertDialogContext, false),
                                                child: Text('Não'),
                                              ),
                                              TextButton(
                                                onPressed: () => Navigator.pop(
                                                    alertDialogContext, true),
                                                child: Text('Sim'),
                                              ),
                                            ],
                                          );
                                        },
                                      ) ??
                                      false;
                              if (confirmDialogResponse) {
                                await CentrosCustoTable().delete(
                                  matchingRows: (rows) => rows
                                      .eqOrNull(
                                        'organization_id',
                                        FFAppState().currentOrganizationId,
                                      )
                                      .eqOrNull(
                                        'id',
                                        widget.pIdCentroResultado,
                                      ),
                                );
                                _shouldSetState = true;
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
                                        pMensagem:
                                            'Centro de resultado excluída com sucesso!',
                                      ),
                                    );
                                  },
                                );

                                Navigator.pop(context);
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
                                      alignment: AlignmentDirectional(0.0, 0.0)
                                          .resolve(Directionality.of(context)),
                                      child: BsTopNotificacoesWidget(
                                        pTipo: 'ERRO',
                                        pMensagem:
                                            'Não foi possível realizar a exclusão.',
                                      ),
                                    );
                                  },
                                );

                                if (_shouldSetState) safeSetState(() {});
                                return;
                              }

                              if (_shouldSetState) safeSetState(() {});
                            },
                            text: 'Excluir',
                            icon: Icon(
                              Icons.delete,
                              size: 15.0,
                            ),
                            options: FFButtonOptions(
                              width: double.infinity,
                              height: 40.0,
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  0.0, 0.0, 0.0, 0.0),
                              iconPadding: EdgeInsetsDirectional.fromSTEB(
                                  0.0, 0.0, 0.0, 0.0),
                              color: FlutterFlowTheme.of(context)
                                  .primaryBackground,
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
                              borderSide: BorderSide(
                                color: FlutterFlowTheme.of(context).error,
                                width: 1.0,
                              ),
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
