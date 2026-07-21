// Automatic FlutterFlow imports
import '/backend/schema/structs/index.dart';
import '/flutter_flow/flutter_flow_util.dart';
// Imports other custom actions
// Imports custom functions
import 'package:flutter/material.dart';
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:intl/intl.dart';

Future gerarPdfBalanceteCR(
  String? nomeInstituicao, // NOVO: Parâmetro para o nome da organização
  DateTime dataInicio,
  DateTime dataFim,
  double saldoAnterior,
  double resultadoExercicio,
  double disponibilidadeCaixa,
  DTCrSinteticoStruct fundoGeral,
  List<DTCrAnaliticoStruct> ministerios,
) async {
  if (ministerios.isEmpty) {
    debugPrint('Aviso: Nenhum CR para imprimir.');
    return;
  }

  // Otimização e Compressão
  final pdf = pw.Document(version: PdfVersion.pdf_1_5, compress: true);

  final currencyFormatter =
      NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$');
  final dateFormatter = DateFormat('dd/MM/yyyy');

  // Paleta de cores otimizada para impressão
  final corPrimaria = PdfColor.fromHex('#1a252f');
  final corCredito = PdfColors.green800;
  final corDebito = PdfColors.red800;
  final corAlerta = PdfColors.orange800;
  final corInformativa = PdfColor.fromHex('#4B39EF'); // Azul (Reservas)
  final corSubsidioRecebido = PdfColor.fromHex('#4B39EF'); // Azul (Recebido)
  final corSubsidioConcedido =
      PdfColor.fromHex('#D35400'); // Laranja (Concedido)

  // Tratamento do nome da Instituição (Fallback de segurança)
  final String instituicao =
      (nomeInstituicao == null || nomeInstituicao.trim().isEmpty)
          ? 'BALANCETE CONSOLIDADO'
          : nomeInstituicao.toUpperCase();

  // Cálculos do Fundo Geral alinhados com o novo motor lógico
  final bool isUsandoReservas =
      fundoGeral.subsidiosAlocados > fundoGeral.totalArrecadado;
  double indiceRepasse = 0.0;

  if (fundoGeral.totalArrecadado > 0) {
    indiceRepasse =
        (fundoGeral.subsidiosAlocados / fundoGeral.totalArrecadado) * 100;
  } else if (fundoGeral.subsidiosAlocados > 0) {
    indiceRepasse = 100.0;
  }

  pdf.addPage(
    pw.MultiPage(
      pageFormat: PdfPageFormat.a4,
      margin: const pw.EdgeInsets.all(32),
      build: (pw.Context context) {
        return [
          // ==========================================
          // 1. CABEÇALHO
          // ==========================================
          pw.Header(
            level: 0,
            child: pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    // Nome da Instituição em destaque (Padrão Ouro)
                    pw.Text(
                      instituicao,
                      style: pw.TextStyle(
                          fontSize: 18,
                          fontWeight: pw.FontWeight.bold,
                          color: corPrimaria),
                    ),
                    pw.SizedBox(height: 2),
                    pw.Text(
                      'Balancete Consolidado de Centros de Resultado',
                      style: pw.TextStyle(
                          fontSize: 12,
                          fontWeight: pw.FontWeight.bold,
                          color: PdfColors.grey800),
                    ),
                    pw.SizedBox(height: 4),
                    pw.Container(
                      padding: const pw.EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: pw.BoxDecoration(
                          color: PdfColors.grey100,
                          borderRadius: pw.BorderRadius.circular(4),
                          border: pw.Border.all(
                              color: PdfColors.grey300, width: 0.5)),
                      child: pw.Text(
                        'Período: ${dateFormatter.format(dataInicio)} a ${dateFormatter.format(dataFim)}',
                        style: pw.TextStyle(
                            fontSize: 10,
                            fontWeight: pw.FontWeight.bold,
                            color: corPrimaria),
                      ),
                    ),
                  ],
                ),
                pw.Text('LASTRO',
                    style: pw.TextStyle(
                        fontSize: 14,
                        fontWeight: pw.FontWeight.bold,
                        color: PdfColors.grey500)),
              ],
            ),
          ),
          pw.SizedBox(height: 15),

          // ==========================================
          // 2. CONSOLIDAÇÃO GLOBAL
          // ==========================================
          pw.Container(
              padding: const pw.EdgeInsets.all(12),
              decoration: pw.BoxDecoration(
                color: PdfColors.white,
                border: pw.Border.all(color: corPrimaria, width: 1.5),
                borderRadius: const pw.BorderRadius.all(pw.Radius.circular(6)),
              ),
              child: pw.Column(children: [
                pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.Text('Saldo Anterior / Reservas',
                          style: pw.TextStyle(
                              fontSize: 10, color: PdfColors.grey700)),
                      pw.Text(currencyFormatter.format(saldoAnterior),
                          style: const pw.TextStyle(fontSize: 10)),
                    ]),
                pw.SizedBox(height: 6),
                pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.Text('Resultado do Exercício',
                          style: pw.TextStyle(
                              fontSize: 10, color: PdfColors.grey700)),
                      pw.Text(currencyFormatter.format(resultadoExercicio),
                          style: pw.TextStyle(
                              fontSize: 10,
                              fontWeight: pw.FontWeight.bold,
                              color: resultadoExercicio >= 0
                                  ? corCredito
                                  : corDebito)),
                    ]),
                pw.Padding(
                  padding: const pw.EdgeInsets.symmetric(vertical: 8),
                  child: pw.Divider(color: PdfColors.grey300, thickness: 1),
                ),
                pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.Text('Disponibilidade em Caixa',
                          style: pw.TextStyle(
                              fontSize: 12, fontWeight: pw.FontWeight.bold)),
                      pw.Text(currencyFormatter.format(disponibilidadeCaixa),
                          style: pw.TextStyle(
                              fontSize: 12, fontWeight: pw.FontWeight.bold)),
                    ]),
              ])),
          pw.SizedBox(height: 20),

          // ==========================================
          // 3. O MACRO: FUNDO GERAL (Agora com 5 Métricas)
          // ==========================================
          pw.Container(
            padding: const pw.EdgeInsets.all(12),
            decoration: pw.BoxDecoration(
              color: PdfColors.grey100,
              border: pw.Border.all(color: PdfColors.grey400),
              borderRadius: const pw.BorderRadius.all(pw.Radius.circular(4)),
            ),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text('00. Fundo Geral / Matriz Institucional',
                    style: pw.TextStyle(
                        fontSize: 12, fontWeight: pw.FontWeight.bold)),
                pw.SizedBox(height: 10),
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    _buildMetricaFundo(
                        'Arrecadação',
                        currencyFormatter.format(fundoGeral.totalArrecadado),
                        corCredito),

                    // Desmembramento dos Subsídios no Bloco Superior
                    _buildMetricaFundo(
                        'Sub. Recebido',
                        currencyFormatter.format(fundoGeral.subsidiosRecebidos),
                        corSubsidioRecebido),
                    _buildMetricaFundo(
                        'Sub. Concedido',
                        currencyFormatter
                            .format(fundoGeral.subsidiosConcedidos),
                        corSubsidioConcedido),

                    _buildMetricaFundo(
                        'Despesas',
                        currencyFormatter.format(fundoGeral.despesasProprias),
                        corDebito),
                    _buildMetricaFundo(
                        'Saldo Disponível',
                        currencyFormatter.format(fundoGeral.saldoDisponivel),
                        corPrimaria),
                  ],
                ),
                pw.SizedBox(height: 10),
                pw.Container(
                  width: double.infinity,
                  padding: const pw.EdgeInsets.all(6),
                  decoration: pw.BoxDecoration(
                      color: isUsandoReservas
                          ? corInformativa
                          : (indiceRepasse < 50 ? corAlerta : corCredito)),
                  child: pw.Text(
                    isUsandoReservas
                        ? 'Taxa de Repasse: ${indiceRepasse.toStringAsFixed(1)}% (Usou Reservas)'
                        : 'Taxa de Repasse: ${indiceRepasse.toStringAsFixed(1)}%',
                    textAlign: pw.TextAlign.center,
                    style: pw.TextStyle(
                        color: PdfColors.white,
                        fontSize: 10,
                        fontWeight: pw.FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
          pw.SizedBox(height: 20),

          // ==========================================
          // 4. DETALHAMENTO EM TABELA (8 Colunas)
          // ==========================================
          pw.Text('Detalhamento por Departamento',
              style:
                  pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold)),
          pw.SizedBox(height: 8),
          pw.Table(
            border: pw.TableBorder.all(color: PdfColors.grey300),
            columnWidths: {
              0: const pw.FlexColumnWidth(2.2), // CR Nome
              1: const pw.FlexColumnWidth(1.1), // Saldo Anterior
              2: const pw.FlexColumnWidth(1.0), // Receitas
              3: const pw.FlexColumnWidth(1.0), // Sub. Recebido
              4: const pw.FlexColumnWidth(1.0), // Sub. Concedido
              5: const pw.FlexColumnWidth(1.0), // Despesas
              6: const pw.FlexColumnWidth(1.1), // Saldo Atual
              7: const pw.FlexColumnWidth(0.8), // Autossuf.
            },
            children: [
              // Cabeçalho da Tabela
              pw.TableRow(
                decoration: const pw.BoxDecoration(color: PdfColors.grey200),
                children: [
                  _buildHeaderCell('Centro de Resultado', pw.TextAlign.left),
                  _buildHeaderCell('Saldo Ant.', pw.TextAlign.right),
                  _buildHeaderCell('Receitas', pw.TextAlign.right),
                  _buildHeaderCell('Sub. Rec.', pw.TextAlign.right),
                  _buildHeaderCell('Sub. Conc.', pw.TextAlign.right),
                  _buildHeaderCell('Despesas', pw.TextAlign.right),
                  _buildHeaderCell('Saldo Final', pw.TextAlign.right),
                  _buildHeaderCell('Auto.', pw.TextAlign.right),
                ],
              ),
              // Linhas
              ...ministerios.where((cr) => !cr.isFundo).map((cr) {
                final isNegativo = cr.saldoCaixa < 0;

                final double saldoAntCalculado = cr.saldoCaixa -
                    (cr.receitaPropria +
                        cr.subsidioRecebido -
                        cr.subsidioConcedido -
                        cr.despesaRealizada);

                return pw.TableRow(
                  children: [
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(4),
                      child: pw.Text(cr.crNome,
                          style: pw.TextStyle(
                              fontSize: 8, fontWeight: pw.FontWeight.bold)),
                    ),
                    _buildDataCell(currencyFormatter.format(saldoAntCalculado),
                        PdfColors.grey700),
                    _buildDataCell(currencyFormatter.format(cr.receitaPropria),
                        corCredito),
                    _buildDataCell(
                        currencyFormatter.format(cr.subsidioRecebido),
                        corSubsidioRecebido),
                    _buildDataCell(
                        currencyFormatter.format(cr.subsidioConcedido),
                        corSubsidioConcedido),
                    _buildDataCell(
                        currencyFormatter.format(cr.despesaRealizada),
                        corDebito),
                    _buildDataCell(currencyFormatter.format(cr.saldoCaixa),
                        isNegativo ? corDebito : PdfColors.black,
                        isBold: true),
                    _buildDataCell('${cr.autossuficiencia.toStringAsFixed(0)}%',
                        PdfColors.grey700),
                  ],
                );
              }),
            ],
          ),
        ];
      },
      // ==========================================
      // 5. RODAPÉ DE AUDITORIA
      // ==========================================
      footer: (pw.Context context) {
        return pw.Container(
          alignment:
              pw.Alignment.centerRight, // Ajustado à direita como no Dashboard
          margin: const pw.EdgeInsets.only(top: 20),
          padding: const pw.EdgeInsets.only(top: 10),
          decoration: const pw.BoxDecoration(
              border: pw.Border(top: pw.BorderSide(color: PdfColors.grey300))),
          child: pw.Text(
            'LASTRO | Balancete gerado em ${dateFormatter.format(DateTime.now())} às ${DateFormat('HH:mm').format(DateTime.now())} | Página ${context.pageNumber} de ${context.pagesCount}',
            style: const pw.TextStyle(fontSize: 7, color: PdfColors.grey500),
          ),
        );
      },
    ),
  );

  final formataArquivo = DateFormat('MM_yyyy');
  await Printing.sharePdf(
    bytes: await pdf.save(),
    filename:
        'Balancete_Consolidado_LASTRO_${formataArquivo.format(dataInicio)}.pdf',
  );
}

