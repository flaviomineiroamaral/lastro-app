// Automatic FlutterFlow imports
import '/backend/schema/structs/index.dart';
import '/backend/supabase/supabase.dart';
// Imports other custom actions
// Imports custom functions
import 'package:flutter/material.dart';
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

// Nomenclatura atualizada para refletir o domínio da informação
Future<DTResumoContasAPagarReceberStruct> getResumoContasAPagarReceber(
    String orgId) async {
  final supabase = Supabase.instance.client;

  try {
    // Aponta para a nova RPC padronizada no Supabase
    final response =
        await supabase.rpc('fn_resumo_contas_pagar_receber', params: {
      'p_org_id': orgId,
    });

    // Pega o índice [0] com parsing defensivo
    if (response != null && response is List && response.isNotEmpty) {
      final data = response.first;

      return DTResumoContasAPagarReceberStruct(
        totalPagar:
            double.tryParse(data['total_pagar']?.toString() ?? '0') ?? 0.0,
        totalPagarAtrasado:
            double.tryParse(data['total_pagar_atrasado']?.toString() ?? '0') ??
                0.0,
        totalPagarHoje:
            double.tryParse(data['total_pagar_hoje']?.toString() ?? '0') ?? 0.0,
        totalPagarVencer:
            double.tryParse(data['total_pagar_vencer']?.toString() ?? '0') ??
                0.0,
        totalReceber:
            double.tryParse(data['total_receber']?.toString() ?? '0') ?? 0.0,
        totalReceberAtrasado: double.tryParse(
                data['total_receber_atrasado']?.toString() ?? '0') ??
            0.0,
        totalReceberHoje:
            double.tryParse(data['total_receber_hoje']?.toString() ?? '0') ??
                0.0,
        totalReceberVencer:
            double.tryParse(data['total_receber_vencer']?.toString() ?? '0') ??
                0.0,
      );
    }

    // Retorno vazio garantido caso a base não tenha nada
    return DTResumoContasAPagarReceberStruct();
  } catch (e) {
    debugPrint('Erro CRÍTICO ao buscar resumo de contas a pagar e receber: $e');
    return DTResumoContasAPagarReceberStruct();
  }
}
