import 'dart:convert';

import 'package:flutter/material.dart';
import '/flutter_flow/custom_functions.dart';
import '/backend/schema/structs/index.dart';

List<OfxTransactionStruct> jsonToOfx(String jsonString) {
  if (jsonString.isEmpty) return [];

  try {
    String cleanText =
        jsonString.replaceAll('```json', '').replaceAll('```', '').trim();
    List<dynamic> jsonList = jsonDecode(cleanText);
    List<OfxTransactionStruct> listaFinal = [];
    Map<String, int> contagemDuplicidade = {};

    for (int i = 0; i < jsonList.length; i++) {
      var item = jsonList[i];

      // 1. Tratamento de Data com Trava do Meio-Dia (Proteção para a UI do FlutterFlow)
      DateTime rawDate =
          DateTime.tryParse(item['date']?.toString() ?? '') ?? DateTime.now();
      DateTime date =
          DateTime.utc(rawDate.year, rawDate.month, rawDate.day, 12, 0, 0);

      DateTime rawDueDate =
          DateTime.tryParse(item['dueDate']?.toString() ?? '') ?? rawDate;
      DateTime dueDate = DateTime.utc(
          rawDueDate.year, rawDueDate.month, rawDueDate.day, 12, 0, 0);

      // 2. Tratamento de Valor usando a Função Customizada modular
      double valor = sanitizarValor(item['amount']) ?? 0.0;

      // 3. Definição de Tipo e Descrição
      String tipoOriginal = item['type']?.toString().toUpperCase() ?? '';
      String tipoOperacao =
          (tipoOriginal.contains('CREDIT') || valor > 0) ? "CREDITO" : "DEBITO";

      double absAmount = valor.abs();
      String descricao = item['description']?.toString().trim() ?? '';
      if (descricao.isEmpty) descricao = 'Sem descrição';

      // 4. Geração de ID Estável (FITID)
      // O hash usa o toIso8601String (que agora será sempre T12:00:00.000Z), mantendo estabilidade
      String hashBase =
          "${date.toIso8601String()}-$tipoOperacao-$absAmount-$descricao";

      // Controla duplicidade dentro do mesmo lote
      int ocorrencia = (contagemDuplicidade[hashBase] ?? 0) + 1;
      contagemDuplicidade[hashBase] = ocorrencia;

      String fitidFinal =
          (item['fitid'] != null && item['fitid'].toString().trim().length > 5)
              ? item['fitid'].toString().trim()
              : "LASTRO_${base64Encode(utf8.encode(hashBase))}-$ocorrencia";

      listaFinal.add(OfxTransactionStruct(
        amount: absAmount,
        description: descricao,
        date: date,
        dueDate: dueDate,
        type: tipoOperacao,
        fitid: fitidFinal,
      ));
    }

    return listaFinal;
  } catch (e) {
    debugPrint("Erro no processamento JSON da IA: $e");
    return [];
  }
}
