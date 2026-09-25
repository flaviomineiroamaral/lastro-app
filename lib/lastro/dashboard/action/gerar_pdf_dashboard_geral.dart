// Automatic FlutterFlow imports
import '/backend/schema/structs/index.dart';
import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/custom_code/actions/index.dart'; // Imports other custom actions
import '/flutter_flow/custom_functions.dart'; // Imports custom functions
import 'package:flutter/material.dart';
import '/app_state.dart';
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:intl/intl.dart';

Future gerarPdfDashboardGeral(
  String? nomeInstituicao,
  String? tipoPerfilOrg,
  DTSaldoTotalOrgStruct? saldoTotal,
  List<DTSaldoContaStruct>? saldosContas,
  DTDfcSinteticoStruct? dfc,
  DTDreSinteticoStruct? dre,
  DTResumoContasAPagarReceberStruct?
      pagarReceber, // Este será alimentado pela nova RPC Retroativa
  DTResumoSaudeCRStruct? saudeCR,
  DTAlertasResumoStruct? alertas,
  DateTime? dataInicio,
  DateTime? dataFim,
  // NOTA: O parâmetro pendenciasMes foi APAGADO. Menos complexidade no FlutterFlow!
) async {
  final doc = pw.Document(version: PdfVersion.pdf_1_5, compress: true);

  final currencyFormatter =
      NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$');
  final percentFormatter = NumberFormat.decimalPattern('pt_BR');
  final dataHoraFormatter = DateFormat('dd/MM/yyyy HH:mm');
  final dataCurtaFormatter = DateFormat('dd/MM/yyyy');

  final corPrimaria = PdfColor.fromHex('#1a252f');
  final corAzul = PdfColor.fromHex('#2980b9');
  final corCredito = PdfColors.green700;
  final corDebito = PdfColors.red700;
  final corAlerta = PdfColors.orange700;
  final corCinzaFundo = PdfColors.grey100;

  final agora = DateTime.now();
  final dInicio = dataInicio ?? DateTime(agora.year, agora.month, 1);
  final dFim = dataFim ?? DateTime(agora.year, agora.month + 1, 0);

  final String instituicao =
      (nomeInstituicao == null || nomeInstituicao.trim().isEmpty)
          ? 'DASHBOARD CONSOLIDADO'
          : nomeInstituicao.toUpperCase();

  // DICIONÁRIO DINÂMICO MULTI-PERFIL
  String tPerfil = (tipoPerfilOrg ?? '').toUpperCase();
  bool isIgreja = tPerfil == 'IGREJA';
  bool isOng = tPerfil == 'OSC/ONG' || tPerfil == 'ONG' || tPerfil == 'OSC';
  bool isFamilia = tPerfil == 'FAMILIA' || tPerfil == 'FAMÍLIA';
  bool isNegocio = tPerfil == 'NEGOCIO' || tPerfil == 'NEGÓCIO' || tPerfil == 'INDUSTRIA' || tPerfil == 'INDÚSTRIA';

  String lblTituloDfc = (isIgreja || isOng) ? 'Arrecadação vs Queima' : (isFamilia ? 'Entradas vs Saídas' : 'Fluxo de Caixa (Giro)');
  String labelEntradas = isIgreja ? 'Dízimos/Ofertas (Líquido)' : (isOng ? 'Doações/Receitas' : 'Entradas (Líquidas)');
  String labelSaidas = (isIgreja || isOng) ? 'Despesas (Queima)' : 'Saídas (Queima:';
  String lblDRE = (isIgreja || isOng) ? 'Raio-X da Organização' : 'Raio-X do Mês';
  String lblDreReceita = isFamilia ? 'Receitas' : labelEntradas;
  String lblDreCusto = isFamilia ? 'Custo Operacional' : labelSaidas;
  String lblResultado = (isIgreja || isOng) ? 'Superávit / Déficit' : (isFamilia ? 'Sobra / Falta' : 'Resultado Líquido');

  final st = saldoTotal ?? DTSaldoTotalOrgStruct();
  final dtDfc = dfc ?? DTDfcSinteticoStruct();
  final dtDre = dre ?? DTDreSinteticoStruct();
  final pr = pagarReceber ?? DTResumoContasAPagarReceberStruct();
  final scr = saudeCR ?? DTResumoSaudeCRStruct();
  final alt = alertas ?? DTAlertasResumoStruct();
  
  List<DTSaldoContaStruct> listaContas = saldosContas ?? [];

  // ==========================================
  // INJEÇÃO: BUSCAR SALDOS EXATOS DO PERÍODO
  // ==========================================
  try {
    String orgId = FFAppState().currentOrganizationId;
    if (orgId.isNotEmpty) {
      final res = await SupaFlow.client.rpc(
        'obter_saldos_contas_por_periodo',
        params: {
          'p_org_id': orgId,
          'p_data_inicio': dInicio.toIso8601String(),
          'p_data_fim': dFim.toIso8601String()
        }
      );
      if (res != null && res is List) {
        listaContas = res.map((e) => DTSaldoContaStruct(
          contaId: e['conta_id']?.toString(),
          nomeConta: e['nome_conta']?.toString(),
          tipoConta: e['tipo_conta']?.toString(),
          saldoInicial: e['saldo_inicial'] != null ? double.tryParse(e['saldo_inicial'].toString()) : 0.0,
          totalEntradas: e['total_entradas'] != null ? double.tryParse(e['total_entradas'].toString()) : 0.0,
          totalSaidas: e['total_saidas'] != null ? double.tryParse(e['total_saidas'].toString()) : 0.0,
          saldoAtual: e['saldo_atual'] != null ? double.tryParse(e['saldo_atual'].toString()) : 0.0,
          diaFechamento: e['dia_fechamento'] != null ? int.tryParse(e['dia_fechamento'].toString()) : null,
          diaVencimento: e['dia_vencimento'] != null ? int.tryParse(e['dia_vencimento'].toString()) : null,
        )).toList();
      }
    }
  } catch (e) {
    debugPrint('Erro ao buscar saldos_contas_por_periodo no PDF: $e');
  }

  final contasBancarias = listaContas
      .where((c) =>
          (c.tipoConta ?? '').toUpperCase() != 'CARTAO' &&
          (c.tipoConta ?? '').toUpperCase() != 'CARTÃO' &&
          (c.tipoConta ?? '').toUpperCase() != 'VIRTUAL')
      .toList();

  final contasCartao = listaContas
      .where((c) =>
          (c.tipoConta ?? '').toUpperCase() == 'CARTAO' ||
          (c.tipoConta ?? '').toUpperCase() == 'CARTÃO')
      .toList();

  final dataHojeStr = dataCurtaFormatter.format(agora);
  final periodoStr =
      'Período: ${dataCurtaFormatter.format(dInicio)} a ${dataCurtaFormatter.format(dFim)}';

  // ==========================================
  // FILTRO DE VIAGEM NO TEMPO (PARADOXO TEMPORAL)
  // ==========================================
  bool isMesAnterior = (dFim.year < agora.year) ||
      (dFim.year == agora.year && dFim.month < agora.month);

  double caixaParaCalculo =
      isMesAnterior ? dtDfc.saldoFinal : st.saldoDisponivelReal;
  String labelCaixaMetrica =
      isMesAnterior ? 'Caixa (Fim do Período)' : 'Disponível Real (Hoje)';

  // O rótulo dinâmico da fatura
  String labelVencimentoMeio = isMesAnterior
      ? 'Vence na Emissão (${dataCurtaFormatter.format(dFim)})'
      : 'Vence Hoje ($dataHojeStr)';

  // ==========================================
  // CÁLCULO DE BURN RATE DO PERÍODO
  // ==========================================
  double burnRatePeriodo = 0.0;
  if (dtDfc.totalEntradas > 0) {
    burnRatePeriodo = dtDfc.totalSaidas / dtDfc.totalEntradas;
  } else if (dtDfc.totalSaidas > 0) {
    burnRatePeriodo = 1.0;
  }

  final corSolvencia = st.isInsolvente
      ? corDebito
      : (burnRatePeriodo > 1.0 ? corAlerta : corCredito);
  final corFundoSolvencia = st.isInsolvente
      ? PdfColors.red50
      : (burnRatePeriodo > 1.0 ? PdfColors.orange50 : PdfColors.green50);
  final statusSolvenciaText = st.statusSolvencia.isNotEmpty
      ? st.statusSolvencia
      : 'Diagnóstico de Solvência';

  String msgSolvenciaText = '';
  if (st.isInsolvente) {
    msgSolvenciaText =
        'INSOLVÊNCIA TÉCNICA: Mesmo com o dinheiro no banco, há um buraco de ${currencyFormatter.format(st.resumoAtivoPassivo.abs())}. O caixa já pertence aos credores. Entre em regime de guerra: corte despesas e foque na arrecadação imediata.';
  } else if (!st.isInsolvente && burnRatePeriodo > 1.0) {
    msgSolvenciaText =
        'DESCAPITALIZAÇÃO: A solvência é positiva (${currencyFormatter.format(st.resumoAtivoPassivo)}), mas a máquina está a inchar neste período (Queima > 100%). O custo fixo está corroendo o patrimônio. Freie a expansão de novos gastos.';
  } else {
    msgSolvenciaText =
        'SUPERÁVIT REAL: Solvência forte (${currencyFormatter.format(st.resumoAtivoPassivo)}) e máquina eficiente. Momento ideal para expansões físicas, infraestrutura ou aumento de repasses.';
  }

  double pagarCurto = pr.toMap().containsKey('totalPagarVencerCurtoPrazo') ? (pr.toMap()['totalPagarVencerCurtoPrazo'] as num).toDouble() : pr.totalPagarVencer;
  double pagarLongo = pr.toMap().containsKey('totalPagarVencerLongoPrazo') ? (pr.toMap()['totalPagarVencerLongoPrazo'] as num).toDouble() : 0.0;
  double receberCurto = pr.toMap().containsKey('totalReceberVencerCurtoPrazo') ? (pr.toMap()['totalReceberVencerCurtoPrazo'] as num).toDouble() : pr.totalReceberVencer;
  double receberLongo = pr.toMap().containsKey('totalReceberVencerLongoPrazo') ? (pr.toMap()['totalReceberVencerLongoPrazo'] as num).toDouble() : 0.0;

  // ==========================================
  // PENTE FINO: ALGORITMO CONSOLIDADO DE BREAK-EVEN
  // ==========================================

  // A Dívida e Receita exigível do mês é exatamente a soma do Atrasado com o Vence no Dia.
  // Graças à nova RPC, o 'pr' já tem a fotografia perfeita do passado.
  double dividaFornecedoresMes = pr.totalPagarAtrasado + pr.totalPagarHoje;
  double receitasPrevistasMes = pr.totalReceberAtrasado + pr.totalReceberHoje;

  double dividaCartoesMes = contasCartao.fold(
      0.0, (sum, c) => sum + (c.saldoAtual < 0 ? c.saldoAtual.abs() : 0.0));
  double dividaTotalCorrente = dividaFornecedoresMes + dividaCartoesMes;

  // ALERTA 1: ALVO DE ARRECADAÇÃO
  double esforcoCaixaReal =
      dividaTotalCorrente - (caixaParaCalculo + receitasPrevistasMes);
  String msgAlvoArrecadacao = '';
  PdfColor corAlertaMeta = PdfColors.black;

  if (esforcoCaixaReal > 0) {
    msgAlvoArrecadacao =
        'ALVO DE ARRECADAÇÃO (FECHO DO MÊS): O saldo em caixa somado às previsões de recebimento não é suficiente para quitar as obrigações deste período. É necessário gerar ${currencyFormatter.format(esforcoCaixaReal)} em novas receitas (arrecadação extra) para não fechar o mês no vermelho.';
    corAlertaMeta = corDebito;
  } else {
    msgAlvoArrecadacao =
        'PONTO DE EQUILÍBRIO ATINGIDO: O caixa atual somado aos recebimentos agendados já garante o pagamento de 100% da operação do mês. O que entrar extra é Superávit Livre para investimento.';
    corAlertaMeta = PdfColors.green800;
  }

  // ALERTA 2: TRAVA DE COMPRAS
  bool isCaixaCongelado = dividaTotalCorrente > caixaParaCalculo;
  final String msgTravaCompras = isCaixaCongelado
      ? 'TRAVA DE COMPRAS (LIQUIDEZ CRÍTICA): O dinheiro em caixa (${currencyFormatter.format(caixaParaCalculo)}) não é suficiente para pagar as obrigações ativas do mês (${currencyFormatter.format(dividaTotalCorrente)}). PROIBIDO assumir novos compromissos.'
      : 'CAIXA LIVRE: O saldo em caixa (${currencyFormatter.format(caixaParaCalculo)}) é maior que as dívidas do mês (${currencyFormatter.format(dividaTotalCorrente)}). Operação segura.';

  // ALERTA 3: ALAVANCAGEM DE CARTÃO
  double limiteSeguro = caixaParaCalculo > 0 ? caixaParaCalculo * 0.30 : 0.0;
  bool isAlavancadoLocal = dividaCartoesMes > limiteSeguro;
  final String msgAlavancagem = isAlavancadoLocal
      ? 'ALERTA DE ALAVANCAGEM: A dívida de cartões de crédito (${currencyFormatter.format(dividaCartoesMes)}) está acima da margem de segurança do caixa livre (${currencyFormatter.format(limiteSeguro)}). A operação está perigosamente financiada por dívida.'
      : 'CRÉDITO SAUDÁVEL: O uso de cartões de crédito (${currencyFormatter.format(dividaCartoesMes)}) está protegido por liquidez. (Abaixo do teto seguro de ${currencyFormatter.format(limiteSeguro)}).';

  // ALERTA 4: DEPENDÊNCIA DE RECEBÍVEIS
  String msgRiscoRecebiveis = '';
  if (isCaixaCongelado && receitasPrevistasMes > 0) {
    msgRiscoRecebiveis =
        'RISCO DE INADIMPLÊNCIA: Como o caixa disponível não cobre as contas, dependemos da entrada exata dos ${currencyFormatter.format(receitasPrevistasMes)} agendados para fechar o mês. Monitore atrasos e inadimplência diariamente.';
  } else if (!isCaixaCongelado && receitasPrevistasMes > 0) {
    msgRiscoRecebiveis =
        'EFICIÊNCIA DE FLUXO: Existem ${currencyFormatter.format(receitasPrevistasMes)} agendados para entrar. Como a operação já está coberta, esse valor irá integralmente para o crescimento do patrimônio.';
  }

  doc.addPage(
    pw.MultiPage(
      pageFormat: PdfPageFormat.a4,
      margin: const pw.EdgeInsets.all(32),
      header: (context) => pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            crossAxisAlignment: pw.CrossAxisAlignment.center,
            children: [
              pw.Expanded(
                child: pw.Text(instituicao,
                    style: pw.TextStyle(
                        fontSize: 18,
                        fontWeight: pw.FontWeight.bold,
                        color: corPrimaria)),
              ),
              pw.Text('LASTRO',
                  style: pw.TextStyle(
                      fontSize: 14,
                      fontWeight: pw.FontWeight.bold,
                      color: PdfColors.grey500)),
            ],
          ),
          pw.SizedBox(height: 4),
          pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Text('Relatório de Posição Financeira e Operacional',
                    style: pw.TextStyle(
                        fontSize: 10, color: PdfColors.grey700)),
                pw.Container(
                  padding:
                      const pw.EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: pw.BoxDecoration(
                      color: PdfColors.grey100,
                      borderRadius: pw.BorderRadius.circular(4),
                      border:
                          pw.Border.all(color: PdfColors.grey300, width: 0.5)),
                  child: pw.Text(periodoStr,
                      style: pw.TextStyle(
                          fontSize: 10,
                          fontWeight: pw.FontWeight.bold,
                          color: corPrimaria)),
                ),
              ]),
          pw.SizedBox(height: 15),
        ],
      ),
      footer: (context) => pw.Container(
        alignment: pw.Alignment.centerRight,
        margin: const pw.EdgeInsets.only(top: 10),
        padding: const pw.EdgeInsets.only(top: 5),
        decoration: const pw.BoxDecoration(
            border: pw.Border(top: pw.BorderSide(color: PdfColors.grey300))),
        child: pw.Text(
            'Gerado em: ${dataHoraFormatter.format(DateTime.now())} | Página ${context.pageNumber} de ${context.pagesCount}',
            style: pw.TextStyle(fontSize: 8, color: PdfColors.grey600)),
      ),
      build: (context) => [
        // 0. DIAGNÓSTICO EXECUTIVO
        pw.Container(
            width: double.infinity,
            padding: const pw.EdgeInsets.all(12),
            decoration: pw.BoxDecoration(
              color: corFundoSolvencia,
              border: pw.Border.all(color: corSolvencia, width: 1.5),
              borderRadius: pw.BorderRadius.circular(0),
            ),
            child: pw.Row(children: [
              pw.Expanded(
                  flex: 3,
                  child: pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text(statusSolvenciaText,
                            style: pw.TextStyle(
                                fontSize: 12,
                                fontWeight: pw.FontWeight.bold,
                                color: corSolvencia)),
                        pw.SizedBox(height: 4),
                        pw.Text(msgSolvenciaText,
                            style: pw.TextStyle(
                                fontSize: 9, color: PdfColors.black)),
                      ])),
              pw.Expanded(
                  flex: 1,
                  child: pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.end,
                      children: [
                        pw.Text('Bens/Ativos: ${currencyFormatter.format(st.toMap().containsKey('totalAtivos') ? st.toMap()['totalAtivos'] : 0.0)}',
                            style: pw.TextStyle(
                                fontSize: 8, color: PdfColors.grey700)),
                        pw.Text('(-) Dívidas: ${currencyFormatter.format(st.toMap().containsKey('totalPassivos') ? st.toMap()['totalPassivos'] : 0.0)}',
                            style: pw.TextStyle(
                                fontSize: 8, color: PdfColors.grey700)),
                        pw.SizedBox(height: 10),
                        pw.Text('Capital Líquido',
                            style: pw.TextStyle(
                                fontSize: 9, fontWeight: pw.FontWeight.bold, color: PdfColors.black)),
                        pw.Text(currencyFormatter.format(st.resumoAtivoPassivo),
                            style: pw.TextStyle(
                                fontSize: 14,
                                fontWeight: pw.FontWeight.bold,
                                color: corSolvencia)),
                      ]))
            ])),
        pw.SizedBox(height: 20),

        // 4. SAÚDE DOS CRs E ALERTAS INTELIGENTES
        pw.Row(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
          pw.Expanded(
              child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                pw.Text('SAÚDE E OFENSORES (Categorias)',
                    style: pw.TextStyle(
                        fontSize: 12,
                        fontWeight: pw.FontWeight.bold,
                        color: corAzul)),
                pw.Divider(color: PdfColors.grey300),
                pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceAround,
                    children: [
                      _buildPontoSaude('Superávit', scr.qtdVerde, corCredito),
                      _buildPontoSaude('Atenção', scr.qtdAmarelo, corAlerta),
                      _buildPontoSaude('Déficit', scr.qtdVermelho, corDebito),
                    ])
              ])),
          pw.SizedBox(width: 20),
          pw.Expanded(
              child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                pw.Text('PRESCRIÇÕES & ALERTAS',
                    style: pw.TextStyle(
                        fontSize: 12,
                        fontWeight: pw.FontWeight.bold,
                        color: corAzul)),
                pw.Divider(color: PdfColors.grey300),
                _buildAlertaInteligente(
                    msgAlvoArrecadacao, corAlertaMeta, corAlertaMeta),
                _buildAlertaInteligente(
                    msgTravaCompras,
                    isCaixaCongelado ? corDebito : corCredito,
                    isCaixaCongelado ? corDebito : PdfColors.green800),
                _buildAlertaInteligente(
                    msgAlavancagem,
                    isAlavancadoLocal ? corAlerta : corCredito,
                    isAlavancadoLocal ? corAlerta : PdfColors.grey800),
                if (msgRiscoRecebiveis.isNotEmpty)
                  _buildAlertaInteligente(
                      msgRiscoRecebiveis,
                      isCaixaCongelado ? corAlerta : corAzul,
                      isCaixaCongelado ? corAlerta : corAzul),
              ]))
        ]),
