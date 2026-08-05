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

import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:intl/intl.dart';

Future gerarPdfDfc(
  String? nomeOrganizacao, // NOVO: Parâmetro da Instituição
  List<DTDfcAnaliticoStruct> dfcDados,
  DateTime dataInicio,
  DateTime dataFim,
) async {
  // Barreira de segurança
  if (dfcDados.isEmpty) {
    debugPrint('Erro: Dados do DFC vazios. PDF cancelado.');
    return;
  }

  // Formatadores
  final formataMoeda = NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$');
  final formataData = DateFormat('dd/MM/yyyy');
  final periodoStr =
      '${formataData.format(dataInicio)} a ${formataData.format(dataFim)}';

  // Paleta de Cores Padronizada
  final corPrimaria = PdfColor.fromHex('#1a252f');

  // Tratamento do nome da Instituição (Fallback de segurança)
  final String instituicao =
      (nomeOrganizacao == null || nomeOrganizacao.trim().isEmpty)
          ? 'DEMONSTRAÇÃO DOS FLUXOS DE CAIXA'
          : nomeOrganizacao.toUpperCase();

  // 1. Instancia o Documento PDF
  final pdf = pw.Document(
    version: PdfVersion.pdf_1_5,
    compress: true,
  );

  // 2. Construção do Layout (MultiPage permite quebra automática de páginas)
  pdf.addPage(
    pw.MultiPage(
      pageFormat: PdfPageFormat.a4,
      margin: const pw.EdgeInsets.all(32),
      build: (pw.Context context) {
        return [
          // ==========================================
          // CABEÇALHO DO RELATÓRIO
          // ==========================================
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
                        'DFC - Fluxos de Caixa (Método Direto)',
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
                          'Período Analisado: $periodoStr',
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
          // TABELA DE DADOS DO DFC
          // ==========================================
          pw.Table(
            border: pw.TableBorder.symmetric(
                inside:
                    const pw.BorderSide(width: 0.5, color: PdfColors.grey300)),
            columnWidths: {
              0: const pw.FlexColumnWidth(4), // Coluna Descrição
              1: const pw.FlexColumnWidth(1.5), // Coluna Entradas
              2: const pw.FlexColumnWidth(1.5), // Coluna Saídas
              3: const pw.FlexColumnWidth(1.5), // Coluna Saldo
            },
            children: [
              // Linha de Título (Header Row)
              pw.TableRow(
                decoration: const pw.BoxDecoration(color: PdfColors.grey200),
                children: [
                  pw.Padding(
                      padding: const pw.EdgeInsets.all(6),
                      child: pw.Text('Descrição',
                          style: pw.TextStyle(
                              fontWeight: pw.FontWeight.bold, fontSize: 10))),
                  pw.Padding(
                      padding: const pw.EdgeInsets.all(6),
                      child: pw.Text('Entradas (R\$)',
                          textAlign: pw.TextAlign.right,
                          style: pw.TextStyle(
                              fontWeight: pw.FontWeight.bold, fontSize: 10))),
                  pw.Padding(
                      padding: const pw.EdgeInsets.all(6),
                      child: pw.Text('Saídas (R\$)',
                          textAlign: pw.TextAlign.right,
                          style: pw.TextStyle(
                              fontWeight: pw.FontWeight.bold, fontSize: 10))),
                  pw.Padding(
                      padding: const pw.EdgeInsets.all(6),
                      child: pw.Text('Saldo (R\$)',
                          textAlign: pw.TextAlign.right,
                          style: pw.TextStyle(
                              fontWeight: pw.FontWeight.bold, fontSize: 10))),
                ],
              ),

              // Linhas de Dados Dinâmicos
              ...dfcDados.map((item) {
                // Lógica de UI baseada no tipo da linha do DFC
                final isCabecalho = item.tipoLinha == 'CABECALHO';
                final isTotal = item.tipoLinha == 'TOTAL';
                final isSaldo = item.tipoLinha == 'SALDO';
                final isCategoria = item.tipoLinha == 'CATEGORIA';

                final isBold = isCabecalho || isTotal || isSaldo;
                final fontSize = isBold ? 10.0 : 9.0;

                PdfColor bgColor = PdfColors.white;
                PdfColor textColor = PdfColors.black;

                if (isCabecalho) bgColor = PdfColors.grey200;
                if (isTotal) bgColor = PdfColors.grey100;
                if (isSaldo) {
                  bgColor = PdfColors.teal700;
                  textColor = PdfColors.white;
                }

                // Ocultar zeros nas linhas de agrupamento para limpar a leitura
                String entradasStr = (isSaldo || isCabecalho)
                    ? '-'
                    : formataMoeda.format(item.entradas);
                String saidasStr = (isSaldo || isCabecalho)
                    ? '-'
                    : formataMoeda.format(item.saidas);
                String saldoStr = formataMoeda.format(item.saldo);

                return pw.TableRow(
                  decoration: pw.BoxDecoration(color: bgColor),
                  children: [
                    pw.Padding(
                      // Indentação cirúrgica para as contas analíticas
                      padding: pw.EdgeInsets.only(
                          left: isCategoria ? 18.0 : 6.0,
                          top: 6,
                          bottom: 6,
                          right: 6),
                      child: pw.Text(
                        item.descricao,
                        style: pw.TextStyle(
                            fontWeight: isBold
                                ? pw.FontWeight.bold
                                : pw.FontWeight.normal,
                            fontSize: fontSize,
                            color: textColor),
                      ),
                    ),
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(6),
                      child: pw.Text(
                        entradasStr,
                        textAlign: pw.TextAlign.right,
                        style: pw.TextStyle(
                            fontWeight: isBold
                                ? pw.FontWeight.bold
                                : pw.FontWeight.normal,
                            fontSize: fontSize,
                            color: textColor),
                      ),
                    ),
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(6),
                      child: pw.Text(
                        saidasStr,
                        textAlign: pw.TextAlign.right,
                        style: pw.TextStyle(
                            fontWeight: isBold
                                ? pw.FontWeight.bold
                                : pw.FontWeight.normal,
                            fontSize: fontSize,
                            color: textColor),
                      ),
                    ),
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(6),
                      child: pw.Text(
                        saldoStr,
                        textAlign: pw.TextAlign.right,
                        style: pw.TextStyle(
                            fontWeight: isBold
                                ? pw.FontWeight.bold
                                : pw.FontWeight.normal,
                            fontSize: fontSize,
                            color: textColor),
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
      // RODAPÉ DE COMPLIANCE
      // ==========================================
      footer: (pw.Context context) {
        return pw.Container(
          alignment: pw.Alignment.centerRight,
          margin: const pw.EdgeInsets.only(top: 20),
          padding: const pw.EdgeInsets.only(top: 10),
          decoration: const pw.BoxDecoration(
              border: pw.Border(top: pw.BorderSide(color: PdfColors.grey300))),
          child: pw.Text(
            'Gerado pelo sistema LASTRO em ${formataData.format(DateTime.now())} às ${DateFormat('HH:mm').format(DateTime.now())} | Página ${context.pageNumber} de ${context.pagesCount}\nDocumento de conferência interna e governança financeira.',
            textAlign: pw.TextAlign.right,
            style: const pw.TextStyle(fontSize: 7, color: PdfColors.grey500),
          ),
        );
      },
    ),
  );

  // 3. Ação Final: Aciona o menu nativo do iOS/Android para Compartilhar/Salvar
  final formataArquivo = DateFormat('dd_MM_yyyy');
  await Printing.sharePdf(
    bytes: await pdf.save(),
    filename:
        'Auditoria_DFC_${formataArquivo.format(dataInicio)}_a_${formataArquivo.format(dataFim)}.pdf',
  );
}
