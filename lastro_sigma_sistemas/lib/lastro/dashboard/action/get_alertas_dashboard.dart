// Automatic FlutterFlow imports
import '/backend/schema/structs/index.dart';
import '/backend/supabase/supabase.dart';
// Imports other custom actions
// Imports custom functions
import 'package:flutter/material.dart';
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

Future<DTAlertasResumoStruct?> getAlertasDashboard(String orgId) async {
  final supabase = Supabase.instance.client;

  try {
    // ⚠️ Aponta para o novo nome padronizado
    final response = await supabase.rpc('fn_alertas_dashboard', params: {
      'p_org_id': orgId,
    });

    if (response != null && response is List && response.isNotEmpty) {
      final data = response.first;

      // PARSING DA LISTA JSONB DE CARTÕES INDIVIDUAIS
      List<DTCartaoResumoStruct> cartoesMapeados = [];
      if (data['detalhes_cartoes'] != null) {
        final List<dynamic> jsonCartoes = data['detalhes_cartoes'];

        for (var cartao in jsonCartoes) {
          cartoesMapeados.add(DTCartaoResumoStruct(
            idCartao: cartao['id']?.toString() ?? '',
            nome: cartao['nome']?.toString() ?? 'Cartão Desconhecido',
            limiteTotal:
                double.tryParse(cartao['limite_total']?.toString() ?? '0') ??
                    0.0,
            limiteRestante:
                double.tryParse(cartao['limite_restante']?.toString() ?? '0') ??
                    0.0,
            melhorDiaCompra: cartao['melhor_dia_compra'] != null
                ? DateTime.tryParse(cartao['melhor_dia_compra'].toString())
                : null,
          ));
        }
      }

      // RETORNO GLOBAL
      return DTAlertasResumoStruct(
        qtdVencidas: int.tryParse(data['qtd_vencidas']?.toString() ?? '0') ?? 0,
        valorVencidas:
            double.tryParse(data['valor_vencidas']?.toString() ?? '0') ?? 0.0,
        qtdHoje: int.tryParse(data['qtd_hoje']?.toString() ?? '0') ?? 0,
        valorHoje:
            double.tryParse(data['valor_hoje']?.toString() ?? '0') ?? 0.0,
        qtdFaturasCartao:
            int.tryParse(data['qtd_faturas_cartao']?.toString() ?? '0') ?? 0,
        valorFaturasCartao:
            double.tryParse(data['valor_faturas_cartao']?.toString() ?? '0') ??
                0.0,

        // Cartões Vencidos (Passado)
        qtdCartoesVencidos:
            int.tryParse(data['qtd_cartoes_vencidos']?.toString() ?? '0') ?? 0,
        valorCartoesVencidos: double.tryParse(
                data['valor_cartoes_vencidos']?.toString() ?? '0') ??
            0.0,

        // Métrica de Hoje
        qtdCartoesHoje:
            int.tryParse(data['qtd_cartoes_hoje']?.toString() ?? '0') ?? 0,
        valorCartoesHoje:
            double.tryParse(data['valor_cartoes_hoje']?.toString() ?? '0') ??
                0.0,

        // Cartões a Vencer (Futuro)
        qtdCartoesAVencer:
            int.tryParse(data['qtd_cartoes_a_vencer']?.toString() ?? '0') ?? 0,
        valorCartoesAVencer: double.tryParse(
                data['valor_cartoes_a_vencer']?.toString() ?? '0') ??
            0.0,

        limiteRestanteTotal:
            double.tryParse(data['limite_restante_total']?.toString() ?? '0') ??
                0.0,
        proximoMelhorDiaCompra: data['proximo_melhor_dia_compra_global'] != null
            ? DateTime.tryParse(
                data['proximo_melhor_dia_compra_global'].toString())
            : null,

        listaCartoes: cartoesMapeados,
      );
    }
    return null;
  } catch (e) {
    debugPrint('Erro CRÍTICO ao buscar Alertas e Cartões do Dashboard: $e');
    return null;
  }
}
