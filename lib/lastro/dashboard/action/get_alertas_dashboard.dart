// Automatic FlutterFlow imports
import '/backend/schema/structs/index.dart';
import '/backend/supabase/supabase.dart';
// Imports other custom actions
// Imports custom functions
import 'package:flutter/material.dart' hide RepeatMode;
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

Future<DTAlertasResumoStruct?> getAlertasDashboard(String orgId) async {
  final supabase = Supabase.instance.client;

  // ==========================================
  // FUNÇÕES DE PARSING INTELIGENTE E SEGURO
  // ==========================================
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

  DateTime? parseDate(dynamic value) {
    if (value == null) return null;
    if (value is DateTime) return value;
    if (value is String) return DateTime.tryParse(value);
    return null;
  }

  try {
    // Aponta para o novo nome padronizado
    final response = await supabase.rpc('fn_alertas_dashboard', params: {
      'p_org_id': orgId,
    });

    if (response != null && response is List && response.isNotEmpty) {
      final data = response.first as Map<String, dynamic>;

      // ==========================================
      // PARSING DA LISTA JSON DE CARTÕES
      // ==========================================
      List<DTCartaoResumoStruct> cartoesMapeados = [];
      if (data['detalhes_cartoes'] != null || data['detalhesCartoes'] != null) {
        final List<dynamic> jsonCartoes =
            data['detalhes_cartoes'] ?? data['detalhesCartoes'];

        for (var cartao in jsonCartoes) {
          cartoesMapeados.add(DTCartaoResumoStruct(
            idCartao: cartao['id']?.toString() ??
                cartao['idCartao']?.toString() ??
                '',
            nome: cartao['nome']?.toString() ?? 'Cartão Desconhecido',

            // Aceita snake_case ou camelCase
            limiteTotal:
                parseDouble(cartao['limite_total'] ?? cartao['limiteTotal']),
            limiteRestante: parseDouble(
                cartao['limite_restante'] ?? cartao['limiteRestante']),
            melhorDiaCompra: parseDate(
                cartao['melhor_dia_compra'] ?? cartao['melhorDiaCompra']),

            // DICA: Se a sua base de dados já envia o valor da fatura, descomente a linha abaixo
            // no seu FlutterFlow (após criar o campo "faturaAtual" no DTCartaoResumoStruct)
            // faturaAtual: parseDouble(cartao['fatura_atual'] ?? cartao['faturaAtual']),
          ));
        }
      }

      // ==========================================
      // RETORNO GLOBAL DO DASHBOARD
      // ==========================================
      return DTAlertasResumoStruct(
        // Contas a Pagar
        qtdVencidas: parseInt(data['qtd_vencidas'] ?? data['qtdVencidas']),
        valorVencidas:
            parseDouble(data['valor_vencidas'] ?? data['valorVencidas']),
        qtdHoje: parseInt(data['qtd_hoje'] ?? data['qtdHoje']),
        valorHoje: parseDouble(data['valor_hoje'] ?? data['valorHoje']),

        // Cartões Geral
        qtdFaturasCartao:
            parseInt(data['qtd_faturas_cartao'] ?? data['qtdFaturasCartao']),
        valorFaturasCartao: parseDouble(
            data['valor_faturas_cartao'] ?? data['valorFaturasCartao']),

        // Faturas Vencidas (Passado)
        qtdCartoesVencidos: parseInt(
            data['qtd_cartoes_vencidos'] ?? data['qtdCartoesVencidos']),
        valorCartoesVencidos: parseDouble(
            data['valor_cartoes_vencidos'] ?? data['valorCartoesVencidos']),

        // Faturas a Vencer Hoje
        qtdCartoesHoje:
            parseInt(data['qtd_cartoes_hoje'] ?? data['qtdCartoesHoje']),
        valorCartoesHoje:
            parseDouble(data['valor_cartoes_hoje'] ?? data['valorCartoesHoje']),

        // Faturas a Vencer (Futuro)
        qtdCartoesAVencer:
            parseInt(data['qtd_cartoes_a_vencer'] ?? data['qtdCartoesAVencer']),
        valorCartoesAVencer: parseDouble(
            data['valor_cartoes_a_vencer'] ?? data['valorCartoesAVencer']),

        // Limites Globais
        limiteRestanteTotal: parseDouble(
            data['limite_restante_total'] ?? data['limiteRestanteTotal']),
        proximoMelhorDiaCompra: parseDate(
            data['proximo_melhor_dia_compra_global'] ??
                data['proximoMelhorDiaCompraGlobal']),

        // A Lista Aninhada
        listaCartoes: cartoesMapeados,
      );
    }
    return null;
  } catch (e) {
    debugPrint('🔴 Erro CRÍTICO ao buscar Alertas e Cartões do Dashboard: $e');
    return null;
  }
}
