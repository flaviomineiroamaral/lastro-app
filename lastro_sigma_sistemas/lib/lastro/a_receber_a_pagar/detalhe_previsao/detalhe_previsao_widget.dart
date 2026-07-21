import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_choice_chips.dart';
import '/flutter_flow/flutter_flow_count_controller.dart';
import '/flutter_flow/flutter_flow_drop_down.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/flutter_flow/form_field_controller.dart';
import '/flutter_flow/upload_data.dart';
import '/lastro/geral/bs_top_notificacoes/bs_top_notificacoes_widget.dart';
import '/custom_code/actions/index.dart' as actions;
import '/custom_code/widgets/index.dart' as custom_widgets;
import '/flutter_flow/custom_functions.dart' as functions;
import '/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'detalhe_previsao_model.dart';
export 'detalhe_previsao_model.dart';

class DetalhePrevisaoWidget extends StatefulWidget {
  const DetalhePrevisaoWidget({
    super.key,
    required this.pIdAgendamento,
    this.pViewAgendamento,
  });

  final String? pIdAgendamento;
  final VwAgendamentosRow? pViewAgendamento;

  static String routeName = 'DetalhePrevisao';
  static String routePath = '/DetalhePrevisao';

  @override
  State<DetalhePrevisaoWidget> createState() => _DetalhePrevisaoWidgetState();
}

