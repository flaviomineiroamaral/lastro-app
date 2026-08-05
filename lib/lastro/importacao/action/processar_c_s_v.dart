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
    String csvString = utf8.decode(arquivoCSV.bytes!, allowMalformed: true);
    List<String> linhas = csvString.split('\n');
    List<OfxTransactionStruct> listaFinal = [];

    // Mapa para controlar ocorrências idênticas no mesmo lote (para unicidade)
    Map<String, int> contagemDuplicidade = {};

    for (int i = 1; i < linhas.length; i++) {
      String linha = linhas[i].trim();
      if (linha.isEmpty) continue;

      // Limpeza de aspas de CSV
      if (linha.startsWith('"') && linha.endsWith('"')) {
        linha = linha.substring(1, linha.length - 1);
      }
      List<String> colunas = linha.split('","');

      if (colunas.length >= 5) {
        // --- 1. DATA (Com Trava do Meio-Dia UTC para UI do FlutterFlow) ---
        List<String> partesData = colunas[0].split('/');

        DateTime dataCompra = DateTime.now().toUtc();
        if (partesData.length == 3) {
          int dia = int.parse(partesData[0]);
          int mes = int.parse(partesData[1]);
          int ano = int.parse(partesData[2]);
          // Cravamos ao meio-dia UTC para não virar o dia na tela
          dataCompra = DateTime.utc(ano, mes, dia, 12, 0, 0);
        }

        DateTime dataVencimentoSegura = dataVencimento != null
            ? DateTime.utc(dataVencimento.year, dataVencimento.month,
                dataVencimento.day, 12, 0, 0)
            : dataCompra;

        // --- 2. VALOR (Usando a lógica modular blindada) ---
        double valor = sanitizarValor(colunas[4]) ?? 0;
        double absAmount = valor.abs();
        String tipoFinal = valor < 0 ? 'DEBITO' : 'CREDITO';

        // --- 3. DESCRIÇÃO ---
        String descricao = colunas[1].replaceAll(RegExp(r'\s+'), ' ').trim();
        if (descricao.isEmpty) descricao = 'Sem descrição';

        // --- 4. IDENTIDADE ESTÁVEL (Padrão Ouro: Chave Semântica) ---
        // Evitamos o Base64 para não estourar o limite de VARCHAR no banco.
        String dataStr =
            "${dataCompra.year}${dataCompra.month.toString().padLeft(2, '0')}${dataCompra.day.toString().padLeft(2, '0')}";
        String tipoChar = tipoFinal == 'CREDITO' ? 'C' : 'D';
        String valorCentavos = (absAmount * 100).toInt().toString();

        // Exemplo: 20260701_D_60745
        String assinaturaBase = "${dataStr}_${tipoChar}_${valorCentavos}";

        int ocorrencia = (contagemDuplicidade[assinaturaBase] ?? 0) + 1;
        contagemDuplicidade[assinaturaBase] = ocorrencia;

        // Gera: LS_20260701_D_60745_1 (Tamanho seguro e altamente auditável via SQL)
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
    }
    return listaFinal;
  } catch (e) {
    debugPrint("Erro no processamento do CSV: $e");
    return [];
  }
}
// Set your action name, define your arguments and return parameter,
// and then add the boilerplate code using the green button on the right!