pw.SizedBox(height: 20),

        // 1. FLUXO DO PERÍODO E LIQUIDEZ
        pw.Text('1. FLUXO DO PERÍODO E LIQUIDEZ',
            style: pw.TextStyle(
                fontSize: 12, fontWeight: pw.FontWeight.bold, color: corAzul)),
        pw.Divider(color: PdfColors.grey300),
        pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          children: [
            _buildCaixaMetrica(
                'Saldo Inicial (Período)',
                currencyFormatter.format(dtDfc.saldoInicial),
                PdfColors.black,
                corCinzaFundo),
            _buildCaixaMetrica(
                'Entradas (Período)',
                currencyFormatter.format(dtDfc.totalEntradas),
                corCredito,
                corCinzaFundo),
            _buildCaixaMetrica(
                'Saídas (Período)',
                currencyFormatter.format(dtDfc.totalSaidas),
                corDebito,
                corCinzaFundo,
                subtitulo:
                    'Queima: ${(burnRatePeriodo * 100).toStringAsFixed(1)}%',
                corSub: burnRatePeriodo > 1.0 ? corDebito : PdfColors.grey600),
            _buildCaixaMetrica(
                labelCaixaMetrica,
                currencyFormatter.format(caixaParaCalculo),
                corPrimaria,
                PdfColors.blue50),
          ],
        ),
        pw.SizedBox(height: 20),

        // 2. PERFORMANCE (DRE & DFC)
        pw.Text('PERFORMANCE E LIQUIDEZ',
            style: pw.TextStyle(
                fontSize: 12, fontWeight: pw.FontWeight.bold, color: corAzul)),
        pw.Divider(color: PdfColors.grey300),
        pw.Row(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Expanded(
              child: pw.Container(
                padding: const pw.EdgeInsets.all(10),
                decoration: pw.BoxDecoration(
                    border: pw.Border.all(color: PdfColors.grey300),
                    borderRadius: pw.BorderRadius.circular(4)),
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text(lblDRE,
                        style: pw.TextStyle(
                            fontSize: 10, fontWeight: pw.FontWeight.bold)),
                    pw.SizedBox(height: 8),
                    _buildLinhaResumo(
                        lblDreReceita,
                        currencyFormatter.format(dtDre.totalReceitas),
                        PdfColors.black),
                    _buildLinhaResumo(
                        lblDreCusto,
                        currencyFormatter.format(dtDre.toMap().containsKey('somaDespesasOperacionais') ? dtDre.toMap()['somaDespesasOperacionais'] : dtDre.totalDespesas),
                        PdfColors.black),
                    if (dtDre.toMap().containsKey('resultadoOperacional')) ...[
                      pw.Divider(color: PdfColors.grey300, thickness: 0.5),
                      _buildLinhaResumo(
                          'Res. Operacional',
                          currencyFormatter.format(dtDre.toMap()['resultadoOperacional']),
                          PdfColors.black,
                          isBold: true),
                    ],
                    if (dtDre.toMap().containsKey('somaDespesasFinanceiras') && (dtDre.toMap()['somaDespesasFinanceiras'] as num) > 0) ...[
                      pw.SizedBox(height: 4),
                      _buildLinhaResumo(
                          '(-) Custo Fin. (Juros)',
                          currencyFormatter.format(dtDre.toMap()['somaDespesasFinanceiras']),
                          corDebito),
                    ],
                    pw.Divider(color: PdfColors.grey300, thickness: 0.5),
                    _buildLinhaResumo(
                        lblResultado,
                        currencyFormatter.format(dtDre.resultadoLiquido),
                        dtDre.resultadoLiquido >= 0 ? corCredito : corDebito,
                        isBold: true),
                    pw.SizedBox(height: 4),
                    pw.Text(
                        'Margem: ${percentFormatter.format(dtDre.margemLucro)}%',
                        style: pw.TextStyle(
                            fontSize: 9, color: PdfColors.grey700)),
                  ],
                ),
              ),
            ),
            pw.SizedBox(width: 10),
            pw.Expanded(
              child: pw.Container(
                padding: const pw.EdgeInsets.all(10),
                decoration: pw.BoxDecoration(
                    border: pw.Border.all(color: PdfColors.grey300),
                    borderRadius: pw.BorderRadius.circular(4)),
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text(lblTituloDfc,
                        style: pw.TextStyle(
                            fontSize: 10, fontWeight: pw.FontWeight.bold)),
                    pw.SizedBox(height: 8),

                    _buildLinhaResumo(
                        labelEntradas,
                        currencyFormatter.format(dtDfc.totalEntradas),
                        corCredito),
                    _buildLinhaResumo('$labelSaidas ${(burnRatePeriodo * 100).toStringAsFixed(1)}%)',
                        currencyFormatter.format(dtDfc.totalSaidas), corDebito),
                    pw.Divider(color: PdfColors.grey300, thickness: 0.5),
                    _buildLinhaResumo(
                        'Geração de Caixa',
                        currencyFormatter.format(dtDfc.geracaoCaixa),
                        dtDfc.geracaoCaixa >= 0 ? corCredito : corDebito,
                        isBold: true),
                    pw.SizedBox(height: 4),
                    pw.Text(
                        'Saldo Final: ${currencyFormatter.format(dtDfc.saldoFinal)}',
                        style: pw.TextStyle(
                            fontSize: 9,
                            fontWeight: pw.FontWeight.bold,
                            color: PdfColors.black)),
                  ],
                ),
              ),
            ),
          ],
        ),
        pw.SizedBox(height: 20),

        // 3. PROJEÇÃO A PAGAR E RECEBER
        pw.Text('PROJEÇÃO DE OBRIGAÇÕES',
            style: pw.TextStyle(
                fontSize: 12, fontWeight: pw.FontWeight.bold, color: corAzul)),
        pw.Divider(color: PdfColors.grey300),
        pw.Row(
          children: [
            pw.Expanded(
              child: _buildBlocoProjecao(
                  'TOTAL A PAGAR (PASSIVO)',
                  pr.totalPagar,
                  pr.totalPagarAtrasado,
                  pr.totalPagarHoje,
                  pagarCurto,
                  pagarLongo,
                  corDebito,
                  corAlerta,
                  currencyFormatter,
                  labelVencimentoMeio),
            ),
            pw.SizedBox(width: 10),
            pw.Expanded(
              child: _buildBlocoProjecao(
                  'TOTAL A RECEBER (ATIVO)',
                  pr.totalReceber,
                  pr.totalReceberAtrasado,
                  pr.totalReceberHoje,
                  receberCurto,
                  receberLongo,
                  corCredito,
                  corAlerta,
                  currencyFormatter,
                  labelVencimentoMeio),
            ),
          ],
        ),
        pw.SizedBox(height: 20),

        
        pw.SizedBox(height: 20),

        // 5.1 COMPOSIÇÃO DOS SALDOS
        pw.Header(
          level: 1,
          decoration: const pw.BoxDecoration(),
          margin: const pw.EdgeInsets.only(bottom: 8),
          child: pw.Text('5.1 COMPOSIÇÃO DOS SALDOS (Bancos e Cofre)',
              style: pw.TextStyle(
                  fontSize: 12,
                  fontWeight: pw.FontWeight.bold,
                  color: corAzul)),
        ),
        pw.TableHelper.fromTextArray(
          headers: [
            'Conta',
            'Tipo',
            'Saldo Inicial',
            'Entradas',
            'Saídas',
            'Saldo Atual'
          ],
          columnWidths: {
            0: const pw.FlexColumnWidth(2.5),
            1: const pw.FlexColumnWidth(1.5),
            2: const pw.FlexColumnWidth(2),
            3: const pw.FlexColumnWidth(1.5),
            4: const pw.FlexColumnWidth(1.5),
            5: const pw.FlexColumnWidth(2),
          },
          border: const pw.TableBorder(
            horizontalInside:
                pw.BorderSide(width: 0.5, color: PdfColors.grey300),
            bottom: pw.BorderSide(width: 1, color: PdfColors.grey800),
            top: pw.BorderSide(width: 1, color: PdfColors.grey800),
          ),
          headerStyle: pw.TextStyle(
              fontWeight: pw.FontWeight.bold,
              fontSize: 8,
              color: PdfColors.black),
          headerDecoration: const pw.BoxDecoration(color: PdfColors.grey100),
          headerAlignments: {
            0: pw.Alignment.centerLeft,
            1: pw.Alignment.centerLeft,
            2: pw.Alignment.centerRight,
            3: pw.Alignment.centerRight,
            4: pw.Alignment.centerRight,
            5: pw.Alignment.centerRight,
          },
          cellStyle: pw.TextStyle(fontSize: 8),
          cellAlignments: {
            0: pw.Alignment.centerLeft,
            1: pw.Alignment.centerLeft,
            2: pw.Alignment.centerRight,
            3: pw.Alignment.centerRight,
            4: pw.Alignment.centerRight,
            5: pw.Alignment.centerRight,
          },
          data: contasBancarias.map((conta) {
            double valSaldoInicial = 0.0;
            try {
              valSaldoInicial = conta.saldoInicial ?? 0.0;
            } catch (e) {
              valSaldoInicial = 0.0;
            }

            return [
              conta.nomeConta,
              conta.tipoConta,
              currencyFormatter.format(valSaldoInicial),
              currencyFormatter.format(conta.totalEntradas),
              currencyFormatter.format(conta.totalSaidas),
              currencyFormatter.format(conta.saldoAtual),
            ];
          }).toList(),
        ),

        // 5.2 CONSOLIDAÇÃO DE CARTÕES DE CRÉDITO
        if (contasCartao.isNotEmpty) ...[
          pw.SizedBox(height: 20),
          pw.Header(
            level: 2,
            textStyle: pw.TextStyle(
                fontSize: 12, fontWeight: pw.FontWeight.bold, color: corDebito),
            decoration: const pw.BoxDecoration(),
            margin: const pw.EdgeInsets.only(bottom: 8),
            child: pw.Text('5.2 FATURAS DE CARTÃO DE CRÉDITO (Passivo)',
                style: pw.TextStyle(
                    fontSize: 12,
                    fontWeight: pw.FontWeight.bold,
                    color: corDebito)),
          ),
          pw.TableHelper.fromTextArray(
            headers: [
              'Cartão / Emissor',
              'Limite\nRestante',
              'Encargos /\nSaídas',
              'Pagamentos /\nBaixas',
              'Fatura Atual\n(Dívida)'
            ],
            columnWidths: {
              0: const pw.FlexColumnWidth(2.5),
              1: const pw.FlexColumnWidth(1.5),
              2: const pw.FlexColumnWidth(1.5),
              3: const pw.FlexColumnWidth(1.5),
              4: const pw.FlexColumnWidth(1.5),
            },
            border: const pw.TableBorder(
              horizontalInside:
                  pw.BorderSide(width: 0.5, color: PdfColors.grey300),
              bottom: pw.BorderSide(width: 1, color: PdfColors.red800),
              top: pw.BorderSide(width: 1, color: PdfColors.red800),
            ),
            headerStyle: pw.TextStyle(
                fontWeight: pw.FontWeight.bold, fontSize: 8, color: corDebito),
            headerDecoration: const pw.BoxDecoration(color: PdfColors.red50),
            headerAlignments: {
              0: pw.Alignment.centerLeft,
              1: pw.Alignment.centerRight,
              2: pw.Alignment.centerRight,
              3: pw.Alignment.centerRight,
              4: pw.Alignment.centerRight,
            },
            cellStyle: pw.TextStyle(fontSize: 9),
            cellAlignments: {
              0: pw.Alignment.centerLeft,
              1: pw.Alignment.centerRight,
              2: pw.Alignment.centerRight,
              3: pw.Alignment.centerRight,
              4: pw.Alignment.centerRight,
            },
            data: contasCartao.map((conta) {
              double limiteIndividual = 0.0;
              double limiteTotal = 0.0;
              if (alt.listaCartoes.isNotEmpty) {
                try {
                  final cartaoDetalhe = alt.listaCartoes.firstWhere((c) =>
                      c.nome.toLowerCase().trim() ==
                      (conta.nomeConta ?? '').toLowerCase().trim());
                  limiteIndividual = cartaoDetalhe.limiteRestante;
                  limiteTotal = cartaoDetalhe.toMap().containsKey('limiteTotal') ? (cartaoDetalhe.toMap()['limiteTotal'] as num).toDouble() : 0.0;
                } catch (e) {
                  debugPrint('Cartão não encontrado: ${conta.nomeConta}');
                }
              }

              return [
                conta.nomeConta,
                '${currencyFormatter.format(limiteTotal)}\n${currencyFormatter.format(limiteIndividual)}',
                currencyFormatter.format(conta.totalSaidas),
                currencyFormatter.format(conta.totalEntradas),
                currencyFormatter.format(conta.saldoAtual),
              ];
            }).toList(),
          ),
        ]
      ],
    ),
  );

  final bytes = await doc.save();
  await Printing.sharePdf(
    bytes: bytes,
    filename:
        'LASTRO_Dashboard_${dataCurtaFormatter.format(dInicio).replaceAll('/', '-')}_a_${dataCurtaFormatter.format(dFim).replaceAll('/', '-')}.pdf',
  );
}

