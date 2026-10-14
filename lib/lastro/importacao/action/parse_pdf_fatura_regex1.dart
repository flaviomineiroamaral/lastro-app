// Automatic FlutterFlow imports
import '/backend/schema/structs/index.dart';
// Imports other custom actions
// Imports custom functions
import 'package:flutter/material.dart' hide RepeatMode;
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

Future<List<OfxTransactionStruct>> parsePdfFaturaRegex1(
    String textoFatura) async {
  List<OfxTransactionStruct> transacoes = [];
  final textoMaiusculo = textoFatura.toUpperCase();

  if (textoMaiusculo.contains('NU PAGAMENTOS') ||
      textoMaiusculo.contains('NUBANK')) {
    debugPrint("Regex: Banco Nubank detectado - fallback para IA.");
  } else if (textoMaiusculo.contains('ITAÚ') ||
      textoMaiusculo.contains('ITAU')) {
    debugPrint("Regex: Banco Itaú detectado - fallback para IA.");
  } else if (textoMaiusculo.contains('INTER') ||
      textoFatura.contains('Despesas da fatura CARTÃO')) {
    // BANCO INTER
    debugPrint("Regex: Banco Inter detectado");
    try {
      DateTime? dataVencimentoReal;
      final RegExp dueDateRegex = RegExp(
          r'(\d)\s*(\d)\s*/\s*(\d)\s*(\d)\s*/\s*(\d)\s*(\d)\s*(\d)\s*(\d)');
      final dueDateMatch = dueDateRegex.firstMatch(textoFatura);
      if (dueDateMatch != null) {
        final day = '${dueDateMatch.group(1)}${dueDateMatch.group(2)}';
        final month = '${dueDateMatch.group(3)}${dueDateMatch.group(4)}';
        final year =
            '${dueDateMatch.group(5)}${dueDateMatch.group(6)}${dueDateMatch.group(7)}${dueDateMatch.group(8)}';
        dataVencimentoReal =
            DateTime.tryParse('$year-$month-${day}T00:00:00.000Z');
      }
      final RegExp lineRegex = RegExp(
          r'(\d{2} de [a-zA-Z]{3}\. \d{4})\s+(.*?)[-\s]+(\+?\s*R\$\s*[\d.,]+)');
      final Map<String, String> months = {
        'jan': '01',
        'fev': '02',
        'mar': '03',
        'abr': '04',
        'mai': '05',
        'jun': '06',
        'jul': '07',
        'ago': '08',
        'set': '09',
        'out': '10',
        'nov': '11',
        'dez': '12'
      };

      int contador = 0;
      for (final match in lineRegex.allMatches(textoFatura)) {
        contador++;
        String dateStr = match.group(1)!;
        String desc = match.group(2)!.trim();
        String valStr = match.group(3)!;
        if (desc.endsWith('-')) {
          desc = desc.substring(0, desc.length - 1).trim();
        }
        final dateParts = dateStr.split(' ');
        final String day = dateParts[0];
        final String monthStr = dateParts[2].replaceAll('.', '').toLowerCase();
        final String year = dateParts[3];
        final String month = months[monthStr] ?? '01';
        final String isoDate = '$year-$month-${day}T00:00:00.000Z';

        final dataDaCompra = DateTime.tryParse(isoDate) ?? DateTime.now();
        final bool isPositive = valStr.contains('+');
        valStr = valStr.replaceAll(RegExp(r'[^\d,]'), '').replaceAll(',', '.');
        double amount = double.tryParse(valStr) ?? 0.0;
        amount = isPositive ? amount.abs() : -amount.abs();

        transacoes.add(OfxTransactionStruct(
          date: dataDaCompra,
          dueDate: dataVencimentoReal ?? dataDaCompra,
          description: desc,
          amount: amount,
          type: isPositive ? 'CREDITO' : 'DEBITO',
          fitid: 'INTER-$year$month$day-$contador',
          selecionado: true,
          categoriaSugerida: 'Outros',
        ));
      }
      debugPrint(
          "Regex: ${transacoes.length} transações extraídas do Banco Inter.");
    } catch (e) {
      debugPrint("Regex: Erro ao parsear fatura do Banco Inter: $e");
    }
  } else if (textoMaiusculo.contains('CAIXA') ||
      textoMaiusculo.contains('DEMONSTRATIVO')) {
    // CAIXA ECONÔMICA FEDERAL
    debugPrint("Regex: Banco Caixa detectado");
    try {
      final RegExp lineRegex =
          RegExp(r'^(\d{2}/\d{2})\s+(.*?)\s+([\d.,]+)([DC])$');
      final lines = textoFatura
          .split('\n')
          .map((e) => e.trim())
          .where((e) => e.isNotEmpty)
          .toList();
      for (var line in lines) {
        final match = lineRegex.firstMatch(line);
        if (match != null) {
          final String date = match.group(1)!;
          final String desc = match.group(2)!;
          String val = match.group(3)!;
          final String tipo = match.group(4)!;
          if (!desc.contains('TOTAL DA FATURA') &&
              !desc.contains('PAGAMENTO') &&
              !desc.contains('AJUSTE CRED PARC')) {
            final String day = date.split('/')[0];
            final String month = date.split('/')[1];
            final String year = DateTime.now().year.toString();
            final String isoDate = '$year-$month-${day}T00:00:00.000Z';

            val = val.replaceAll('.', '').replaceAll(',', '.');
            double amount = double.tryParse(val) ?? 0.0;
            amount = (tipo == 'D') ? -amount.abs() : amount.abs();

            final parsedDate = DateTime.tryParse(isoDate) ?? DateTime.now();

            transacoes.add(OfxTransactionStruct(
              date: parsedDate,
              dueDate: parsedDate,
              description: desc,
              amount: amount,
              type: (tipo == 'D') ? 'DEBITO' : 'CREDITO',
              fitid: 'CAIXA-$year$month$day',
              selecionado: true,
              categoriaSugerida: 'Outros',
            ));
          }
        }
      }
      debugPrint("Regex: ${transacoes.length} transações extraídas da Caixa.");
    } catch (e) {
      debugPrint("Regex: Erro ao parsear fatura da Caixa: $e");
    }
  } else if (textoMaiusculo.contains('MERCADO PAGO')) {
    // MERCADO PAGO
    debugPrint("Regex: Banco Mercado Pago detectado");
    try {
      final RegExp dateRegex = RegExp(r'^(\d{2}/\d{2})$', multiLine: true);
      final RegExp valueRegex = RegExp(r'(?:\+\s*)?R\$\s*([\d.,]+)');
      final List<String> allDates = dateRegex
          .allMatches(textoFatura)
          .map((m) => m.group(1)!.trim())
          .toList();
      final List<String> allValuesRaw = valueRegex
          .allMatches(textoFatura)
          .map((m) => m.group(0)!.trim())
          .toList();
      final int N = allDates.length;

      if (N == 0 || allValuesRaw.length < N) {
        debugPrint("Regex: Mercado Pago - dados insuficientes, fallback IA.");
      } else {
        final List<String> filteredValues = allValuesRaw.sublist(0, N);
        final List<String> allDesc = [];
        final lines = textoFatura
            .split('\n')
            .map((e) => e.trim())
            .where((e) => e.isNotEmpty)
            .toList();
        for (var line in lines) {
          if (!dateRegex.hasMatch(line) &&
              !valueRegex.hasMatch(line) &&
              !line.contains('Data') &&
              !line.contains('Movimentações') &&
              !line.contains('Valor') &&
              !line.contains('Total') &&
              !line.contains('Cartão') &&
              !line.toLowerCase().contains('mercado pago')) {
            allDesc.add(line);
          }
        }
        if (allDesc.length < N) {
          debugPrint(
              "Regex: Mercado Pago - descrições insuficientes, fallback IA.");
        } else {
          final List<String> descriptions = allDesc.sublist(0, N);
          for (int i = 0; i < N; i++) {
            final String day = allDates[i].split('/')[0];
            final String month = allDates[i].split('/')[1];
            final String year = DateTime.now().year.toString();
            final String isoDate = '$year-$month-${day}T00:00:00.000Z';

            String valStr = filteredValues[i];
            final bool isPositive = valStr.contains('+');
            valStr =
                valStr.replaceAll(RegExp(r'[^\d,]'), '').replaceAll(',', '.');
            double amount = double.tryParse(valStr) ?? 0.0;
            amount = isPositive ? amount.abs() : -amount.abs();

            final parsedDate = DateTime.tryParse(isoDate) ?? DateTime.now();

            transacoes.add(OfxTransactionStruct(
              date: parsedDate,
              dueDate: parsedDate,
              description: descriptions[i],
              amount: amount,
              type: isPositive ? 'CREDITO' : 'DEBITO',
              fitid: 'MP-$year$month$day-$i',
              selecionado: true,
              categoriaSugerida: 'Outros',
            ));
          }
        }
      }
      debugPrint(
          "Regex: ${transacoes.length} transações extraídas do Mercado Pago.");
    } catch (e) {
      debugPrint("Regex: Erro ao parsear fatura do Mercado Pago: $e");
    }
  } else if (textoMaiusculo.contains('CORA')) {
    // BANCO CORA
    debugPrint("Regex: Banco Cora detectado");
    try {
      final RegExp dateRegex =
          RegExp(r'^(\d{2}/\d{2}/\d{4})$', multiLine: true);
      final RegExp valueRegex = RegExp(r'^-?([\d.,]+)$', multiLine: true);
      final List<String> allDates = dateRegex
          .allMatches(textoFatura)
          .map((m) => m.group(1)!.trim())
          .toList();
      final List<String> allValuesRaw = [];
      final lines = textoFatura
          .split('\n')
          .map((e) => e.trim())
          .where((e) => e.isNotEmpty)
          .toList();

      for (var line in lines) {
        if (valueRegex.hasMatch(line) && !dateRegex.hasMatch(line)) {
          allValuesRaw.add(line);
        }
      }
      final int N = allDates.length;
      if (N == 0 || allValuesRaw.length < N) {
        debugPrint("Regex: Cora - dados insuficientes, fallback IA.");
      } else {
        final List<String> filteredValues = allValuesRaw.sublist(0, N);
        final List<String> allDesc = [];
        for (var line in lines) {
          if (!dateRegex.hasMatch(line) &&
              !valueRegex.hasMatch(line) &&
              !line.contains('Data') &&
              !line.contains('Descrição') &&
              !line.contains('Valores') &&
              !line.contains('Total') &&
              !line.toLowerCase().contains('cora')) {
            allDesc.add(line);
          }
        }
        if (allDesc.length < N) {
          debugPrint("Regex: Cora - descrições insuficientes, fallback IA.");
        } else {
          final List<String> descriptions = allDesc.sublist(0, N);
          for (int i = 0; i < N; i++) {
            final String day = allDates[i].split('/')[0];
            final String month = allDates[i].split('/')[1];
            final String year = allDates[i].split('/')[2];
            final String isoDate = '$year-$month-${day}T00:00:00.000Z';

            String valStr = filteredValues[i];
            valStr =
                valStr.replaceAll(RegExp(r'[^\d,]'), '').replaceAll(',', '.');
            double amount = double.tryParse(valStr) ?? 0.0;
            amount = -amount.abs();

            final parsedDate = DateTime.tryParse(isoDate) ?? DateTime.now();

            transacoes.add(OfxTransactionStruct(
              date: parsedDate,
              dueDate: parsedDate,
              description: descriptions[i],
              amount: amount,
              type: 'DEBITO',
              fitid: 'CORA-$year$month$day-$i',
              selecionado: true,
              categoriaSugerida: 'Outros',
            ));
          }
        }
      }
      debugPrint(
          "Regex: ${transacoes.length} transações extraídas do Banco Cora.");
    } catch (e) {
      debugPrint("Regex: Erro ao parsear fatura do Banco Cora: $e");
    }
  } else {
    debugPrint("Regex: Banco não reconhecido. Fazendo fallback para IA.");
  }
  return transacoes;
}
// Set your action name, define your arguments and return parameter,
// and then add the boilerplate code using the `</>` button on the right!
