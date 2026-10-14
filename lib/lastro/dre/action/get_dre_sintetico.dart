// Automatic FlutterFlow imports
import '/backend/schema/structs/index.dart';
import '/backend/supabase/supabase.dart';
// Imports other custom actions
// Imports custom functions
import 'package:flutter/material.dart' hide RepeatMode;
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

Future<DTDreSinteticoStruct> getDreSintetico(
  String orgId,
  DateTime dataInicio,
  DateTime dataFim,
) async {
  final supabase = Supabase.instance.client;

  // Escudo Protetor contra falhas de tipagem do JSON (Impede o crash de Strings numéricas)
  double parseDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? 0.0;
    return 0.0;
  }

  try {
    // Formata as datas para YYYY-MM-DD garantindo a leitura correta no PostgreSQL
    final strDataInicio =
        DateTime.utc(dataInicio.year, dataInicio.month, dataInicio.day)
            .toIso8601String();
    final strDataFim =
        DateTime.utc(dataFim.year, dataFim.month, dataFim.day, 23, 59, 59)
            .toIso8601String();

    // Aponta para a nova função de performance otimizada no banco de dados
    final response = await supabase.rpc('fn_relatorio_dre_sintetico', params: {
      'p_org_id': orgId,
      'p_data_inicio': strDataInicio,
      'p_data_fim': strDataFim,
    });

    // Como garantimos no banco que sempre voltará 1 linha agregada, lemos o índice [0]
    if (response != null && response is List && response.isNotEmpty) {
      final data = response[0] as Map<String, dynamic>;

      return DTDreSinteticoStruct(
        // Extração Base Consolidada (Lê snake_case ou camelCase)
        totalReceitas:
            parseDouble(data['soma_receitas'] ?? data['totalReceitas']),
        totalDespesas:
            parseDouble(data['soma_despesas'] ?? data['totalDespesas']),
        resultadoLiquido:
            parseDouble(data['soma_liquido'] ?? data['resultadoLiquido']),
        margemLucro:
            parseDouble(data['margem_lucro_percentual'] ?? data['margemLucro']),

        // EXTRAÇÃO AVANÇADA PARA O PDF (Para quebrar o DRE entre Operação e Financeiro)
        somaDespesasOperacionais: parseDouble(
            data['soma_despesas_operacionais'] ??
                data['somaDespesasOperacionais']),
        resultadoOperacional: parseDouble(
            data['resultado_operacional'] ?? data['resultadoOperacional']),
        somaDespesasFinanceiras: parseDouble(
            data['soma_despesas_financeiras'] ??
                data['somaDespesasFinanceiras']),
      );
    }

    // Retorno zerado de segurança caso o banco retorne um array vazio
    return DTDreSinteticoStruct();
  } catch (e) {
    // O seu comentário sobre o Sentry/Crashlytics está certíssimo!
    debugPrint('🔴 Erro crítico ao buscar DRE Sintético no período: $e');
    return DTDreSinteticoStruct();
  }
}
// Set your action name, define your arguments and return parameter,
// and then add the boilerplate code using the green button on the right!
