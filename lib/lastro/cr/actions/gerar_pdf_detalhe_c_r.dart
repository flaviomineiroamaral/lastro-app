// Automatic FlutterFlow imports
import '/backend/schema/structs/index.dart';
import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/custom_code/actions/index.dart'; // Imports other custom actions
import '/flutter_flow/custom_functions.dart'; // Imports custom functions
import 'package:flutter/material.dart';
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

// Importações Críticas para o Motor de PDF
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:intl/intl.dart';

Future gerarPdfDetalheCR(
  String? nomeOrganizacao, // NOVO: Parâmetro da Instituição
  String crNome,
  DateTime dataInicio,
  DateTime dataFim,

  // Variáveis do Cabeçalho
  double totalArrecadado,
  double totalSubsidioRecebido,
  double totalSubsidioConcedido,
  double totalDespesa,
  double saldoAcumulado,
  List<DTDetalheCRStruct> transacoes,
) async {
  if (transacoes.isEmpty) {
    debugPrint('Aviso: Nenhuma transação para gerar PDF.');
    return;
  }

  final pdf = pw.Document(version: PdfVersion.pdf_1_5, compress: true);

  final currencyFormatter =
      NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$');
  final dateFormatter = DateFormat('dd/MM/yyyy');

  // Cores de Governança
  final corCredito = PdfColors.green800;
  final corDebito = PdfColors.red800;
  final corPrimaria = PdfColor.fromHex('#1a252f');
  final corSecundaria = PdfColor.fromHex('#0097A7');
  final corInformativa =
      PdfColor.fromHex('#4B39EF'); // Cor para Transferências Internas

  // Tratamento do nome da Instituição (Fallback de segurança)
  final String instituicao =
      (nomeOrganizacao == null || nomeOrganizacao.trim().isEmpty)
          ? 'EXTRATO DE AUDITORIA'
          : nomeOrganizacao.toUpperCase();

  pdf.addPage(
    pw.MultiPage(
      pageFormat: PdfPageFormat.a4,
      margin: const pw.EdgeInsets.all(32),
      build: (pw.Context context) {
        return [
          // ==========================================
          // 1. CABEÇALHO DO DOCUMENTO
          // ==========================================
          pw.Container(
            padding: const pw.EdgeInsets.all(16),
            decoration: pw.BoxDecoration(
              color: corPrimaria,
              border: pw.Border(
                  bottom: pw.BorderSide(color: corSecundaria, width: 4)),
            ),
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
                            color: PdfColors.white,
                            fontSize: 18,
                            fontWeight: pw.FontWeight.bold),
                      ),
                      pw.SizedBox(height: 2),
                      pw.Text(
                        'Extrato de Auditoria - Centro de Resultado',
                        style: pw.TextStyle(
                            color: PdfColors.grey300,
                            fontSize: 12,
                            fontWeight: pw.FontWeight.bold),
                      ),
                      pw.SizedBox(height: 6),
                      pw.Container(
                        padding: const pw.EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: pw.BoxDecoration(
                            color: PdfColor.fromHex(
                                '#2C3E50'), // Fundo levemente mais claro que o primário
                            borderRadius: pw.BorderRadius.circular(4),
                            border: pw.Border.all(
                                color: PdfColors.grey500, width: 0.5)),
                        child: pw.Text(
                          '$crNome | Período: ${dateFormatter.format(dataInicio)} a ${dateFormatter.format(dataFim)}',
                          style: pw.TextStyle(
                              color: PdfColors.white,
                              fontSize: 10,
                              fontWeight: pw.FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
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
          // 2. RESUMO EXECUTIVO (O Balanço Corrigido)
          // ==========================================
          pw.Container(
            decoration: pw.BoxDecoration(
              border: pw.Border.all(color: PdfColors.grey300),
              borderRadius: pw.BorderRadius.circular(4),
            ),
            child: pw.Row(
              children: [
                _buildSummaryBox(
                    'ARRECADADO', totalArrecadado, corCredito, true),
                _buildSummaryBox('SUB. RECEBIDO', totalSubsidioRecebido,
                    corInformativa, true),
                _buildSummaryBox('SUB. CONCEDIDO', totalSubsidioConcedido,
                    corInformativa, true),
                _buildSummaryBox('DESPESAS', totalDespesa, corDebito, true),
                _buildSummaryBox(
                    'SALDO FINAL', saldoAcumulado, PdfColors.black, false),
              ],
            ),
          ),
          pw.SizedBox(height: 20),

          // ==========================================
          // 3. LIVRO-RAZÃO (TABELA DE TRANSAÇÕES)
          // ==========================================
          pw.Table(
            border: pw.TableBorder.all(color: PdfColors.grey300),
            columnWidths: {
              0: const pw.FlexColumnWidth(1.2), // Data
              1: const pw.FlexColumnWidth(4.8), // Descrição
              2: const pw.FlexColumnWidth(2.0), // Conta
              3: const pw.FlexColumnWidth(2.0), // Valor
            },
            children: [
              // Cabeçalho da Tabela
              pw.TableRow(
                decoration: const pw.BoxDecoration(color: PdfColors.grey200),
                children: [
                  pw.Padding(
                      padding: const pw.EdgeInsets.all(6),
                      child: pw.Text('DATA',
                          style: pw.TextStyle(
                              fontSize: 8, fontWeight: pw.FontWeight.bold))),
                  pw.Padding(
                      padding: const pw.EdgeInsets.all(6),
                      child: pw.Text('DESCRIÇÃO / CATEGORIA',
                          style: pw.TextStyle(
                              fontSize: 8, fontWeight: pw.FontWeight.bold))),
                  pw.Padding(
                      padding: const pw.EdgeInsets.all(6),
                      child: pw.Text('CONTA',
                          style: pw.TextStyle(
                              fontSize: 8, fontWeight: pw.FontWeight.bold))),
                  pw.Padding(
                      padding: const pw.EdgeInsets.all(6),
                      child: pw.Text('VALOR',
                          textAlign: pw.TextAlign.right,
                          style: pw.TextStyle(
                              fontSize: 8, fontWeight: pw.FontWeight.bold))),
                ],
              ),

              // Renderização Dinâmica das Linhas
              ...transacoes.map((t) {
                final isCredito =
                    t.tipoOperacao == 'CREDITO' || t.tipoOperacao == 'CRÉDITO';

                final isTransferenciaInterna = t.categoriaNome
                        .toUpperCase()
                        .contains('TRANSFERÊNCIAS INTERNAS') ||
                    t.contaNome.toUpperCase().contains('TRANSFERÊNCIAS') ||
                    t.contaNome.toUpperCase().contains('AJUSTES CONTÁBEIS');

                // Se for interna, usa cor neutra. Se externa, usa verde/vermelho.
                final corValor = isTransferenciaInterna
                    ? corInformativa
                    : (isCredito ? corCredito : corDebito);

                final sinal = isCredito ? '+' : '-';
                final categoria = t.categoriaNome.isNotEmpty
                    ? t.categoriaNome
                    : 'Sem Categoria';
                final dataFmt = t.dataPagamento != null
                    ? dateFormatter.format(t.dataPagamento!)
                    : '--/--/----';

                return pw.TableRow(
                  children: [
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(6),
                      child: pw.Text(dataFmt,
                          style: const pw.TextStyle(fontSize: 8)),
                    ),
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(6),
                      child: pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          pw.Text(t.descricao,
                              style: pw.TextStyle(
                                  fontSize: 8, fontWeight: pw.FontWeight.bold)),
                          pw.SizedBox(height: 2),
                          pw.Text('Cat: $categoria',
                              style: const pw.TextStyle(
                                  fontSize: 7, color: PdfColors.grey700)),
                        ],
                      ),
                    ),
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(6),
                      child: pw.Text(t.contaNome,
                          style: const pw.TextStyle(fontSize: 7)),
                    ),
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(6),
                      child: pw.Text(
                        '$sinal ${currencyFormatter.format(t.valor)}',
                        textAlign: pw.TextAlign.right,
                        style: pw.TextStyle(
                            fontSize: 8,
                            fontWeight: pw.FontWeight.bold,
                            color: corValor),
                      ),
                    ),
                  ],
                );
              }),
            ],
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

  final formataArquivo = DateFormat('dd_MM_yyyy');
  final nomeFicheiroLimpo =
      crNome.replaceAll(RegExp(r'[^\w\s]+'), '').replaceAll(' ', '_');

  await Printing.sharePdf(
    bytes: await pdf.save(),
    filename:
        'Auditoria_${nomeFicheiroLimpo}_${formataArquivo.format(dataInicio)}.pdf',
  );
}

// Widget auxiliar para construir os blocos do resumo executivo dinamicamente
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
