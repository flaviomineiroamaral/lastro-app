import '/backend/schema/structs/index.dart';
import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_drop_down.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/flutter_flow/form_field_controller.dart';
import '/lastro/geral/bs_top_notificacoes/bs_top_notificacoes_widget.dart';
import 'dart:ui';
import '/custom_code/actions/index.dart' as actions;
import '/flutter_flow/custom_functions.dart' as functions;
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '/index.dart';
import 'selecionar_transacoes_model.dart';
export 'selecionar_transacoes_model.dart';

class SelecionarTransacoesWidget extends StatefulWidget {
  const SelecionarTransacoesWidget({super.key});

  static String routeName = 'SelecionarTransacoes';
  static String routePath = '/selecionarTransacoes';

  @override
  State<SelecionarTransacoesWidget> createState() =>
      _SelecionarTransacoesWidgetState();
}

class _SelecionarTransacoesWidgetState
    extends State<SelecionarTransacoesWidget> {
  late SelecionarTransacoesModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => SelecionarTransacoesModel());

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    // On page dispose action.
    () async {
      if (_model.chkSelecaoCheckedItems.length > 0) {
        var confirmDialogResponse = await showDialog<bool>(
              context: context,
              builder: (alertDialogContext) {
                return AlertDialog(
                  title: Text('Atenção'),
                  content: Text(
                      'Existem itens na sua lista de importação. Deseja mante-lós?'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(alertDialogContext, false),
                      child: Text('Não'),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pop(alertDialogContext, true),
                      child: Text('Sim'),
                    ),
                  ],
                );
              },
            ) ??
            false;
        if (!confirmDialogResponse) {
          FFAppState().tempImportacaoOFX = [];
          safeSetState(() {});
        }
      }
    }();

    _model.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    context.watch<FFAppState>();

    return Title(
        title: 'SelecionarTransacoes',
        color: FlutterFlowTheme.of(context).primary.withAlpha(0XFF),
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
            FocusManager.instance.primaryFocus?.unfocus();
          },
          child: PopScope(
            canPop: false,
            onPopInvokedWithResult: (didPop, result) {
              if (didPop) return;
              if (context.canPop()) {
                context.pop();
              } else {
                context.goNamed(DashboardWidget.routeName);
              }
            },
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
                    if (context.canPop()) {
                      context.pop();
                    } else {
                      context.goNamed(DashboardWidget.routeName);
                    }
                  },
                ),
                title: Text(
                  'Selecionar Transações',
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
                          12.0, 24.0, 12.0, 12.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Align(
                            alignment: AlignmentDirectional(0.0, 0.0),
                            child: Container(
                              width: 351.7,
                              height: 170.0,
                              decoration: BoxDecoration(
                                color: FlutterFlowTheme.of(context)
                                    .primaryBackground,
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Row(
                                    mainAxisSize: MainAxisSize.max,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Expanded(
                                        child: Padding(
                                          padding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  0.0, 12.0, 0.0, 12.0),
                                          child: FlutterFlowDropDown<String>(
                                            controller: _model
                                                    .ddContaOrigemValueController ??=
                                                FormFieldController<String>(
                                              _model.ddContaOrigemValue ??= '',
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
                                              _model.tipoConta = FFAppState()
                                                  .cacheContasBancarias
                                                  .where((e) =>
                                                      e.id ==
                                                      _model.ddContaOrigemValue)
                                                  .toList()
                                                  .firstOrNull
                                                  ?.tipo;
                                              _model.diaVencimento = FFAppState()
                                                  .cacheContasBancarias
                                                  .where((e) =>
                                                      e.id ==
                                                      _model.ddContaOrigemValue)
                                                  .toList()
                                                  .firstOrNull
                                                  ?.diaVencimento;
                                              _model.diaFechamento = FFAppState()
                                                  .cacheContasBancarias
                                                  .where((e) =>
                                                      e.id ==
                                                      _model.ddContaOrigemValue)
                                                  .toList()
                                                  .firstOrNull
                                                  ?.diaFechamento;
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
                                            hintText: 'Selecione uma conta...',
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
                                            isOverButton: false,
                                            isSearchable: false,
                                            isMultiSelect: false,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisSize: MainAxisSize.max,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        child: Padding(
                                          padding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  0.0, 0.0, 0.0, 12.0),
                                          child: FlutterFlowDropDown<String>(
                                            controller: _model
                                                    .ddCategoriaValueController ??=
                                                FormFieldController<String>(
                                              _model.ddCategoriaValue ??= '',
                                            ),
                                            options: List<String>.from(
                                                FFAppState()
                                                    .cachePlanoContas
                                                    .where((e) =>
                                                        e.permiteLancamento ==
                                                        true)
                                                    .toList()
                                                    .map((e) => e.id)
                                                    .toList()),
                                            optionLabels: functions
                                                .formatarDropdownContas(
                                                    FFAppState()
                                                        .cachePlanoContas
                                                        .where((e) =>
                                                            e.permiteLancamento ==
                                                            true)
                                                        .toList()),
                                            onChanged: (val) => safeSetState(
                                                () => _model.ddCategoriaValue =
                                                    val),
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
                                                'Selecione uma categoria...',
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
                                            isOverButton: false,
                                            isSearchable: false,
                                            isMultiSelect: false,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisSize: MainAxisSize.max,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        child: FlutterFlowDropDown<String>(
                                          controller: _model
                                                  .ddCentroDeCustoValueController ??=
                                              FormFieldController<String>(
                                            _model.ddCentroDeCustoValue ??=
                                                FFAppState()
                                                    .cacheCentrosDeResultado
                                                    .where((e) =>
                                                        e.isPadrao == true)
                                                    .toList()
                                                    .firstOrNull
                                                    ?.id,
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
                                              'Selecione centro de custo...',
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
                                ],
                              ),
                            ),
                          ),
                          Column(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Row(
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        FlutterFlowIconButton(
                                          borderRadius: 8.0,
                                          buttonSize: 40.0,
                                          fillColor:
                                              FlutterFlowTheme.of(context)
                                                  .primaryBackground,
                                          icon: Icon(
                                            Icons.playlist_add_check,
                                            color: FlutterFlowTheme.of(context)
                                                .info,
                                            size: 24.0,
                                          ),
                                          onPressed: () async {
                                            _model.statusSelecaoGeral =
                                                !_model.statusSelecaoGeral;
                                            safeSetState(() {});
                                            _model.listaProcessada =
                                                await actions
                                                    .marcarDesmarcarTudo(
                                              FFAppState()
                                                  .tempImportacaoOFX
                                                  .toList(),
                                              _model.statusSelecaoGeral,
                                            );
                                            FFAppState().tempImportacaoOFX =
                                                _model.listaProcessada!
                                                    .toList()
                                                    .cast<
                                                        OfxTransactionStruct>();
                                            safeSetState(() {});

                                            safeSetState(() {});
                                          },
                                        ),
                                        Expanded(
                                          child: Align(
                                            alignment:
                                                AlignmentDirectional(-1.0, 0.0),
                                            child: Padding(
                                              padding: EdgeInsetsDirectional
                                                  .fromSTEB(4.0, 0.0, 0.0, 0.0),
                                              child: Text(
                                                'Marcar/Desmarcar ',
                                                textAlign: TextAlign.start,
                                                style:
                                                    FlutterFlowTheme.of(context)
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
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              Divider(
                                thickness: 2.0,
                                color: FlutterFlowTheme.of(context).alternate,
                              ),
                            ],
                          ),
                          Expanded(
                            child: Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  0.0, 12.0, 0.0, 0.0),
                              child: SafeArea(
                                child: Container(
                                  width: 100.0,
                                  height: 550.0,
                                  decoration: BoxDecoration(
                                    color: FlutterFlowTheme.of(context)
                                        .primaryBackground,
                                  ),
                                  child: Builder(
                                    builder: (context) {
                                      final transacaoItemOfx = FFAppState()
                                          .tempImportacaoOFX
                                          .toList();

                                      return ListView.builder(
                                        padding: EdgeInsets.zero,
                                        scrollDirection: Axis.vertical,
                                        itemCount: transacaoItemOfx.length,
                                        itemBuilder:
                                            (context, transacaoItemOfxIndex) {
                                          final transacaoItemOfxItem =
                                              transacaoItemOfx[
                                                  transacaoItemOfxIndex];
                                          return Column(
                                            mainAxisSize: MainAxisSize.max,
                                            children: [
                                              Row(
                                                mainAxisSize: MainAxisSize.max,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  Theme(
                                                    data: ThemeData(
                                                      checkboxTheme:
                                                          CheckboxThemeData(
                                                        visualDensity:
                                                            VisualDensity
                                                                .compact,
                                                        materialTapTargetSize:
                                                            MaterialTapTargetSize
                                                                .shrinkWrap,
                                                        shape:
                                                            RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      4.0),
                                                        ),
                                                      ),
                                                      unselectedWidgetColor:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .alternate,
                                                    ),
                                                    child: Checkbox(
                                                      value: _model
                                                                  .chkSelecaoValueMap[
                                                              transacaoItemOfxItem] ??=
                                                          transacaoItemOfxItem
                                                              .selecionado,
                                                      onChanged:
                                                          (newValue) async {
                                                        safeSetState(() => _model
                                                                    .chkSelecaoValueMap[
                                                                transacaoItemOfxItem] =
                                                            newValue!);
                                                        if (newValue!) {
                                                          FFAppState()
                                                              .updateTempImportacaoOFXAtIndex(
                                                            transacaoItemOfxIndex,
                                                            (e) => e
                                                              ..selecionado =
                                                                  true,
                                                          );
                                                          safeSetState(() {});
                                                        } else {
                                                          FFAppState()
                                                              .updateTempImportacaoOFXAtIndex(
                                                            transacaoItemOfxIndex,
                                                            (e) => e
                                                              ..selecionado =
                                                                  false,
                                                          );
                                                          safeSetState(() {});
                                                        }
                                                      },
                                                      side: (FlutterFlowTheme.of(
                                                                      context)
                                                                  .alternate !=
                                                              null)
                                                          ? BorderSide(
                                                              width: 2,
                                                              color: FlutterFlowTheme
                                                                      .of(context)
                                                                  .alternate!,
                                                            )
                                                          : null,
                                                      activeColor:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .secondary,
                                                      checkColor:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .info,
                                                    ),
                                                  ),
                                                  Expanded(
                                                    child: Column(
                                                      mainAxisSize:
                                                          MainAxisSize.max,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Row(
                                                          mainAxisSize:
                                                              MainAxisSize.max,
                                                          children: [
                                                            Expanded(
                                                              child: Align(
                                                                alignment:
                                                                    AlignmentDirectional(
                                                                        -1.0,
                                                                        0.0),
                                                                child: Text(
                                                                  transacaoItemOfxItem.hasCategoriaSugerida() && transacaoItemOfxItem.categoriaSugerida.isNotEmpty
                                                                      ? '${transacaoItemOfxItem.description} [${transacaoItemOfxItem.categoriaSugerida}]'
                                                                      : transacaoItemOfxItem.description,
                                                                  textAlign:
                                                                      TextAlign
                                                                          .start,
                                                                  maxLines: 3,
                                                                  style: FlutterFlowTheme.of(
                                                                          context)
                                                                      .titleSmall
                                                                      .override(
                                                                        font: GoogleFonts
                                                                            .interTight(
                                                                          fontWeight:
                                                                              FontWeight.w300,
                                                                          fontStyle: FlutterFlowTheme.of(context)
                                                                              .titleSmall
                                                                              .fontStyle,
                                                                        ),
                                                                        color: FlutterFlowTheme.of(context)
                                                                            .primaryText,
                                                                        fontSize:
                                                                            14.0,
                                                                        letterSpacing:
                                                                            0.0,
                                                                        fontWeight:
                                                                            FontWeight.w300,
                                                                        fontStyle: FlutterFlowTheme.of(context)
                                                                            .titleSmall
                                                                            .fontStyle,
                                                                      ),
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        Row(
                                                          mainAxisSize:
                                                              MainAxisSize.max,
                                                          children: [
                                                            Column(
                                                              mainAxisSize:
                                                                  MainAxisSize
                                                                      .max,
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Text(
                                                                  'Aconteceu em: ',
                                                                  style: FlutterFlowTheme.of(
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
                                                                        color: FlutterFlowTheme.of(context)
                                                                            .secondaryText,
                                                                        fontSize:
                                                                            12.0,
                                                                        letterSpacing:
                                                                            0.0,
                                                                        fontWeight: FlutterFlowTheme.of(context)
                                                                            .bodyMedium
                                                                            .fontWeight,
                                                                        fontStyle: FlutterFlowTheme.of(context)
                                                                            .bodyMedium
                                                                            .fontStyle,
                                                                      ),
                                                                ),
                                                                Padding(
                                                                  padding: EdgeInsetsDirectional
                                                                      .fromSTEB(
                                                                          0.0,
                                                                          4.0,
                                                                          0.0,
                                                                          0.0),
                                                                  child: Text(
                                                                    dateTimeFormat(
                                                                      "d/M/y",
                                                                      transacaoItemOfxItem
                                                                          .date!,
                                                                      locale: FFLocalizations.of(
                                                                              context)
                                                                          .languageCode,
                                                                    ),
                                                                    textAlign:
                                                                        TextAlign
                                                                            .start,
                                                                    style: FlutterFlowTheme.of(
                                                                            context)
                                                                        .bodyMedium
                                                                        .override(
                                                                          font:
                                                                              GoogleFonts.inter(
                                                                            fontWeight:
                                                                                FlutterFlowTheme.of(context).bodyMedium.fontWeight,
                                                                            fontStyle:
                                                                                FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                                                                          ),
                                                                          color:
                                                                              FlutterFlowTheme.of(context).secondaryText,
                                                                          fontSize:
                                                                              12.0,
                                                                          letterSpacing:
                                                                              0.0,
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
                                                            Padding(
                                                              padding:
                                                                  EdgeInsetsDirectional
                                                                      .fromSTEB(
                                                                          24.0,
                                                                          0.0,
                                                                          0.0,
                                                                          0.0),
                                                              child: Column(
                                                                mainAxisSize:
                                                                    MainAxisSize
                                                                        .max,
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  Text(
                                                                    'Vence em: ',
                                                                    style: FlutterFlowTheme.of(
                                                                            context)
                                                                        .bodyMedium
                                                                        .override(
                                                                          font:
                                                                              GoogleFonts.inter(
                                                                            fontWeight:
                                                                                FlutterFlowTheme.of(context).bodyMedium.fontWeight,
                                                                            fontStyle:
                                                                                FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                                                                          ),
                                                                          color:
                                                                              FlutterFlowTheme.of(context).secondaryText,
                                                                          fontSize:
                                                                              12.0,
                                                                          letterSpacing:
                                                                              0.0,
                                                                          fontWeight: FlutterFlowTheme.of(context)
                                                                              .bodyMedium
                                                                              .fontWeight,
                                                                          fontStyle: FlutterFlowTheme.of(context)
                                                                              .bodyMedium
                                                                              .fontStyle,
                                                                        ),
                                                                  ),
                                                                  Padding(
                                                                    padding: EdgeInsetsDirectional
                                                                        .fromSTEB(
                                                                            0.0,
                                                                            4.0,
                                                                            0.0,
                                                                            0.0),
                                                                    child: Text(
                                                                      dateTimeFormat(
                                                                        "d/M/y",
                                                                        transacaoItemOfxItem
                                                                            .dueDate!,
                                                                        locale:
                                                                            FFLocalizations.of(context).languageCode,
                                                                      ),
                                                                      textAlign:
                                                                          TextAlign
                                                                              .start,
                                                                      style: FlutterFlowTheme.of(
                                                                              context)
                                                                          .bodyMedium
                                                                          .override(
                                                                            font:
                                                                                GoogleFonts.inter(
                                                                              fontWeight: FlutterFlowTheme.of(context).bodyMedium.fontWeight,
                                                                              fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                                                                            ),
                                                                            color:
                                                                                FlutterFlowTheme.of(context).secondaryText,
                                                                            fontSize:
                                                                                12.0,
                                                                            letterSpacing:
                                                                                0.0,
                                                                            fontWeight:
                                                                                FlutterFlowTheme.of(context).bodyMedium.fontWeight,
                                                                            fontStyle:
                                                                                FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                                                                          ),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        EdgeInsetsDirectional
                                                            .fromSTEB(0.0, 0.0,
                                                                12.0, 0.0),
                                                    child: Text(
                                                      transacaoItemOfxItem
                                                                  .type ==
                                                              'CREDITO'
                                                          ? '+ ${formatNumber(
                                                              transacaoItemOfxItem
                                                                  .amount,
                                                              formatType:
                                                                  FormatType
                                                                      .decimal,
                                                              decimalType:
                                                                  DecimalType
                                                                      .commaDecimal,
                                                              currency: 'R\$ ',
                                                            )}'
                                                          : '- ${formatNumber(
                                                              transacaoItemOfxItem
                                                                  .amount,
                                                              formatType:
                                                                  FormatType
                                                                      .decimal,
                                                              decimalType:
                                                                  DecimalType
                                                                      .commaDecimal,
                                                              currency: 'R\$ ',
                                                            )}',
                                                      style: FlutterFlowTheme
                                                              .of(context)
                                                          .bodyMedium
                                                          .override(
                                                            font: GoogleFonts
                                                                .inter(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                              fontStyle:
                                                                  FlutterFlowTheme.of(
                                                                          context)
                                                                      .bodyMedium
                                                                      .fontStyle,
                                                            ),
                                                            color: transacaoItemOfxItem
                                                                        .type ==
                                                                    'CREDITO'
                                                                ? FlutterFlowTheme.of(
                                                                        context)
                                                                    .secondaryText
                                                                : FlutterFlowTheme.of(
                                                                        context)
                                                                    .error,
                                                            letterSpacing: 0.0,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            fontStyle:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyMedium
                                                                    .fontStyle,
                                                          ),
                                                    ),
                                                  ),
                                                ].divide(SizedBox(width: 12.0)),
                                              ),
                                              Divider(
                                                thickness: 0.0,
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .alternate,
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(
                                0.0, 12.0, 0.0, 0.0),
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Builder(
                                  builder: (context) => Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        0.0, 12.0, 0.0, 0.0),
                                    child: FFButtonWidget(
                                      onPressed: () async {
                                        var _shouldSetState = false;
                                        if ((_model.ddContaOrigemValue !=
                                                    null &&
                                                _model.ddContaOrigemValue !=
                                                    '') &&
                                            (_model.ddCategoriaValue != null &&
                                                _model.ddCategoriaValue !=
                                                    '') &&
                                            (_model.ddCentroDeCustoValue !=
                                                    null &&
                                                _model.ddCentroDeCustoValue !=
                                                    '')) {
                                          for (int loop1Index = 0;
                                              loop1Index <
                                                  FFAppState()
                                                      .tempImportacaoOFX
                                                      .length;
                                              loop1Index++) {
                                            final currentLoop1Item =
                                                FFAppState().tempImportacaoOFX[
                                                    loop1Index];
                                            if (currentLoop1Item.selecionado ==
                                                true) {
                                              _model.checkExistencia =
                                                  await TransacoesTable()
                                                      .queryRows(
                                                queryFn: (q) => q
                                                    .eqOrNull(
                                                      'id_unico_banco',
                                                      currentLoop1Item.fitid,
                                                    )
                                                    .eqOrNull(
                                                      'organization_id',
                                                      FFAppState()
                                                          .currentOrganizationId,
                                                    ),
                                              );
                                              _shouldSetState = true;
                                              if (_model
                                                      .checkExistencia!.length >
                                                  0) {
                                                _model.contadorDuplicados =
                                                    _model.contadorDuplicados +
                                                        1;
                                                safeSetState(() {});
                                              } else {
                                                await TransacoesTable().insert({
                                                  'descricao': currentLoop1Item
                                                      .description,
                                                  'valor':
                                                      currentLoop1Item.amount,
                                                  'data_pagamento':
                                                      supaSerialize<DateTime>(
                                                          _model.tipoConta ==
                                                                  'CARTAO'
                                                              ? null
                                                              : currentLoop1Item
                                                                  .date),
                                                  'tipo_operacao': _model
                                                              .tipoConta ==
                                                          'CARTAO'
                                                      ? 'DEBITO'
                                                      : currentLoop1Item.type,
                                                  'id_unico_banco':
                                                      currentLoop1Item.fitid,
                                                  'conta_bancaria_id':
                                                      _model.ddContaOrigemValue,
                                                  'plano_contas_id':
                                                      _model.ddCategoriaValue,
                                                  'centro_custo_id': _model
                                                      .ddCentroDeCustoValue,
                                                  'organization_id': FFAppState()
                                                      .currentOrganizationId,
                                                  'data_vencimento':
                                                      supaSerialize<DateTime>(
                                                          currentLoop1Item
                                                              .dueDate),
                                                  'data_competencia':
                                                      supaSerialize<DateTime>(
                                                          currentLoop1Item
                                                              .date),
                                                  'status': 'CONCILIADO',
                                                });
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
                                                backgroundColor:
                                                    Colors.transparent,
                                                alignment: AlignmentDirectional(
                                                        -1.0, 0.0)
                                                    .resolve(Directionality.of(
                                                        context)),
                                                child: GestureDetector(
                                                  onTap: () {
                                                    FocusScope.of(dialogContext)
                                                        .unfocus();
                                                    FocusManager
                                                        .instance.primaryFocus
                                                        ?.unfocus();
                                                  },
                                                  child:
                                                      BsTopNotificacoesWidget(
                                                    pTipo: 'ERRO',
                                                    pMensagem:
                                                        'Selecione os itens (Conta/Categoria/Centro de Custo) acima!',
                                                  ),
                                                ),
                                              );
                                            },
                                          );

                                          if (_shouldSetState)
                                            safeSetState(() {});
                                          return;
                                        }

                                        // Atualiza o pulse para sincronização em tempo real do Dashboard
                                        try {
                                          await OrgPulseTable().upsert({
                                            'organization_id': FFAppState().currentOrganizationId,
                                            'ultima_atualizacao': supaSerialize<DateTime>(DateTime.now()),
                                          });
                                        } catch (e) {
                                          debugPrint('Erro ao atualizar org_pulse: \$e');
                                        }

                                        FFAppState().tempImportacaoOFX =
                                            FFAppState()
                                                .tempImportacaoOFX
                                                .where((e) =>
                                                    e.selecionado == false)
                                                .toList()
                                                .cast<OfxTransactionStruct>();
                                        safeSetState(() {});
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
                                              child: GestureDetector(
                                                onTap: () {
                                                  FocusScope.of(dialogContext)
                                                      .unfocus();
                                                  FocusManager
                                                      .instance.primaryFocus
                                                      ?.unfocus();
                                                },
                                                child: BsTopNotificacoesWidget(
                                                  pTipo: 'SUCESSO',
                                                  pMensagem:
                                                      'Importação concluída! ${_model.contadorDuplicados > 0 ? '${_model.contadorDuplicados.toString()} itens já existiam e foram ignorados.' : ''}',
                                                ),
                                              ),
                                            );
                                          },
                                        );

                                        _model.contadorDuplicados = 0;
                                        safeSetState(() {});
                                        if (_shouldSetState)
                                          safeSetState(() {});
                                      },
                                      text: 'Salvar Selecionados',
                                      icon: Icon(
                                        Icons.save,
                                        size: 15.0,
                                      ),
                                      options: FFButtonOptions(
                                        height: 40.0,
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                            16.0, 0.0, 16.0, 0.0),
                                        iconPadding:
                                            EdgeInsetsDirectional.fromSTEB(
                                                0.0, 0.0, 0.0, 0.0),
                                        color: FlutterFlowTheme.of(context)
                                            .primary,
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
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                      ),
                                    ),
                                  ),
                                ),
                                Builder(
                                  builder: (context) => Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        0.0, 12.0, 0.0, 24.0),
                                    child: FFButtonWidget(
                                      onPressed: () async {
                                        FFAppState().tempImportacaoOFX =
                                            FFAppState()
                                                .tempImportacaoOFX
                                                .where((e) =>
                                                    e.selecionado == false)
                                                .toList()
                                                .cast<OfxTransactionStruct>();
                                        safeSetState(() {});
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
                                              child: GestureDetector(
                                                onTap: () {
                                                  FocusScope.of(dialogContext)
                                                      .unfocus();
                                                  FocusManager
                                                      .instance.primaryFocus
                                                      ?.unfocus();
                                                },
                                                child: BsTopNotificacoesWidget(
                                                  pTipo: 'SUCESSO',
                                                  pMensagem:
                                                      'Registro excluídos com sucesso!',
                                                ),
                                              ),
                                            );
                                          },
                                        );
                                      },
                                      text: 'Excluir Selecionados',
                                      icon: Icon(
                                        Icons.clear,
                                        size: 15.0,
                                      ),
                                      options: FFButtonOptions(
                                        height: 40.0,
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                            16.0, 0.0, 16.0, 0.0),
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
                                        elevation: 0.0,
                                        borderSide: BorderSide(
                                          color: FlutterFlowTheme.of(context)
                                              .error,
                                        ),
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                      ),
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
            ),
          ),
        ));
  }
}
