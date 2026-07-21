import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_choice_chips.dart';
import '/flutter_flow/flutter_flow_drop_down.dart';
import '/flutter_flow/flutter_flow_expanded_image_view.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/flutter_flow/form_field_controller.dart';
import '/flutter_flow/upload_data.dart';
import '/lastro/geral/bs_top_notificacoes/bs_top_notificacoes_widget.dart';
import '/custom_code/actions/index.dart' as actions;
import '/custom_code/widgets/index.dart' as custom_widgets;
import '/flutter_flow/custom_functions.dart' as functions;
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'bs_detalhe_transacao_model.dart';
export 'bs_detalhe_transacao_model.dart';

class BsDetalheTransacaoWidget extends StatefulWidget {
  const BsDetalheTransacaoWidget({
    super.key,
    required this.pIdTransacao,
    this.pIdConta,
    this.pTipoConta,
    this.pDataVencimentoSugerida,
  });

  final String? pIdTransacao;
  final String? pIdConta;
  final String? pTipoConta;
  final DateTime? pDataVencimentoSugerida;

  @override
  State<BsDetalheTransacaoWidget> createState() =>
      _BsDetalheTransacaoWidgetState();
}

class _BsDetalheTransacaoWidgetState extends State<BsDetalheTransacaoWidget> {
  late BsDetalheTransacaoModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => BsDetalheTransacaoModel());

    // On component load action.
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      if (widget.pIdTransacao != null && widget.pIdTransacao != '') {
        _model.retBSDetalheTransacao = await actions.getDetalheTransacao(
          FFAppState().currentOrganizationId,
          widget.pIdTransacao!,
        );
        _model.vUrlComprovante = _model.retBSDetalheTransacao?.comprovativoUrl;
        _model.vDataPagamento = _model.retBSDetalheTransacao?.dataPagamento;
        _model.vDataVencimento = _model.retBSDetalheTransacao?.dataVencimento;
        _model.vDataCompetencia = _model.retBSDetalheTransacao?.dataCompetencia;
        _model.vIdCategoria = _model.retBSDetalheTransacao?.categoriaId;
        _model.vIdContaOrigem = _model.retBSDetalheTransacao?.contaOrigemId;
        _model.vIdContaDestino = _model.retBSDetalheTransacao?.contaDestinoId;
        _model.vIdCentroCusto = _model.retBSDetalheTransacao?.centroCustoId;
        _model.vIdMembro = _model.retBSDetalheTransacao?.membroId;
        _model.vDescricao = _model.retBSDetalheTransacao?.descricao;
        _model.vValorFormulario = _model.retBSDetalheTransacao?.valor;
        _model.vStatus = _model.retBSDetalheTransacao?.status == 'CONCILIADO';
        _model.vTipoOperacao =
            _model.retBSDetalheTransacao?.tipoOperacao == 'CREDITO'
                ? 'RECEITA'
                : (_model.retBSDetalheTransacao?.tipoOperacao == 'DEBITO'
                    ? 'DESPESA'
                    : 'TRANSFERENCIA');
        _model.vIdTransacao = widget.pIdTransacao;
        _model.vNomeDaConta = null;
        _model.vMostrarAvancadas = false;
        _model.vDescricaoCategoria = null;
        _model.vTipoConta = widget.pTipoConta;
        _model.inputDescricaoTextController?.text = _model.vDescricao!;

        _model.choTipoValueController?.value = [_model.vTipoOperacao];
        _model.ddCategoriaValueController?.value = _model.vIdCategoria!;
        _model.ddCategoriaValue = _model.vIdCategoria!;
        _model.ddContaOrigemValueController?.value = _model.vIdContaOrigem!;
        _model.ddContaOrigemValue = _model.vIdContaOrigem!;
        _model.ddContaDestinoValueController?.value = _model.vIdContaDestino!;
        _model.ddContaDestinoValue = _model.vIdContaDestino!;
        _model.ddCentroDeCustoValueController?.value = _model.vIdCentroCusto!;
        _model.ddCentroDeCustoValue = _model.vIdCentroCusto!;
        _model.ddMembroValueController?.value = _model.vIdMembro!;
        _model.ddMembroValue = _model.vIdMembro!;
        return;
      } else {
        _model.vDataPagamento =
            widget.pIdConta == 'CARTAO' ? null : getCurrentTimestamp;
        _model.vDataVencimento = widget.pDataVencimentoSugerida != null
            ? widget.pDataVencimentoSugerida
            : getCurrentTimestamp;
        _model.vDataCompetencia = getCurrentTimestamp;
        _model.vIdCentroCusto = null;
        _model.vUrlComprovante = null;
        _model.vNomeDaConta = null;
        _model.vMostrarAvancadas = false;
        _model.vDescricaoCategoria = null;
        _model.vIdCategoria = null;
        _model.vIdContaOrigem =
            widget.pIdConta != null && widget.pIdConta != ''
                ? widget.pIdConta
                : '';
        _model.vIdContaDestino = null;
        _model.vIdMembro = null;
        _model.vDescricao = null;
        _model.vValorFormulario = 0.0;
        _model.vTipoOperacao = 'DESPESA';
        _model.vStatus = true;
        _model.vIdTransacao = null;
        _model.vTipoConta = widget.pTipoConta;
        safeSetState(() {});
        await Future.delayed(
          Duration(
            milliseconds: 500,
          ),
        );
        safeSetState(() {
          _model.choTipoValueController?.value = ['DESPESA'];
        });
        _model.ddContaOrigemValueController?.value = _model.vIdContaOrigem!;
        _model.ddContaOrigemValue = _model.vIdContaOrigem!;
        safeSetState(() {});
        return;
      }
    });

    _model.inputDescricaoTextController ??=
        TextEditingController(text: _model.vDescricao);
    _model.inputDescricaoFocusNode ??= FocusNode();

    _model.swtStatusValue = _model.vStatus!;
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
          color: FlutterFlowTheme.of(context).primaryBackground,
          borderRadius: BorderRadius.only(),
        ),
        child: Padding(
          padding: EdgeInsetsDirectional.fromSTEB(20.0, 40.0, 20.0, 20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Align(
                alignment: AlignmentDirectional(0.0, 1.0),
                child: Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 20.0),
                  child: Container(
                    width: double.infinity,
                    height: 30.0,
                    decoration: BoxDecoration(
                      color: FlutterFlowTheme.of(context).primaryBackground,
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
                            widget.pIdTransacao == null ||
                                    widget.pIdTransacao == ''
                                ? 'Nova Transação'
                                : 'Editar Transação',
                            style: FlutterFlowTheme.of(context)
                                .headlineMedium
                                .override(
                                  font: GoogleFonts.interTight(
                                    fontWeight: FlutterFlowTheme.of(context)
                                        .headlineMedium
                                        .fontWeight,
                                    fontStyle: FlutterFlowTheme.of(context)
                                        .headlineMedium
                                        .fontStyle,
                                  ),
                                  color:
                                      FlutterFlowTheme.of(context).primaryText,
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
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 12.0),
                child: FlutterFlowChoiceChips(
                  options: [
                    ChipData('RECEITA'),
                    ChipData('DESPESA'),
                    ChipData('TRANSFERENCIA')
                  ],
                  onChanged: (widget.pIdTransacao != null &&
                          widget.pIdTransacao != '')
                      ? null
                      : (val) => safeSetState(
                          () => _model.choTipoValue = val?.firstOrNull),
                  selectedChipStyle: ChipStyle(
                    backgroundColor: FlutterFlowTheme.of(context).primary,
                    textStyle: FlutterFlowTheme.of(context).bodyMedium.override(
                          font: GoogleFonts.inter(
                            fontWeight: FontWeight.w600,
                            fontStyle: FlutterFlowTheme.of(context)
                                .bodyMedium
                                .fontStyle,
                          ),
                          color: FlutterFlowTheme.of(context).primaryText,
                          letterSpacing: 0.0,
                          fontWeight: FontWeight.w600,
                          fontStyle:
                              FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                        ),
                    iconColor: FlutterFlowTheme.of(context).alternate,
                    iconSize: 16.0,
                    elevation: 0.0,
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  unselectedChipStyle: ChipStyle(
                    backgroundColor:
                        FlutterFlowTheme.of(context).secondaryBackground,
                    textStyle: FlutterFlowTheme.of(context).bodyMedium.override(
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
                          fontStyle:
                              FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                        ),
                    iconColor: FlutterFlowTheme.of(context).secondaryText,
                    iconSize: 16.0,
                    elevation: 2.0,
                    borderColor: FlutterFlowTheme.of(context).alternate,
                    borderWidth: 1.0,
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  chipSpacing: 8.0,
                  rowSpacing: 8.0,
                  multiselect: false,
                  initialized: _model.choTipoValue != null,
                  alignment: WrapAlignment.start,
                  controller: _model.choTipoValueController ??=
                      FormFieldController<List<String>>(
                    [_model.vTipoOperacao],
                  ),
                  wrapped: false,
                ),
              ),
              Expanded(
                child: ListView(
                  padding: EdgeInsets.zero,
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  children: [
                    Padding(
                      padding:
                          EdgeInsetsDirectional.fromSTEB(4.0, 0.0, 0.0, 6.0),
                      child: Text(
                        'Valor (R\$)',
                        style: FlutterFlowTheme.of(context)
                            .labelMedium
                            .override(
                              font: GoogleFonts.inter(
                                fontWeight: FlutterFlowTheme.of(context)
                                    .labelMedium
                                    .fontWeight,
                                fontStyle: FlutterFlowTheme.of(context)
                                    .labelMedium
                                    .fontStyle,
                              ),
                              color: FlutterFlowTheme.of(context).secondaryText,
                              letterSpacing: 0.0,
                              fontWeight: FlutterFlowTheme.of(context)
                                  .labelMedium
                                  .fontWeight,
                              fontStyle: FlutterFlowTheme.of(context)
                                  .labelMedium
                                  .fontStyle,
                            ),
                      ),
                    ),
                    Padding(
                      padding:
                          EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 12.0),
                      child: Container(
                        width: 100.0,
                        height: 60.0,
                        child: custom_widgets.CampoMoedaNubank(
                          width: 100.0,
                          height: 60.0,
                          tamanhoFonte: 24.0,
                          corTexto: FlutterFlowTheme.of(context).secondaryText,
                          corFundo:
                              FlutterFlowTheme.of(context).secondaryBackground,
                          corBorda:
                              FlutterFlowTheme.of(context).secondaryBackground,
                          arredondamento: 8.0,
                          centralizarTexto: false,
                          valorInicial: widget.pIdTransacao != null &&
                                  widget.pIdTransacao != ''
                              ? _model.retBSDetalheTransacao?.valor
                              : _model.vValorFormulario,
                          acaoAoMudar: (valorDigitado) async {
                            _model.vValorFormulario = valorDigitado;
                            safeSetState(() {});
                          },
                        ),
                      ),
                    ),
                    if (_model.choTipoValue != 'TRANSFERENCIA')
                      Padding(
                        padding:
                            EdgeInsetsDirectional.fromSTEB(4.0, 0.0, 0.0, 6.0),
                        child: Text(
                          'Descrição do Lançamento',
                          style: FlutterFlowTheme.of(context)
                              .labelMedium
                              .override(
                                font: GoogleFonts.inter(
                                  fontWeight: FlutterFlowTheme.of(context)
                                      .labelMedium
                                      .fontWeight,
                                  fontStyle: FlutterFlowTheme.of(context)
                                      .labelMedium
                                      .fontStyle,
                                ),
                                color:
                                    FlutterFlowTheme.of(context).secondaryText,
                                letterSpacing: 0.0,
                                fontWeight: FlutterFlowTheme.of(context)
                                    .labelMedium
                                    .fontWeight,
                                fontStyle: FlutterFlowTheme.of(context)
                                    .labelMedium
                                    .fontStyle,
                              ),
                        ),
                      ),
                    if (_model.choTipoValue != 'TRANSFERENCIA')
                      Padding(
                        padding:
                            EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 12.0),
                        child: Container(
                          width: 200.0,
                          child: TextFormField(
                            controller: _model.inputDescricaoTextController,
                            focusNode: _model.inputDescricaoFocusNode,
                            autofocus: false,
                            enabled: true,
                            obscureText: false,
                            decoration: InputDecoration(
                              isDense: true,
                              labelStyle: FlutterFlowTheme.of(context)
                                  .labelMedium
                                  .override(
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
                              alignLabelWithHint: true,
                              hintText: () {
                                if (FFAppState().currentOrganizationType ==
                                    'Igreja') {
                                  return 'Ex: Dízimo Irmã Maria, Conta de Energia...';
                                } else if (FFAppState()
                                        .currentOrganizationType ==
                                    'Família') {
                                  return 'Ex: Salário, Conta de Energia...';
                                } else {
                                  return 'Ex: Venda a vista, Conta de Energia...';
                                }
                              }(),
                              hintStyle: FlutterFlowTheme.of(context)
                                  .labelMedium
                                  .override(
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
                              fillColor: FlutterFlowTheme.of(context)
                                  .secondaryBackground,
                              prefixIcon: Icon(
                                Icons.description_outlined,
                                color: FlutterFlowTheme.of(context).primary,
                              ),
                            ),
                            style: FlutterFlowTheme.of(context)
                                .bodyMedium
                                .override(
                                  font: GoogleFonts.inter(
                                    fontWeight: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .fontWeight,
                                    fontStyle: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .fontStyle,
                                  ),
                                  color: FlutterFlowTheme.of(context)
                                      .secondaryText,
                                  letterSpacing: 0.0,
                                  fontWeight: FlutterFlowTheme.of(context)
                                      .bodyMedium
                                      .fontWeight,
                                  fontStyle: FlutterFlowTheme.of(context)
                                      .bodyMedium
                                      .fontStyle,
                                ),
                            cursorColor:
                                FlutterFlowTheme.of(context).primaryText,
                            enableInteractiveSelection: true,
                            validator: _model
                                .inputDescricaoTextControllerValidator
                                .asValidator(context),
                          ),
                        ),
                      ),
                    if (_model.choTipoValue != 'TRANSFERENCIA')
                      Padding(
                        padding:
                            EdgeInsetsDirectional.fromSTEB(4.0, 0.0, 0.0, 6.0),
                        child: Text(
                          'Categoria',
                          style: FlutterFlowTheme.of(context)
                              .labelMedium
                              .override(
                                font: GoogleFonts.inter(
                                  fontWeight: FlutterFlowTheme.of(context)
                                      .labelMedium
                                      .fontWeight,
                                  fontStyle: FlutterFlowTheme.of(context)
                                      .labelMedium
                                      .fontStyle,
                                ),
                                color:
                                    FlutterFlowTheme.of(context).secondaryText,
                                letterSpacing: 0.0,
                                fontWeight: FlutterFlowTheme.of(context)
                                    .labelMedium
                                    .fontWeight,
                                fontStyle: FlutterFlowTheme.of(context)
                                    .labelMedium
                                    .fontStyle,
                              ),
                        ),
                      ),
                    if (_model.choTipoValue != 'TRANSFERENCIA')
                      Padding(
                        padding:
                            EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 12.0),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (_model.choTipoValue != 'TRANSFERENCIA')
                              Expanded(
                                child: FlutterFlowDropDown<String>(
                                  controller:
                                      _model.ddCategoriaValueController ??=
                                          FormFieldController<String>(
                                    _model.ddCategoriaValue ??=
                                        _model.vIdCategoria,
                                  ),
                                  options: List<String>.from(FFAppState()
                                      .cachePlanoContas
                                      .where((e) =>
                                          (e.permiteLancamento == true) &&
                                          ((e.naturezaFluxo ==
                                                  () {
                                                    if (_model.choTipoValue ==
                                                        'RECEITA') {
                                                      return 'ENTRADA';
                                                    } else if (_model
                                                            .choTipoValue ==
                                                        'DESPESA') {
                                                      return 'SAIDA';
                                                    } else {
                                                      return null;
                                                    }
                                                  }()) ||
                                              (e.naturezaFluxo == '')))
                                      .toList()
                                      .map((e) => e.id)
                                      .toList()),
                                  optionLabels: functions
                                      .formatarDropdownContas(FFAppState()
                                          .cachePlanoContas
                                          .where((e) =>
                                              (e.permiteLancamento == true) &&
                                              ((e.naturezaFluxo ==
                                                      () {
                                                        if (_model
                                                                .choTipoValue ==
                                                            'RECEITA') {
                                                          return 'ENTRADA';
                                                        } else if (_model
                                                                .choTipoValue ==
                                                            'DESPESA') {
                                                          return 'SAIDA';
                                                        } else {
                                                          return null;
                                                        }
                                                      }()) ||
                                                  (e.naturezaFluxo == '')))
                                          .toList()),
                                  onChanged: (val) async {
                                    safeSetState(
                                        () => _model.ddCategoriaValue = val);
                                    _model.vDescricaoCategoria = FFAppState()
                                        .cachePlanoContas
                                        .where((e) =>
                                            e.id == _model.ddCategoriaValue)
                                        .toList()
                                        .firstOrNull
                                        ?.nome;
                                    safeSetState(() {});
                                  },
                                  width: 200.0,
                                  height: 40.0,
                                  textStyle: FlutterFlowTheme.of(context)
                                      .bodyMedium
                                      .override(
                                        font: GoogleFonts.inter(
                                          fontWeight:
                                              FlutterFlowTheme.of(context)
                                                  .bodyMedium
                                                  .fontWeight,
                                          fontStyle:
                                              FlutterFlowTheme.of(context)
                                                  .bodyMedium
                                                  .fontStyle,
                                        ),
                                        color: FlutterFlowTheme.of(context)
                                            .secondaryText,
                                        letterSpacing: 0.0,
                                        fontWeight: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .fontWeight,
                                        fontStyle: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .fontStyle,
                                      ),
                                  hintText: 'Selecione a categoria...',
                                  icon: Icon(
                                    Icons.keyboard_arrow_down_rounded,
                                    color: FlutterFlowTheme.of(context)
                                        .secondaryText,
                                    size: 24.0,
                                  ),
                                  fillColor: FlutterFlowTheme.of(context)
                                      .secondaryBackground,
                                  elevation: 2.0,
                                  borderColor: Colors.transparent,
                                  borderWidth: 0.0,
                                  borderRadius: 8.0,
                                  margin: EdgeInsetsDirectional.fromSTEB(
                                      12.0, 0.0, 12.0, 0.0),
                                  hidesUnderline: true,
                                  isOverButton: false,
                                  isSearchable: false,
                                  isMultiSelect: false,
                                ),
                              ),
                          ],
                        ),
                      ),
                    Padding(
                      padding:
                          EdgeInsetsDirectional.fromSTEB(4.0, 0.0, 0.0, 6.0),
                      child: Text(
                        _model.choTipoValue == 'TRANSFERENCIA'
                            ? 'Data Transferência'
                            : (_model.choTipoValue == 'RECEITA'
                                ? 'Data Movimento'
                                : 'Data Vencimento'),
                        style: FlutterFlowTheme.of(context)
                            .labelMedium
                            .override(
                              font: GoogleFonts.inter(
                                fontWeight: FlutterFlowTheme.of(context)
                                    .labelMedium
                                    .fontWeight,
                                fontStyle: FlutterFlowTheme.of(context)
                                    .labelMedium
                                    .fontStyle,
                              ),
                              color: FlutterFlowTheme.of(context).secondaryText,
                              letterSpacing: 0.0,
                              fontWeight: FlutterFlowTheme.of(context)
                                  .labelMedium
                                  .fontWeight,
                              fontStyle: FlutterFlowTheme.of(context)
                                  .labelMedium
                                  .fontStyle,
                            ),
                      ),
                    ),
                    Padding(
                      padding:
                          EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 12.0),
                      child: InkWell(
                        splashColor: Colors.transparent,
                        focusColor: Colors.transparent,
                        hoverColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        onTap: () async {
                          // dtpDataVenc
                          final _datePicked1Date = await showDatePicker(
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
                                headerTextStyle: FlutterFlowTheme.of(context)
                                    .headlineLarge
                                    .override(
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
                                    FlutterFlowTheme.of(context)
                                        .secondaryBackground,
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

                          if (_datePicked1Date != null) {
                            safeSetState(() {
                              _model.datePicked1 = DateTime(
                                _datePicked1Date.year,
                                _datePicked1Date.month,
                                _datePicked1Date.day,
                              );
                            });
                          } else if (_model.datePicked1 != null) {
                            safeSetState(() {
                              _model.datePicked1 = getCurrentTimestamp;
                            });
                          }
                          _model.vDataVencimento = _model.datePicked1;
                          safeSetState(() {});
                        },
                        child: Container(
                          width: double.infinity,
                          height: 40.0,
                          decoration: BoxDecoration(
                            color: FlutterFlowTheme.of(context)
                                .secondaryBackground,
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.center,
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
                              Expanded(
                                child: Text(
                                  dateTimeFormat(
                                    "dd/MM/y",
                                    _model.vDataVencimento,
                                    locale: FFLocalizations.of(context)
                                        .languageCode,
                                  ),
                                  style: FlutterFlowTheme.of(context)
                                      .bodyMedium
                                      .override(
                                        font: GoogleFonts.inter(
                                          fontWeight:
                                              FlutterFlowTheme.of(context)
                                                  .bodyMedium
                                                  .fontWeight,
                                          fontStyle:
                                              FlutterFlowTheme.of(context)
                                                  .bodyMedium
                                                  .fontStyle,
                                        ),
                                        color: FlutterFlowTheme.of(context)
                                            .secondaryText,
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
                            ],
                          ),
                        ),
                      ),
                    ),
                    if (_model.choTipoValue != 'TRANSFERENCIA')
                      Align(
                        alignment: AlignmentDirectional(-1.0, 0.0),
                        child: Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(
                              0.0, 0.0, 0.0, 12.0),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    4.0, 0.0, 8.0, 6.0),
                                child: Text(
                                  _model.choTipoValue == 'RECEITA'
                                      ? 'Esta conta já foi recebida?'
                                      : 'Esta conta já foi paga?',
                                  style: FlutterFlowTheme.of(context)
                                      .labelMedium
                                      .override(
                                        font: GoogleFonts.inter(
                                          fontWeight:
                                              FlutterFlowTheme.of(context)
                                                  .labelMedium
                                                  .fontWeight,
                                          fontStyle:
                                              FlutterFlowTheme.of(context)
                                                  .labelMedium
                                                  .fontStyle,
                                        ),
                                        color: FlutterFlowTheme.of(context)
                                            .secondaryText,
                                        letterSpacing: 0.0,
                                        fontWeight: FlutterFlowTheme.of(context)
                                            .labelMedium
                                            .fontWeight,
                                        fontStyle: FlutterFlowTheme.of(context)
                                            .labelMedium
                                            .fontStyle,
                                      ),
                                ),
                              ),
                              Switch.adaptive(
                                value: _model.swtStatusValue!,
                                onChanged: ((_model.vTipoOperacao ==
                                            'TRANSFERENCIA') &&
                                        (_model.vIdTransacao != null &&
                                            _model.vIdTransacao != ''))
                                    ? null
                                    : (newValue) async {
                                        safeSetState(() =>
                                            _model.swtStatusValue = newValue);
                                        if (newValue) {
                                          _model.vDataPagamento =
                                              _model.vTipoConta == 'CARTAO'
                                                  ? null
                                                  : getCurrentTimestamp;
                                          safeSetState(() {});
                                        } else {
                                          _model.vDataPagamento = null;
                                          _model.vIdContaOrigem =
                                              _model.vTipoConta == 'CARTAO'
                                                  ? null
                                                  : _model.ddContaOrigemValue;
                                          safeSetState(() {});
                                        }
                                      },
                                activeColor: ((_model.vTipoOperacao ==
                                            'TRANSFERENCIA') &&
                                        (_model.vIdTransacao != null &&
                                            _model.vIdTransacao != ''))
                                    ? FlutterFlowTheme.of(context).primary
                                    : FlutterFlowTheme.of(context).primary,
                                activeTrackColor: ((_model.vTipoOperacao ==
                                            'TRANSFERENCIA') &&
                                        (_model.vIdTransacao != null &&
                                            _model.vIdTransacao != ''))
                                    ? FlutterFlowTheme.of(context).alternate
                                    : FlutterFlowTheme.of(context).fundoText,
                                inactiveTrackColor: ((_model.vTipoOperacao ==
                                            'TRANSFERENCIA') &&
                                        (_model.vIdTransacao != null &&
                                            _model.vIdTransacao != ''))
                                    ? FlutterFlowTheme.of(context).primary
                                    : FlutterFlowTheme.of(context).primary,
                                inactiveThumbColor: ((_model.vTipoOperacao ==
                                            'TRANSFERENCIA') &&
                                        (_model.vIdTransacao != null &&
                                            _model.vIdTransacao != ''))
                                    ? FlutterFlowTheme.of(context).alternate
                                    : FlutterFlowTheme.of(context).fundoText,
                              ),
                            ],
                          ),
                        ),
                      ),
                    if ((_model.swtStatusValue == true) &&
                        (_model.choTipoValue != 'TRANSFERENCIA') &&
                        (_model.vTipoConta != 'CARTAO'))
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(
                                4.0, 0.0, 0.0, 6.0),
                            child: Text(
                              _model.choTipoValue == 'RECEITA'
                                  ? 'Data Recebimento'
                                  : 'Data Pagamento',
                              style: FlutterFlowTheme.of(context)
                                  .labelMedium
                                  .override(
                                    font: GoogleFonts.inter(
                                      fontWeight: FlutterFlowTheme.of(context)
                                          .labelMedium
                                          .fontWeight,
                                      fontStyle: FlutterFlowTheme.of(context)
                                          .labelMedium
                                          .fontStyle,
                                    ),
                                    color: FlutterFlowTheme.of(context)
                                        .secondaryText,
                                    letterSpacing: 0.0,
                                    fontWeight: FlutterFlowTheme.of(context)
                                        .labelMedium
                                        .fontWeight,
                                    fontStyle: FlutterFlowTheme.of(context)
                                        .labelMedium
                                        .fontStyle,
                                  ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(
                                0.0, 0.0, 0.0, 6.0),
                            child: InkWell(
                              splashColor: Colors.transparent,
                              focusColor: Colors.transparent,
                              hoverColor: Colors.transparent,
                              highlightColor: Colors.transparent,
                              onTap: () async {
                                final _datePicked2Date = await showDatePicker(
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
                                      headerTextStyle: FlutterFlowTheme.of(
                                              context)
                                          .headlineLarge
                                          .override(
                                            font: GoogleFonts.interTight(
                                              fontWeight: FontWeight.w600,
                                              fontStyle:
                                                  FlutterFlowTheme.of(context)
                                                      .headlineLarge
                                                      .fontStyle,
                                            ),
                                            fontSize: 32.0,
                                            letterSpacing: 0.0,
                                            fontWeight: FontWeight.w600,
                                            fontStyle:
                                                FlutterFlowTheme.of(context)
                                                    .headlineLarge
                                                    .fontStyle,
                                          ),
                                      pickerBackgroundColor:
                                          FlutterFlowTheme.of(context)
                                              .secondaryBackground,
                                      pickerForegroundColor:
                                          FlutterFlowTheme.of(context)
                                              .primaryText,
                                      selectedDateTimeBackgroundColor:
                                          FlutterFlowTheme.of(context).primary,
                                      selectedDateTimeForegroundColor:
                                          FlutterFlowTheme.of(context).info,
                                      actionButtonForegroundColor:
                                          FlutterFlowTheme.of(context)
                                              .primaryText,
                                      iconSize: 24.0,
                                    );
                                  },
                                );

                                TimeOfDay? _datePicked2Time;
                                if (_datePicked2Date != null) {
                                  _datePicked2Time = await showTimePicker(
                                    context: context,
                                    initialTime: TimeOfDay.fromDateTime(
                                        getCurrentTimestamp),
                                    builder: (context, child) {
                                      return wrapInMaterialTimePickerTheme(
                                        context,
                                        child!,
                                        headerBackgroundColor:
                                            FlutterFlowTheme.of(context)
                                                .primary,
                                        headerForegroundColor:
                                            FlutterFlowTheme.of(context).info,
                                        headerTextStyle: FlutterFlowTheme.of(
                                                context)
                                            .headlineLarge
                                            .override(
                                              font: GoogleFonts.interTight(
                                                fontWeight: FontWeight.w600,
                                                fontStyle:
                                                    FlutterFlowTheme.of(context)
                                                        .headlineLarge
                                                        .fontStyle,
                                              ),
                                              fontSize: 32.0,
                                              letterSpacing: 0.0,
                                              fontWeight: FontWeight.w600,
                                              fontStyle:
                                                  FlutterFlowTheme.of(context)
                                                      .headlineLarge
                                                      .fontStyle,
                                            ),
                                        pickerBackgroundColor:
                                            FlutterFlowTheme.of(context)
                                                .secondaryBackground,
                                        pickerForegroundColor:
                                            FlutterFlowTheme.of(context)
                                                .primaryText,
                                        selectedDateTimeBackgroundColor:
                                            FlutterFlowTheme.of(context)
                                                .primary,
                                        selectedDateTimeForegroundColor:
                                            FlutterFlowTheme.of(context).info,
                                        actionButtonForegroundColor:
                                            FlutterFlowTheme.of(context)
                                                .primaryText,
                                        iconSize: 24.0,
                                      );
                                    },
                                  );
                                }

                                if (_datePicked2Date != null &&
                                    _datePicked2Time != null) {
                                  safeSetState(() {
                                    _model.datePicked2 = DateTime(
                                      _datePicked2Date.year,
                                      _datePicked2Date.month,
                                      _datePicked2Date.day,
                                      _datePicked2Time!.hour,
                                      _datePicked2Time.minute,
                                    );
                                  });
                                } else if (_model.datePicked2 != null) {
                                  safeSetState(() {
                                    _model.datePicked2 = getCurrentTimestamp;
                                  });
                                }
                                _model.vDataPagamento = _model.datePicked2;
                                safeSetState(() {});
                              },
                              child: Container(
                                width: double.infinity,
                                height: 40.0,
                                decoration: BoxDecoration(
                                  color: FlutterFlowTheme.of(context)
                                      .secondaryBackground,
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
                                        color: FlutterFlowTheme.of(context)
                                            .primary,
                                        size: 16.0,
                                      ),
                                    ),
                                    Text(
                                      dateTimeFormat(
                                        "dd/MM/yyyy HH:mm",
                                        _model.vDataPagamento,
                                        locale: FFLocalizations.of(context)
                                            .languageCode,
                                      ),
                                      style: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .override(
                                            font: GoogleFonts.inter(
                                              fontWeight:
                                                  FlutterFlowTheme.of(context)
                                                      .bodyMedium
                                                      .fontWeight,
                                              fontStyle:
                                                  FlutterFlowTheme.of(context)
                                                      .bodyMedium
                                                      .fontStyle,
                                            ),
                                            color: FlutterFlowTheme.of(context)
                                                .secondaryText,
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
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(
                              0.0, 6.0, 0.0, 0.0),
                          child: Container(
                            width: 100.0,
                            decoration: BoxDecoration(
                              color: FlutterFlowTheme.of(context)
                                  .primaryBackground,
                            ),
                            child: Visibility(
                              visible: _model.swtStatusValue == true,
                              child: Column(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        4.0, 0.0, 0.0, 6.0),
                                    child: Text(
                                      _model.choTipoValue == 'TRANSFERENCIA'
                                          ? 'Conta Origem'
                                          : 'Conta Bancária/Caixa',
                                      style: FlutterFlowTheme.of(context)
                                          .labelMedium
                                          .override(
                                            font: GoogleFonts.inter(
                                              fontWeight:
                                                  FlutterFlowTheme.of(context)
                                                      .labelMedium
                                                      .fontWeight,
                                              fontStyle:
                                                  FlutterFlowTheme.of(context)
                                                      .labelMedium
                                                      .fontStyle,
                                            ),
                                            color: FlutterFlowTheme.of(context)
                                                .secondaryText,
                                            letterSpacing: 0.0,
                                            fontWeight:
                                                FlutterFlowTheme.of(context)
                                                    .labelMedium
                                                    .fontWeight,
                                            fontStyle:
                                                FlutterFlowTheme.of(context)
                                                    .labelMedium
                                                    .fontStyle,
                                          ),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        0.0, 0.0, 0.0, 12.0),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          child: FlutterFlowDropDown<String>(
                                            controller: _model
                                                    .ddContaOrigemValueController ??=
                                                FormFieldController<String>(
                                              _model.ddContaOrigemValue ??=
                                                  _model.vIdContaOrigem,
                                            ),
                                            options: List<String>.from(
                                                FFAppState()
                                                    .cacheContasBancarias
                                                    .where(
                                                        (e) => e.ativo == true)
                                                    .toList()
                                                    .map((e) => e.id)
                                                    .toList()),
                                            optionLabels: FFAppState()
                                                .cacheContasBancarias
                                                .where((e) => e.ativo == true)
                                                .toList()
                                                .map((e) => e.nome)
                                                .toList(),
                                            onChanged: (val) async {
                                              safeSetState(() => _model
                                                  .ddContaOrigemValue = val);
                                              _model.vTipoConta = FFAppState()
                                                  .cacheContasBancarias
                                                  .where((e) =>
                                                      e.id ==
                                                      _model.ddContaOrigemValue)
                                                  .toList()
                                                  .firstOrNull
                                                  ?.tipo;
                                              _model
                                                  .vDataPagamento = FFAppState()
                                                          .cacheContasBancarias
                                                          .where((e) =>
                                                              e.id ==
                                                              _model
                                                                  .ddContaOrigemValue)
                                                          .toList()
                                                          .firstOrNull
                                                          ?.tipo ==
                                                      'CARTAO'
                                                  ? null
                                                  : _model.vDataPagamento;
                                              _model.vStatus = false;
                                              _model.vDataVencimento = (FFAppState()
                                                              .cacheContasBancarias
                                                              .where((e) =>
                                                                  e.id ==
                                                                  _model
                                                                      .ddContaOrigemValue)
                                                              .toList()
                                                              .firstOrNull
                                                              ?.tipo ==
                                                          'CARTAO') &&
                                                      (widget.pIdTransacao ==
                                                              null ||
                                                          widget.pIdTransacao ==
                                                              '')
                                                  ? functions
                                                      .calcularVencimentoFatura(
                                                          getCurrentTimestamp,
                                                          FFAppState()
                                                              .cacheContasBancarias
                                                              .where((e) =>
                                                                  e.id ==
                                                                  _model
                                                                      .ddContaOrigemValue)
                                                              .toList()
                                                              .firstOrNull!
                                                              .diaFechamento,
                                                          FFAppState()
                                                              .cacheContasBancarias
                                                              .where((e) =>
                                                                  e.id ==
                                                                  _model.ddContaOrigemValue)
                                                              .toList()
                                                              .firstOrNull!
                                                              .diaVencimento)
                                                  : _model.vDataVencimento;
                                              safeSetState(() {});
                                            },
                                            width: 200.0,
                                            height: 40.0,
                                            textStyle:
                                                FlutterFlowTheme.of(context)
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
                                                      color:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .secondaryText,
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
                                            hintText:
                                                'Selecione conta de origem...',
                                            icon: Icon(
                                              Icons.keyboard_arrow_down_rounded,
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .secondaryText,
                                              size: 24.0,
                                            ),
                                            fillColor:
                                                FlutterFlowTheme.of(context)
                                                    .secondaryBackground,
                                            elevation: 2.0,
                                            borderColor: Colors.transparent,
                                            borderWidth: 0.0,
                                            borderRadius: 8.0,
                                            margin:
                                                EdgeInsetsDirectional.fromSTEB(
                                                    12.0, 0.0, 12.0, 0.0),
                                            hidesUnderline: true,
                                            disabled: (_model.vIdTransacao ==
                                                            null ||
                                                        _model.vIdTransacao ==
                                                            '') &&
                                                    (_model.vTipoOperacao ==
                                                        'TRANSFERENCIA')
                                                ? true
                                                : false,
                                            isOverButton: false,
                                            isSearchable: false,
                                            isMultiSelect: false,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  if (_model.choTipoValue == 'TRANSFERENCIA')
                                    Column(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.stretch,
                                      children: [
                                        Padding(
                                          padding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  4.0, 0.0, 0.0, 6.0),
                                          child: Text(
                                            'Conta Destino',
                                            style: FlutterFlowTheme.of(context)
                                                .labelMedium
                                                .override(
                                                  font: GoogleFonts.inter(
                                                    fontWeight:
                                                        FlutterFlowTheme.of(
                                                                context)
                                                            .labelMedium
                                                            .fontWeight,
                                                    fontStyle:
                                                        FlutterFlowTheme.of(
                                                                context)
                                                            .labelMedium
                                                            .fontStyle,
                                                  ),
                                                  color: FlutterFlowTheme.of(
                                                          context)
                                                      .secondaryText,
                                                  letterSpacing: 0.0,
                                                  fontWeight:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .labelMedium
                                                          .fontWeight,
                                                  fontStyle:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .labelMedium
                                                          .fontStyle,
                                                ),
                                          ),
                                        ),
                                        Expanded(
                                          child: Padding(
                                            padding:
                                                EdgeInsetsDirectional.fromSTEB(
                                                    0.0, 0.0, 0.0, 12.0),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Expanded(
                                                  child: FlutterFlowDropDown<
                                                      String>(
                                                    controller: _model
                                                            .ddContaDestinoValueController ??=
                                                        FormFieldController<
                                                            String>(
                                                      _model.ddContaDestinoValue ??=
                                                          _model
                                                              .vIdContaDestino,
                                                    ),
                                                    options: List<String>.from(
                                                        FFAppState()
                                                            .cacheContasBancarias
                                                            .where((e) =>
                                                                e.ativo == true)
                                                            .toList()
                                                            .map((e) => e.id)
                                                            .toList()),
                                                    optionLabels: FFAppState()
                                                        .cacheContasBancarias
                                                        .where((e) =>
                                                            e.ativo == true)
                                                        .toList()
                                                        .map((e) => e.nome)
                                                        .toList(),
                                                    onChanged: (val) async {
                                                      safeSetState(() => _model
                                                              .ddContaDestinoValue =
                                                          val);
                                                      _model.vNomeDaConta =
                                                          FFAppState()
                                                              .cacheContasBancarias
                                                              .where((e) =>
                                                                  e.id ==
                                                                  _model
                                                                      .ddContaOrigemValue)
                                                              .toList()
                                                              .firstOrNull
                                                              ?.nome;
                                                      safeSetState(() {});
                                                    },
                                                    width: 200.0,
                                                    height: 40.0,
                                                    textStyle: FlutterFlowTheme
                                                            .of(context)
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
                                                          color: FlutterFlowTheme
                                                                  .of(context)
                                                              .secondaryText,
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
                                                    hintText:
                                                        'Selecione a conta de destino...',
                                                    icon: Icon(
                                                      Icons
                                                          .keyboard_arrow_down_rounded,
                                                      color:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .secondaryText,
                                                      size: 24.0,
                                                    ),
                                                    fillColor: FlutterFlowTheme
                                                            .of(context)
                                                        .secondaryBackground,
                                                    elevation: 2.0,
                                                    borderColor:
                                                        Colors.transparent,
                                                    borderWidth: 0.0,
                                                    borderRadius: 8.0,
                                                    margin:
                                                        EdgeInsetsDirectional
                                                            .fromSTEB(12.0, 0.0,
                                                                12.0, 0.0),
                                                    hidesUnderline: true,
                                                    disabled: (_model.vIdTransacao ==
                                                                    null ||
                                                                _model.vIdTransacao ==
                                                                    '') &&
                                                            (_model.vTipoOperacao ==
                                                                'TRANSFERENCIA')
                                                        ? true
                                                        : false,
                                                    isOverButton: false,
                                                    isSearchable: false,
                                                    isMultiSelect: false,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    if (_model.choTipoValue != 'TRANSFERENCIA')
                      Padding(
                        padding:
                            EdgeInsetsDirectional.fromSTEB(0.0, 6.0, 0.0, 6.0),
                        child: InkWell(
                          splashColor: Colors.transparent,
                          focusColor: Colors.transparent,
                          hoverColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          onTap: () async {
                            _model.vMostrarAvancadas =
                                !_model.vMostrarAvancadas;
                            safeSetState(() {});
                          },
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Align(
                                alignment: AlignmentDirectional(0.0, -1.0),
                                child: Text(
                                  'Opções Avançadas',
                                  style: FlutterFlowTheme.of(context)
                                      .bodyMedium
                                      .override(
                                        font: GoogleFonts.inter(
                                          fontWeight:
                                              FlutterFlowTheme.of(context)
                                                  .bodyMedium
                                                  .fontWeight,
                                          fontStyle: FontStyle.italic,
                                        ),
                                        color: FlutterFlowTheme.of(context)
                                            .accent1,
                                        letterSpacing: 0.0,
                                        fontWeight: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .fontWeight,
                                        fontStyle: FontStyle.italic,
                                      ),
                                ),
                              ),
                              Icon(
                                Icons.chevron_right,
                                color: FlutterFlowTheme.of(context).accent1,
                                size: 24.0,
                              ),
                            ],
                          ),
                        ),
                      ),
                    if (valueOrDefault<bool>(
                      (_model.vMostrarAvancadas == true) &&
                          (_model.choTipoValue != 'TRANSFERENCIA'),
                      false,
                    ))
                      Container(
                        decoration: BoxDecoration(),
                        child: Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(
                              0.0, 6.0, 0.0, 0.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    4.0, 0.0, 0.0, 6.0),
                                child: Text(
                                  'Centro de Custo',
                                  style: FlutterFlowTheme.of(context)
                                      .labelMedium
                                      .override(
                                        font: GoogleFonts.inter(
                                          fontWeight:
                                              FlutterFlowTheme.of(context)
                                                  .labelMedium
                                                  .fontWeight,
                                          fontStyle:
                                              FlutterFlowTheme.of(context)
                                                  .labelMedium
                                                  .fontStyle,
                                        ),
                                        color: FlutterFlowTheme.of(context)
                                            .secondaryText,
                                        letterSpacing: 0.0,
                                        fontWeight: FlutterFlowTheme.of(context)
                                            .labelMedium
                                            .fontWeight,
                                        fontStyle: FlutterFlowTheme.of(context)
                                            .labelMedium
                                            .fontStyle,
                                      ),
                                ),
                              ),
                              Expanded(
                                child: Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      0.0, 0.0, 0.0, 12.0),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: FlutterFlowDropDown<String>(
                                          controller: _model
                                                  .ddCentroDeCustoValueController ??=
                                              FormFieldController<String>(
                                            _model
                                                .ddCentroDeCustoValue ??= _model
                                                            .vIdTransacao ==
                                                        null ||
                                                    _model.vIdTransacao == ''
                                                ? (_model.vTipoOperacao ==
                                                        'RECEITA'
                                                    ? FFAppState()
                                                        .cacheCentrosDeResultado
                                                        .where((e) =>
                                                            e.isFundo == true)
                                                        .toList()
                                                        .firstOrNull
                                                        ?.id
                                                    : FFAppState()
                                                        .cacheCentrosDeResultado
                                                        .where((e) =>
                                                            e.isPadrao == true)
                                                        .toList()
                                                        .firstOrNull
                                                        ?.id)
                                                : _model.vIdCentroCusto,
                                          ),
                                          options: List<String>.from(
                                              FFAppState()
                                                  .cacheCentrosDeResultado
                                                  .where((e) => e.ativo == true)
                                                  .toList()
                                                  .map((e) => e.id)
                                                  .toList()),
                                          optionLabels: FFAppState()
                                              .cacheCentrosDeResultado
                                              .where((e) => e.ativo == true)
                                              .toList()
                                              .map((e) => e.nome)
                                              .toList(),
                                          onChanged: (val) => safeSetState(() =>
                                              _model.ddCentroDeCustoValue =
                                                  val),
                                          width: 200.0,
                                          height: 40.0,
                                          textStyle: FlutterFlowTheme.of(
                                                  context)
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
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .secondaryText,
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
                                          hintText:
                                              'Selecione o centro de custo...',
                                          icon: Icon(
                                            Icons.keyboard_arrow_down_rounded,
                                            color: FlutterFlowTheme.of(context)
                                                .secondaryText,
                                            size: 24.0,
                                          ),
                                          fillColor:
                                              FlutterFlowTheme.of(context)
                                                  .secondaryBackground,
                                          elevation: 2.0,
                                          borderColor: Colors.transparent,
                                          borderWidth: 0.0,
                                          borderRadius: 8.0,
                                          margin:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  12.0, 0.0, 12.0, 0.0),
                                          hidesUnderline: true,
                                          isOverButton: false,
                                          isSearchable: false,
                                          isMultiSelect: false,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    4.0, 0.0, 0.0, 6.0),
                                child: Text(
                                  _model.choTipoValue == 'RECEITA'
                                      ? 'Pessoa'
                                      : 'Fornecedor',
                                  style: FlutterFlowTheme.of(context)
                                      .labelMedium
                                      .override(
                                        font: GoogleFonts.inter(
                                          fontWeight:
                                              FlutterFlowTheme.of(context)
                                                  .labelMedium
                                                  .fontWeight,
                                          fontStyle:
                                              FlutterFlowTheme.of(context)
                                                  .labelMedium
                                                  .fontStyle,
                                        ),
                                        color: FlutterFlowTheme.of(context)
                                            .secondaryText,
                                        letterSpacing: 0.0,
                                        fontWeight: FlutterFlowTheme.of(context)
                                            .labelMedium
                                            .fontWeight,
                                        fontStyle: FlutterFlowTheme.of(context)
                                            .labelMedium
                                            .fontStyle,
                                      ),
                                ),
                              ),
                              Expanded(
                                child: Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      0.0, 0.0, 0.0, 12.0),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Expanded(
                                        child: FlutterFlowDropDown<String>(
                                          controller:
                                              _model.ddMembroValueController ??=
                                                  FormFieldController<String>(
                                            _model.ddMembroValue ??=
                                                _model.vIdMembro,
                                          ),
                                          options: List<String>.from(
                                              FFAppState()
                                                  .cacheMembros
                                                  .where((e) => e.ativo == true)
                                                  .toList()
                                                  .map((e) => e.id)
                                                  .toList()),
                                          optionLabels: FFAppState()
                                              .cacheMembros
                                              .where((e) => e.ativo == true)
                                              .toList()
                                              .map((e) => e.nomeCompleto)
                                              .toList(),
                                          onChanged: (val) => safeSetState(
                                              () => _model.ddMembroValue = val),
                                          width: 200.0,
                                          height: 40.0,
                                          textStyle: FlutterFlowTheme.of(
                                                  context)
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
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .secondaryText,
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
                                          hintText: _model.choTipoValue ==
                                                  'RECEITA'
                                              ? 'Selecione uma pessoa...'
                                              : 'Selecione um fornecedor...',
                                          icon: Icon(
                                            Icons.keyboard_arrow_down_rounded,
                                            color: FlutterFlowTheme.of(context)
                                                .secondaryText,
                                            size: 24.0,
                                          ),
                                          fillColor:
                                              FlutterFlowTheme.of(context)
                                                  .secondaryBackground,
                                          elevation: 2.0,
                                          borderColor: Colors.transparent,
                                          borderWidth: 0.0,
                                          borderRadius: 8.0,
                                          margin:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  12.0, 0.0, 12.0, 0.0),
                                          hidesUnderline: true,
                                          isOverButton: false,
                                          isSearchable: false,
                                          isMultiSelect: false,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    4.0, 0.0, 0.0, 6.0),
                                child: Text(
                                  'Data Competência',
                                  style: FlutterFlowTheme.of(context)
                                      .labelMedium
                                      .override(
                                        font: GoogleFonts.inter(
                                          fontWeight:
                                              FlutterFlowTheme.of(context)
                                                  .labelMedium
                                                  .fontWeight,
                                          fontStyle:
                                              FlutterFlowTheme.of(context)
                                                  .labelMedium
                                                  .fontStyle,
                                        ),
                                        color: FlutterFlowTheme.of(context)
                                            .secondaryText,
                                        letterSpacing: 0.0,
                                        fontWeight: FlutterFlowTheme.of(context)
                                            .labelMedium
                                            .fontWeight,
                                        fontStyle: FlutterFlowTheme.of(context)
                                            .labelMedium
                                            .fontStyle,
                                      ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    0.0, 0.0, 0.0, 12.0),
                                child: InkWell(
                                  splashColor: Colors.transparent,
                                  focusColor: Colors.transparent,
                                  hoverColor: Colors.transparent,
                                  highlightColor: Colors.transparent,
                                  onTap: () async {
                                    final _datePicked3Date =
                                        await showDatePicker(
                                      context: context,
                                      initialDate: getCurrentTimestamp,
                                      firstDate: DateTime(1900),
                                      lastDate: DateTime(2050),
                                      builder: (context, child) {
                                        return wrapInMaterialDatePickerTheme(
                                          context,
                                          child!,
                                          headerBackgroundColor:
                                              FlutterFlowTheme.of(context)
                                                  .primary,
                                          headerForegroundColor:
                                              FlutterFlowTheme.of(context).info,
                                          headerTextStyle: FlutterFlowTheme.of(
                                                  context)
                                              .headlineLarge
                                              .override(
                                                font: GoogleFonts.interTight(
                                                  fontWeight: FontWeight.w600,
                                                  fontStyle:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .headlineLarge
                                                          .fontStyle,
                                                ),
                                                fontSize: 32.0,
                                                letterSpacing: 0.0,
                                                fontWeight: FontWeight.w600,
                                                fontStyle:
                                                    FlutterFlowTheme.of(context)
                                                        .headlineLarge
                                                        .fontStyle,
                                              ),
                                          pickerBackgroundColor:
                                              FlutterFlowTheme.of(context)
                                                  .secondaryBackground,
                                          pickerForegroundColor:
                                              FlutterFlowTheme.of(context)
                                                  .primaryText,
                                          selectedDateTimeBackgroundColor:
                                              FlutterFlowTheme.of(context)
                                                  .primary,
                                          selectedDateTimeForegroundColor:
                                              FlutterFlowTheme.of(context).info,
                                          actionButtonForegroundColor:
                                              FlutterFlowTheme.of(context)
                                                  .primaryText,
                                          iconSize: 24.0,
                                        );
                                      },
                                    );

                                    if (_datePicked3Date != null) {
                                      safeSetState(() {
                                        _model.datePicked3 = DateTime(
                                          _datePicked3Date.year,
                                          _datePicked3Date.month,
                                          _datePicked3Date.day,
                                        );
                                      });
                                    } else if (_model.datePicked3 != null) {
                                      safeSetState(() {
                                        _model.datePicked3 =
                                            getCurrentTimestamp;
                                      });
                                    }
                                    _model.vDataCompetencia =
                                        _model.datePicked3;
                                    safeSetState(() {});
                                  },
                                  child: Container(
                                    width: double.infinity,
                                    height: 40.0,
                                    decoration: BoxDecoration(
                                      color: FlutterFlowTheme.of(context)
                                          .secondaryBackground,
                                      borderRadius: BorderRadius.circular(8.0),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Padding(
                                          padding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  12.0, 0.0, 12.0, 0.0),
                                          child: Icon(
                                            Icons.edit_calendar_outlined,
                                            color: FlutterFlowTheme.of(context)
                                                .primary,
                                            size: 16.0,
                                          ),
                                        ),
                                        Text(
                                          dateTimeFormat(
                                            "dd/MM/y",
                                            _model.vDataCompetencia,
                                            locale: FFLocalizations.of(context)
                                                .languageCode,
                                          ),
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
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .secondaryText,
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
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    if (_model.choTipoValue != 'TRANSFERENCIA')
                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(
                            4.0, 12.0, 4.0, 12.0),
                        child: FFButtonWidget(
                          onPressed: () async {
                            final selectedMedia =
                                await selectMediaWithSourceBottomSheet(
                              context: context,
                              storageFolderPath: '',
                              maxWidth: 200.00,
                              maxHeight: 200.00,
                              allowPhoto: true,
                            );
                            if (selectedMedia != null &&
                                selectedMedia.every((m) => validateFileFormat(
                                    m.storagePath, context))) {
                              safeSetState(() => _model
                                  .isDataUploading_outComprovanteBS = true);
                              var selectedUploadedFiles = <FFUploadedFile>[];

                              var downloadUrls = <String>[];
                              try {
                                selectedUploadedFiles = selectedMedia
                                    .map((m) => FFUploadedFile(
                                          name: m.storagePath.split('/').last,
                                          bytes: m.bytes,
                                          height: m.dimensions?.height,
                                          width: m.dimensions?.width,
                                          blurHash: m.blurHash,
                                          originalFilename: m.originalFilename,
                                        ))
                                    .toList();

                                downloadUrls = await uploadSupabaseStorageFiles(
                                  bucketName: 'comprovantes',
                                  selectedFiles: selectedMedia,
                                );
                              } finally {
                                _model.isDataUploading_outComprovanteBS = false;
                              }
                              if (selectedUploadedFiles.length ==
                                      selectedMedia.length &&
                                  downloadUrls.length == selectedMedia.length) {
                                safeSetState(() {
                                  _model.uploadedLocalFile_outComprovanteBS =
                                      selectedUploadedFiles.first;
                                  _model.uploadedFileUrl_outComprovanteBS =
                                      downloadUrls.first;
                                });
                              } else {
                                safeSetState(() {});
                                return;
                              }
                            }

                            _model.vUrlComprovante =
                                _model.uploadedFileUrl_outComprovanteBS;
                            safeSetState(() {});
                          },
                          text: 'Anexar Comprovante',
                          icon: Icon(
                            Icons.camera_alt_outlined,
                            size: 24.0,
                          ),
                          options: FFButtonOptions(
                            height: 40.0,
                            padding: EdgeInsets.all(0.0),
                            iconPadding: EdgeInsetsDirectional.fromSTEB(
                                0.0, 0.0, 0.0, 0.0),
                            iconColor: FlutterFlowTheme.of(context).primary,
                            color:
                                FlutterFlowTheme.of(context).primaryBackground,
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
                                  color: FlutterFlowTheme.of(context).primary,
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
                              color: FlutterFlowTheme.of(context).primary,
                            ),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                      ),
                    if ((_model.vUrlComprovante != null &&
                            _model.vUrlComprovante != '') &&
                        (_model.choTipoValue != 'TRANSFERENCIA'))
                      InkWell(
                        splashColor: Colors.transparent,
                        focusColor: Colors.transparent,
                        hoverColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        onTap: () async {
                          await Navigator.push(
                            context,
                            PageTransition(
                              type: PageTransitionType.fade,
                              child: FlutterFlowExpandedImageView(
                                image: Image.network(
                                  _model.vUrlComprovante!,
                                  fit: BoxFit.contain,
                                ),
                                allowRotation: false,
                                tag: _model.vUrlComprovante!,
                                useHeroAnimation: true,
                              ),
                            ),
                          );
                        },
                        child: Hero(
                          tag: _model.vUrlComprovante!,
                          transitionOnUserGestures: true,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8.0),
                            child: Image.network(
                              _model.vUrlComprovante!,
                              width: 200.0,
                              height: 200.0,
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              Align(
                alignment: AlignmentDirectional(0.0, 0.0),
                child: Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(0.0, 8.0, 0.0, 8.0),
                  child: SafeArea(
                    child: Container(
                      decoration: BoxDecoration(
                        color: FlutterFlowTheme.of(context).primaryBackground,
                        borderRadius: BorderRadius.only(),
                      ),
                      alignment: AlignmentDirectional(0.0, 0.0),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Expanded(
                            child: Align(
                              alignment: AlignmentDirectional(0.0, 0.0),
                              child: Builder(
                                builder: (context) => FFButtonWidget(
                                  onPressed: () async {
                                    var _shouldSetState = false;
                                    if (((_model.swtStatusValue == false) &&
                                            (_model.vDataVencimento != null) &&
                                            (_model.ddCategoriaValue != null &&
                                                _model.ddCategoriaValue !=
                                                    '') &&
                                            (_model.vIdContaOrigem == null ||
                                                _model.vIdContaOrigem == '') &&
                                            (_model.vDataPagamento == null) &&
                                            (_model.vValorFormulario! > 0.0) &&
                                            (_model.choTipoValue !=
                                                'TRANSFERENCIA')) ||
                                        ((_model.swtStatusValue == true) &&
                                            (_model.vDataVencimento != null) &&
                                            (_model.ddCategoriaValue != null &&
                                                _model.ddCategoriaValue !=
                                                    '') &&
                                            (_model.ddContaOrigemValue !=
                                                    null &&
                                                _model.ddContaOrigemValue !=
                                                    '') &&
                                            () {
                                              if ((_model.vTipoConta ==
                                                      'CARTAO') &&
                                                  (_model.vDataPagamento ==
                                                      null)) {
                                                return true;
                                              } else if ((_model
                                                          .vDataPagamento !=
                                                      null) &&
                                                  (_model.vTipoConta !=
                                                      'CARTAO')) {
                                                return true;
                                              } else {
                                                return false;
                                              }
                                            }() &&
                                            (_model.choTipoValue !=
                                                'TRANSFERENCIA')) ||
                                        ((_model.choTipoValue ==
                                                'TRANSFERENCIA') &&
                                            (_model.vValorFormulario! > 0.0) &&
                                            (_model.ddContaOrigemValue !=
                                                    null &&
                                                _model.ddContaOrigemValue !=
                                                    '') &&
                                            (_model.ddContaDestinoValue !=
                                                    null &&
                                                _model.ddContaDestinoValue !=
                                                    '') &&
                                            (_model.ddCategoriaValue == null ||
                                                _model.ddCategoriaValue ==
                                                    '') &&
                                            (_model.vDataPagamento != null) &&
                                            (_model.vDataVencimento != null) &&
                                            (_model.vDataCompetencia !=
                                                null))) {
                                      if (_model.vIdTransacao == null ||
                                          _model.vIdTransacao == '') {
                                        _model.retStatusInsert =
                                            await TransacoesTable().insert({
                                          'valor': _model.vValorFormulario,
                                          'descricao': valueOrDefault<String>(
                                            () {
                                              if (_model.choTipoValue ==
                                                  'TRANSFERENCIA') {
                                                return '*';
                                              } else if (_model.inputDescricaoTextController
                                                          .text ==
                                                      '') {
                                                return _model
                                                    .vDescricaoCategoria;
                                              } else {
                                                return _model
                                                    .inputDescricaoTextController
                                                    .text;
                                              }
                                            }(),
                                            'Sem descrição',
                                          ),
                                          'plano_contas_id':
                                              _model.choTipoValue ==
                                                      'TRANSFERENCIA'
                                                  ? null
                                                  : _model.ddCategoriaValue,
                                          'status':
                                              (_model.swtStatusValue == true) ||
                                                      (_model.choTipoValue ==
                                                          'TRANSFERENCIA')
                                                  ? 'CONCILIADO'
                                                  : 'PENDENTE',
                                          'conta_bancaria_id':
                                              (_model.swtStatusValue == true) ||
                                                      (_model.choTipoValue ==
                                                          'TRANSFERENCIA')
                                                  ? _model.ddContaOrigemValue
                                                  : null,
                                          'centro_custo_id':
                                              _model.ddCentroDeCustoValue,
                                          'membro_id': _model.ddMembroValue,
                                          'comprovativo_url':
                                              _model.vUrlComprovante,
                                          'data_vencimento':
                                              supaSerialize<DateTime>(
                                                  _model.vDataVencimento),
                                          'data_competencia':
                                              supaSerialize<DateTime>(_model
                                                          .choTipoValue ==
                                                      'TRANSFERENCIA'
                                                  ? _model.vDataVencimento
                                                  : _model.vDataCompetencia),
                                          'organization_id': FFAppState()
                                              .currentOrganizationId,
                                          'tipo_operacao':
                                              _model.choTipoValue == 'RECEITA'
                                                  ? 'CREDITO'
                                                  : (_model.choTipoValue ==
                                                          'DESPESA'
                                                      ? 'DEBITO'
                                                      : 'TRANSFERENCIA'),
                                          'conta_destino_id':
                                              _model.choTipoValue ==
                                                      'TRANSFERENCIA'
                                                  ? _model.ddContaDestinoValue
                                                  : null,
                                          'data_pagamento':
                                              supaSerialize<DateTime>(() {
                                            if (_model.choTipoValue ==
                                                'TRANSFERENCIA') {
                                              return _model.vDataVencimento;
                                            } else if ((_model.swtStatusValue ==
                                                    true) &&
                                                (_model.vTipoConta !=
                                                    'CARTAO')) {
                                              return _model.vDataPagamento;
                                            } else if ((_model.swtStatusValue ==
                                                    true) &&
                                                (_model.vTipoConta ==
                                                    'CARTAO')) {
                                              return null;
                                            } else {
                                              return null;
                                            }
                                          }()),
                                        });
                                        _shouldSetState = true;
                                        if (_model.retStatusInsert != null) {
                                          await showDialog(
                                            context: context,
                                            builder: (dialogContext) {
                                              return Dialog(
                                                elevation: 0,
                                                insetPadding: EdgeInsets.zero,
                                                backgroundColor:
                                                    Colors.transparent,
                                                alignment: AlignmentDirectional(
                                                        -1.0, 0.0)
                                                    .resolve(Directionality.of(
                                                        context)),
                                                child: BsTopNotificacoesWidget(
                                                  pTipo: 'SUCESSO',
                                                  pMensagem:
                                                      'Lançamento realizado com sucesso!',
                                                ),
                                              );
                                            },
                                          );

                                          Navigator.pop(context);
                                          if (_shouldSetState)
                                            safeSetState(() {});
                                          return;
                                        } else {
                                          await showDialog(
                                            context: context,
                                            builder: (dialogContext) {
                                              return Dialog(
                                                elevation: 0,
                                                insetPadding: EdgeInsets.zero,
                                                backgroundColor:
                                                    Colors.transparent,
                                                alignment: AlignmentDirectional(
                                                        -1.0, 0.0)
                                                    .resolve(Directionality.of(
                                                        context)),
                                                child: BsTopNotificacoesWidget(
                                                  pTipo: 'ERRO',
                                                  pMensagem:
                                                      'Falha ao tentar gravar o lançamento!',
                                                ),
                                              );
                                            },
                                          );

                                          if (_shouldSetState)
                                            safeSetState(() {});
                                          return;
                                        }
                                      } else {
                                        _model.retStatusUpdate =
                                            await TransacoesTable().update(
                                          data: {
                                            'valor': _model.vValorFormulario,
                                            'descricao': _model.inputDescricaoTextController
                                                            .text ==
                                                        ''
                                                ? _model.vDescricaoCategoria
                                                : _model
                                                    .inputDescricaoTextController
                                                    .text,
                                            'plano_contas_id':
                                                _model.choTipoValue ==
                                                        'TRANSFERENCIA'
                                                    ? null
                                                    : _model.ddCategoriaValue,
                                            'status':
                                                _model.swtStatusValue == true
                                                    ? 'CONCILIADO'
                                                    : 'PENDENTE',
                                            'conta_bancaria_id':
                                                (_model.swtStatusValue ==
                                                            true) ||
                                                        (_model.choTipoValue ==
                                                            'TRANSFERENCIA')
                                                    ? _model.ddContaOrigemValue
                                                    : null,
                                            'centro_custo_id':
                                                _model.ddCentroDeCustoValue,
                                            'membro_id': _model.ddMembroValue !=
                                                        null &&
                                                    _model.ddMembroValue != ''
                                                ? _model.ddMembroValue
                                                : null,
                                            'comprovativo_url':
                                                _model.vUrlComprovante,
                                            'data_vencimento':
                                                supaSerialize<DateTime>(
                                                    _model.vDataVencimento),
                                            'data_competencia':
                                                supaSerialize<DateTime>(_model
                                                            .choTipoValue ==
                                                        'TRANSFERENCIA'
                                                    ? _model.vDataVencimento
                                                    : _model.vDataCompetencia),
                                            'organization_id': FFAppState()
                                                .currentOrganizationId,
                                            'tipo_operacao':
                                                _model.choTipoValue == 'RECEITA'
                                                    ? 'CREDITO'
                                                    : (_model.choTipoValue ==
                                                            'DESPESA'
                                                        ? 'DEBITO'
                                                        : 'TRANSFERENCIA'),
                                            'conta_destino_id':
                                                _model.choTipoValue ==
                                                        'TRANSFERENCIA'
                                                    ? _model.ddContaDestinoValue
                                                    : null,
                                            'data_pagamento':
                                                supaSerialize<DateTime>(() {
                                              if (_model.choTipoValue ==
                                                  'TRANSFERENCIA') {
                                                return _model.vDataVencimento;
                                              } else if ((_model.swtStatusValue ==
                                                      true) &&
                                                  (_model.vTipoConta !=
                                                      'CARTAO')) {
                                                return _model.vDataPagamento;
                                              } else if ((_model.swtStatusValue ==
                                                      true) &&
                                                  (_model.vTipoConta ==
                                                      'CARTAO') &&
                                                  (_model.vDataPagamento ==
                                                      null)) {
                                                return null;
                                              } else if ((_model
                                                          .swtStatusValue ==
                                                      true) &&
                                                  (_model.vTipoConta ==
                                                      'CARTAO') &&
                                                  (_model.vDataPagamento !=
                                                      null)) {
                                                return _model.vDataPagamento;
                                              } else {
                                                return null;
                                              }
                                            }()),
                                          },
                                          matchingRows: (rows) => rows
                                              .eqOrNull(
                                                'id',
                                                widget.pIdTransacao,
                                              )
                                              .eqOrNull(
                                                'organization_id',
                                                FFAppState()
                                                    .currentOrganizationId,
                                              ),
                                          returnRows: true,
                                        );
                                        _shouldSetState = true;
                                        if ((_model.retStatusUpdate != null &&
                                                (_model.retStatusUpdate)!
                                                    .isNotEmpty) ==
                                            true) {
                                          await showDialog(
                                            context: context,
                                            builder: (dialogContext) {
                                              return Dialog(
                                                elevation: 0,
                                                insetPadding: EdgeInsets.zero,
                                                backgroundColor:
                                                    Colors.transparent,
                                                alignment: AlignmentDirectional(
                                                        -1.0, 0.0)
                                                    .resolve(Directionality.of(
                                                        context)),
                                                child: BsTopNotificacoesWidget(
                                                  pTipo: 'SUCESSO',
                                                  pMensagem:
                                                      'Lançamento realizado com sucesso!',
                                                ),
                                              );
                                            },
                                          );

                                          Navigator.pop(context);
                                          if (_shouldSetState)
                                            safeSetState(() {});
                                          return;
                                        } else {
                                          await showDialog(
                                            context: context,
                                            builder: (dialogContext) {
                                              return Dialog(
                                                elevation: 0,
                                                insetPadding: EdgeInsets.zero,
                                                backgroundColor:
                                                    Colors.transparent,
                                                alignment: AlignmentDirectional(
                                                        -1.0, 0.0)
                                                    .resolve(Directionality.of(
                                                        context)),
                                                child: BsTopNotificacoesWidget(
                                                  pTipo: 'ERRO',
                                                  pMensagem:
                                                      'Falha ao salvar os dados!',
                                                ),
                                              );
                                            },
                                          );

                                          if (_shouldSetState)
                                            safeSetState(() {});
                                          return;
                                        }
                                      }
                                    } else {
                                      if (widget.pIdTransacao != null &&
                                          widget.pIdTransacao != '') {
                                        await showDialog(
                                          context: context,
                                          builder: (dialogContext) {
                                            return Dialog(
                                              elevation: 0,
                                              insetPadding: EdgeInsets.zero,
                                              backgroundColor:
                                                  Colors.transparent,
                                              alignment: AlignmentDirectional(
                                                      -1.0, 0.0)
                                                  .resolve(Directionality.of(
                                                      context)),
                                              child: BsTopNotificacoesWidget(
                                                pTipo: 'ERRO',
                                                pMensagem:
                                                    'Erro ao salvar alterações. Verifique se os campos permanecem válidos.',
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
                                              backgroundColor:
                                                  Colors.transparent,
                                              alignment: AlignmentDirectional(
                                                      -1.0, 0.0)
                                                  .resolve(Directionality.of(
                                                      context)),
                                              child: BsTopNotificacoesWidget(
                                                pTipo: 'ERRO',
                                                pMensagem:
                                                    'Erro ao criar transação. Verifique os dados informados.',
                                              ),
                                            );
                                          },
                                        );
                                      }

                                      if (_shouldSetState) safeSetState(() {});
                                      return;
                                    }

                                    if (_shouldSetState) safeSetState(() {});
                                  },
                                  text: 'SALVAR',
                                  icon: Icon(
                                    Icons.save,
                                    size: 15.0,
                                  ),
                                  options: FFButtonOptions(
                                    width: double.infinity,
                                    height: 50.0,
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        0.0, 0.0, 0.0, 0.0),
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
                                          color: FlutterFlowTheme.of(context)
                                              .primaryText,
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
                                    borderSide: BorderSide(
                                      width: 1.0,
                                    ),
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          if (widget.pIdTransacao != null &&
                              widget.pIdTransacao != '')
                            Expanded(
                              child: Align(
                                alignment: AlignmentDirectional(0.0, 0.0),
                                child: Builder(
                                  builder: (context) => Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        8.0, 0.0, 0.0, 0.0),
                                    child: FFButtonWidget(
                                      onPressed: () async {
                                        var confirmDialogResponse =
                                            await showDialog<bool>(
                                                  context: context,
                                                  builder:
                                                      (alertDialogContext) {
                                                    return AlertDialog(
                                                      title: Text('Atenção'),
                                                      content: Text(
                                                          'Confirma a exclusão deste lançamento?'),
                                                      actions: [
                                                        TextButton(
                                                          onPressed: () =>
                                                              Navigator.pop(
                                                                  alertDialogContext,
                                                                  false),
                                                          child:
                                                              Text('Cancelar'),
                                                        ),
                                                        TextButton(
                                                          onPressed: () =>
                                                              Navigator.pop(
                                                                  alertDialogContext,
                                                                  true),
                                                          child:
                                                              Text('Confirmar'),
                                                        ),
                                                      ],
                                                    );
                                                  },
                                                ) ??
                                                false;
                                        if (confirmDialogResponse) {
                                          await TransacoesTable().delete(
                                            matchingRows: (rows) => rows
                                                .eqOrNull(
                                                  'organization_id',
                                                  FFAppState()
                                                      .currentOrganizationId,
                                                )
                                                .eqOrNull(
                                                  'id',
                                                  widget.pIdTransacao,
                                                ),
                                          );
                                        } else {
                                          return;
                                        }

                                        await showDialog(
                                          context: context,
                                          builder: (dialogContext) {
                                            return Dialog(
                                              elevation: 0,
                                              insetPadding: EdgeInsets.zero,
                                              backgroundColor:
                                                  Colors.transparent,
                                              alignment: AlignmentDirectional(
                                                      -1.0, 0.0)
                                                  .resolve(Directionality.of(
                                                      context)),
                                              child: BsTopNotificacoesWidget(
                                                pTipo: 'SUCESSO',
                                                pMensagem:
                                                    'Lançamento excluído com sucesso!',
                                              ),
                                            );
                                          },
                                        );

                                        Navigator.pop(context);
                                      },
                                      text: 'Excluir',
                                      icon: Icon(
                                        Icons.delete,
                                        size: 15.0,
                                      ),
                                      options: FFButtonOptions(
                                        width: double.infinity,
                                        height: 50.0,
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                            0.0, 0.0, 0.0, 0.0),
                                        iconPadding:
                                            EdgeInsetsDirectional.fromSTEB(
                                                0.0, 0.0, 0.0, 0.0),
                                        color: FlutterFlowTheme.of(context)
                                            .primaryBackground,
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
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .error,
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
                                        borderSide: BorderSide(
                                          color: FlutterFlowTheme.of(context)
                                              .error,
                                          width: 1.0,
                                        ),
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                      ),
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
            ].addToStart(SizedBox(height: 10.0)),
          ),
        ),
      ),
    );
  }
}
