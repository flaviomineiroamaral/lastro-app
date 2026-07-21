import '/backend/schema/structs/index.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/custom_code/actions/index.dart' as actions;
import '/index.dart';
import 'dashboard_widget.dart' show DashboardWidget;
import 'package:flutter/material.dart';

class DashboardModel extends FlutterFlowModel<DashboardWidget> {
  ///  Local state fields for this page.

  List<Color> listaCoresHex = [
    Color(4292250142),
    Color(4280691506),
    Color(4280138068),
    Color(4293348412)
  ];
  void addToListaCoresHex(Color item) => listaCoresHex.add(item);
  void removeFromListaCoresHex(Color item) => listaCoresHex.remove(item);
  void removeAtIndexFromListaCoresHex(int index) =>
      listaCoresHex.removeAt(index);
  void insertAtIndexInListaCoresHex(int index, Color item) =>
      listaCoresHex.insert(index, item);
  void updateListaCoresHexAtIndex(int index, Function(Color) updateFn) =>
      listaCoresHex[index] = updateFn(listaCoresHex[index]);

  bool visaoCaixa = true;

  List<dynamic> dadosGraficoDFC = [];
  void addToDadosGraficoDFC(dynamic item) => dadosGraficoDFC.add(item);
  void removeFromDadosGraficoDFC(dynamic item) => dadosGraficoDFC.remove(item);
  void removeAtIndexFromDadosGraficoDFC(int index) =>
      dadosGraficoDFC.removeAt(index);
  void insertAtIndexInDadosGraficoDFC(int index, dynamic item) =>
      dadosGraficoDFC.insert(index, item);
  void updateDadosGraficoDFCAtIndex(int index, Function(dynamic) updateFn) =>
      dadosGraficoDFC[index] = updateFn(dadosGraficoDFC[index]);

  DTDreSinteticoStruct? dadosDRESintetico;
  void updateDadosDRESinteticoStruct(Function(DTDreSinteticoStruct) updateFn) {
    updateFn(dadosDRESintetico ??= DTDreSinteticoStruct());
  }

  List<DTSaldoContaStruct> dadosSaldoContas = [];
  void addToDadosSaldoContas(DTSaldoContaStruct item) =>
      dadosSaldoContas.add(item);
  void removeFromDadosSaldoContas(DTSaldoContaStruct item) =>
      dadosSaldoContas.remove(item);
  void removeAtIndexFromDadosSaldoContas(int index) =>
      dadosSaldoContas.removeAt(index);
  void insertAtIndexInDadosSaldoContas(int index, DTSaldoContaStruct item) =>
      dadosSaldoContas.insert(index, item);
  void updateDadosSaldoContasAtIndex(
          int index, Function(DTSaldoContaStruct) updateFn) =>
      dadosSaldoContas[index] = updateFn(dadosSaldoContas[index]);

  DTSaldoTotalOrgStruct? dadosSaldoTotalOrg;
  void updateDadosSaldoTotalOrgStruct(
      Function(DTSaldoTotalOrgStruct) updateFn) {
    updateFn(dadosSaldoTotalOrg ??= DTSaldoTotalOrgStruct());
  }

  List<dynamic> dadosGraficoDRE = [];
  void addToDadosGraficoDRE(dynamic item) => dadosGraficoDRE.add(item);
  void removeFromDadosGraficoDRE(dynamic item) => dadosGraficoDRE.remove(item);
  void removeAtIndexFromDadosGraficoDRE(int index) =>
      dadosGraficoDRE.removeAt(index);
  void insertAtIndexInDadosGraficoDRE(int index, dynamic item) =>
      dadosGraficoDRE.insert(index, item);
  void updateDadosGraficoDREAtIndex(int index, Function(dynamic) updateFn) =>
      dadosGraficoDRE[index] = updateFn(dadosGraficoDRE[index]);

  DTAlertasResumoStruct? dadosAlertaDashboard;
  void updateDadosAlertaDashboardStruct(
      Function(DTAlertasResumoStruct) updateFn) {
    updateFn(dadosAlertaDashboard ??= DTAlertasResumoStruct());
  }

  DateTime? dataInicio;

  DateTime? dataFim;

  DTCartaoResumoStruct? dadosMelhorCartaoParaCompra;
  void updateDadosMelhorCartaoParaCompraStruct(
      Function(DTCartaoResumoStruct) updateFn) {
    updateFn(dadosMelhorCartaoParaCompra ??= DTCartaoResumoStruct());
  }

  DTDfcSinteticoStruct? dadosDfcSintetico;
  void updateDadosDfcSinteticoStruct(Function(DTDfcSinteticoStruct) updateFn) {
    updateFn(dadosDfcSintetico ??= DTDfcSinteticoStruct());
  }

  DTResumoContasAPagarReceberStruct? dadosResumoContasAPagarReceber;
  void updateDadosResumoContasAPagarReceberStruct(
      Function(DTResumoContasAPagarReceberStruct) updateFn) {
    updateFn(
        dadosResumoContasAPagarReceber ??= DTResumoContasAPagarReceberStruct());
  }

  DTResumoSaudeCRStruct? dadosResumoSaudeCR;
  void updateDadosResumoSaudeCRStruct(
      Function(DTResumoSaudeCRStruct) updateFn) {
    updateFn(dadosResumoSaudeCR ??= DTResumoSaudeCRStruct());
  }

