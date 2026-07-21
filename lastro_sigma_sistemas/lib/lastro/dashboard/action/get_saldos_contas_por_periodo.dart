// Automatic FlutterFlow imports
import '/backend/schema/structs/index.dart';
import '/backend/supabase/supabase.dart';
// Imports other custom actions
// Imports custom functions
import 'package:flutter/material.dart';
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

Future<List<DTSaldoContaStruct>> getSaldosContasPorPeriodo(
  String orgId,
  DateTime dataInicio, // NOVO: Parâmetro de filtro (Filme)
  DateTime dataFim, // NOVO: Parâmetro de filtro (Filme)
) async {
  final supabase = Supabase.instance.client;

  // Blindagem de tipagem para evitar "White Screen of Death" (Crashes silenciosos)
  double parseDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? 0.0;
    return 0.0;
  }

  int parseInt(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    if (value is double) return value.toInt();
    if (value is String) return int.tryParse(value) ?? 0;
    return 0;
  }

  try {
    // Chama a RPC dinâmica passando as datas formatadas em ISO-8601
    final response =
        await supabase.rpc('obter_saldos_contas_por_periodo', params: {
      'p_org_id': orgId,
      'p_data_inicio': dataInicio.toIso8601String(),
      'p_data_fim': dataFim.toIso8601String(),
    });

    // Mapeamento seguro para o Data Type (com CamelCase conforme definimos)
    if (response != null && response is List) {
      return response
          .map((data) => DTSaldoContaStruct(
                contaId: data['conta_id']?.toString() ?? '',
                nomeConta: data['nome_conta']?.toString() ?? '',
                tipoConta: data['tipo_conta']?.toString() ?? '',
                saldoInicial: parseDouble(data['saldo_inicial']) ?? 0.0,
                totalEntradas: parseDouble(data['total_entradas']) ?? 0.0,
                totalSaidas: parseDouble(data['total_saidas']) ?? 0.0,
                saldoAtual: parseDouble(data['saldo_atual']) ?? 0.0,
                diaFechamento: parseInt(data['dia_fechamento']) ?? 0,
                diaVencimento: parseInt(data['dia_vencimento']) ?? 0,
              ))
          .toList();
    }

    return [];
  } catch (e) {
    debugPrint('🔴 Erro ao buscar saldos dinâmicos das contas: $e');
    return [];
  }
}
// Set your action name, define your arguments and return parameter,
// and then add the boilerplate code using the `</>` button on the right!
