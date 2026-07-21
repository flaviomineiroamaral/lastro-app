// Automatic FlutterFlow imports
import '/backend/schema/structs/index.dart';
import '/backend/supabase/supabase.dart';
// Imports other custom actions
// Imports custom functions
import 'package:flutter/material.dart';
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

Future<DTConciliacaoResumoStruct?> getConciliacaoDashboard(
  String orgId,
  DateTime dataInicio,
  DateTime dataFim,
) async {
  final supabase = Supabase.instance.client;

  try {
    // 1. Sanitização do Início do Dia
    DateTime adjustedInicio = DateTime(
      dataInicio.year,
      dataInicio.month,
      dataInicio.day,
      0, 0, 0, // Primeiro segundo do dia
    );

    // 2. A CORREÇÃO: Forçar o último segundo do dia final
    DateTime adjustedFim = DateTime(
      dataFim.year,
      dataFim.month,
      dataFim.day,
      23, 59, 59, // Último segundo do dia
    );

    // Converte para UTC garantindo que engloba todo o expediente
    final String dataInicioIso = adjustedInicio.toUtc().toIso8601String();
    final String dataFimIso = adjustedFim.toUtc().toIso8601String();

    // 3. Chamada à RPC criada no Supabase
    final response = await supabase.rpc(
      'fn_resumo_conciliacao_dashboard',
      params: {
        'p_org_id': orgId,
        'p_data_inicio': dataInicioIso,
        'p_data_fim': dataFimIso,
      },
    );

    // 4. Validação e Retorno
    if (response != null && response is List && response.isNotEmpty) {
      final data = response.first;

      return DTConciliacaoResumoStruct(
        saldoInicialHistorico: double.tryParse(
                data['saldo_inicial_historico']?.toString() ?? '0') ??
            0.0,
        resultadoOperacional:
            double.tryParse(data['resultado_operacional']?.toString() ?? '0') ??
                0.0,
        disponibilidadeReal:
            double.tryParse(data['disponibilidade_real']?.toString() ?? '0') ??
                0.0,
      );
    }

    return null;
  } catch (e) {
    debugPrint('Erro CRÍTICO ao buscar conciliação do dashboard: $e');
    return null;
  }
}
