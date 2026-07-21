// Automatic FlutterFlow imports
import '/backend/schema/structs/index.dart';
import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_util.dart';
// Imports other custom actions
// Imports custom functions
import 'package:flutter/material.dart';
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'package:intl/intl.dart';

Future<DTCrSinteticoStruct> getCrSintetico(
  String orgId,
  DateTime dataInicio,
  DateTime dataFim,
) async {
  final supabase = Supabase.instance.client;

  // [BLINDAGEM CRÍTICA]: O Supabase converte campos NUMERIC do SQL para String no JSON.
  // Esta função garante que o Dart não sofra um crash silencioso ('String is not a subtype of num')
  double parseDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is num) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? 0.0;
    return 0.0;
  }

  try {
    // O DateFormat garante que a string não sofra shift de -3 horas na serialização
    final formatter = DateFormat('yyyy-MM-dd');
    final strInicio = formatter.format(dataInicio);
    final strFim = formatter.format(dataFim);

    final response = await supabase.rpc(
      'fn_relatorio_cr_sintetico',
      params: {
        'p_org_id': orgId,
        'p_data_inicio': strInicio,
        'p_data_fim': strFim,
      },
    );

    if (response != null && response is List && response.isNotEmpty) {
      final data = response.first as Map<String, dynamic>;

      return DTCrSinteticoStruct(
        totalArrecadado: parseDouble(data['total_arrecadado']),

        // As duas novas colunas da refatoração para corrigir a falha semântica do cabeçalho
        subsidiosRecebidos: parseDouble(data['subsidios_recebidos']),
        subsidiosConcedidos: parseDouble(data['subsidios_concedidos']),

        subsidiosAlocados: parseDouble(data['subsidios_alocados']),
        despesasProprias: parseDouble(data['despesas_proprias']),
        saldoDisponivel: parseDouble(data['saldo_disponivel']),
        saudeOrcamentaria: parseDouble(data['saude_orcamentaria']),
      );
    }

    // Retorno de segurança vazio
    return DTCrSinteticoStruct(
      totalArrecadado: 0.0,
      subsidiosRecebidos: 0.0,
      subsidiosConcedidos: 0.0,
      subsidiosAlocados: 0.0,
      despesasProprias: 0.0,
      saldoDisponivel: 0.0,
      saudeOrcamentaria: 0.0,
    );
  } catch (e) {
    debugPrint('Erro estrutural ao buscar o Sintético: $e');
    return DTCrSinteticoStruct(
      totalArrecadado: 0.0,
      subsidiosRecebidos: 0.0,
      subsidiosConcedidos: 0.0,
      subsidiosAlocados: 0.0,
      despesasProprias: 0.0,
      saldoDisponivel: 0.0,
      saudeOrcamentaria: 0.0,
    );
  }
}
