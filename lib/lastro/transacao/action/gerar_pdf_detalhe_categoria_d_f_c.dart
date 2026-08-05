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

Future gerarPdfDetalheCategoriaDFC(
  String? nomeOrganizacao, // NOVO: Parâmetro da Instituição
  List<DTDetalheDfcCategoriaStruct> listaDetalhes,
  String nomeCategoria,
  double totalCategoria,
  DateTime dataInicio,
  DateTime dataFim,
) async {
  // Barreira de segurança: Impede a geração de PDFs vazios
  if (listaDetalhes.isEmpty) {
    debugPrint(
        'Erro: Lista de transações do DFC vazia. Geração de PDF abortada.');
    return;
  }

  // Formatadores Locais (Padrão Brasil)
  final formataMoeda = NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$');
  final formataData = DateFormat('dd/MM/yyyy');
  final periodoStr =
      '${formataData.format(dataInicio)} a ${formataData.format(dataFim)}';
  final totalStr = formataMoeda.format(totalCategoria);

  // Paleta de Cores Padronizada
  final corPrimaria = PdfColor.fromHex('#1a252f');

  // Tratamento do nome da Instituição (Fallback de segurança)
  final String instituicao =
      (nomeOrganizacao == null || nomeOrganizacao.trim().isEmpty)
          ? 'RAZÃO ANALÍTICO'
          : nomeOrganizacao.toUpperCase();

  // 1. Instancia o Documento PDF
  final pdf = pw.Document(
    version: PdfVersion.pdf_1_5,
    compress: true,
  );

  // 2. Construção do Layout Analítico (Regime de Caixa)
  pdf.addPage(
    pw.MultiPage(
      pageFormat: PdfPageFormat.a4,
      margin: const pw.EdgeInsets.all(32),
      build: (pw.Context context) {
        return [
          // ==========================================
          // CABEÇALHO DO RELATÓRIO ANALÍTICO (DFC)
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
                        'Razão Analítico de Categoria (Caixa)',
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
                          'Categoria: $nomeCategoria',
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

          // BLOCO DE RESUMO CONSOLIDADO
          pw.Container(
            margin: const pw.EdgeInsets.only(bottom: 20, top: 8),
            padding: const pw.EdgeInsets.all(12),
            decoration: pw.BoxDecoration(
              color: PdfColors.grey100,
              border: pw.Border.all(color: PdfColors.grey300, width: 0.5),
              borderRadius: const pw.BorderRadius.all(pw.Radius.circular(4)),
            ),
            child: pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Text('Período Analisado: $periodoStr',
                    style: const pw.TextStyle(fontSize: 11)),
                pw.Text('Geração de Caixa da Categoria: $totalStr',
                    style: pw.TextStyle(
                      fontSize: 12,
                      fontWeight: pw.FontWeight.bold,
                      // Lógica visual de Fluxo de Caixa: Negativo corrói o caixa (Vermelho)
                      color: totalCategoria < 0
                          ? PdfColors.red800
                          : PdfColors.teal800,
                    )),
              ],
            ),
          ),

          // ==========================================
          // TABELA DE DADOS (Livro Razão de Caixa)
          // ==========================================
          pw.Table(
            border: pw.TableBorder.symmetric(
                inside:
                    const pw.BorderSide(width: 0.2, color: PdfColors.grey300)),
            columnWidths: {
              0: const pw.FlexColumnWidth(1.2), // Data de Pagamento
              1: const pw.FlexColumnWidth(3.0), // Descrição
              2: const pw.FlexColumnWidth(2.0), // Conta Bancária
              3: const pw.FlexColumnWidth(2.0), // Centro de Custo
              4: const pw.FlexColumnWidth(1.5), // Valor (Fluxo)
            },
            children: [
              // Linha de Título (Header Row)
              pw.TableRow(
                decoration: const pw.BoxDecoration(color: PdfColors.grey200),
                children: [
                  _buildHeaderCell(
                      'Data Pgto.'), // Foco no momento em que o dinheiro entrou/saiu
                  _buildHeaderCell('Histórico da Transação'),
                  _buildHeaderCell('Conta Bancária'),
                  _buildHeaderCell('Centro de Custo'),
                  _buildHeaderCell('Fluxo (R\$)', align: pw.TextAlign.right),
                ],
              ),

              // Iteração sobre os dados
              ...listaDetalhes.map((item) {
                // Matemática de Caixa: Avalia se a operação é um DÉBITO para inverter o sinal visualmente
                final bool isSaida =
                    item.tipoOperacao?.toUpperCase() == 'DEBITO';
                final double valorMovimento =
                    isSaida ? -(item.valor) : item.valor;

                final textColor = isSaida ? PdfColors.red800 : PdfColors.black;
                final valorStr = formataMoeda.format(valorMovimento);

                // No DFC, a data de pagamento é a rainha da análise
                final dataStr = item.dataPagamento != null
                    ? formataData.format(item.dataPagamento!)
                    : '-'; // Prevenção, embora no DFC concialiado deva existir sempre

                return pw.TableRow(
                  children: [
                    _buildDataCell(dataStr),
                    _buildDataCell(item.descricao),
                    _buildDataCell(item.contaNome),
                    _buildDataCell(item.centroCustoNome),
                    _buildDataCell(valorStr,
                        align: pw.TextAlign.right, textColor: textColor),
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

  // 3. Comando de Impressão Nativo (Partilha do PDF gerado)
  final safeName = nomeCategoria.replaceAll(RegExp(r'[^a-zA-Z0-9]'), '_');
  final formataArquivo = DateFormat('dd_MM_yyyy');
  await Printing.sharePdf(
    bytes: await pdf.save(),
    filename:
        'Auditoria_DFC_${safeName}_${formataArquivo.format(dataInicio)}.pdf',
  );
}

// Funções Utilitárias para isolar o design da tabela
pw.Widget _buildHeaderCell(String text,
    {pw.TextAlign align = pw.TextAlign.left}) {
  return pw.Padding(
    padding: const pw.EdgeInsets.all(6),
    child: pw.Text(
      text,
      textAlign: align,
      style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 9),
    ),
  );
}

pw.Widget _buildDataCell(String text,
    {pw.TextAlign align = pw.TextAlign.left,
    PdfColor textColor = PdfColors.black}) {
  return pw.Padding(
    padding: const pw.EdgeInsets.all(6),
    child: pw.Text(
      text,
      textAlign: align,
      style: pw.TextStyle(fontSize: 8, color: textColor),
    ),
  );
}
