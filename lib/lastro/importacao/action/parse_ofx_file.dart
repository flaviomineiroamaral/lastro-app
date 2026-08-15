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

  final transactionRegex = RegExp(
    r'<STMTTRN>(.*?)<\/STMTTRN>',
    multiLine: true,
    dotAll: true,
    caseSensitive: false,
  );

  final matches = transactionRegex.allMatches(content);

  // ============================================================================
  // PASSO 1: O PADRÃO OURO - ANÁLISE DE FREQUÊNCIA (Detecção de Lixo do Banco)
  // ============================================================================
  Map<String, int> frequenciaFitid = {};

  for (final match in matches) {
    final block = match.group(1) ?? '';
    final r = RegExp(r'<FITID>([^<]+)', caseSensitive: false);
    String fitid = r.firstMatch(block)?.group(1)?.trim() ?? '';

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

    String getTag(String tag) {
      final r = RegExp(r'<' + tag + r'>([^<]+)', caseSensitive: false);
      return r.firstMatch(block)?.group(1)?.trim() ?? '';
    }

    String type = getTag('TRNTYPE');
    String dtPosted = getTag('DTPOSTED');
    String amountStr = getTag('TRNAMT');
    String memo = getTag('MEMO');
    String originalFitid = getTag('FITID');

    // Data com Trava do Meio-Dia UTC (Proteção de Interface do FlutterFlow)
    DateTime date = DateTime.now().toUtc();
    if (dtPosted.length >= 8) {
      try {
        int year = int.parse(dtPosted.substring(0, 4));
        int month = int.parse(dtPosted.substring(4, 6));
        int day = int.parse(dtPosted.substring(6, 8));
        date = DateTime.utc(year, month, day, 12, 0, 0);
      } catch (_) {}
    }

    // Sanitização Modular Blindada
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

    // A MÁGICA: Um ID só é confiável se tiver tamanho decente E aparecer apenas UMA vez no arquivo.
    bool isFitidConfiavel =
        safeFitid.length > 5 && (frequenciaFitid[safeFitid] == 1);

    if (isFitidConfiavel) {
      // O banco enviou um ID válido e único (Ex: 011815).
      // Mantemos um teto de 30 caracteres para segurança do Supabase.
      fitidFinal =
          safeFitid.length > 30 ? safeFitid.substring(0, 30) : safeFitid;
    } else {
      // O banco enviou lixo repetido (Ex: 000000 quatro vezes) ou vazio.
      // Assumimos o controle e criamos a CHAVE SEMÂNTICA.

      String dataStr =
          "${date.year}${date.month.toString().padLeft(2, '0')}${date.day.toString().padLeft(2, '0')}";
      String tipoChar = finalType == 'CREDITO' ? 'C' : 'D';

      // Convertendo o valor para centavos (inteiro) para remover pontos e vírgulas da chave
      String valorCentavos = (absAmount * 100).toInt().toString();

      String assinaturaBase = "${dataStr}_${tipoChar}_${valorCentavos}";
      int ocorrenciaAtual = (ocorrenciasIntrinsecas[assinaturaBase] ?? 0) + 1;
      ocorrenciasIntrinsecas[assinaturaBase] = ocorrenciaAtual;

      // Resultado exato: LS_20260701_D_60745_1
      // Tamanho: 22 caracteres (Cabe no banco com folga, altamente legível e matematicamente único).
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