class _DetalhePrevisaoWidgetState extends State<DetalhePrevisaoWidget> {
  late DetalhePrevisaoModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => DetalhePrevisaoModel());

    // On page load action.
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      if (widget.pIdAgendamento == null || widget.pIdAgendamento == '') {
        _model.vDataPagamento = null;
        _model.vDataVencimento = getCurrentTimestamp;
        _model.vDataCompetencia = getCurrentTimestamp;
        _model.vIdCentroCusto = null;
        _model.vUrlComprovante = null;
        _model.mostrarAvancadas = false;
        _model.vDescricaoCategoria = null;
        _model.vIdCategoria = null;
        _model.vIdContaOrigem = null;
        _model.vIdMembro = null;
        _model.vDescricao = null;
        _model.vValorFormulario = 0.0;
        _model.vTipoOperacao = 'A Pagar';
        _model.vStatus = false;
        _model.vIdTransacao = null;
        safeSetState(() {});
        safeSetState(() {
          _model.choTipoValueController?.value = [_model.vTipoOperacao];
        });
      } else {
        _model.vUrlComprovante = widget.pViewAgendamento?.comprovativoUrl;
        _model.vDataPagamento = widget.pViewAgendamento?.dataPagamento;
        _model.vDataVencimento = widget.pViewAgendamento?.dataVencimento;
        _model.vDataCompetencia = widget.pViewAgendamento?.dataCompetencia;
        _model.vIdCategoria = widget.pViewAgendamento?.categoriaId;
        _model.vIdContaOrigem = widget.pViewAgendamento?.contaId;
        _model.vIdCentroCusto = widget.pViewAgendamento?.centroCustoId;
        _model.vIdMembro = widget.pViewAgendamento?.membroId;
        _model.vDescricao = widget.pViewAgendamento?.descricao;
        _model.vValorFormulario = widget.pViewAgendamento!.valor!;
        _model.vStatus = widget.pViewAgendamento?.status != 'PENDENTE';
        _model.vTipoOperacao =
            widget.pViewAgendamento?.tipoOperacao == 'CREDITO'
                ? 'A Receber'
                : 'A Pagar';
        _model.vIdTransacao = widget.pViewAgendamento?.transacaoId;
        _model.mostrarAvancadas = false;
        _model.vDescricaoCategoria = null;
        safeSetState(() {});
        _model.inputDescricaoTextController?.text = _model.vDescricao!;

        _model.choTipoValueController?.value = [_model.vTipoOperacao];
        _model.ddCategoriaValueController?.value = _model.vIdCategoria!;
        _model.ddCategoriaValue = _model.vIdCategoria!;
        _model.ddContaOrigemValueController?.value =
            (_model.vIdContaOrigem != null && _model.vIdContaOrigem != ''
                ? _model.vIdCategoria!
                : '');
        _model.ddContaOrigemValue =
            (_model.vIdContaOrigem != null && _model.vIdContaOrigem != ''
                ? _model.vIdCategoria!
                : '');
        _model.ddCentroDeCustoValueController?.value = _model.vIdCentroCusto!;
        _model.ddCentroDeCustoValue = _model.vIdCentroCusto!;
        _model.ddMembroValueController?.value = _model.vIdMembro!;
        _model.ddMembroValue = _model.vIdMembro!;
      }
    });

    _model.inputDescricaoTextController ??=
        TextEditingController(text: _model.vDescricao);
    _model.inputDescricaoFocusNode ??= FocusNode();

    _model.swtRecorrenteValue = _model.vStatus!;
    _model.swtManterCompFixaValue = _model.vStatus!;
    _model.swtStatusValue = _model.vStatus!;
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
        title: 'DetalhePrevisao',
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
                  widget.pIdAgendamento == null || widget.pIdAgendamento == ''
                      ? 'Novo Agendamento'
                      : 'Editar Agendamento',
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
                    alignment: AlignmentDirectional(0.0, -1.0),
                    child: Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(
                          20.0, 20.0, 20.0, 20.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(
                                0.0, 0.0, 0.0, 12.0),
                            child: FlutterFlowChoiceChips(
                              options: [
                                ChipData('A Receber'),
                                ChipData('A Pagar')
                              ],
                              onChanged: (widget.pIdAgendamento != null &&
                                      widget.pIdAgendamento != '')
                                  ? null
                                  : (val) => safeSetState(() =>
                                      _model.choTipoValue = val?.firstOrNull),
                              selectedChipStyle: ChipStyle(
                                backgroundColor:
                                    FlutterFlowTheme.of(context).primary,
                                textStyle: FlutterFlowTheme.of(context)
                                    .bodyMedium
                                    .override(
                                      font: GoogleFonts.inter(
                                        fontWeight: FontWeight.w600,
                                        fontStyle: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .fontStyle,
                                      ),
                                      color: FlutterFlowTheme.of(context)
                                          .primaryText,
                                      letterSpacing: 0.0,
                                      fontWeight: FontWeight.w600,
                                      fontStyle: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .fontStyle,
                                    ),
                                iconColor:
                                    FlutterFlowTheme.of(context).alternate,
                                iconSize: 16.0,
                                elevation: 0.0,
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              unselectedChipStyle: ChipStyle(
                                backgroundColor: FlutterFlowTheme.of(context)
                                    .secondaryBackground,
                                textStyle: FlutterFlowTheme.of(context)
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
                                          .primaryText,
                                      letterSpacing: 0.0,
                                      fontWeight: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .fontWeight,
                                      fontStyle: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .fontStyle,
                                    ),
                                iconColor:
                                    FlutterFlowTheme.of(context).secondaryText,
                                iconSize: 16.0,
                                elevation: 2.0,
                                borderColor:
                                    FlutterFlowTheme.of(context).alternate,
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
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      4.0, 0.0, 0.0, 6.0),
                                  child: Text(
                                    'Valor (R\$)',
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
                                Container(
                                  width: 100.0,
                                  height: 60.0,
                                  child: custom_widgets.CampoMoedaNubank(
                                    width: 100.0,
                                    height: 60.0,
                                    tamanhoFonte: 24.0,
                                    corTexto: FlutterFlowTheme.of(context)
                                        .primaryText,
                                    corFundo: FlutterFlowTheme.of(context)
                                        .secondaryBackground,
                                    corBorda: FlutterFlowTheme.of(context)
                                        .secondaryBackground,
                                    arredondamento: 8.0,
                                    centralizarTexto: false,
                                    valorInicial:
                                        widget.pIdAgendamento != null &&
                                                widget.pIdAgendamento != ''
                                            ? widget.pViewAgendamento?.valor
                                            : _model.vValorFormulario,
                                    acaoAoMudar: (valorDigitado) async {
                                      _model.vValorFormulario = valorDigitado;
                                      safeSetState(() {});
                                    },
                                  ),
                                ),
                                if (_model.choTipoValue != 'TRANSFERENCIA')
                                  Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        4.0, 0.0, 0.0, 6.0),
                                    child: Text(
                                      'Descrição do Lançamento',
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
                                  child: Container(
                                    width: 200.0,
                                    child: TextFormField(
                                      controller:
                                          _model.inputDescricaoTextController,
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
                                                fontWeight:
                                                    FlutterFlowTheme.of(context)
                                                        .labelMedium
                                                        .fontWeight,
                                                fontStyle:
                                                    FlutterFlowTheme.of(context)
                                                        .labelMedium
                                                        .fontStyle,
                                              ),
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
                                        alignLabelWithHint: true,
                                        hintText: () {
                                          if (FFAppState()
                                                  .currentOrganizationType ==
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
                                                fontWeight:
                                                    FlutterFlowTheme.of(context)
                                                        .labelMedium
                                                        .fontWeight,
                                                fontStyle:
                                                    FlutterFlowTheme.of(context)
                                                        .labelMedium
                                                        .fontStyle,
                                              ),
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
                                        enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Color(0x00000000),
                                            width: 1.0,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(8.0),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Color(0x00000000),
                                            width: 1.0,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(8.0),
                                        ),
                                        errorBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: FlutterFlowTheme.of(context)
                                                .error,
                                            width: 1.0,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(8.0),
                                        ),
                                        focusedErrorBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: FlutterFlowTheme.of(context)
                                                .error,
                                            width: 1.0,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(8.0),
                                        ),
                                        filled: true,
                                        fillColor: FlutterFlowTheme.of(context)
                                            .secondaryBackground,
                                        prefixIcon: Icon(
                                          Icons.description_outlined,
                                          color: FlutterFlowTheme.of(context)
                                              .primary,
                                        ),
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
                                      cursorColor: FlutterFlowTheme.of(context)
                                          .primaryText,
                                      enableInteractiveSelection: true,
                                      validator: _model
                                          .inputDescricaoTextControllerValidator
                                          .asValidator(context),
                                    ),
                                  ),
                                ),
                                if (_model.choTipoValue != 'TRANSFERENCIA')
                                  Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        4.0, 0.0, 0.0, 6.0),
                                    child: Text(
                                      'Categoria',
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        child: FlutterFlowDropDown<String>(
                                          controller: _model
                                                  .ddCategoriaValueController ??=
                                              FormFieldController<String>(
                                            _model.ddCategoriaValue ??=
                                                _model.vIdCategoria,
                                          ),
                                          options: List<String>.from(FFAppState()
                                              .cachePlanoContas
                                              .where((e) =>
                                                  (e.permiteLancamento ==
                                                      true) &&
                                                  (e.naturezaFluxo ==
                                                      (_model.choTipoValue ==
                                                              'A Receber'
                                                          ? 'ENTRADA'
                                                          : 'SAIDA')))
                                              .toList()
                                              .map((e) => e.id)
                                              .toList()),
                                          optionLabels: functions
                                              .formatarDropdownContas(FFAppState()
                                                  .cachePlanoContas
                                                  .where((e) =>
                                                      (e.permiteLancamento ==
                                                          true) &&
                                                      (e.naturezaFluxo ==
                                                          (_model.choTipoValue ==
                                                                  'A Receber'
                                                              ? 'ENTRADA'
                                                              : 'SAIDA')))
                                                  .toList()),
                                          onChanged: (val) async {
                                            safeSetState(() =>
                                                _model.ddCategoriaValue = val);
                                            _model.vDescricaoCategoria =
                                                FFAppState()
                                                    .cachePlanoContas
                                                    .where((e) =>
                                                        e.id ==
                                                        _model.ddCategoriaValue)
                                                    .toList()
                                                    .firstOrNull
                                                    ?.nome;
                                            _model.vIdCategoria =
                                                _model.ddCategoriaValue;
                                            safeSetState(() {});
                                          },
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
                                          hintText: 'Selecione a categoria...',
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
                                          borderColor:
                                              FlutterFlowTheme.of(context)
                                                  .accent3,
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
                                Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      4.0, 0.0, 0.0, 6.0),
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
                                  child: InkWell(
                                    splashColor: Colors.transparent,
                                    focusColor: Colors.transparent,
                                    hoverColor: Colors.transparent,
                                    highlightColor: Colors.transparent,
                                    onTap: () async {
                                      final _datePicked1Date =
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
                                                FlutterFlowTheme.of(context)
                                                    .info,
                                            headerTextStyle: FlutterFlowTheme
                                                    .of(context)
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
                                                      FlutterFlowTheme.of(
                                                              context)
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
                                                FlutterFlowTheme.of(context)
                                                    .info,
                                            actionButtonForegroundColor:
                                                FlutterFlowTheme.of(context)
                                                    .primaryText,
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
                                          _model.datePicked1 =
                                              getCurrentTimestamp;
                                        });
                                      }
                                      _model.vDataVencimento =
                                          _model.datePicked1;
                                      safeSetState(() {});
                                    },
                                    child: Container(
                                      width: double.infinity,
                                      height: 40.0,
                                      decoration: BoxDecoration(
                                        color: FlutterFlowTheme.of(context)
                                            .secondaryBackground,
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Padding(
                                            padding:
                                                EdgeInsetsDirectional.fromSTEB(
                                                    12.0, 0.0, 12.0, 0.0),
                                            child: Icon(
                                              Icons.edit_calendar_outlined,
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .primary,
                                              size: 16.0,
                                            ),
                                          ),
                                          Expanded(
                                            child: Text(
                                              _model.vDataVencimento != null
                                                  ? dateTimeFormat(
                                                      "dd/MM/y",
                                                      _model.vDataVencimento,
                                                      locale:
                                                          FFLocalizations.of(
                                                                  context)
                                                              .languageCode,
                                                    )
                                                  : '',
                                              style:
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
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          4.0, 0.0, 8.0, 6.0),
                                      child: Text(
                                        'Repetir este lançamento?',
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
                                              color:
                                                  FlutterFlowTheme.of(context)
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
                                    Switch.adaptive(
                                      value: _model.swtRecorrenteValue!,
                                      onChanged: ((_model.vTipoOperacao ==
                                                  'TRANSFERENCIA') &&
                                              (_model.vIdTransacao != null &&
                                                  _model.vIdTransacao != ''))
                                          ? null
                                          : (newValue) async {
                                              safeSetState(() =>
                                                  _model.swtRecorrenteValue =
                                                      newValue);
                                            },
                                      activeColor: ((_model.vTipoOperacao ==
                                                  'TRANSFERENCIA') &&
                                              (_model.vIdTransacao != null &&
                                                  _model.vIdTransacao != ''))
                                          ? FlutterFlowTheme.of(context).primary
                                          : FlutterFlowTheme.of(context)
                                              .primary,
                                      activeTrackColor: ((_model
                                                      .vTipoOperacao ==
                                                  'TRANSFERENCIA') &&
                                              (_model.vIdTransacao != null &&
                                                  _model.vIdTransacao != ''))
                                          ? FlutterFlowTheme.of(context)
                                              .secondaryBackground
                                          : FlutterFlowTheme.of(context)
                                              .fundoText,
                                      inactiveTrackColor: ((_model
                                                      .vTipoOperacao ==
                                                  'TRANSFERENCIA') &&
                                              (_model.vIdTransacao != null &&
                                                  _model.vIdTransacao != ''))
                                          ? FlutterFlowTheme.of(context).primary
                                          : FlutterFlowTheme.of(context)
                                              .primary,
                                      inactiveThumbColor: ((_model
                                                      .vTipoOperacao ==
                                                  'TRANSFERENCIA') &&
                                              (_model.vIdTransacao != null &&
                                                  _model.vIdTransacao != ''))
                                          ? FlutterFlowTheme.of(context)
                                              .secondaryBackground
                                          : FlutterFlowTheme.of(context)
                                              .fundoText,
                                    ),
                                  ],
                                ),
                                if (widget.pIdAgendamento == null ||
                                    widget.pIdAgendamento == '')
                                  Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      if (_model.swtRecorrenteValue == true)
                                        Column(
                                          mainAxisSize: MainAxisSize.min,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.stretch,
                                          children: [
                                            Row(
                                              mainAxisSize: MainAxisSize.min,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Column(
                                                  mainAxisSize:
                                                      MainAxisSize.max,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Padding(
                                                      padding:
                                                          EdgeInsetsDirectional
                                                              .fromSTEB(
                                                                  4.0,
                                                                  0.0,
                                                                  8.0,
                                                                  6.0),
                                                      child: Text(
                                                        'Tipo de Recorrência',
                                                        style:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .labelMedium
                                                                .override(
                                                                  font:
                                                                      GoogleFonts
                                                                          .inter(
                                                                    fontWeight: FlutterFlowTheme.of(
                                                                            context)
                                                                        .labelMedium
                                                                        .fontWeight,
                                                                    fontStyle: FlutterFlowTheme.of(
                                                                            context)
                                                                        .labelMedium
                                                                        .fontStyle,
                                                                  ),
                                                                  color: FlutterFlowTheme.of(
                                                                          context)
                                                                      .secondaryText,
                                                                  letterSpacing:
                                                                      0.0,
                                                                  fontWeight: FlutterFlowTheme.of(
                                                                          context)
                                                                      .labelMedium
                                                                      .fontWeight,
                                                                  fontStyle: FlutterFlowTheme.of(
                                                                          context)
                                                                      .labelMedium
                                                                      .fontStyle,
                                                                ),
                                                      ),
                                                    ),
                                                    Align(
                                                      alignment:
                                                          AlignmentDirectional(
                                                              -1.0, 0.0),
                                                      child: Padding(
                                                        padding:
                                                            EdgeInsetsDirectional
                                                                .fromSTEB(
                                                                    0.0,
                                                                    0.0,
                                                                    0.0,
                                                                    12.0),
                                                        child:
                                                            FlutterFlowChoiceChips(
                                                          options: [
                                                            ChipData('Fixo'),
                                                            ChipData(
                                                                'Parcelado')
                                                          ],
                                                          onChanged: (val) =>
                                                              safeSetState(() =>
                                                                  _model.chipTipoRecorrenciaValue =
                                                                      val?.firstOrNull),
                                                          selectedChipStyle:
                                                              ChipStyle(
                                                            backgroundColor:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .primary,
                                                            textStyle:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyMedium
                                                                    .override(
                                                                      font: GoogleFonts
                                                                          .inter(
                                                                        fontWeight:
                                                                            FontWeight.w600,
                                                                        fontStyle: FlutterFlowTheme.of(context)
                                                                            .bodyMedium
                                                                            .fontStyle,
                                                                      ),
                                                                      color: FlutterFlowTheme.of(
                                                                              context)
                                                                          .primaryText,
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
                                                            iconColor:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .alternate,
                                                            iconSize: 16.0,
                                                            elevation: 0.0,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        8.0),
                                                          ),
                                                          unselectedChipStyle:
                                                              ChipStyle(
                                                            backgroundColor:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .secondaryBackground,
                                                            textStyle:
                                                                FlutterFlowTheme.of(
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
                                                                      color: FlutterFlowTheme.of(
                                                                              context)
                                                                          .primaryText,
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
                                                            iconColor:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .secondaryText,
                                                            iconSize: 16.0,
                                                            elevation: 2.0,
                                                            borderColor:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .alternate,
                                                            borderWidth: 1.0,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        8.0),
                                                          ),
                                                          chipSpacing: 8.0,
                                                          rowSpacing: 8.0,
                                                          multiselect: false,
                                                          initialized: _model
                                                                  .chipTipoRecorrenciaValue !=
                                                              null,
                                                          alignment:
                                                              WrapAlignment
                                                                  .start,
                                                          controller: _model
                                                                  .chipTipoRecorrenciaValueController ??=
                                                              FormFieldController<
                                                                  List<String>>(
                                                            ['Fixo'],
                                                          ),
                                                          wrapped: false,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                if (_model
                                                        .chipTipoRecorrenciaValue ==
                                                    'Parcelado')
                                                  Padding(
                                                    padding:
                                                        EdgeInsetsDirectional
                                                            .fromSTEB(24.0, 0.0,
                                                                0.0, 0.0),
                                                    child: Column(
                                                      mainAxisSize:
                                                          MainAxisSize.max,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Padding(
                                                          padding:
                                                              EdgeInsetsDirectional
                                                                  .fromSTEB(
                                                                      4.0,
                                                                      0.0,
                                                                      8.0,
                                                                      6.0),
                                                          child: Text(
                                                            'Quantos meses?',
                                                            style: FlutterFlowTheme
                                                                    .of(context)
                                                                .labelMedium
                                                                .override(
                                                                  font:
                                                                      GoogleFonts
                                                                          .inter(
                                                                    fontWeight: FlutterFlowTheme.of(
                                                                            context)
                                                                        .labelMedium
                                                                        .fontWeight,
                                                                    fontStyle: FlutterFlowTheme.of(
                                                                            context)
                                                                        .labelMedium
                                                                        .fontStyle,
                                                                  ),
                                                                  color: FlutterFlowTheme.of(
                                                                          context)
                                                                      .secondaryText,
                                                                  letterSpacing:
                                                                      0.0,
                                                                  fontWeight: FlutterFlowTheme.of(
                                                                          context)
                                                                      .labelMedium
                                                                      .fontWeight,
                                                                  fontStyle: FlutterFlowTheme.of(
                                                                          context)
                                                                      .labelMedium
                                                                      .fontStyle,
                                                                ),
                                                          ),
                                                        ),
                                                        Container(
                                                          width: 100.0,
                                                          height: 30.0,
                                                          decoration:
                                                              BoxDecoration(
                                                            color: FlutterFlowTheme
                                                                    .of(context)
                                                                .secondaryBackground,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        8.0),
                                                            shape: BoxShape
                                                                .rectangle,
                                                          ),
                                                          child:
                                                              FlutterFlowCountController(
                                                            decrementIconBuilder:
                                                                (enabled) =>
                                                                    Icon(
                                                              Icons
                                                                  .remove_rounded,
                                                              color: enabled
                                                                  ? FlutterFlowTheme.of(
                                                                          context)
                                                                      .secondaryText
                                                                  : FlutterFlowTheme.of(
                                                                          context)
                                                                      .secondaryText,
                                                              size: 16.0,
                                                            ),
                                                            incrementIconBuilder:
                                                                (enabled) =>
                                                                    Icon(
                                                              Icons.add_rounded,
                                                              color: enabled
                                                                  ? FlutterFlowTheme.of(
                                                                          context)
                                                                      .primary
                                                                  : FlutterFlowTheme.of(
                                                                          context)
                                                                      .secondaryText,
                                                              size: 16.0,
                                                            ),
                                                            countBuilder:
                                                                (count) => Text(
                                                              count.toString(),
                                                              style: FlutterFlowTheme
                                                                      .of(context)
                                                                  .titleLarge
                                                                  .override(
                                                                    font: GoogleFonts
                                                                        .interTight(
                                                                      fontWeight: FlutterFlowTheme.of(
                                                                              context)
                                                                          .titleLarge
                                                                          .fontWeight,
                                                                      fontStyle: FlutterFlowTheme.of(
                                                                              context)
                                                                          .titleLarge
                                                                          .fontStyle,
                                                                    ),
                                                                    color: FlutterFlowTheme.of(
                                                                            context)
                                                                        .secondaryText,
                                                                    fontSize:
                                                                        16.0,
                                                                    letterSpacing:
                                                                        0.0,
                                                                    fontWeight: FlutterFlowTheme.of(
                                                                            context)
                                                                        .titleLarge
                                                                        .fontWeight,
                                                                    fontStyle: FlutterFlowTheme.of(
                                                                            context)
                                                                        .titleLarge
                                                                        .fontStyle,
                                                                  ),
                                                            ),
                                                            count: _model
                                                                .contadorMesesValue ??= 2,
                                                            updateCount: (count) =>
                                                                safeSetState(() =>
                                                                    _model.contadorMesesValue =
                                                                        count),
                                                            stepSize: 1,
                                                            minimum: 2,
                                                            maximum: 120,
                                                            contentPadding:
                                                                EdgeInsetsDirectional
                                                                    .fromSTEB(
                                                                        12.0,
                                                                        0.0,
                                                                        12.0,
                                                                        0.0),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                              ],
                                            ),
                                            Padding(
                                              padding: EdgeInsetsDirectional
                                                  .fromSTEB(
                                                      0.0, 12.0, 0.0, 0.0),
                                              child: Column(
                                                mainAxisSize: MainAxisSize.max,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.stretch,
                                                children: [
                                                  Padding(
                                                    padding:
                                                        EdgeInsetsDirectional
                                                            .fromSTEB(4.0, 0.0,
                                                                8.0, 6.0),
                                                    child: Text(
                                                      'A que mês se refere esta conta?',
                                                      style:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .labelMedium
                                                              .override(
                                                                font:
                                                                    GoogleFonts
                                                                        .inter(
                                                                  fontWeight: FlutterFlowTheme.of(
                                                                          context)
                                                                      .labelMedium
                                                                      .fontWeight,
                                                                  fontStyle: FlutterFlowTheme.of(
                                                                          context)
                                                                      .labelMedium
                                                                      .fontStyle,
                                                                ),
                                                                color: FlutterFlowTheme.of(
                                                                        context)
                                                                    .secondaryText,
                                                                letterSpacing:
                                                                    0.0,
                                                                fontWeight: FlutterFlowTheme.of(
                                                                        context)
                                                                    .labelMedium
                                                                    .fontWeight,
                                                                fontStyle: FlutterFlowTheme.of(
                                                                        context)
                                                                    .labelMedium
                                                                    .fontStyle,
                                                              ),
                                                    ),
                                                  ),
                                                  FlutterFlowDropDown<String>(
                                                    controller: _model
                                                            .ddMesDeReferenciaValueController ??=
                                                        FormFieldController<
                                                            String>(
                                                      _model.ddMesDeReferenciaValue ??=
                                                          'Mesmo Mês do Vencimento',
                                                    ),
                                                    options: [
                                                      'Mesmo Mês do Vencimento',
                                                      'Mês Anterior',
                                                      'Mês Seguinte',
                                                      'Mesmo Mês da Competência'
                                                    ],
                                                    onChanged: (val) =>
                                                        safeSetState(() => _model
                                                                .ddMesDeReferenciaValue =
                                                            val),
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
                                                        'Seleione uma das opções...',
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
                                                    isOverButton: false,
                                                    isSearchable: false,
                                                    isMultiSelect: false,
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Align(
                                              alignment: AlignmentDirectional(
                                                  -1.0, 0.0),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.min,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  Padding(
                                                    padding:
                                                        EdgeInsetsDirectional
                                                            .fromSTEB(4.0, 0.0,
                                                                8.0, 6.0),
                                                    child: Text(
                                                      'Reconhecer valor total no mês do fato?',
                                                      style:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .labelMedium
                                                              .override(
                                                                font:
                                                                    GoogleFonts
                                                                        .inter(
                                                                  fontWeight: FlutterFlowTheme.of(
                                                                          context)
                                                                      .labelMedium
                                                                      .fontWeight,
                                                                  fontStyle: FlutterFlowTheme.of(
                                                                          context)
                                                                      .labelMedium
                                                                      .fontStyle,
                                                                ),
                                                                color: FlutterFlowTheme.of(
                                                                        context)
                                                                    .secondaryText,
                                                                letterSpacing:
                                                                    0.0,
                                                                fontWeight: FlutterFlowTheme.of(
                                                                        context)
                                                                    .labelMedium
                                                                    .fontWeight,
                                                                fontStyle: FlutterFlowTheme.of(
                                                                        context)
                                                                    .labelMedium
                                                                    .fontStyle,
                                                              ),
                                                    ),
                                                  ),
                                                  Switch.adaptive(
                                                    value: _model
                                                        .swtManterCompFixaValue!,
                                                    onChanged: ((_model
                                                                    .vTipoOperacao ==
                                                                'TRANSFERENCIA') &&
                                                            (_model.vIdTransacao !=
                                                                    null &&
                                                                _model.vIdTransacao !=
                                                                    ''))
                                                        ? null
                                                        : (newValue) async {
                                                            safeSetState(() =>
                                                                _model.swtManterCompFixaValue =
                                                                    newValue);
                                                          },
                                                    activeColor: ((_model
                                                                    .vTipoOperacao ==
                                                                'TRANSFERENCIA') &&
                                                            (_model
                                                                        .vIdTransacao !=
                                                                    null &&
                                                                _model.vIdTransacao !=
                                                                    ''))
                                                        ? FlutterFlowTheme.of(
                                                                context)
                                                            .primary
                                                        : FlutterFlowTheme.of(
                                                                context)
                                                            .primary,
                                                    activeTrackColor: ((_model
                                                                    .vTipoOperacao ==
                                                                'TRANSFERENCIA') &&
                                                            (_model.vIdTransacao !=
                                                                    null &&
                                                                _model
                                                                        .vIdTransacao !=
                                                                    ''))
                                                        ? FlutterFlowTheme.of(
                                                                context)
                                                            .secondaryBackground
                                                        : FlutterFlowTheme.of(
                                                                context)
                                                            .fundoText,
                                                    inactiveTrackColor: ((_model
                                                                    .vTipoOperacao ==
                                                                'TRANSFERENCIA') &&
                                                            (_model
                                                                        .vIdTransacao !=
                                                                    null &&
                                                                _model.vIdTransacao !=
                                                                    ''))
                                                        ? FlutterFlowTheme.of(
                                                                context)
                                                            .primary
                                                        : FlutterFlowTheme.of(
                                                                context)
                                                            .primary,
                                                    inactiveThumbColor: ((_model
                                                                    .vTipoOperacao ==
                                                                'TRANSFERENCIA') &&
                                                            (_model.vIdTransacao !=
                                                                    null &&
                                                                _model.vIdTransacao !=
                                                                    ''))
                                                        ? FlutterFlowTheme.of(
                                                                context)
                                                            .secondaryBackground
                                                        : FlutterFlowTheme.of(
                                                                context)
                                                            .fundoText,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                    ],
                                  ),
                                Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    Align(
                                      alignment:
                                          AlignmentDirectional(-1.0, 0.0),
                                      child: Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                            0.0, 0.0, 0.0, 12.0),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Padding(
                                              padding: EdgeInsetsDirectional
                                                  .fromSTEB(4.0, 0.0, 8.0, 6.0),
                                              child: Text(
                                                _model.choTipoValue == 'RECEITA'
                                                    ? 'Esta conta já foi recebida?'
                                                    : 'Esta conta já foi paga?',
                                                style: FlutterFlowTheme.of(
                                                        context)
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
                                                      color:
                                                          FlutterFlowTheme.of(
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
                                            Switch.adaptive(
                                              value: _model.swtStatusValue!,
                                              onChanged: ((_model
                                                              .vTipoOperacao ==
                                                          'TRANSFERENCIA') &&
                                                      (_model.vIdTransacao !=
                                                              null &&
                                                          _model.vIdTransacao !=
                                                              ''))
                                                  ? null
                                                  : (newValue) async {
                                                      safeSetState(() => _model
                                                              .swtStatusValue =
                                                          newValue);
                                                      if (newValue) {
                                                        _model.vDataPagamento =
                                                            _model.vTipoConta ==
                                                                    'CARTAO'
                                                                ? null
                                                                : getCurrentTimestamp;
                                                        safeSetState(() {});
                                                      } else {
                                                        _model.vDataPagamento =
                                                            null;
                                                        _model.vIdContaOrigem =
                                                            _model.vTipoConta !=
                                                                    'CARTAO'
                                                                ? null
                                                                : _model
                                                                    .ddContaOrigemValue;
                                                        safeSetState(() {});
                                                      }
                                                    },
                                              activeColor: ((_model
                                                              .vTipoOperacao ==
                                                          'TRANSFERENCIA') &&
                                                      (_model.vIdTransacao !=
                                                              null &&
                                                          _model.vIdTransacao !=
                                                              ''))
                                                  ? FlutterFlowTheme.of(context)
                                                      .primary
                                                  : FlutterFlowTheme.of(context)
                                                      .primary,
                                              activeTrackColor: ((_model
                                                              .vTipoOperacao ==
                                                          'TRANSFERENCIA') &&
                                                      (_model.vIdTransacao !=
                                                              null &&
                                                          _model.vIdTransacao !=
                                                              ''))
                                                  ? FlutterFlowTheme.of(context)
                                                      .secondaryBackground
                                                  : FlutterFlowTheme.of(context)
                                                      .fundoText,
                                              inactiveTrackColor: ((_model
                                                              .vTipoOperacao ==
                                                          'TRANSFERENCIA') &&
                                                      (_model.vIdTransacao !=
                                                              null &&
                                                          _model.vIdTransacao !=
                                                              ''))
                                                  ? FlutterFlowTheme.of(context)
                                                      .primary
                                                  : FlutterFlowTheme.of(context)
                                                      .primary,
                                              inactiveThumbColor: ((_model
                                                              .vTipoOperacao ==
                                                          'TRANSFERENCIA') &&
                                                      (_model.vIdTransacao !=
                                                              null &&
                                                          _model.vIdTransacao !=
                                                              ''))
                                                  ? FlutterFlowTheme.of(context)
                                                      .secondaryBackground
                                                  : FlutterFlowTheme.of(context)
                                                      .fundoText,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    if ((_model.swtStatusValue == true) &&
                                        (_model.vTipoConta != 'CARTAO'))
                                      Column(
                                        mainAxisSize: MainAxisSize.max,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding:
                                                EdgeInsetsDirectional.fromSTEB(
                                                    4.0, 0.0, 0.0, 6.0),
                                            child: Text(
                                              _model.choTipoValue == 'A Receber'
                                                  ? 'Data Recebimento'
                                                  : 'Data Pagamento',
                                              style:
                                                  FlutterFlowTheme.of(context)
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
                                                        color:
                                                            FlutterFlowTheme.of(
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
                                          Padding(
                                            padding:
                                                EdgeInsetsDirectional.fromSTEB(
                                                    0.0, 0.0, 0.0, 12.0),
                                            child: InkWell(
                                              splashColor: Colors.transparent,
                                              focusColor: Colors.transparent,
                                              hoverColor: Colors.transparent,
                                              highlightColor:
                                                  Colors.transparent,
                                              onTap: () async {
                                                final _datePicked2Date =
                                                    await showDatePicker(
                                                  context: context,
                                                  initialDate:
                                                      getCurrentTimestamp,
                                                  firstDate: DateTime(1900),
                                                  lastDate: DateTime(2050),
                                                  builder: (context, child) {
                                                    return wrapInMaterialDatePickerTheme(
                                                      context,
                                                      child!,
                                                      headerBackgroundColor:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .primary,
                                                      headerForegroundColor:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .info,
                                                      headerTextStyle:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .headlineLarge
                                                              .override(
                                                                font: GoogleFonts
                                                                    .interTight(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
                                                                  fontStyle: FlutterFlowTheme.of(
                                                                          context)
                                                                      .headlineLarge
                                                                      .fontStyle,
                                                                ),
                                                                fontSize: 32.0,
                                                                letterSpacing:
                                                                    0.0,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                                fontStyle: FlutterFlowTheme.of(
                                                                        context)
                                                                    .headlineLarge
                                                                    .fontStyle,
                                                              ),
                                                      pickerBackgroundColor:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .secondaryBackground,
                                                      pickerForegroundColor:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .primaryText,
                                                      selectedDateTimeBackgroundColor:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .primary,
                                                      selectedDateTimeForegroundColor:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .info,
                                                      actionButtonForegroundColor:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .primaryText,
                                                      iconSize: 24.0,
                                                    );
                                                  },
                                                );

                                                TimeOfDay? _datePicked2Time;
                                                if (_datePicked2Date != null) {
                                                  _datePicked2Time =
                                                      await showTimePicker(
                                                    context: context,
                                                    initialTime:
                                                        TimeOfDay.fromDateTime(
                                                            getCurrentTimestamp),
                                                    builder: (context, child) {
                                                      return wrapInMaterialTimePickerTheme(
                                                        context,
                                                        child!,
                                                        headerBackgroundColor:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .primary,
                                                        headerForegroundColor:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .info,
                                                        headerTextStyle:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .headlineLarge
                                                                .override(
                                                                  font: GoogleFonts
                                                                      .interTight(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600,
                                                                    fontStyle: FlutterFlowTheme.of(
                                                                            context)
                                                                        .headlineLarge
                                                                        .fontStyle,
                                                                  ),
                                                                  fontSize:
                                                                      32.0,
                                                                  letterSpacing:
                                                                      0.0,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
                                                                  fontStyle: FlutterFlowTheme.of(
                                                                          context)
                                                                      .headlineLarge
                                                                      .fontStyle,
                                                                ),
                                                        pickerBackgroundColor:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .secondaryBackground,
                                                        pickerForegroundColor:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .primaryText,
                                                        selectedDateTimeBackgroundColor:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .primary,
                                                        selectedDateTimeForegroundColor:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .info,
                                                        actionButtonForegroundColor:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .primaryText,
                                                        iconSize: 24.0,
                                                      );
                                                    },
                                                  );
                                                }

                                                if (_datePicked2Date != null &&
                                                    _datePicked2Time != null) {
                                                  safeSetState(() {
                                                    _model.datePicked2 =
                                                        DateTime(
                                                      _datePicked2Date.year,
                                                      _datePicked2Date.month,
                                                      _datePicked2Date.day,
                                                      _datePicked2Time!.hour,
                                                      _datePicked2Time.minute,
                                                    );
                                                  });
                                                } else if (_model.datePicked2 !=
                                                    null) {
                                                  safeSetState(() {
                                                    _model.datePicked2 =
                                                        getCurrentTimestamp;
                                                  });
                                                }
                                                _model.vDataPagamento =
                                                    _model.datePicked2;
                                                safeSetState(() {});
                                              },
                                              child: Container(
                                                width: double.infinity,
                                                height: 40.0,
                                                decoration: BoxDecoration(
                                                  color: FlutterFlowTheme.of(
                                                          context)
                                                      .secondaryBackground,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          8.0),
                                                ),
                                                child: Row(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    Padding(
                                                      padding:
                                                          EdgeInsetsDirectional
                                                              .fromSTEB(
                                                                  12.0,
                                                                  0.0,
                                                                  12.0,
                                                                  0.0),
                                                      child: Icon(
                                                        Icons
                                                            .edit_calendar_outlined,
                                                        color:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .primary,
                                                        size: 16.0,
                                                      ),
                                                    ),
                                                    Text(
                                                      _model.vDataPagamento !=
                                                              null
                                                          ? dateTimeFormat(
                                                              "dd/MM/y HH:mm",
                                                              _model
                                                                  .vDataPagamento,
                                                              locale: FFLocalizations
                                                                      .of(context)
                                                                  .languageCode,
                                                            )
                                                          : ((_model.swtStatusValue ==
                                                                      true) &&
                                                                  (_model.vTipoConta !=
                                                                      'CARTAO')
                                                              ? dateTimeFormat(
                                                                  "dd/MM/y HH:mm",
                                                                  getCurrentTimestamp,
                                                                  locale: FFLocalizations.of(
                                                                          context)
                                                                      .languageCode,
                                                                )
                                                              : ''),
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
                                                                color: FlutterFlowTheme.of(
                                                                        context)
                                                                    .secondaryText,
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
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    Container(
                                      width: 100.0,
                                      decoration: BoxDecoration(
                                        color: FlutterFlowTheme.of(context)
                                            .primaryBackground,
                                      ),
                                      child: Visibility(
                                        visible: _model.swtStatusValue == true,
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.stretch,
                                          children: [
                                            Padding(
                                              padding: EdgeInsetsDirectional
                                                  .fromSTEB(4.0, 0.0, 0.0, 6.0),
                                              child: Text(
                                                _model.choTipoValue ==
                                                        'TRANSFERENCIA'
                                                    ? 'Conta Origem'
                                                    : 'Conta Bancária/Caixa',
                                                style: FlutterFlowTheme.of(
                                                        context)
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
                                                      color:
                                                          FlutterFlowTheme.of(
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
                                            Padding(
                                              padding: EdgeInsetsDirectional
                                                  .fromSTEB(
                                                      0.0, 0.0, 0.0, 12.0),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.min,
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Expanded(
                                                    child: FlutterFlowDropDown<
                                                        String>(
                                                      controller: _model
                                                              .ddContaOrigemValueController ??=
                                                          FormFieldController<
                                                              String>(
                                                        _model.ddContaOrigemValue ??=
                                                            _model
                                                                .vIdContaOrigem,
                                                      ),
                                                      options: List<
                                                              String>.from(
                                                          FFAppState()
                                                              .cacheContasBancarias
                                                              .where((e) =>
                                                                  e.ativo ==
                                                                  true)
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
                                                                .ddContaOrigemValue =
                                                            val);
                                                        _model
                                                            .vDataVencimento = FFAppState()
                                                                    .cacheContasBancarias
                                                                    .where((e) =>
                                                                        e.id ==
                                                                        _model
                                                                            .ddContaOrigemValue)
                                                                    .toList()
                                                                    .firstOrNull
                                                                    ?.tipo ==
                                                                'CARTAO'
                                                            ? functions.calcularVencimentoFatura(
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
                                                                        _model
                                                                            .ddContaOrigemValue)
                                                                    .toList()
                                                                    .firstOrNull!
                                                                    .diaVencimento)
                                                            : _model
                                                                .vDataVencimento;
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
                                                            : _model
                                                                .vDataPagamento;
                                                        _model
                                                            .vStatus = FFAppState()
                                                                    .cacheContasBancarias
                                                                    .where((e) =>
                                                                        e.id ==
                                                                        _model
                                                                            .ddContaOrigemValue)
                                                                    .toList()
                                                                    .firstOrNull
                                                                    ?.tipo ==
                                                                'CARTAO'
                                                            ? true
                                                            : _model
                                                                .swtStatusValue;
                                                        _model.vTipoConta = FFAppState()
                                                            .cacheContasBancarias
                                                            .where((e) =>
                                                                e.id ==
                                                                _model
                                                                    .ddContaOrigemValue)
                                                            .toList()
                                                            .firstOrNull
                                                            ?.tipo;
                                                        safeSetState(() {});
                                                      },
                                                      width: 200.0,
                                                      height: 40.0,
                                                      textStyle:
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
                                                                color: FlutterFlowTheme.of(
                                                                        context)
                                                                    .secondaryText,
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
                                                      hintText:
                                                          'Selecione conta de origem...',
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
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .accent3,
                                                      borderWidth: 0.0,
                                                      borderRadius: 8.0,
                                                      margin:
                                                          EdgeInsetsDirectional
                                                              .fromSTEB(
                                                                  12.0,
                                                                  0.0,
                                                                  12.0,
                                                                  0.0),
                                                      hidesUnderline: true,
                                                      isOverButton: false,
                                                      isSearchable: false,
                                                      isMultiSelect: false,
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
                                Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      0.0, 12.0, 0.0, 6.0),
                                  child: InkWell(
                                    splashColor: Colors.transparent,
                                    focusColor: Colors.transparent,
                                    hoverColor: Colors.transparent,
                                    highlightColor: Colors.transparent,
                                    onTap: () async {
                                      _model.mostrarAvancadas =
                                          !_model.mostrarAvancadas;
                                      safeSetState(() {});
                                    },
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Align(
                                          alignment:
                                              AlignmentDirectional(0.0, -1.0),
                                          child: Text(
                                            'Opções Avançadas',
                                            style: FlutterFlowTheme.of(context)
                                                .bodyMedium
                                                .override(
                                                  font: GoogleFonts.inter(
                                                    fontWeight:
                                                        FlutterFlowTheme.of(
                                                                context)
                                                            .bodyMedium
                                                            .fontWeight,
                                                    fontStyle: FontStyle.italic,
                                                  ),
                                                  color: FlutterFlowTheme.of(
                                                          context)
                                                      .accent1,
                                                  letterSpacing: 0.0,
                                                  fontWeight:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .bodyMedium
                                                          .fontWeight,
                                                  fontStyle: FontStyle.italic,
                                                ),
                                          ),
                                        ),
                                        Icon(
                                          Icons.chevron_right,
                                          color: FlutterFlowTheme.of(context)
                                              .accent1,
                                          size: 24.0,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                if (_model.mostrarAvancadas == true)
                                  Container(
                                    decoration: BoxDecoration(),
                                    child: Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          0.0, 6.0, 0.0, 0.0),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.stretch,
                                        children: [
                                          Padding(
                                            padding:
                                                EdgeInsetsDirectional.fromSTEB(
                                                    4.0, 0.0, 0.0, 6.0),
                                            child: Text(
                                              'Centro de Custo',
                                              style:
                                                  FlutterFlowTheme.of(context)
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
                                                        color:
                                                            FlutterFlowTheme.of(
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
                                              padding: EdgeInsetsDirectional
                                                  .fromSTEB(
                                                      0.0, 0.0, 0.0, 12.0),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.min,
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Expanded(
                                                    child: FlutterFlowDropDown<
                                                        String>(
                                                      controller: _model
                                                              .ddCentroDeCustoValueController ??=
                                                          FormFieldController<
                                                              String>(
                                                        _model
                                                            .ddCentroDeCustoValue ??= widget
                                                                        .pIdAgendamento ==
                                                                    null ||
                                                                widget.pIdAgendamento ==
                                                                    ''
                                                            ? (_model.vTipoOperacao ==
                                                                    'A Receber'
                                                                ? FFAppState()
                                                                    .cacheCentrosDeResultado
                                                                    .where((e) =>
                                                                        e.isFundo ==
                                                                        true)
                                                                    .toList()
                                                                    .firstOrNull
                                                                    ?.id
                                                                : FFAppState()
                                                                    .cacheCentrosDeResultado
                                                                    .where((e) =>
                                                                        e.isPadrao ==
                                                                        true)
                                                                    .toList()
                                                                    .firstOrNull
                                                                    ?.id)
                                                            : _model
                                                                .vIdCentroCusto,
                                                      ),
                                                      options: List<
                                                              String>.from(
                                                          FFAppState()
                                                              .cacheCentrosDeResultado
                                                              .where((e) =>
                                                                  e.ativo ==
                                                                  true)
                                                              .toList()
                                                              .map((e) => e.id)
                                                              .toList()),
                                                      optionLabels: FFAppState()
                                                          .cacheCentrosDeResultado
                                                          .where((e) =>
                                                              e.ativo == true)
                                                          .toList()
                                                          .map((e) => e.nome)
                                                          .toList(),
                                                      onChanged: (val) =>
                                                          safeSetState(() =>
                                                              _model.ddCentroDeCustoValue =
                                                                  val),
                                                      width: 200.0,
                                                      height: 40.0,
                                                      textStyle:
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
                                                                color: FlutterFlowTheme.of(
                                                                        context)
                                                                    .secondaryText,
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
                                                      hintText:
                                                          'Selecione o centro de custo...',
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
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .accent3,
                                                      borderWidth: 0.0,
                                                      borderRadius: 8.0,
                                                      margin:
                                                          EdgeInsetsDirectional
                                                              .fromSTEB(
                                                                  12.0,
                                                                  0.0,
                                                                  12.0,
                                                                  0.0),
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
                                            padding:
                                                EdgeInsetsDirectional.fromSTEB(
                                                    4.0, 0.0, 0.0, 6.0),
                                            child: Text(
                                              _model.choTipoValue == 'RECEITA'
                                                  ? 'Pessoa'
                                                  : 'Fornecedor',
                                              style:
                                                  FlutterFlowTheme.of(context)
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
                                                        color:
                                                            FlutterFlowTheme.of(
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
                                              padding: EdgeInsetsDirectional
                                                  .fromSTEB(
                                                      0.0, 0.0, 0.0, 12.0),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.min,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  Expanded(
                                                    child: FlutterFlowDropDown<
                                                        String>(
                                                      controller: _model
                                                              .ddMembroValueController ??=
                                                          FormFieldController<
                                                              String>(
                                                        _model.ddMembroValue ??=
                                                            _model.vIdMembro,
                                                      ),
                                                      options:
                                                          List<String>.from(
                                                              FFAppState()
                                                                  .cacheMembros
                                                                  .where((e) =>
                                                                      e.ativo ==
                                                                      true)
                                                                  .toList()
                                                                  .map((e) =>
                                                                      e.id)
                                                                  .toList()),
                                                      optionLabels: FFAppState()
                                                          .cacheMembros
                                                          .where((e) =>
                                                              e.ativo == true)
                                                          .toList()
                                                          .map((e) =>
                                                              e.nomeCompleto)
                                                          .toList(),
                                                      onChanged: (val) =>
                                                          safeSetState(() =>
                                                              _model.ddMembroValue =
                                                                  val),
                                                      width: 200.0,
                                                      height: 40.0,
                                                      textStyle:
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
                                                                color: FlutterFlowTheme.of(
                                                                        context)
                                                                    .secondaryText,
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
                                                      hintText: _model
                                                                  .choTipoValue ==
                                                              'RECEITA'
                                                          ? 'Selecione uma pessoa...'
                                                          : 'Selecione um fornecedor...',
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
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .accent3,
                                                      borderWidth: 0.0,
                                                      borderRadius: 8.0,
                                                      margin:
                                                          EdgeInsetsDirectional
                                                              .fromSTEB(
                                                                  12.0,
                                                                  0.0,
                                                                  12.0,
                                                                  0.0),
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
                                            padding:
                                                EdgeInsetsDirectional.fromSTEB(
                                                    4.0, 0.0, 0.0, 6.0),
                                            child: Text(
                                              'Data Competência',
                                              style:
                                                  FlutterFlowTheme.of(context)
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
                                                        color:
                                                            FlutterFlowTheme.of(
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
                                          Padding(
                                            padding:
                                                EdgeInsetsDirectional.fromSTEB(
                                                    0.0, 0.0, 0.0, 12.0),
                                            child: InkWell(
                                              splashColor: Colors.transparent,
                                              focusColor: Colors.transparent,
                                              hoverColor: Colors.transparent,
                                              highlightColor:
                                                  Colors.transparent,
                                              onTap: () async {
                                                final _datePicked3Date =
                                                    await showDatePicker(
                                                  context: context,
                                                  initialDate:
                                                      getCurrentTimestamp,
                                                  firstDate: DateTime(1900),
                                                  lastDate: DateTime(2050),
                                                  builder: (context, child) {
                                                    return wrapInMaterialDatePickerTheme(
                                                      context,
                                                      child!,
                                                      headerBackgroundColor:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .primary,
                                                      headerForegroundColor:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .info,
                                                      headerTextStyle:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .headlineLarge
                                                              .override(
                                                                font: GoogleFonts
                                                                    .interTight(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
                                                                  fontStyle: FlutterFlowTheme.of(
                                                                          context)
                                                                      .headlineLarge
                                                                      .fontStyle,
                                                                ),
                                                                fontSize: 32.0,
                                                                letterSpacing:
                                                                    0.0,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                                fontStyle: FlutterFlowTheme.of(
                                                                        context)
                                                                    .headlineLarge
                                                                    .fontStyle,
                                                              ),
                                                      pickerBackgroundColor:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .secondaryBackground,
                                                      pickerForegroundColor:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .primaryText,
                                                      selectedDateTimeBackgroundColor:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .primary,
                                                      selectedDateTimeForegroundColor:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .info,
                                                      actionButtonForegroundColor:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .primaryText,
                                                      iconSize: 24.0,
                                                    );
                                                  },
                                                );

                                                if (_datePicked3Date != null) {
                                                  safeSetState(() {
                                                    _model.datePicked3 =
                                                        DateTime(
                                                      _datePicked3Date.year,
                                                      _datePicked3Date.month,
                                                      _datePicked3Date.day,
                                                    );
                                                  });
                                                } else if (_model.datePicked3 !=
                                                    null) {
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
                                                  color: FlutterFlowTheme.of(
                                                          context)
                                                      .secondaryBackground,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          8.0),
                                                ),
                                                child: Row(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    Padding(
                                                      padding:
                                                          EdgeInsetsDirectional
                                                              .fromSTEB(
                                                                  12.0,
                                                                  0.0,
                                                                  12.0,
                                                                  0.0),
                                                      child: Icon(
                                                        Icons
                                                            .edit_calendar_outlined,
                                                        color:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .primary,
                                                        size: 16.0,
                                                      ),
                                                    ),
                                                    Text(
                                                      dateTimeFormat(
                                                        "dd/MM/y",
                                                        _model.vDataCompetencia,
                                                        locale:
                                                            FFLocalizations.of(
                                                                    context)
                                                                .languageCode,
                                                      ),
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
                                                                color: FlutterFlowTheme.of(
                                                                        context)
                                                                    .secondaryText,
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
                                            selectedMedia.every((m) =>
                                                validateFileFormat(
                                                    m.storagePath, context))) {
                                          safeSetState(() => _model
                                                  .isDataUploading_outComprovanteAgendamento =
                                              true);
                                          var selectedUploadedFiles =
                                              <FFUploadedFile>[];

                                          var downloadUrls = <String>[];
                                          try {
                                            selectedUploadedFiles =
                                                selectedMedia
                                                    .map((m) => FFUploadedFile(
                                                          name: m.storagePath
                                                              .split('/')
                                                              .last,
                                                          bytes: m.bytes,
                                                          height: m.dimensions
                                                              ?.height,
                                                          width: m.dimensions
                                                              ?.width,
                                                          blurHash: m.blurHash,
                                                          originalFilename: m
                                                              .originalFilename,
                                                        ))
                                                    .toList();

                                            downloadUrls =
                                                await uploadSupabaseStorageFiles(
                                              bucketName: 'comprovantes',
                                              selectedFiles: selectedMedia,
                                            );
                                          } finally {
                                            _model.isDataUploading_outComprovanteAgendamento =
                                                false;
                                          }
                                          if (selectedUploadedFiles.length ==
                                                  selectedMedia.length &&
                                              downloadUrls.length ==
                                                  selectedMedia.length) {
                                            safeSetState(() {
                                              _model.uploadedLocalFile_outComprovanteAgendamento =
                                                  selectedUploadedFiles.first;
                                              _model.uploadedFileUrl_outComprovanteAgendamento =
                                                  downloadUrls.first;
                                            });
                                          } else {
                                            safeSetState(() {});
                                            return;
                                          }
                                        }

                                        _model.vUrlComprovante = _model
                                            .uploadedFileUrl_outComprovanteAgendamento;
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
                                        iconPadding:
                                            EdgeInsetsDirectional.fromSTEB(
                                                0.0, 0.0, 0.0, 0.0),
                                        iconColor: FlutterFlowTheme.of(context)
                                            .primary,
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
                                                      .primary,
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
                                        borderSide: BorderSide(
                                          color: FlutterFlowTheme.of(context)
                                              .primary,
                                        ),
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                      ),
                                    ),
                                  ),
                                if ((_model.vUrlComprovante != null &&
                                        _model.vUrlComprovante != '') &&
                                    (_model.choTipoValue != 'TRANSFERENCIA'))
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(8.0),
                                    child: Image.network(
                                      _model.vUrlComprovante!,
                                      width: 200.0,
                                      height: 200.0,
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                              ],
                            ),
                          ),
                          Align(
                            alignment: AlignmentDirectional(0.0, 0.0),
                            child: Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  0.0, 8.0, 0.0, 8.0),
                              child: SafeArea(
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: FlutterFlowTheme.of(context)
                                        .primaryBackground,
                                    borderRadius: BorderRadius.only(),
                                  ),
                                  alignment: AlignmentDirectional(0.0, 0.0),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      Expanded(
                                        child: Align(
                                          alignment:
                                              AlignmentDirectional(0.0, 0.0),
                                          child: Builder(
                                            builder: (context) =>
                                                FFButtonWidget(
                                              onPressed: () async {
                                                var _shouldSetState = false;
                                                if (((_model.swtStatusValue ==
                                                            false) &&
                                                        (_model.vDataVencimento !=
                                                            null) &&
                                                        (_model.ddCategoriaValue !=
                                                                null &&
                                                            _model.ddCategoriaValue !=
                                                                '') &&
                                                        (_model.ddContaOrigemValue ==
                                                                null ||
                                                            _model.ddContaOrigemValue ==
                                                                '') &&
                                                        (_model.vDataPagamento ==
                                                            null) &&
                                                        (_model.vValorFormulario >
                                                            0.0)) ||
                                                    ((_model.swtStatusValue == true) &&
                                                        (_model.vDataVencimento !=
                                                            null) &&
                                                        (_model.ddCategoriaValue != null &&
                                                            _model.ddCategoriaValue !=
                                                                '') &&
                                                        (_model.ddContaOrigemValue != null &&
                                                            _model.ddContaOrigemValue !=
                                                                '') &&
                                                        (_model.vDataPagamento !=
                                                            null) &&
                                                        (_model.vValorFormulario >
                                                            0.0)) ||
                                                    ((_model.swtStatusValue ==
                                                            true) &&
                                                        (_model.vDataVencimento !=
                                                            null) &&
                                                        (_model.ddCategoriaValue !=
                                                                null &&
                                                            _model.ddCategoriaValue !=
                                                                '') &&
                                                        (_model.ddContaOrigemValue !=
                                                                null &&
                                                            _model.ddContaOrigemValue !=
                                                                '') &&
                                                        (_model.vDataPagamento ==
                                                            null) &&
                                                        (_model.vValorFormulario >
                                                            0.0))) {
                                                  if (widget.pIdAgendamento ==
                                                          null ||
                                                      widget.pIdAgendamento ==
                                                          '') {
                                                    if (_model
                                                            .swtRecorrenteValue ==
                                                        true) {
                                                      _model.bolGerarLancRecorrente =
                                                          await actions
                                                              .gerarLancamentosRecorrentes(
                                                        FFAppState()
                                                            .currentOrganizationId,
                                                        _model.swtStatusValue ==
                                                                true
                                                            ? _model
                                                                .ddContaOrigemValue
                                                            : null,
                                                        _model.vTipoConta,
                                                        valueOrDefault<String>(
                                                          _model.inputDescricaoTextController
                                                                          .text ==
                                                                      ''
                                                              ? _model
                                                                  .vDescricaoCategoria
                                                              : _model
                                                                  .inputDescricaoTextController
                                                                  .text,
                                                          'Sem descrição',
                                                        ),
                                                        _model.vValorFormulario,
                                                        _model.vDataVencimento!,
                                                        _model.vDataCompetencia,
                                                        _model
                                                            .ddMesDeReferenciaValue,
                                                        _model.vTipoConta ==
                                                                'CARTAO'
                                                            ? true
                                                            : _model
                                                                .swtManterCompFixaValue!,
                                                        _model.choTipoValue ==
                                                                'A Receber'
                                                            ? 'CREDITO'
                                                            : 'DEBITO',
                                                        _model.chipTipoRecorrenciaValue ==
                                                                'Fixo'
                                                            ? 60
                                                            : _model
                                                                .contadorMesesValue!,
                                                        _model.chipTipoRecorrenciaValue ==
                                                            'Parcelado',
                                                        _model.ddCategoriaValue,
                                                        _model
                                                            .ddCentroDeCustoValue,
                                                      );
                                                      _shouldSetState = true;
                                                      if (_model
                                                          .bolGerarLancRecorrente!) {
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
                                                                  pTipo:
                                                                      'SUCESSO',
                                                                  pMensagem:
                                                                      'Parcelamento gerado com sucesso!',
                                                                ),
                                                              ),
                                                            );
                                                          },
                                                        );
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
                                                                  pTipo: 'ERRO',
                                                                  pMensagem:
                                                                      'Erro ao gerar as parcelas. Verifique os dados inseridos.',
                                                                ),
                                                              ),
                                                            );
                                                          },
                                                        );
                                                      }
                                                    } else {
                                                      _model.rowNovoRegistro =
                                                          await TransacoesTable()
                                                              .insert({
                                                        'valor': _model
                                                            .vValorFormulario,
                                                        'descricao':
                                                            valueOrDefault<
                                                                String>(
                                                          _model.inputDescricaoTextController
                                                                          .text ==
                                                                      ''
                                                              ? _model
                                                                  .vDescricaoCategoria
                                                              : _model
                                                                  .inputDescricaoTextController
                                                                  .text,
                                                          'Sem descrição',
                                                        ),
                                                        'plano_contas_id': _model
                                                            .ddCategoriaValue,
                                                        'status':
                                                            _model.swtStatusValue ==
                                                                    true
                                                                ? 'CONCILIADO'
                                                                : 'PENDENTE',
                                                        'conta_bancaria_id':
                                                            _model.swtStatusValue ==
                                                                    true
                                                                ? _model
                                                                    .ddContaOrigemValue
                                                                : null,
                                                        'centro_custo_id': _model
                                                            .ddCentroDeCustoValue,
                                                        'membro_id': _model
                                                            .ddMembroValue,
                                                        'comprovativo_url': _model
                                                            .uploadedFileUrl_outComprovanteAgendamento,
                                                        'data_vencimento':
                                                            supaSerialize<
                                                                    DateTime>(
                                                                _model
                                                                    .vDataVencimento),
                                                        'data_competencia':
                                                            supaSerialize<
                                                                    DateTime>(
                                                                _model
                                                                    .vDataVencimento),
                                                        'organization_id':
                                                            FFAppState()
                                                                .currentOrganizationId,
                                                        'tipo_operacao':
                                                            _model.choTipoValue ==
                                                                    'A Receber'
                                                                ? 'CREDITO'
                                                                : 'DEBITO',
                                                        'data_pagamento': supaSerialize<
                                                            DateTime>((_model
                                                                        .swtStatusValue ==
                                                                    true) &&
                                                                (_model.vTipoConta !=
                                                                    'CARTAO')
                                                            ? _model
                                                                .vDataPagamento
                                                            : null),
                                                        'total_parcelas': 1,
                                                        'parcela_atual': 1,
                                                      });
                                                      _shouldSetState = true;
                                                      if (_model.rowNovoRegistro
                                                                  ?.id !=
                                                              null &&
                                                          _model.rowNovoRegistro
                                                                  ?.id !=
                                                              '') {
                                                        if (_model
                                                            .swtStatusValue!) {
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
                                                                        -1.0,
                                                                        0.0)
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
                                                                    pTipo:
                                                                        'SUCESSO',
                                                                    pMensagem:
                                                                        'Lançamento registado e pago com sucesso!',
                                                                  ),
                                                                ),
                                                              );
                                                            },
                                                          );
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
                                                                        -1.0,
                                                                        0.0)
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
                                                                    pTipo:
                                                                        'SUCESSO',
                                                                    pMensagem:
                                                                        'Conta agendada com sucesso!',
                                                                  ),
                                                                ),
                                                              );
                                                            },
                                                          );
                                                        }
                                                      } else {
                                                        if (_model
                                                            .swtStatusValue!) {
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
                                                                        -1.0,
                                                                        0.0)
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
                                                                    pTipo:
                                                                        'ERRO',
                                                                    pMensagem:
                                                                        'Erro ao registar o lançamento. Verifique a sua ligação.',
                                                                  ),
                                                                ),
                                                              );
                                                            },
                                                          );
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
                                                                        -1.0,
                                                                        0.0)
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
                                                                    pTipo:
                                                                        'ERRO',
                                                                    pMensagem:
                                                                        'Erro ao agendar a conta. Tente novamente.',
                                                                  ),
                                                                ),
                                                              );
                                                            },
                                                          );
                                                        }
                                                      }
                                                    }
                                                  } else {
                                                    await TransacoesTable()
                                                        .update(
                                                      data: {
                                                        'valor': _model
                                                            .vValorFormulario,
                                                        'descricao': _model.inputDescricaoTextController
                                                                        .text ==
                                                                    ''
                                                            ? _model
                                                                .vDescricaoCategoria
                                                            : _model
                                                                .inputDescricaoTextController
                                                                .text,
                                                        'plano_contas_id': _model
                                                            .ddCategoriaValue,
                                                        'status':
                                                            _model.swtStatusValue ==
                                                                    true
                                                                ? 'CONCILIADO'
                                                                : 'PENDENTE',
                                                        'conta_bancaria_id':
                                                            _model.swtStatusValue ==
                                                                    true
                                                                ? _model
                                                                    .ddContaOrigemValue
                                                                : null,
                                                        'centro_custo_id': _model
                                                            .ddCentroDeCustoValue,
                                                        'membro_id': _model
                                                            .ddMembroValue,
                                                        'comprovativo_url':
                                                            _model
                                                                .vUrlComprovante,
                                                        'data_vencimento':
                                                            supaSerialize<
                                                                    DateTime>(
                                                                _model
                                                                    .vDataVencimento),
                                                        'organization_id':
                                                            FFAppState()
                                                                .currentOrganizationId,
                                                        'data_pagamento': supaSerialize<
                                                            DateTime>((_model
                                                                        .swtStatusValue ==
                                                                    true) &&
                                                                (_model.vTipoConta !=
                                                                    'CARTAO')
                                                            ? _model
                                                                .vDataPagamento
                                                            : null),
                                                      },
                                                      matchingRows: (rows) =>
                                                          rows
                                                              .eqOrNull(
                                                                'id',
                                                                widget
                                                                    .pIdAgendamento,
                                                              )
                                                              .eqOrNull(
                                                                'organization_id',
                                                                FFAppState()
                                                                    .currentOrganizationId,
                                                              ),
                                                    );
                                                    _shouldSetState = true;
                                                    if ((_model.rowUpdateRegistro !=
                                                                null &&
                                                            (_model.rowUpdateRegistro)!
                                                                .isNotEmpty) ==
                                                        false) {
                                                      if ((widget.pViewAgendamento
                                                                  ?.status ==
                                                              'PENDENTE') &&
                                                          _model
                                                              .swtStatusValue!) {
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
                                                                  pTipo:
                                                                      'SUCESSO',
                                                                  pMensagem:
                                                                      'Pagamento registado com sucesso!',
                                                                ),
                                                              ),
                                                            );
                                                          },
                                                        );
                                                      } else if ((widget
                                                                  .pViewAgendamento
                                                                  ?.status ==
                                                              'CONCILIADO') &&
                                                          !_model
                                                              .swtStatusValue!) {
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
                                                                  pTipo:
                                                                      'SUCESSO',
                                                                  pMensagem:
                                                                      'Lançamento estornado e reaberto!',
                                                                ),
                                                              ),
                                                            );
                                                          },
                                                        );
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
                                                                  pTipo:
                                                                      'SUCESSO',
                                                                  pMensagem:
                                                                      'Alterações salvas com sucesso!',
                                                                ),
                                                              ),
                                                            );
                                                          },
                                                        );
                                                      }
                                                    } else {
                                                      if ((widget.pViewAgendamento
                                                                  ?.status ==
                                                              'PENDENTE') &&
                                                          _model
                                                              .swtStatusValue!) {
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
                                                                  pTipo: 'ERRO',
                                                                  pMensagem:
                                                                      'Erro ao registar o pagamento.',
                                                                ),
                                                              ),
                                                            );
                                                          },
                                                        );
                                                      } else if ((widget
                                                                  .pViewAgendamento
                                                                  ?.status ==
                                                              'CONCILIADO') &&
                                                          !_model
                                                              .swtStatusValue!) {
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
                                                                  pTipo: 'ERRO',
                                                                  pMensagem:
                                                                      'Erro ao estornar o lançamento.',
                                                                ),
                                                              ),
                                                            );
                                                          },
                                                        );
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
                                                                  pTipo:
                                                                      'AVISO',
                                                                  pMensagem:
                                                                      'Não foi possível salvar as alterações.',
                                                                ),
                                                              ),
                                                            );
                                                          },
                                                        );
                                                      }
                                                    }
                                                  }

                                                  if (Navigator.of(context)
                                                      .canPop()) {
                                                    context.pop();
                                                  }
                                                  context.pushNamed(
                                                    PrevisaoWidget.routeName,
                                                    queryParameters: {
                                                      'pTipo': serializeParam(
                                                        _model.choTipoValue ==
                                                                'A Pagar'
                                                            ? 0
                                                            : 1,
                                                        ParamType.int,
                                                      ),
                                                    }.withoutNulls,
                                                    extra: <String, dynamic>{
                                                      '__transition_info__':
                                                          TransitionInfo(
                                                        hasTransition: true,
                                                        transitionType:
                                                            PageTransitionType
                                                                .fade,
                                                        duration: Duration(
                                                            milliseconds: 0),
                                                      ),
                                                    },
                                                  );
                                                } else {
                                                  if (widget.pIdAgendamento !=
                                                          null &&
                                                      widget.pIdAgendamento !=
                                                          '') {
                                                    await showDialog(
                                                      context: context,
                                                      builder: (dialogContext) {
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
                                                                  'Por favor, preencha o valor e a categoria do lançamento.',
                                                            ),
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
                                                              pTipo: 'ERRO',
                                                              pMensagem:
                                                                  'Erro ao criar transação. Verifique os dados informados.',
                                                            ),
                                                          ),
                                                        );
                                                      },
                                                    );
                                                  }

                                                  if (_shouldSetState)
                                                    safeSetState(() {});
                                                  return;
                                                }

                                                if (_shouldSetState)
                                                  safeSetState(() {});
                                              },
                                              text: 'SALVAR',
                                              icon: Icon(
                                                Icons.save,
                                                size: 15.0,
                                              ),
                                              options: FFButtonOptions(
                                                width: double.infinity,
                                                height: 50.0,
                                                padding: EdgeInsetsDirectional
                                                    .fromSTEB(
                                                        0.0, 0.0, 0.0, 0.0),
                                                iconPadding:
                                                    EdgeInsetsDirectional
                                                        .fromSTEB(
                                                            0.0, 0.0, 0.0, 0.0),
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .primary,
                                                textStyle:
                                                    FlutterFlowTheme.of(context)
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
                                                          color: FlutterFlowTheme
                                                                  .of(context)
                                                              .primaryText,
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
                                                borderSide: BorderSide(
                                                  width: 1.0,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(8.0),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      if (widget.pIdAgendamento != null &&
                                          widget.pIdAgendamento != '')
                                        Expanded(
                                          child: Align(
                                            alignment:
                                                AlignmentDirectional(0.0, 0.0),
                                            child: Builder(
                                              builder: (context) => Padding(
                                                padding: EdgeInsetsDirectional
                                                    .fromSTEB(
                                                        8.0, 0.0, 0.0, 0.0),
                                                child: FFButtonWidget(
                                                  onPressed: () async {
                                                    var confirmDialogResponse =
                                                        await showDialog<bool>(
                                                              context: context,
                                                              builder:
                                                                  (alertDialogContext) {
                                                                return AlertDialog(
                                                                  title: Text(
                                                                      'Atenção'),
                                                                  content: Text(
                                                                      'Confirma a exclusão deste lançamento?'),
                                                                  actions: [
                                                                    TextButton(
                                                                      onPressed: () => Navigator.pop(
                                                                          alertDialogContext,
                                                                          false),
                                                                      child: Text(
                                                                          'Cancelar'),
                                                                    ),
                                                                    TextButton(
                                                                      onPressed: () => Navigator.pop(
                                                                          alertDialogContext,
                                                                          true),
                                                                      child: Text(
                                                                          'Confirmar'),
                                                                    ),
                                                                  ],
                                                                );
                                                              },
                                                            ) ??
                                                            false;
                                                    if (confirmDialogResponse) {
                                                      await TransacoesTable()
                                                          .delete(
                                                        matchingRows: (rows) =>
                                                            rows
                                                                .eqOrNull(
                                                                  'organization_id',
                                                                  FFAppState()
                                                                      .currentOrganizationId,
                                                                )
                                                                .eqOrNull(
                                                                  'id',
                                                                  widget
                                                                      .pIdAgendamento,
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
                                                              pTipo: 'SUCESSO',
                                                              pMensagem:
                                                                  'Lançamento excluído com sucesso!',
                                                            ),
                                                          ),
                                                        );
                                                      },
                                                    );

                                                    if (Navigator.of(context)
                                                        .canPop()) {
                                                      context.pop();
                                                    }
                                                    context.pushNamed(
                                                      PrevisaoWidget.routeName,
                                                      queryParameters: {
                                                        'pTipo': serializeParam(
                                                          _model.choTipoValue ==
                                                                  'A Pagar'
                                                              ? 0
                                                              : 1,
                                                          ParamType.int,
                                                        ),
                                                      }.withoutNulls,
                                                      extra: <String, dynamic>{
                                                        '__transition_info__':
                                                            TransitionInfo(
                                                          hasTransition: true,
                                                          transitionType:
                                                              PageTransitionType
                                                                  .fade,
                                                          duration: Duration(
                                                              milliseconds: 0),
                                                        ),
                                                      },
                                                    );
                                                  },
                                                  text: 'Excluir',
                                                  icon: Icon(
                                                    Icons.delete,
                                                    size: 15.0,
                                                  ),
                                                  options: FFButtonOptions(
                                                    width: double.infinity,
                                                    height: 50.0,
                                                    padding:
                                                        EdgeInsetsDirectional
                                                            .fromSTEB(0.0, 0.0,
                                                                0.0, 0.0),
                                                    iconPadding:
                                                        EdgeInsetsDirectional
                                                            .fromSTEB(0.0, 0.0,
                                                                0.0, 0.0),
                                                    color: FlutterFlowTheme.of(
                                                            context)
                                                        .primaryBackground,
                                                    textStyle:
                                                        FlutterFlowTheme.of(
                                                                context)
                                                            .titleSmall
                                                            .override(
                                                              font: GoogleFonts
                                                                  .interTight(
                                                                fontWeight: FlutterFlowTheme.of(
                                                                        context)
                                                                    .titleSmall
                                                                    .fontWeight,
                                                                fontStyle: FlutterFlowTheme.of(
                                                                        context)
                                                                    .titleSmall
                                                                    .fontStyle,
                                                              ),
                                                              color: FlutterFlowTheme
                                                                      .of(context)
                                                                  .error,
                                                              letterSpacing:
                                                                  0.0,
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
                                                    borderSide: BorderSide(
                                                      color:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .error,
                                                      width: 1.0,
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8.0),
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
                ),
              ),
            ),
          ),
        ));
  }
}
