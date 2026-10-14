// Automatic FlutterFlow imports
import '/backend/schema/structs/index.dart';
import '/backend/supabase/supabase.dart';
// Imports other custom actions
// Imports custom functions
import 'package:flutter/material.dart' hide RepeatMode;
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

Future<DTResumoContasAPagarReceberStruct> getProjecaoTitulosRetroativa(
  String orgId,
  DateTime dataFim,
) async {
  final supabase = Supabase.instance.client;

  // Escudo protetor de conversão
  double parseDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? 0.0;
    return 0.0;
  }

  try {
    // CORREÇÃO CRÍTICA 1: Garantir que a "Máquina do Tempo" vai até ao último segundo do dia!
    final strDataFim =
        DateTime.utc(dataFim.year, dataFim.month, dataFim.day, 23, 59, 59)
            .toIso8601String();

    final response =
        await supabase.rpc('obter_projecao_titulos_retroativa', params: {
      'p_org_id': orgId,
      'p_data_fim': strDataFim,
    });

    if (response != null && response is List && response.isNotEmpty) {
      // CORREÇÃO CRÍTICA 2: Casting explícito
      final data = response.first as Map<String, dynamic>;

      return DTResumoContasAPagarReceberStruct(
        // Extração com dupla compatibilidade (snake_case e camelCase)
        totalPagar: parseDouble(data['total_pagar'] ?? data['totalPagar']),
        totalPagarAtrasado: parseDouble(
            data['total_pagar_atrasado'] ?? data['totalPagarAtrasado']),
        totalPagarHoje:
            parseDouble(data['total_pagar_hoje'] ?? data['totalPagarHoje']),
        totalPagarVencer:
            parseDouble(data['total_pagar_vencer'] ?? data['totalPagarVencer']),

        // CORREÇÃO CRÍTICA 3: Os campos vitais para o PDF não zerar!
        totalPagarVencerCurtoPrazo: parseDouble(
            data['total_pagar_vencer_curto_prazo'] ??
                data['totalPagarVencerCurtoPrazo']),
        totalPagarVencerLongoPrazo: parseDouble(
            data['total_pagar_vencer_longo_prazo'] ??
                data['totalPagarVencerLongoPrazo']),

        totalReceber:
            parseDouble(data['total_receber'] ?? data['totalReceber']),
        totalReceberAtrasado: parseDouble(
            data['total_receber_atrasado'] ?? data['totalReceberAtrasado']),
        totalReceberHoje:
            parseDouble(data['total_receber_hoje'] ?? data['totalReceberHoje']),
        totalReceberVencer: parseDouble(
            data['total_receber_vencer'] ?? data['totalReceberVencer']),

        // CORREÇÃO CRÍTICA 3: Os campos vitais para o PDF não zerar!
        totalReceberVencerCurtoPrazo: parseDouble(
            data['total_receber_vencer_curto_prazo'] ??
                data['totalReceberVencerCurtoPrazo']),
        totalReceberVencerLongoPrazo: parseDouble(
            data['total_receber_vencer_longo_prazo'] ??
                data['totalReceberVencerLongoPrazo']),
      );
    }

    return DTResumoContasAPagarReceberStruct();
  } catch (e) {
    debugPrint('🔴 Erro na Máquina do Tempo do Contas a Pagar: $e');
    return DTResumoContasAPagarReceberStruct();
  }
}
// Set your action name, define your arguments and return parameter,
// and then add the boilerplate code using the `</>` button on the right!