// Funções Auxiliares
pw.Widget _buildMetricaFundo(String titulo, String valor, PdfColor cor) {
  return pw.Column(
    crossAxisAlignment: pw.CrossAxisAlignment.start,
    children: [
      pw.Text(titulo,
          style: const pw.TextStyle(fontSize: 8, color: PdfColors.grey600)),
      pw.SizedBox(height: 2),
      pw.Text(valor,
          style: pw.TextStyle(
              fontSize: 11, fontWeight: pw.FontWeight.bold, color: cor)),
    ],
  );
}

pw.Widget _buildHeaderCell(String texto, pw.TextAlign alinhamento) {
  return pw.Padding(
    padding: const pw.EdgeInsets.all(4),
    child: pw.Text(texto,
        textAlign: alinhamento,
        style: pw.TextStyle(fontSize: 7, fontWeight: pw.FontWeight.bold)),
  );
}

pw.Widget _buildDataCell(String texto, PdfColor cor, {bool isBold = false}) {
  return pw.Padding(
    padding: const pw.EdgeInsets.all(4),
    child: pw.Text(texto,
        textAlign: pw.TextAlign.right,
        style: pw.TextStyle(
            fontSize: 8,
            color: cor,
            fontWeight: isBold ? pw.FontWeight.bold : pw.FontWeight.normal)),
  );
}
