// Automatic FlutterFlow imports
import '/backend/schema/structs/index.dart';
import '/backend/supabase/supabase.dart';
// Imports other custom actions
// Imports custom functions
import 'package:flutter/material.dart' hide RepeatMode;
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

Future<List<DTSaldoContaStruct>> getSaldosContas(String orgId) async {
  final supabase = Supabase.instance.client;

  // Escudo contra falhas de JSON do banco de dados
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
    final response = await supabase.rpc('obter_saldos_contas', params: {
      'p_org_id': orgId,
    });

    if (response != null && response is List) {
      // OBRIGATÓRIO: <DTSaldoContaStruct> para o Dart compilar sem erros de tipagem
      return response.map<DTSaldoContaStruct>((data) {
        // Converte a linha de dados para o formato seguro
        final mapData = data as Map<String, dynamic>;

        return DTSaldoContaStruct(
          contaId: mapData['conta_id']?.toString() ?? '',
          nomeConta: mapData['nome_conta']?.toString() ?? '',
          tipoConta: mapData['tipo_conta']?.toString() ?? '',
          saldoInicial:
              parseDouble(mapData['saldo_inicial'] ?? mapData['saldoInicial']),
          totalEntradas: parseDouble(
              mapData['total_entradas'] ?? mapData['totalEntradas']),
          totalSaidas:
              parseDouble(mapData['total_saidas'] ?? mapData['totalSaidas']),
          saldoAtual:
              parseDouble(mapData['saldo_atual'] ?? mapData['saldoAtual']),
          diaFechamento:
              parseInt(mapData['dia_fechamento'] ?? mapData['diaFechamento']),
          diaVencimento:
              parseInt(mapData['dia_vencimento'] ?? mapData['diaVencimento']),
        );
      }).toList();
    }

    return [];
  } catch (e) {
    debugPrint('🔴 Erro CRÍTICO ao buscar saldos: $e');
    return [];
  }
}
// Set your action name, define your arguments and return parameter,
// and then add the boilerplate code using the green button on the right!
