// Automatic FlutterFlow imports
import '/backend/schema/structs/index.dart';
import '/flutter_flow/flutter_flow_util.dart';
// Imports other custom actions
// Imports custom functions
import 'package:flutter/material.dart';
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'dart:convert';
import 'package:share_plus/share_plus.dart';

Future gerarCsvDfc(
  String? nomeOrganizacao,
  List<DTDfcAnaliticoStruct> dfcDados,
  DateTime dataInicio,
  DateTime dataFim,
) async {
  // Barreira de segurança
  if (dfcDados.isEmpty) {
    debugPrint('Erro: Sem dados para exportar.');
    return;
  }

  final dateFormatter = DateFormat('dd_MM_yyyy');

  // A MÁGICA CONTÁBIL: Formata no padrão BR, mas sem o "R$"
  final numFormatter = NumberFormat.currency(locale: 'pt_BR', symbol: '');

  // 1. Instancia o construtor de strings
  StringBuffer csvBuffer = StringBuffer();

  // 2. Cabeçalho das Colunas (Padrão de Importação)
  csvBuffer.writeln('TIPO_LINHA;DESCRICAO;ENTRADAS;SAIDAS;SALDO_ACUMULADO');

  // 3. Iteração e Limpeza de Dados
  for (var item in dfcDados) {
    // Limpeza crítica: Remove quebras de linha e pontos e vírgulas da descrição
    // para evitar que o Excel crie colunas falsas ou parta as linhas.
    String descricaoLimpa =
        item.descricao.replaceAll(';', ',').replaceAll('\n', ' ').trim();
    String tipo = item.tipoLinha;

    // Removemos os zeros das linhas estruturais (Cabeçalhos/Totais de agrupamento)
    // para o contador conseguir aplicar a função SOMA() apenas nas contas analíticas
    String entradas = (tipo == 'CABECALHO' || tipo == 'SALDO')
        ? ''
        : numFormatter.format(item.entradas).trim();

    String saidas = (tipo == 'CABECALHO' || tipo == 'SALDO')
        ? ''
        : numFormatter.format(item.saidas).trim();

    String saldo = numFormatter.format(item.saldo).trim();

    // Monta a linha usando o separador ";"
    csvBuffer.writeln('$tipo;$descricaoLimpa;$entradas;$saidas;$saldo');
  }

  // 4. Tratamento de Codificação (BOM - Byte Order Mark)
  // Sem estes três primeiros bytes, o Excel no Windows não entende o UTF-8 e corrompe acentos
  final List<int> bytes = [0xEF, 0xBB, 0xBF];
  bytes.addAll(utf8.encode(csvBuffer.toString()));

  // 5. Preparação e Compartilhamento Nativo (Substitui o pacote 'printing')
  final fileName =
      'Exportacao_DFC_${dateFormatter.format(dataInicio)}_a_${dateFormatter.format(dataFim)}.csv';

  final xFile = XFile.fromData(
    Uint8List.fromList(bytes),
    mimeType: 'text/csv',
    name: fileName,
  );

  // O texto que acompanha o arquivo ao ser partilhado (WhatsApp, Email, etc.)
  final orgNome = nomeOrganizacao ?? 'Organização';
  await Share.shareXFiles([xFile], text: 'Exportação Contábil DFC - $orgNome');
}
// Set your action name, define your arguments and return parameter,
// and then add the boilerplate code using the `</>` button on the right!
