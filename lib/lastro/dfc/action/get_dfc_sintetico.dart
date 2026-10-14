// Automatic FlutterFlow imports
import '/backend/schema/structs/index.dart';
import '/backend/supabase/supabase.dart';
// Imports other custom actions
// Imports custom functions
import 'package:flutter/material.dart' hide RepeatMode;
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

Future<DTDfcSinteticoStruct> getDfcSintetico(
  String orgId,
  DateTime dataInicio,
  DateTime dataFim,
) async {
  final supabase = Supabase.instance.client;

  // O nosso "Escudo Protetor" contra quebras de JSON do Supabase
  double parseDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? 0.0;
    return 0.0;
  }

  try {
    // Garante que pegamos o início do dia na data local e forçamos para UTC
    // Isso evita qualquer manipulação de fuso dentro do banco de dados (Jogada de Mestre).
    final inicioUtc =
        DateTime.utc(dataInicio.year, dataInicio.month, dataInicio.day)
            .toIso8601String();
    final fimUtc =
        DateTime.utc(dataFim.year, dataFim.month, dataFim.day, 23, 59, 59)
            .toIso8601String();

    final response = await supabase.rpc('fn_relatorio_dfc_sintetico', params: {
      'p_org_id': orgId,
      'p_data_inicio': inicioUtc,
      'p_data_fim': fimUtc,
    });

    if (response != null && response is List && response.isNotEmpty) {
      final data = response.first as Map<String, dynamic>;

      return DTDfcSinteticoStruct(
        // Aceita snake_case (Padrão Supabase) ou camelCase (Padrão Dart) com parser inquebrável
        saldoInicial:
            parseDouble(data['saldo_inicial'] ?? data['saldoInicial']),
        totalEntradas:
            parseDouble(data['total_entradas'] ?? data['totalEntradas']),
        totalSaidas: parseDouble(data['total_saidas'] ?? data['totalSaidas']),
        geracaoCaixa:
            parseDouble(data['geracao_caixa'] ?? data['geracaoCaixa']),
        saldoFinal: parseDouble(data['saldo_final'] ?? data['saldoFinal']),
      );
    }

    // Retorno de segurança caso não haja movimento no período
    return DTDfcSinteticoStruct(
      saldoInicial: 0.0,
      totalEntradas: 0.0,
      totalSaidas: 0.0,
      geracaoCaixa: 0.0,
      saldoFinal: 0.0,
    );
  } catch (e) {
    debugPrint('🔴 Erro crítico ao buscar DFC Sintético: $e');
    return DTDfcSinteticoStruct();
  }
}