// ==========================================
// FUNÇÕES AUXILIARES DE DESIGN (Widgets PDF)
// ==========================================

pw.Widget _buildCaixaMetrica(
    String titulo, String valor, PdfColor corTexto, PdfColor corFundo,
    {String subtitulo = '', PdfColor corSub = PdfColors.grey600}) {
  return pw.Expanded(
    child: pw.Container(
      margin: const pw.EdgeInsets.symmetric(horizontal: 4),
      padding: const pw.EdgeInsets.all(10),
      decoration: pw.BoxDecoration(
        color: corFundo,
        borderRadius: pw.BorderRadius.circular(0),
        border: pw.Border.all(color: PdfColors.grey300, width: 0.5),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.center,
        mainAxisAlignment: pw.MainAxisAlignment.center,
        children: [
          pw.Text(titulo,
              style: pw.TextStyle(fontSize: 8, color: PdfColors.grey700),
              textAlign: pw.TextAlign.center),
          pw.SizedBox(height: 6),
          pw.Text(valor,
              style: pw.TextStyle(
                  fontSize: 11,
                  fontWeight: pw.FontWeight.bold,
                  color: corTexto),
              textAlign: pw.TextAlign.center),
          pw.SizedBox(height: 4),
          pw.Opacity(
              opacity: subtitulo.isNotEmpty ? 1.0 : 0.0,
              child: pw.Text(subtitulo.isNotEmpty ? subtitulo : 'Queima: 0.0%',
                  style: pw.TextStyle(fontSize: 7, color: corSub),
                  textAlign: pw.TextAlign.center)),
        ],
      ),
    ),
  );
}

