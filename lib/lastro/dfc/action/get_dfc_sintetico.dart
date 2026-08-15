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

Future<DTDfcSinteticoStruct> getDfcSintetico(
  String orgId,
  DateTime dataInicio,
  DateTime dataFim,
) async {
  final supabase = Supabase.instance.client;

  try {
    // Garante que pegamos o início do dia na data local e forçamos para UTC
    // Isso evita qualquer manipulação de fuso dentro do banco de dados.
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
      final data = response.first;

      return DTDfcSinteticoStruct(
        saldoInicial: data['saldo_inicial']?.toDouble() ?? 0.0,
        totalEntradas: data['total_entradas']?.toDouble() ?? 0.0,
        totalSaidas: data['total_saidas']?.toDouble() ?? 0.0,
        geracaoCaixa: data['geracao_caixa']?.toDouble() ?? 0.0,
        saldoFinal: data['saldo_final']?.toDouble() ?? 0.0,
      );
    }

    // Retorno de segurança
    return DTDfcSinteticoStruct();
  } catch (e) {
    debugPrint('Erro crítico ao buscar DFC Sintético: $e');
    return DTDfcSinteticoStruct();
  }
}