  List<DTSaldoContaStruct> dadosSaldosContasPorPeriodo = [];
  void addToDadosSaldosContasPorPeriodo(DTSaldoContaStruct item) =>
      dadosSaldosContasPorPeriodo.add(item);
  void removeFromDadosSaldosContasPorPeriodo(DTSaldoContaStruct item) =>
      dadosSaldosContasPorPeriodo.remove(item);
  void removeAtIndexFromDadosSaldosContasPorPeriodo(int index) =>
      dadosSaldosContasPorPeriodo.removeAt(index);
  void insertAtIndexInDadosSaldosContasPorPeriodo(
          int index, DTSaldoContaStruct item) =>
      dadosSaldosContasPorPeriodo.insert(index, item);
  void updateDadosSaldosContasPorPeriodoAtIndex(
          int index, Function(DTSaldoContaStruct) updateFn) =>
      dadosSaldosContasPorPeriodo[index] =
          updateFn(dadosSaldosContasPorPeriodo[index]);

  DTResumoContasAPagarReceberStruct? dadosContasAPagarReceberRetroativa;
  void updateDadosContasAPagarReceberRetroativaStruct(
      Function(DTResumoContasAPagarReceberStruct) updateFn) {
    updateFn(dadosContasAPagarReceberRetroativa ??=
        DTResumoContasAPagarReceberStruct());
  }

  ///  State fields for stateful widgets in this page.

  // State field(s) for PageView widget.
  PageController? pageViewController;

  int get pageViewCurrentIndex => pageViewController != null &&
          pageViewController!.hasClients &&
          pageViewController!.page != null
      ? pageViewController!.page!.round()
      : 0;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {}

  /// Action blocks.
  Future abAtualizaDashboard(BuildContext context) async {
    DTSaldoTotalOrgStruct? retSaldoTotalOrg;
    List<DTSaldoContaStruct>? retSaldoContas;
    DTDfcSinteticoStruct? retDFCSintetico;
    DTDreSinteticoStruct? retDRESintetico;
    List<dynamic>? retGraficoDFC;
    List<dynamic>? retGraficoDRE;
    DTResumoContasAPagarReceberStruct? retResumoContasPagarReceber;
    DTAlertasResumoStruct? retDadosAlertaDashboard;
    DTCartaoResumoStruct? retMelhorCartaoParaCompra;
    DTResumoSaudeCRStruct? retDadosResumoCR;
    List<DTSaldoContaStruct>? retSaldosContasPorPeriodo;
    DTResumoContasAPagarReceberStruct? retProjecaoTituloRetroativa;

    await Future.wait([
      Future(() async {
        retSaldoTotalOrg = await actions.getSaldoTotalOrg(
          FFAppState().currentOrganizationId,
        );
      }),
      Future(() async {
        retSaldoContas = await actions.getSaldosContas(
          FFAppState().currentOrganizationId,
        );
      }),
      Future(() async {
        retDFCSintetico = await actions.getDfcSintetico(
          FFAppState().currentOrganizationId,
          dataInicio!,
          dataFim!,
        );
      }),
      Future(() async {
        retDRESintetico = await actions.getDreSintetico(
          FFAppState().currentOrganizationId,
          dataInicio!,
          dataFim!,
        );
      }),
      Future(() async {
        retGraficoDFC = await actions.getGraficoDfc(
          FFAppState().currentOrganizationId,
          dataInicio!,
          dataFim!,
        );
      }),
      Future(() async {
        retGraficoDRE = await actions.getGraficoDre(
          FFAppState().currentOrganizationId,
          dataInicio!,
          dataFim!,
        );
      }),
      Future(() async {
        retResumoContasPagarReceber =
            await actions.getResumoContasAPagarReceber(
          FFAppState().currentOrganizationId,
        );
      }),
      Future(() async {
        retDadosAlertaDashboard = await actions.getAlertasDashboard(
          FFAppState().currentOrganizationId,
        );
        retMelhorCartaoParaCompra = await actions.getMelhorCartaoParaCompra(
          retDadosAlertaDashboard!.listaCartoes.toList(),
          0.0,
        );
      }),
      Future(() async {
        retDadosResumoCR = await actions.getResumoSaudeCR(
          FFAppState().currentOrganizationId,
          dataInicio!,
          dataFim!,
        );
      }),
      Future(() async {
        retSaldosContasPorPeriodo = await actions.getSaldosContasPorPeriodo(
          FFAppState().currentOrganizationId,
          dataInicio!,
          dataFim!,
        );
      }),
      Future(() async {
        retProjecaoTituloRetroativa =
            await actions.getProjecaoTitulosRetroativa(
          FFAppState().currentOrganizationId,
          dataFim!,
        );
      }),
    ]);
    dadosSaldoTotalOrg = retSaldoTotalOrg;
    dadosSaldoContas = retSaldoContas!.toList().cast<DTSaldoContaStruct>();
    dadosGraficoDFC = retGraficoDFC!.toList().cast<dynamic>();
    dadosGraficoDRE = retGraficoDRE!.toList().cast<dynamic>();
    dadosDRESintetico = retDRESintetico;
    dadosAlertaDashboard = retDadosAlertaDashboard;
    dadosMelhorCartaoParaCompra = retMelhorCartaoParaCompra;
    dadosDfcSintetico = retDFCSintetico;
    dadosResumoContasAPagarReceber = retResumoContasPagarReceber;
    dadosResumoSaudeCR = retDadosResumoCR;
    dadosSaldosContasPorPeriodo =
        retSaldosContasPorPeriodo!.toList().cast<DTSaldoContaStruct>();
    dadosContasAPagarReceberRetroativa = dadosResumoContasAPagarReceber;
  }
}