pw.Widget _buildLinhaResumo(String label, String valor, PdfColor corValor,
    {bool isBold = false}) {
  return pw.Padding(
    padding: const pw.EdgeInsets.symmetric(vertical: 2),
    child: pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
      children: [
        pw.Text(label,
            style: pw.TextStyle(fontSize: 9, color: PdfColors.grey800)),
        pw.Text(valor,
            style: pw.TextStyle(
                fontSize: 9,
                fontWeight: isBold ? pw.FontWeight.bold : pw.FontWeight.normal,
                color: corValor)),
      ],
    ),
  );
}

pw.Widget _buildAlertaInteligente(
    String texto, PdfColor corMarcador, PdfColor corTexto) {
  return pw.Padding(
    padding: const pw.EdgeInsets.only(bottom: 6),
    child: pw.Row(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Container(
          margin: const pw.EdgeInsets.only(top: 3, right: 6),
          width: 4,
          height: 4,
          decoration:
              pw.BoxDecoration(color: corMarcador, shape: pw.BoxShape.circle),
        ),
        pw.Expanded(
          child:
              pw.Text(texto, style: pw.TextStyle(fontSize: 8, color: corTexto)),
        ),
      ],
    ),
  );
}

pw.Widget _buildBlocoProjecao(
    String titulo,
    double total,
    double atrasado,
    double hoje,
      double curto,
      double longo,
    PdfColor corBase,
    PdfColor corAtraso,
    NumberFormat formatter,
    String labelMeio) {
  String pctAtrasado =
      total > 0 ? '${((atrasado / total) * 100).toStringAsFixed(1)}%' : '0%';
  String pctHoje =
      total > 0 ? '${((hoje / total) * 100).toStringAsFixed(1)}%' : '0%';
  String pctCurto =
        total > 0 ? '%' : '0%';
    String pctLongo =
        total > 0 ? '%' : '0%';

  return pw.Container(
    decoration: pw.BoxDecoration(
      border: pw.Border.all(color: PdfColors.grey300, width: 0.5),
      borderRadius: pw.BorderRadius.circular(0),
    ),
    child: pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.stretch,
      children: [
        pw.Container(
          padding: const pw.EdgeInsets.all(8),
          decoration: pw.BoxDecoration(
            color: PdfColors.grey100,
            borderRadius:
                const pw.BorderRadius.vertical(top: pw.Radius.circular(6)),
            border:
                pw.Border(bottom: pw.BorderSide(color: corBase, width: 1.5)),
          ),
          child: pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Text('TOTAL ${titulo.toUpperCase()}',
                  style: pw.TextStyle(
                      fontSize: 9,
                      fontWeight: pw.FontWeight.bold,
                      color: corBase)),
              pw.Text(formatter.format(total),
                  style: pw.TextStyle(
                      fontSize: 12,
                      fontWeight: pw.FontWeight.bold,
                      color: corBase)),
            ],
          ),
        ),
        pw.Padding(
          padding: const pw.EdgeInsets.all(10),
          child: pw.Column(
            children: [
              _buildLinhaProjecaoDetalhe(
                  'Vencido (Atrasado)',
                  formatter.format(atrasado),
                  pctAtrasado,
                  atrasado > 0 ? corAtraso : PdfColors.grey600),
              pw.SizedBox(height: 6),
              _buildLinhaProjecaoDetalhe(labelMeio, formatter.format(hoje),
                  pctHoje, hoje > 0 ? PdfColors.orange700 : PdfColors.grey600),
              pw.SizedBox(height: 6),
              _buildLinhaProjecaoDetalhe('A Vencer (Até 1 Ano)',
                  formatter.format(curto), pctCurto, PdfColors.black),
              pw.SizedBox(height: 6),
              _buildLinhaProjecaoDetalhe('Longo Prazo (> 1 Ano)',
                  formatter.format(longo), pctLongo, PdfColors.black),
            ],
          ),
        ),
      ],
    ),
  );
}

