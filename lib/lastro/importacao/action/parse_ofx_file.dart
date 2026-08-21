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
import 'dart:math' as math;

import '/flutter_flow/uploaded_file.dart';

Future<List<OfxTransactionStruct>> parseOfxFile(
    FFUploadedFile fileBytes) async {
  if (fileBytes.bytes == null) return [];

  String content;
  try {
    content = utf8.decode(fileBytes.bytes!);
  } catch (e) {
    content = latin1.decode(fileBytes.bytes!);
  }

  // Suporta tanto XML quanto SGML (OFX 1.02), onde </STMTTRN> pode não existir
  final transactionRegex = RegExp(
    r'<STMTTRN>(.*?)(?=(<\/STMTTRN>|<STMTTRN>|<\/BANKTRANLIST>|\Z))',
    dotAll: true,
    caseSensitive: false,
  );

  final matches = transactionRegex.allMatches(content);

  String extractTag(String block, String tag) {
    final r = RegExp(r'<' + tag + r'>\s*([^<\r\n]+)', caseSensitive: false);
    return r.firstMatch(block)?.group(1)?.trim() ?? '';
  }

  // ============================================================================
  // PASSO 1: ANÁLISE DE FREQUÊNCIA DE FITID (Detecção de Lixo do Banco)
  // ============================================================================
  Map<String, int> frequenciaFitid = {};

  for (final match in matches) {
    final block = match.group(1) ?? '';
    String fitid = extractTag(block, 'FITID');
    if (fitid.isNotEmpty) {
      frequenciaFitid[fitid] = (frequenciaFitid[fitid] ?? 0) + 1;
    }
  }

  // ============================================================================
  // PASSO 2: PROCESSAMENTO E GERAÇÃO DE IDENTIDADE
  // ============================================================================
  List<OfxTransactionStruct> transactions = [];
  Map<String, int> ocorrenciasIntrinsecas = {};

  for (final match in matches) {
    final block = match.group(1) ?? '';

    String type = extractTag(block, 'TRNTYPE');
    String dtPosted = extractTag(block, 'DTPOSTED');
    String amountStr = extractTag(block, 'TRNAMT');
    String memo = extractTag(block, 'MEMO');
    if (memo.isEmpty) memo = extractTag(block, 'NAME');
    if (memo.isEmpty) memo = extractTag(block, 'PAYEE');
    String originalFitid = extractTag(block, 'FITID');

    // Data com Trava do Meio-Dia UTC
    DateTime date = DateTime.now().toUtc();
    String digitsDate = RegExp(r'\d+').firstMatch(dtPosted)?.group(0) ?? '';
    if (digitsDate.length >= 8) {
      try {
        int year = int.parse(digitsDate.substring(0, 4));
        int month = int.parse(digitsDate.substring(4, 6));
        int day = int.parse(digitsDate.substring(6, 8));
        date = DateTime.utc(year, month, day, 12, 0, 0);
      } catch (_) {}
    }

    // Sanitização de Valor e Tipo
    double amount = sanitizarValor(amountStr) ?? 0.0;

    String finalType = 'DEBITO';
    if (type.toUpperCase().contains('CREDIT') ||
        (!type.toUpperCase().contains('DEBIT') && amount > 0)) {
      finalType = 'CREDITO';
    }

    double absAmount = amount.abs();
    String safeMemo = memo.trim().isEmpty ? 'Sem descrição' : memo.trim();
    String safeFitid = originalFitid.trim();
    String fitidFinal;

    bool isFitidConfiavel =
        safeFitid.length > 5 && (frequenciaFitid[safeFitid] == 1);

    if (isFitidConfiavel) {
      fitidFinal =
          safeFitid.length > 30 ? safeFitid.substring(0, 30) : safeFitid;
    } else {
      String dataStr =
          "${date.year}${date.month.toString().padLeft(2, '0')}${date.day.toString().padLeft(2, '0')}";
      String tipoChar = finalType == 'CREDITO' ? 'C' : 'D';
      String valorCentavos = (absAmount * 100).toInt().toString();

      String assinaturaBase = "${dataStr}_${tipoChar}_${valorCentavos}";
      int ocorrenciaAtual = (ocorrenciasIntrinsecas[assinaturaBase] ?? 0) + 1;
      ocorrenciasIntrinsecas[assinaturaBase] = ocorrenciaAtual;

      fitidFinal = "LS_${assinaturaBase}_${ocorrenciaAtual}";
    }

    transactions.add(OfxTransactionStruct(
      amount: absAmount,
      description: safeMemo,
      date: date,
      dueDate: date,
      type: finalType,
      fitid: fitidFinal,
    ));
  }

  return transactions;
}
// Set your action name, define your arguments and return parameter,
// and then add the boilerplate code using the green button on the right!
