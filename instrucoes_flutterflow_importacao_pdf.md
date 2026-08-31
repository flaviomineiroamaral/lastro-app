# Instruções de Fluxo: Importação de PDF de Fatura no FlutterFlow

Este documento serve para documentar a lógica e o código criados para otimizar o fluxo de importação de faturas de cartão de crédito em PDF no Lastro App, utilizando Regex como primeira linha de defesa antes de chamar a Inteligência Artificial (Gemini).

---

## 1. Código da Custom Action: `parsePdfFaturaRegex`

Este é o código que deve ser colado na Custom Action `parsePdfFaturaRegex` no FlutterFlow. Ele extrai as transações de bancos mapeados e retorna uma lista vazia para bancos não reconhecidos.

```dart
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

Future<List<OfxTransactionStruct>> parsePdfFaturaRegex(
    String textoFatura) async {
  List<OfxTransactionStruct> transacoes = [];

  // Detecção de Banco e extração (exemplo inicial para ser refinado)
  final textoMaiusculo = textoFatura.toUpperCase();

  if (textoMaiusculo.contains('NU PAGAMENTOS') || textoMaiusculo.contains('NUBANK')) {
    debugPrint("Regex: Banco Nubank detectado");
    // TODO: Implementar a regex específica para o Nubank
  } else if (textoMaiusculo.contains('ITAÚ') || textoMaiusculo.contains('ITAU')) {
    debugPrint("Regex: Banco Itaú detectado");
    // TODO: Implementar a regex específica para o Itaú
  } else if (textoMaiusculo.contains('INTER')) {
    debugPrint("Regex: Banco Inter detectado");
    try {
      final RegExp dateRegex = RegExp(r'(\d{2}) de ([a-zA-Z]{3})\. (\d{4})');
      final RegExp valueRegex = RegExp(r'(?:\+\s*)?R\$\s*([\d.,]+)');
      
      List<int> txCountPerCard = [];
      var parts = textoFatura.split('Total CARTÃO');
      for (int i = 0; i < parts.length - 1; i++) {
        int count = dateRegex.allMatches(parts[i]).length;
        int previousCount = txCountPerCard.fold(0, (a, b) => a + b);
        txCountPerCard.add(count - previousCount);
      }

      List<Match> allDateMatches = dateRegex.allMatches(textoFatura).toList();
      List<String> allValuesRaw = valueRegex.allMatches(textoFatura).map((m) => m.group(0)!.trim()).toList();
      
      List<String> allDesc = [];
      final lines = textoFatura.split('\n').map((e) => e.trim()).where((e) => e.isNotEmpty).toList();
      for (var line in lines) {
        if (!dateRegex.hasMatch(line) && !valueRegex.hasMatch(line) && 
            !line.contains('Data') && !line.contains('Movimentação') && 
            !line.contains('Beneficiário') && !line.contains('Valor') && 
            !line.contains('Total') && !line.contains('Despesas') && 
            !line.contains('CARTÃO') && !line.toLowerCase().contains('banco inter')) {
          allDesc.add(line);
        }
      }

      List<String> filteredValues = [];
      int valueIndex = 0;
      for (int count in txCountPerCard) {
        for (int j = 0; j < count; j++) {
          if (valueIndex < allValuesRaw.length) {
             filteredValues.add(allValuesRaw[valueIndex]);
          }
          valueIndex++;
        }
        valueIndex++; // Pula o total
      }

      Map<String, String> months = {
        'jan': '01', 'fev': '02', 'mar': '03', 'abr': '04', 
        'mai': '05', 'jun': '06', 'jul': '07', 'ago': '08', 
        'set': '09', 'out': '10', 'nov': '11', 'dez': '12'
      };

      int loopCount = allDateMatches.length;
      if (allDesc.length < loopCount) loopCount = allDesc.length;
      if (filteredValues.length < loopCount) loopCount = filteredValues.length;

      for(int i = 0; i < loopCount; i++) {
          final m = allDateMatches[i];
          String day = m.group(1)!;
          String monthStr = m.group(2)!.toLowerCase();
          String year = m.group(3)!;
          String month = months[monthStr] ?? '01';
          
          String isoDate = '$year-$month-${day}T00:00:00.000Z';
          
          String valStr = filteredValues[i];
          bool isPositive = valStr.contains('+');
          valStr = valStr.replaceAll(RegExp(r'[^\d,]'), '').replaceAll(',', '.');
          double amount = double.tryParse(valStr) ?? 0.0;
          if (!isPositive) {
              amount = -amount; // Faturas normalmente mostram despesas (saída), vamos padronizar negativo para gasto
          } else {
              amount = amount.abs(); // Pagamentos ou estornos = positivo
          }

          transacoes.add(OfxTransactionStruct(
              date: DateTime.tryParse(isoDate),
              description: allDesc[i],
              amount: amount,
          ));
      }
    } catch (e) {
      debugPrint("Regex: Erro ao parsear fatura do Banco Inter: $e");
    }
  } else if (textoMaiusculo.contains('CAIXA') || textoMaiusculo.contains('Demonstrativo')) {
    debugPrint("Regex: Banco Caixa detectado");
    try {
      final RegExp lineRegex = RegExp(r'^(\d{2}/\d{2})\s+(.*?)\s+([\d.,]+)([DC])$');
      final lines = textoFatura.split('\n').map((e) => e.trim()).where((e) => e.isNotEmpty).toList();
      
      for (var line in lines) {
        final match = lineRegex.firstMatch(line);
        if (match != null) {
          String date = match.group(1)!;
          String desc = match.group(2)!;
          String val = match.group(3)!;
          String tipo = match.group(4)!;
          
          if (!desc.contains('TOTAL DA FATURA') && 
              !desc.contains('PAGAMENTO') && 
              !desc.contains('AJUSTE CRED PARC')) {
            
            String day = date.split('/')[0];
            String month = date.split('/')[1];
            String year = DateTime.now().year.toString(); // Deduzir o ano atual (simplificação)
            String isoDate = '$year-$month-${day}T00:00:00.000Z';
            
            val = val.replaceAll('.', '').replaceAll(',', '.');
            double amount = double.tryParse(val) ?? 0.0;
            if (tipo == 'D') {
              amount = -amount; // Débito = saída
            } else {
              amount = amount.abs(); // Crédito = entrada/estorno
            }
            
            transacoes.add(OfxTransactionStruct(
                date: DateTime.tryParse(isoDate),
                description: desc,
                amount: amount,
            ));
          }
        }
      }
    } catch (e) {
      debugPrint("Regex: Erro ao parsear fatura da Caixa: $e");
    }
  } else if (textoMaiusculo.contains('MERCADO PAGO')) {
    debugPrint("Regex: Banco Mercado Pago detectado");
    try {
      final RegExp dateRegex = RegExp(r'^(\d{2}/\d{2})$', multiLine: true);
      final RegExp valueRegex = RegExp(r'(?:\+\s*)?R\$\s*([\d.,]+)');
      
      List<String> allDates = dateRegex.allMatches(textoFatura).map((m) => m.group(1)!.trim()).toList();
      List<String> allValuesRaw = valueRegex.allMatches(textoFatura).map((m) => m.group(0)!.trim()).toList();
      
      int N = allDates.length;
      List<String> filteredValues = allValuesRaw.sublist(0, N);
      
      List<String> allDesc = [];
      final lines = textoFatura.split('\n').map((e) => e.trim()).where((e) => e.isNotEmpty).toList();
      for (var line in lines) {
        if (!dateRegex.hasMatch(line) && !valueRegex.hasMatch(line) && 
            !line.contains('Data') && !line.contains('Movimentações') && 
            !line.contains('Valor') && !line.contains('Total') && 
            !line.contains('Cartão') && !line.toLowerCase().contains('banco mercado pago')) {
          allDesc.add(line);
        }
      }
      
      List<String> descriptions = allDesc.sublist(0, N);
      
      for (int i = 0; i < N; i++) {
        String day = allDates[i].split('/')[0];
        String month = allDates[i].split('/')[1];
        String year = DateTime.now().year.toString();
        String isoDate = '$year-$month-${day}T00:00:00.000Z';
        
        String valStr = filteredValues[i];
        bool isPositive = valStr.contains('+');
        valStr = valStr.replaceAll(RegExp(r'[^\d,]'), '').replaceAll(',', '.');
        double amount = double.tryParse(valStr) ?? 0.0;
        if (!isPositive) {
            amount = -amount; 
        } else {
            amount = amount.abs(); 
        }
        
        transacoes.add(OfxTransactionStruct(
            date: DateTime.tryParse(isoDate),
            description: descriptions[i],
            amount: amount,
        ));
      }
    } catch (e) {
      debugPrint("Regex: Erro ao parsear fatura do Mercado Pago: $e");
    }
  } else if (textoMaiusculo.contains('CORA')) {
    debugPrint("Regex: Banco Cora detectado");
    try {
      final RegExp dateRegex = RegExp(r'^(\d{2}/\d{2}/\d{4})$', multiLine: true);
      final RegExp valueRegex = RegExp(r'^-?([\d.,]+)$', multiLine: true);
      
      List<String> allDates = dateRegex.allMatches(textoFatura).map((m) => m.group(1)!.trim()).toList();
      
      List<String> allValuesRaw = [];
      final lines = textoFatura.split('\n').map((e) => e.trim()).where((e) => e.isNotEmpty).toList();
      for (var line in lines) {
         if (valueRegex.hasMatch(line) && !dateRegex.hasMatch(line)) {
            allValuesRaw.add(line);
         }
      }
      
      int N = allDates.length;
      List<String> filteredValues = allValuesRaw.sublist(0, N);
      
      List<String> allDesc = [];
      for (var line in lines) {
        if (!dateRegex.hasMatch(line) && !valueRegex.hasMatch(line) && 
            !line.contains('Data') && !line.contains('Descrição') && 
            !line.contains('Valores') && !line.contains('Total') && 
            !line.toLowerCase().contains('banco cora')) {
          allDesc.add(line);
        }
      }
      
      List<String> descriptions = allDesc.sublist(0, N);
      
      for (int i = 0; i < N; i++) {
        String day = allDates[i].split('/')[0];
        String month = allDates[i].split('/')[1];
        String year = allDates[i].split('/')[2];
        String isoDate = '$year-$month-${day}T00:00:00.000Z';
        
        String valStr = filteredValues[i];
        bool isPositive = !valStr.contains('-'); // Se não tiver -, é despesa? Cora geralmente mostra tudo positivo. Assumiremos despesa como negativo.
        // Faturas Cora geralmente mostram valor positivo para compras.
        valStr = valStr.replaceAll(RegExp(r'[^\d,]'), '').replaceAll(',', '.');
        double amount = double.tryParse(valStr) ?? 0.0;
        
        // Em faturas, gastos normalmente são lançados para pagar, então transformamos em negativo
        amount = -amount.abs();
        
        transacoes.add(OfxTransactionStruct(
            date: DateTime.tryParse(isoDate),
            description: descriptions[i],
            amount: amount,
        ));
      }
    } catch (e) {
      debugPrint("Regex: Erro ao parsear fatura do Banco Cora: $e");
    }
  } else {
    debugPrint("Regex: Banco não reconhecido. Fazendo fallback para IA.");
  }

  // Retorna a lista. Se vazia (tamanho 0), o fluxo no FlutterFlow fará fallback para o Gemini.
  return transacoes;
}
```

