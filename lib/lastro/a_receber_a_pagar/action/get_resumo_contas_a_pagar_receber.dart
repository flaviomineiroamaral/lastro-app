// Automatic FlutterFlow imports
import '/backend/schema/structs/index.dart';
import '/backend/supabase/supabase.dart';
// Imports other custom actions
// Imports custom functions
import 'package:flutter/material.dart' hide RepeatMode;
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

// Nomenclatura atualizada para refletir o domínio da informação
Future<DTResumoContasAPagarReceberStruct> getResumoContasAPagarReceber(
    String orgId) async {
  final supabase = Supabase.instance.client;

  // Função interna elegante e segura para conversão de valores (Reaproveitada)
  double parseDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? 0.0;
    return 0.0;
  }

  try {
    // Aponta para a nova RPC padronizada no Supabase
    final response =
        await supabase.rpc('fn_resumo_contas_pagar_receber', params: {
      'p_org_id': orgId,
    });

    // Pega o índice [0] com parsing defensivo
    if (response != null && response is List && response.isNotEmpty) {
      final data = response.first as Map<String, dynamic>;

      return DTResumoContasAPagarReceberStruct(
        // OBRIGAÇÕES A PAGAR
        totalPagar: parseDouble(data['total_pagar']),
        totalPagarAtrasado: parseDouble(data['total_pagar_atrasado']),
        totalPagarHoje: parseDouble(data['total_pagar_hoje']),
        totalPagarVencer: parseDouble(data['total_pagar_vencer']),

        // NOVOS CAMPOS QUE FALTAVAM (A Pagar)
        totalPagarVencerCurtoPrazo: parseDouble(
            data['total_pagar_vencer_curto_prazo'] ??
                data['totalPagarVencerCurtoPrazo']),
        totalPagarVencerLongoPrazo: parseDouble(
            data['total_pagar_vencer_longo_prazo'] ??
                data['totalPagarVencerLongoPrazo']),

        // DIREITOS A RECEBER
        totalReceber: parseDouble(data['total_receber']),
        totalReceberAtrasado: parseDouble(data['total_receber_atrasado']),
        totalReceberHoje: parseDouble(data['total_receber_hoje']),
        totalReceberVencer: parseDouble(data['total_receber_vencer']),

        // NOVOS CAMPOS QUE FALTAVAM (A Receber)
        totalReceberVencerCurtoPrazo: parseDouble(
            data['total_receber_vencer_curto_prazo'] ??
                data['totalReceberVencerCurtoPrazo']),
        totalReceberVencerLongoPrazo: parseDouble(
            data['total_receber_vencer_longo_prazo'] ??
                data['totalReceberVencerLongoPrazo']),
      );
    }

    // Retorno vazio garantido caso a base não tenha nada
    return DTResumoContasAPagarReceberStruct();
  } catch (e) {
    debugPrint('Erro CRÍTICO ao buscar resumo de contas a pagar e receber: $e');
    return DTResumoContasAPagarReceberStruct();
  }
}
