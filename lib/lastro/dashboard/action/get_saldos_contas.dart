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

Future<List<DTSaldoContaStruct>> getSaldosContas(String orgId) async {
  final supabase = Supabase.instance.client;

  try {
    // Chama a RPC passando o ID da organização
    final response = await supabase.rpc('obter_saldos_contas', params: {
      'p_org_id': orgId,
    });

    // Se a resposta for válida e for uma lista, mapeamos para o nosso Struct
    if (response != null && response is List) {
      return response
          .map((data) => DTSaldoContaStruct(
                contaId: data['conta_id']?.toString() ?? '',
                nomeConta: data['nome_conta']?.toString() ?? '',
                tipoConta: data['tipo_conta']?.toString() ?? '',
                saldoInicial: data['saldo_inicial']?.toDouble() ?? 0.0,
                totalEntradas: data['total_entradas']?.toDouble() ?? 0.0,
                totalSaidas: data['total_saidas']?.toDouble() ?? 0.0,
                saldoAtual: data['saldo_atual']?.toDouble() ?? 0.0,
                diaFechamento: data['dia_fechamento']?.toInt() ?? 0,
                diaVencimento: data['dia_vencimento']?.toInt() ?? 0,
              ))
          .toList();
    }

    // Retorna lista vazia se não houver contas
    return [];
  } catch (e) {
    print('Erro ao buscar saldos das contas: $e');
    return [];
  }
}
// Set your action name, define your arguments and return parameter,
// and then add the boilerplate code using the green button on the right!
