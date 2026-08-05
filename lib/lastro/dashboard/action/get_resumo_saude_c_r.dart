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

Future<DTResumoSaudeCRStruct> getResumoSaudeCR(
  String orgId,
  DateTime dataInicio,
  DateTime dataFim,
) async {
  if (orgId.isEmpty) {
    return DTResumoSaudeCRStruct(qtdVerde: 0, qtdAmarelo: 0, qtdVermelho: 0);
  }

  final supabase = Supabase.instance.client;

  try {
    final strInicio =
        DateTime.utc(dataInicio.year, dataInicio.month, dataInicio.day)
            .toIso8601String();
    final strFim =
        DateTime.utc(dataFim.year, dataFim.month, dataFim.day, 23, 59, 59)
            .toIso8601String();

    // Executa a chamada RPC no Supabase
    final response = await supabase.rpc(
      'fn_resumo_saude_cr',
      params: {
        'p_org_id': orgId,
        'p_data_inicio': strInicio,
        'p_data_fim': strFim,
      },
    );

    // A função retorna uma lista (tabela) com 1 linha. Validamos isso.
    if (response != null && response is List && response.isNotEmpty) {
      final data = Map<String, dynamic>.from(response.first as Map);

      return DTResumoSaudeCRStruct(
        qtdVerde: int.tryParse(data['qtd_verde']?.toString() ?? '0') ?? 0,
        qtdAmarelo: int.tryParse(data['qtd_amarelo']?.toString() ?? '0') ?? 0,
        qtdVermelho: int.tryParse(data['qtd_vermelho']?.toString() ?? '0') ?? 0,
      );
    }

    return DTResumoSaudeCRStruct(qtdVerde: 0, qtdAmarelo: 0, qtdVermelho: 0);
  } catch (e) {
    debugPrint('🔴 [fetchResumoSaudeCR] Erro ao computar saúde dos CRs: $e');
    return DTResumoSaudeCRStruct(qtdVerde: 0, qtdAmarelo: 0, qtdVermelho: 0);
  }
}
