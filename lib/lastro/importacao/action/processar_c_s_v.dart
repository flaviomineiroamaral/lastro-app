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

import 'dart:convert';

List<OfxTransactionStruct> processarCSV(
    FFUploadedFile arquivoCSV, DateTime? dataVencimento) {
  if (arquivoCSV.bytes == null || arquivoCSV.bytes!.isEmpty) return [];

  try {
    String csvString;
    try {
      csvString = utf8.decode(arquivoCSV.bytes!);
      if (csvString.contains('\uFFFD')) {
        csvString = latin1.decode(arquivoCSV.bytes!);
      }
    } catch (_) {
      csvString = latin1.decode(arquivoCSV.bytes!);
    }

    List<String> linhas = csvString
        .split(RegExp(r'\r?\n'))
        .map((l) => l.trim())
        .where((l) => l.isNotEmpty)
        .toList();

    if (linhas.isEmpty) return [];

    // Detecção de delimitador (;, ,, \t)
    String sample = linhas.take(5).join('\n');
    int countSemicolon = ';'.allMatches(sample).length;
    int countComma = ','.allMatches(sample).length;
    int countTab = '\t'.allMatches(sample).length;

    String delimiter = ';';
    if (countComma > countSemicolon && countComma > countTab) {
      delimiter = ',';
    } else if (countTab > countSemicolon && countTab > countComma) {
      delimiter = '\t';
    }

    List<String> parseRow(String row) {
      List<String> rawCols;
      if (delimiter == ',') {
        // Trata split de vírgulas considerando aspas simples/duplas se existirem
        rawCols = row.split(RegExp(r',(?=(?:[^\"]*\"[^\"]*\")*[^\"]*$)'));
      } else {
        rawCols = row.split(delimiter);
      }
      return rawCols.map((c) {
        String clean = c.trim();
        if ((clean.startsWith('"') && clean.endsWith('"')) ||
            (clean.startsWith("'") && clean.endsWith("'"))) {
          clean = clean.substring(1, clean.length - 1).trim();
        }
        return clean;
      }).toList();
    }

    int idxDate = -1;
    int idxDesc = -1;
    int idxAmount = -1;
    int startRow = 0;

    // Tenta detectar cabeçalho na primeira linha
    List<String> headerCols = parseRow(linhas.first);
    for (int i = 0; i < headerCols.length; i++) {
      String colName = headerCols[i].toLowerCase();
      if (idxDate == -1 &&
          (colName.contains('data') || colName.contains('date') || colName == 'dt')) {
        idxDate = i;
      } else if (idxDesc == -1 &&
          (colName.contains('desc') ||
              colName.contains('hist') ||
              colName.contains('dado') ||
              colName.contains('lanca') ||
              colName.contains('estabelec') ||
              colName.contains('memo') ||
              colName.contains('titulo'))) {
        idxDesc = i;
      } else if (idxAmount == -1 &&
          (colName.contains('valor') ||
              colName.contains('amount') ||
              colName.contains('val') ||
              colName.contains('quantia'))) {
        idxAmount = i;
      }
    }

    if (idxDate != -1 && idxAmount != -1) {
      startRow = 1; // Pula a linha do cabeçalho
    }

    List<OfxTransactionStruct> listaFinal = [];
    Map<String, int> contagemDuplicidade = {};

    for (int i = startRow; i < linhas.length; i++) {
      List<String> colunas = parseRow(linhas[i]);
      if (colunas.length < 2) continue;

      // Fallback de índices de colunas caso o cabeçalho não tenha sido conclusivo
      int cDate = idxDate != -1 && idxDate < colunas.length ? idxDate : 0;
      int cDesc = idxDesc != -1 && idxDesc < colunas.length
          ? idxDesc
          : (colunas.length > 1 ? 1 : 0);
      int cAmount = idxAmount != -1 && idxAmount < colunas.length
          ? idxAmount
          : (colunas.length >= 5 ? 4 : (colunas.length >= 3 ? 2 : colunas.length - 1));

      // --- 1. DATA ---
      String strData = colunas[cDate];
      DateTime dataCompra = DateTime.now().toUtc();
      
      // Procura formato DD/MM/YYYY, YYYY-MM-DD, DD-MM-YYYY, DD.MM.YYYY
      List<String> partesData = strData.split(RegExp(r'[/.-]'));
      if (partesData.length == 3) {
        try {
          int p1 = int.parse(partesData[0]);
          int p2 = int.parse(partesData[1]);
          int p3 = int.parse(partesData[2]);
          if (p1 > 1000) {
            // YYYY-MM-DD
            dataCompra = DateTime.utc(p1, p2, p3, 12, 0, 0);
          } else {
            // DD/MM/YYYY
            dataCompra = DateTime.utc(p3, p2, p1, 12, 0, 0);
          }
        } catch (_) {}
      }

      DateTime dataVencimentoSegura = dataVencimento != null
          ? DateTime.utc(dataVencimento.year, dataVencimento.month,
              dataVencimento.day, 12, 0, 0)
          : dataCompra;

      // --- 2. VALOR ---
      double valor = sanitizarValor(colunas[cAmount]) ?? 0.0;
      double absAmount = valor.abs();
      String tipoFinal = valor < 0 ? 'DEBITO' : 'CREDITO';

      // --- 3. DESCRIÇÃO ---
      String descricao = colunas[cDesc].replaceAll(RegExp(r'\s+'), ' ').trim();
      if (descricao.isEmpty) descricao = 'Sem descrição';

      // Se a linha for cabeçalho não pulado ou vazia de valor
      if (absAmount == 0.0 && (descricao.toLowerCase().contains('valor') || descricao.toLowerCase().contains('descricao'))) {
        continue;
      }

      // --- 4. IDENTIDADE SEMÂNTICA ---
      String dataStr =
          "${dataCompra.year}${dataCompra.month.toString().padLeft(2, '0')}${dataCompra.day.toString().padLeft(2, '0')}";
      String tipoChar = tipoFinal == 'CREDITO' ? 'C' : 'D';
      String valorCentavos = (absAmount * 100).toInt().toString();

      String assinaturaBase = "${dataStr}_${tipoChar}_${valorCentavos}";
      int ocorrencia = (contagemDuplicidade[assinaturaBase] ?? 0) + 1;
      contagemDuplicidade[assinaturaBase] = ocorrencia;

      String idUnico = "LS_${assinaturaBase}_$ocorrencia";

      listaFinal.add(OfxTransactionStruct(
        date: dataCompra,
        description: descricao,
        amount: absAmount,
        dueDate: dataVencimentoSegura,
        type: tipoFinal,
        fitid: idUnico,
      ));
    }
    return listaFinal;
  } catch (e) {
    debugPrint("Erro no processamento do CSV: $e");
    return [];
  }
}
// Set your action name, define your arguments and return parameter,
// and then add the boilerplate code using the green button on the right!
