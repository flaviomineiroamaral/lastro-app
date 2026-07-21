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

Future gerarPdfExtrato(
  String? nomeOrganizacao, // Parâmetro da Instituição
  List<DTExtratoPeriodoStruct>? listaTransacoes,
  String? nomeConta,
  DateTime? dataInicio,
  DateTime? dataFim,
) async {
  // 1. BARREIRAS DE SEGURANÇA GLOBAIS
  if (listaTransacoes == null || listaTransacoes.isEmpty) {
    debugPrint('Aviso: Lista de transações vazia ou nula.');
    return;
  }

  // Se as datas vierem nulas, usa o dia de hoje para não dar crash
  final dInicio = dataInicio ?? DateTime.now();
  final dFim = dataFim ?? DateTime.now();
  final contaSegura = nomeConta ?? 'Conta Não Especificada';

  final doc = pw.Document(version: PdfVersion.pdf_1_5, compress: true);

  final dateFormatter = DateFormat('dd/MM/yyyy');
  final currencyFormatter =
      NumberFormat.currency(locale: 'pt_BR', symbol: '', decimalDigits: 2);

  // Paleta de Cores Padronizada
  final corPrimaria = PdfColor.fromHex('#1a252f');
  final corCredito = PdfColors.green800;
  final corDebito = PdfColors.red800;

  // Tratamento do nome da Instituição (Fallback de segurança)
  final String instituicao =
      (nomeOrganizacao == null || nomeOrganizacao.trim().isEmpty)
          ? 'EXTRATO DE MOVIMENTAÇÃO'
          : nomeOrganizacao.toUpperCase();

  // ==========================================
  // MOTOR MATEMÁTICO: CÁLCULO BLINDADO (SEM SORT)
  // ==========================================
  double totalEntradas = 0.0;
  double totalSaidas = 0.0;

  for (var t in listaTransacoes) {
    final double v = t.valorMovimento ?? 0.0;
    if (v > 0) {
      totalEntradas += v;
    } else if (v < 0) {
      totalSaidas += v;
    }
  }

  // [CORREÇÃO]: Detecção de direção cronológica através de Prova Matemática.
  // Mantemos a lista intacta. Avaliamos a relação contábil entre as duas primeiras linhas.
  bool isDescendente = false;
  if (listaTransacoes.length > 1) {
    double s0 = listaTransacoes[0].saldoProgressivo ?? 0.0;
    double m0 = listaTransacoes[0].valorMovimento ?? 0.0;
    double s1 = listaTransacoes[1].saldoProgressivo ?? 0.0;

    // Se o Saldo Anterior (Linha 1) + Movimento Atual (Linha 0) = Saldo Atual (Linha 0),
    // a lista está do Mais Novo para o Mais Velho.
    String provaDesc = (s1 + m0).toStringAsFixed(2);
    String alvoDesc = s0.toStringAsFixed(2);

    if (provaDesc == alvoDesc) {
      isDescendente = true;
    } else {
      // Fallback para as datas se a matemática contábil estiver quebrada ou faturada em lote
      DateTime p = listaTransacoes.first.dataLinhaTempo ?? DateTime.now();
      DateTime u = listaTransacoes.last.dataLinhaTempo ?? DateTime.now();
      if (p.isAfter(u)) {
        isDescendente = true;
      }
    }
  }

  // O Saldo Final é extraído da ponta correta, preservando a matriz original
  final double saldoFinal = isDescendente
      ? (listaTransacoes.first.saldoProgressivo ?? 0.0)
      : (listaTransacoes.last.saldoProgressivo ?? 0.0);

  // O Saldo Inicial é matematicamente inquebrável
  final double saldoInicial = saldoFinal - (totalEntradas + totalSaidas);

  doc.addPage(
    pw.MultiPage(
      pageFormat: PdfPageFormat.a4,
      margin: const pw.EdgeInsets.all(32),

      // ==========================================
      // 1. CABEÇALHO PADRÃO OURO
      // ==========================================
      build: (pw.Context context) {
        return [
          pw.Header(
            level: 0,
            child: pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Expanded(
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      // Nome da Organização em Destaque
                      pw.Text(
                        instituicao,
                        style: pw.TextStyle(
                            fontSize: 18,
                            fontWeight: pw.FontWeight.bold,
                            color: corPrimaria),
                      ),
                      pw.SizedBox(height: 2),
                      pw.Text(
                        'Extrato Analítico de Conta',
                        style: pw.TextStyle(
                            fontSize: 12,
                            fontWeight: pw.FontWeight.bold,
                            color: PdfColors.grey800),
                      ),
                      pw.SizedBox(height: 6),
                      pw.Container(
                        padding: const pw.EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: pw.BoxDecoration(
                            color: PdfColors.grey100,
                            borderRadius: pw.BorderRadius.circular(4),
                            border: pw.Border.all(
                                color: PdfColors.grey300, width: 0.5)),
                        child: pw.Text(
                          'Conta: $contaSegura | Período: ${dateFormatter.format(dInicio)} a ${dateFormatter.format(dFim)}',
                          style: pw.TextStyle(
                              fontSize: 10,
                              fontWeight: pw.FontWeight.bold,
                              color: corPrimaria),
                        ),
                      ),
                    ],
                  ),
                ),
                pw.Text(
                  'LASTRO',
                  style: pw.TextStyle(
                      fontSize: 14,
                      color: PdfColors.grey500,
                      fontWeight: pw.FontWeight.bold),
                ),
              ],
            ),
          ),
          pw.SizedBox(height: 15),

          // ==========================================
          // 2. RESUMO DO PERÍODO
          // ==========================================
          pw.Container(
            decoration: pw.BoxDecoration(
              border: pw.Border.all(color: PdfColors.grey300),
              borderRadius: pw.BorderRadius.circular(4),
            ),
            child: pw.Row(
              children: [
                _buildSummaryBox(
                    'SALDO INICIAL', saldoInicial, PdfColors.black, true),
                _buildSummaryBox('ENTRADAS', totalEntradas, corCredito, true),
                _buildSummaryBox('SAÍDAS', totalSaidas, corDebito, true),
                _buildSummaryBox('SALDO FINAL', saldoFinal, corPrimaria, false),
              ],
            ),
          ),
          pw.SizedBox(height: 20),

          // ==========================================
          // 3. TABELA MINIMALISTA (Ledger)
          // ==========================================
          pw.TableHelper.fromTextArray(
            headers: [
              'Data',
              'Descrição',
              'Categoria',
              'Valor (R\$)',
              'Saldo (R\$)'
            ],
            columnWidths: {
              0: const pw.FixedColumnWidth(65),
              1: const pw.FlexColumnWidth(3),
              2: const pw.FlexColumnWidth(2),
              3: const pw.FixedColumnWidth(70),
              4: const pw.FixedColumnWidth(70),
            },
            border: const pw.TableBorder(
              horizontalInside:
                  pw.BorderSide(width: 0.5, color: PdfColors.grey300),
              bottom: pw.BorderSide(width: 1, color: PdfColors.grey800),
              top: pw.BorderSide(width: 1, color: PdfColors.grey800),
            ),
            headerStyle: pw.TextStyle(
                fontWeight: pw.FontWeight.bold,
                fontSize: 10,
                color: PdfColors.black),
            headerDecoration: const pw.BoxDecoration(color: PdfColors.grey100),
            cellStyle: const pw.TextStyle(fontSize: 9),
            cellAlignment: pw.Alignment.centerLeft,
            cellAlignments: {
              0: pw.Alignment.center,
              3: pw.Alignment.centerRight,
              4: pw.Alignment.centerRight,
            },
            // [CORREÇÃO]: Usamos a lista intacta que veio do banco de dados
            data: listaTransacoes.map((t) {
              final double valorReal = t.valorMovimento ?? 0.0;
              final double saldoReal = t.saldoProgressivo ?? 0.0;
              final String descReal = t.descricao ?? '-';
              final String catReal = t.categoriaNome ?? 'Sem categoria';

              final isDebito = valorReal < 0;

              final valorFormatado = isDebito
                  ? '- ${currencyFormatter.format(valorReal.abs())}'
                  : '  ${currencyFormatter.format(valorReal)}';

              final saldoFormatado = currencyFormatter.format(saldoReal);

              return [
                t.dataLinhaTempo != null
                    ? dateFormatter.format(t.dataLinhaTempo!)
                    : '-',
                descReal,
                catReal,
                valorFormatado,
                saldoFormatado,
              ];
            }).toList(),
          ),
        ];
      },

      // ==========================================
      // 4. RODAPÉ DE COMPLIANCE
      // ==========================================
      footer: (pw.Context context) {
        return pw.Container(
          alignment: pw.Alignment.centerRight,
          margin: const pw.EdgeInsets.only(top: 20),
          padding: const pw.EdgeInsets.only(top: 10),
          decoration: const pw.BoxDecoration(
              border: pw.Border(top: pw.BorderSide(color: PdfColors.grey300))),
          child: pw.Text(
            'Gerado pelo sistema LASTRO em ${dateFormatter.format(DateTime.now())} às ${DateFormat('HH:mm').format(DateTime.now())} | Página ${context.pageNumber} de ${context.pagesCount}\nDocumento de conferência interna e governança financeira.',
            textAlign: pw.TextAlign.right,
            style: const pw.TextStyle(fontSize: 7, color: PdfColors.grey500),
          ),
        );
      },
    ),
  );

  String arquivoNomeSeguro =
      contaSegura.replaceAll(RegExp(r'[^a-zA-Z0-9]'), '_');

  final bytes = await doc.save();
  await Printing.sharePdf(
    bytes: bytes,
    filename:
        'Extrato_${arquivoNomeSeguro}_${dateFormatter.format(dInicio).replaceAll('/', '-')}.pdf',
  );
}

// Widget auxiliar para construir os blocos do resumo executivo
pw.Widget _buildSummaryBox(
    String titulo, double valor, PdfColor corTexto, bool showRightBorder) {
  final currencyFormatter =
      NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$');

  return pw.Expanded(
    child: pw.Container(
      padding: const pw.EdgeInsets.symmetric(vertical: 8, horizontal: 4),
      decoration: pw.BoxDecoration(
        border: showRightBorder
            ? const pw.Border(right: pw.BorderSide(color: PdfColors.grey300))
            : null,
      ),
      child: pw.Column(
        children: [
          pw.Text(titulo,
              textAlign: pw.TextAlign.center,
              style: pw.TextStyle(fontSize: 6, color: PdfColors.grey600)),
          pw.SizedBox(height: 4),
          pw.Text(
            currencyFormatter.format(valor),
            textAlign: pw.TextAlign.center,
            style: pw.TextStyle(
                fontSize: 10, fontWeight: pw.FontWeight.bold, color: corTexto),
          ),
        ],
      ),
    ),
  );
}