pw.Widget _buildLinhaProjecaoDetalhe(
    String label, String valor, String pct, PdfColor cor) {
  return pw.Row(
    children: [
      pw.Expanded(
        flex: 3,
        child: pw.Text(label,
            style: pw.TextStyle(fontSize: 9, color: PdfColors.grey800)),
      ),
      pw.Expanded(
        flex: 3,
        child: pw.Text(valor,
            textAlign: pw.TextAlign.right,
            style: pw.TextStyle(
                fontSize: 9, fontWeight: pw.FontWeight.bold, color: cor)),
      ),
      pw.Expanded(
          flex: 1,
          child: pw.Container(
              alignment: pw.Alignment.centerRight,
              child: pw.Text(pct,
                  style: pw.TextStyle(
                      fontSize: 7, color: PdfColors.grey500)))),
    ],
  );
}

pw.Widget _buildPontoSaude(String label, int quantidade, PdfColor cor) {
  return pw.Column(children: [
    pw.Container(
      width: 16,
      height: 16,
      decoration: pw.BoxDecoration(color: cor, shape: pw.BoxShape.circle),
    ),
    pw.SizedBox(height: 4),
    pw.Text('$quantidade CRs',
        style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold)),
    pw.Text(label,
        style: pw.TextStyle(fontSize: 8, color: PdfColors.grey700)),
  ]);
}
