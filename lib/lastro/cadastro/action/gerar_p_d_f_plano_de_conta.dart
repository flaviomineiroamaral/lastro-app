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

Future<void> gerarPDFPlanoDeConta(
  String orgId,
  String nomeOrganizacao,
) async {
  final supabase = Supabase.instance.client;

  try {
    debugPrint('🟢 [PDF] Iniciando extração do Plano de Contas para: $orgId');

    // 1. Extração dos Dados (Ajuste o nome da sua RPC aqui se for diferente)
    final response = await supabase.rpc('obter_cache_plano_contas', params: {
      'p_org_id': orgId,
    });

    if (response == null || !(response is List)) {
      debugPrint('⚠️ [PDF] RPC retornou vazio ou nulo.');
      return;
    }

    final List<dynamic> registros = response;

    // 2. Inicialização do Documento PDF
    final pdf = pw.Document(
      title: 'Plano de Contas - $nomeOrganizacao',
      author: 'LASTRO ERP',
      creator: 'LASTRO',
    );

    // 3. Transformação dos Dados para a Tabela (Matrix Data)
    // Definimos o cabeçalho
    final headers = ['CÓDIGO', 'DESCRIÇÃO DA CONTA', 'TIPO', 'NATUREZA'];

    // Mapeamos as linhas. Usamos dados brutos para manter a lógica de formatação.
    final dataMatrix = registros.map((r) {
      final row = Map<String, dynamic>.from(r as Map);
      return [
        row['codigo_contabil']?.toString() ?? '',
        // Usamos o nome puro, pois o recuo visual será feito pela tipografia
        row['nome']?.toString() ?? '',
        row['tipo']?.toString() ?? '',
        row['natureza_fluxo']?.toString() ?? '-',
        row['permite_lancamento'] ==
            true, // Variável fantasma usada apenas para formatação
      ];
    }).toList();

    // 4. Construção das Páginas
    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32),
        // Cabeçalho repetido em todas as páginas
        header: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text(
                    'PLANO DE CONTAS',
                    style: pw.TextStyle(
                      fontSize: 24,
                      fontWeight: pw.FontWeight.bold,
                      color: PdfColors.blueGrey900,
                    ),
                  ),
                  pw.Text(
                    DateFormat('dd/MM/yyyy HH:mm').format(DateTime.now()),
                    style:
                        const pw.TextStyle(fontSize: 10, color: PdfColors.grey),
                  ),
                ],
              ),
              pw.Text(
                'Organização: $nomeOrganizacao',
                style:
                    const pw.TextStyle(fontSize: 14, color: PdfColors.grey700),
              ),
              pw.Divider(color: PdfColors.grey400),
              pw.SizedBox(height: 10),
            ],
          );
        },
        // Rodapé com numeração
        footer: (pw.Context context) {
          return pw.Container(
            alignment: pw.Alignment.centerRight,
            margin: const pw.EdgeInsets.only(top: 10.0),
            child: pw.Text(
              'Página ${context.pageNumber} de ${context.pagesCount}  |  Gerado por LASTRO ERP',
              style: const pw.TextStyle(fontSize: 10, color: PdfColors.grey),
            ),
          );
        },
        // O Corpo da Tabela
        build: (pw.Context context) {
          return [
            pw.Table(
              columnWidths: {
                0: const pw.FlexColumnWidth(1.5), // Código
                1: const pw.FlexColumnWidth(4.0), // Descrição
                2: const pw.FlexColumnWidth(1.2), // Tipo
                3: const pw.FlexColumnWidth(1.5), // Natureza
              },
              border: pw.TableBorder.all(color: PdfColors.grey300, width: 0.5),
              children: [
                // Renderização do Cabeçalho da Tabela
                pw.TableRow(
                  decoration:
                      const pw.BoxDecoration(color: PdfColors.blueGrey800),
                  children: headers
                      .map((h) => pw.Padding(
                            padding: const pw.EdgeInsets.all(6),
                            child: pw.Text(h,
                                style: pw.TextStyle(
                                    color: PdfColors.white,
                                    fontWeight: pw.FontWeight.bold,
                                    fontSize: 10)),
                          ))
                      .toList(),
                ),
                // Renderização das Linhas Dinâmicas
                ...dataMatrix.map((row) {
                  final isAnalitica = row[4]
                      as bool; // true = aceita lançamento, false = conta agrupador (sintética)

                  return pw.TableRow(
                    decoration: pw.BoxDecoration(
                      // Contas Sintéticas ganham fundo levemente cinza
                      color: isAnalitica ? PdfColors.white : PdfColors.grey100,
                    ),
                    children: [
                      _buildCell(row[0].toString(), isAnalitica),
                      _buildCell(row[1].toString(), isAnalitica),
                      _buildCell(row[2].toString(), isAnalitica),
                      _buildCell(row[3].toString(), isAnalitica),
                    ],
                  );
                }),
              ],
            ),
          ];
        },
      ),
    );

    debugPrint(
        '🟢 [PDF] Layout construído. Invocando motor de impressão/partilha do sistema...');

    // 5. Invocação nativa do navegador/dispositivo
    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
      name: 'Plano_de_Contas_${nomeOrganizacao.replaceAll(' ', '_')}.pdf',
    );
  } catch (e, stacktrace) {
    debugPrint('🔴 [PDF] Erro fatal na geração do PDF: $e');
    debugPrint(stacktrace.toString());
  }
}

// Função auxiliar para injetar estilo estrito nas células da tabela
pw.Widget _buildCell(String text, bool isAnalitica) {
  return pw.Padding(
    padding: const pw.EdgeInsets.all(6),
    child: pw.Text(
      text,
      style: pw.TextStyle(
        fontSize: 10,
        // Contas analíticas (normais) vs Sintéticas (Negrito)
        fontWeight: isAnalitica ? pw.FontWeight.normal : pw.FontWeight.bold,
        color: isAnalitica ? PdfColors.grey800 : PdfColors.black,
      ),
    ),
  );
}
// Set your action name, define your arguments and return parameter,
// and then add the boilerplate code using the green button on the right!
