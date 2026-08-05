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

Future<List<dynamic>> getGraficoDre(
  String orgId,
  DateTime dataInicio,
  DateTime dataFim,
) async {
  final supabase = Supabase.instance.client;

  try {
    // Isola e extrai apenas o formato YYYY-MM-DD para evitar que o
    // Timezone local do celular desloque os dias no agrupamento do banco.
    final strDataInicio =
        DateTime.utc(dataInicio.year, dataInicio.month, dataInicio.day)
            .toIso8601String();
    final strDataFim =
        DateTime.utc(dataFim.year, dataFim.month, dataFim.day, 23, 59, 59)
            .toIso8601String();

    // Chama a NOVA RPC de Gráfico, que agora consome a View unificada
    final response = await supabase.rpc('fn_grafico_dre_diario', params: {
      'p_org_id': orgId,
      'p_data_inicio': strDataInicio,
      'p_data_fim': strDataFim,
    });

    // Retorna a lista de dados. Como a API agora usa generate_series,
    // garantimos que essa lista terá exatamente o mesmo número de dias do intervalo solicitado.
    return (response as List<dynamic>?) ?? [];
  } catch (e) {
    print('Erro crítico ao buscar dados do gráfico DRE: $e');
    return [];
  }
}
// Set your action name, define your arguments and return parameter,
// and then add the boilerplate code using the green button on the right!
