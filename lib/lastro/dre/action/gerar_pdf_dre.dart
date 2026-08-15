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

Future gerarPdfDre(
  String? nomeOrganizacao, // NOVO: Parâmetro da Instituição
  List<DTDreAnaliticoStruct> dreDados,
  DateTime dataInicio,
  DateTime dataFim,
) async {
  // Barreira de segurança
  if (dreDados.isEmpty) {
    debugPrint('Erro: Dados do DRE vazios. PDF cancelado.');
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
          ? 'DEMONSTRAÇÃO DO RESULTADO (DRE)'
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
                        'DRE - Demonstração do Resultado',
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
          // TABELA DE DADOS DO DRE
          // ==========================================
          pw.Table(
            border: pw.TableBorder.symmetric(
                inside:
                    const pw.BorderSide(width: 0.5, color: PdfColors.grey300)),
            columnWidths: {
              0: const pw.FlexColumnWidth(3), // Coluna Conta (maior espaço)
              1: const pw.FlexColumnWidth(1), // Coluna Valor
              2: const pw.FlexColumnWidth(1), // Coluna AV%
            },
            children: [
              // Linha de Título (Header Row)
              pw.TableRow(
                decoration: const pw.BoxDecoration(color: PdfColors.grey200),
                children: [
                  pw.Padding(
                      padding: const pw.EdgeInsets.all(6),
                      child: pw.Text('Conta Contábil',
                          style: pw.TextStyle(
                              fontWeight: pw.FontWeight.bold, fontSize: 10))),
                  pw.Padding(
                      padding: const pw.EdgeInsets.all(6),
                      child: pw.Text('Valor (R\$)',
                          textAlign: pw.TextAlign.right,
                          style: pw.TextStyle(
                              fontWeight: pw.FontWeight.bold, fontSize: 10))),
                  pw.Padding(
                      padding: const pw.EdgeInsets.all(6),
                      child: pw.Text('AV (%)',
                          textAlign: pw.TextAlign.right,
                          style: pw.TextStyle(
                              fontWeight: pw.FontWeight.bold, fontSize: 10))),
                ],
              ),

              // Linhas de Dados Dinâmicos
              ...dreDados.map((item) {
                // Lógica de UI para o PDF (Negrito para sintéticas, fonte menor para analíticas)
                final isBold = item.isSintetica;
                final textColor =
                    item.valorTotal < 0 ? PdfColors.red800 : PdfColors.black;
                final fontSize = isBold ? 10.0 : 9.0;

                String nomeConta = item.nome.trim();
                // Se o nome NÃO começar com o código, nós adicionamos.
                if (!nomeConta.startsWith(item.codigo)) {
                  nomeConta = '${item.codigo} $nomeConta';
                }

                // Formatação dos números
                final valorFormatado = formataMoeda.format(item.valorTotal);
                final avFormatada =
                    '${(item.analiseVertical * 100).toStringAsFixed(2)}%';

                return pw.TableRow(
                  children: [
                    pw.Padding(
                      // Indentação baseada no Nível Contábil (Multiplica por 12 points)
                      padding: pw.EdgeInsets.only(
                          left: (item.nivel * 12.0) + 6,
                          top: 6,
                          bottom: 6,
                          right: 6),
                      child: pw.Text(
                        nomeConta,
                        style: pw.TextStyle(
                            fontWeight: isBold
                                ? pw.FontWeight.bold
                                : pw.FontWeight.normal,
                            fontSize: fontSize),
                      ),
                    ),
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(6),
                      child: pw.Text(
                        valorFormatado,
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
                        avFormatada,
                        textAlign: pw.TextAlign.right,
                        style: pw.TextStyle(
                            fontWeight: isBold
                                ? pw.FontWeight.bold
                                : pw.FontWeight.normal,
                            fontSize: fontSize,
                            color: PdfColors.grey700),
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
        'Auditoria_DRE_${formataArquivo.format(dataInicio)}_a_${formataArquivo.format(dataFim)}.pdf',
  );
}
