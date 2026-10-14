// Automatic FlutterFlow imports
import '/backend/schema/structs/index.dart';
import '/backend/supabase/supabase.dart';
// Imports other custom actions
// Imports custom functions
import 'package:flutter/material.dart' hide RepeatMode;
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

Future<DTResumoSaudeCRStruct> getResumoSaudeCR(
  String orgId,
  DateTime dataInicio,
  DateTime dataFim,
) async {
  // Barreira de segurança
  if (orgId.isEmpty) {
    return DTResumoSaudeCRStruct(qtdVerde: 0, qtdAmarelo: 0, qtdVermelho: 0);
  }

  final supabase = Supabase.instance.client;

  // Função interna elegante para conversão de inteiros
  int parseInt(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    if (value is double) return value.toInt();
    if (value is String) return int.tryParse(value) ?? 0;
    return 0;
  }

  try {
    // Mantido o seu excelente tratamento de fim de dia!
    final strInicio =
        DateTime.utc(dataInicio.year, dataInicio.month, dataInicio.day)
            .toIso8601String();
    final strFim =
        DateTime.utc(dataFim.year, dataFim.month, dataFim.day, 23, 59, 59)
            .toIso8601String();

    // Executa a chamada RPC no Supabase
    final response = await supabase.rpc('fn_resumo_saude_cr', params: {
      'p_org_id': orgId,
      'p_data_inicio': strInicio,
      'p_data_fim': strFim,
    });

    // A função retorna uma lista (tabela). Validamos isso.
    if (response != null && response is List && response.isNotEmpty) {
      final data = response.first as Map<String, dynamic>;

      // ==========================================
      // CONVERSÃO FORTE DA LISTA DE OFENSORES
      // ==========================================
      List<DTItemCRStructStruct> listaOfensores = [];
      if (data['top_ofensores'] != null || data['topOfensores'] != null) {
        final rawList = (data['top_ofensores'] ?? data['topOfensores']) as List;

        listaOfensores = rawList.map<DTItemCRStructStruct>((item) {
          final o = item as Map<String, dynamic>;
          return DTItemCRStructStruct(
            nome:
                o['nome']?.toString() ?? o['cr']?.toString() ?? 'Desconhecido',
            saldo: double.tryParse(
                    o['saldo']?.toString() ?? o['valor']?.toString() ?? '0') ??
                0.0,
          );
        }).toList();
      }

      return DTResumoSaudeCRStruct(
        qtdVerde: parseInt(data['qtd_verde'] ?? data['qtdVerde']),
        qtdAmarelo: parseInt(data['qtd_amarelo'] ?? data['qtdAmarelo']),
        qtdVermelho: parseInt(data['qtd_vermelho'] ?? data['qtdVermelho']),
        topOfensores: listaOfensores, // Agora é entregue tipado corretamente!
      );

      return DTResumoSaudeCRStruct(
        // Indicadores Base (Aceita snake_case ou camelCase)
        qtdVerde: parseInt(data['qtd_verde'] ?? data['qtdVerde']),
        qtdAmarelo: parseInt(data['qtd_amarelo'] ?? data['qtdAmarelo']),
        qtdVermelho: parseInt(data['qtd_vermelho'] ?? data['qtdVermelho']),

        // A lista de quem está a sangrar o caixa (Fundamental para o PDF)
        topOfensores: listaOfensores,
      );
    }

    return DTResumoSaudeCRStruct(qtdVerde: 0, qtdAmarelo: 0, qtdVermelho: 0);
  } catch (e) {
    debugPrint('🔴 [fetchResumoSaudeCR] Erro ao computar saúde dos CRs: $e');
    return DTResumoSaudeCRStruct(qtdVerde: 0, qtdAmarelo: 0, qtdVermelho: 0);
  }
}