---

## 2. Instruções do Action Flow: Integrar Regex e Gemini (Fallback)

1. Vá para o caminho `FALSE` da `Conditional Action 2` (onde checa `textoExtraido == 'ERRO_IMAGEM'`).
2. Adicione a Custom Action **`parsePdfFaturaRegex`** *antes* da Action de `Backend Call API (LerFaturaGemini)`.
   * Argumento: passe o texto bruto extraído do PDF.
   * Output: `resultadoRegex`.
3. Adicione uma **Conditional Action** logo depois: `resultadoRegex -> Number of Items > 0`.
4. **TRUE (Achou com Regex):** Update App State com as transações -> Navigate To `SelecionarTransacoes`.
5. **FALSE (Não achou - Fallback para IA):** Arraste o bloco antigo de chamada de API (`LerFaturaGemini`) para dentro deste caminho.

---

## 3. Instruções do Action Flow: Corrigir Loop Infinito de Senha

Atualmente, se o PDF tem senha, o fluxo entra em um Loop e apenas abre o Bottom Sheet (`bs_SenhaPDF`), ficando preso. Para resolver:

1. **No Bottom Sheet:** Garanta que a ação do botão "Confirmar" feche o Bottom Sheet (Dismiss) e retorne a senha digitada pelo usuário como Action Output (ex: `senhaDigitada`).
2. **Dentro do Loop:** Após o Bottom Sheet, crie uma **Nova Ação**.
3. Escolha **Custom Action -> `extrairTextoPDF`**.
   * Argumento 1: o mesmo arquivo PDF.
   * Argumento 2: passe a `senhaDigitada` do Bottom Sheet.
4. **Atualize o Estado:** O resultado dessa nova tentativa precisa atualizar a variável que o Loop está checando. Se a condição do loop usa um *Page State Variable*, faça um "Update Page State" com o resultado dessa nova tentativa. Assim, se a senha estiver certa, o retorno deixará de ser `ERRO_SENHA` e o loop encerrará.
