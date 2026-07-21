// Automatic FlutterFlow imports
import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_util.dart';
// Imports other custom actions
// Imports custom functions
import 'package:flutter/material.dart';
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'package:intl/intl.dart';

Future<List<dynamic>> getGraficoDfc(
  String orgId,
  DateTime dataInicio,
  DateTime dataFim,
) async {
  final supabase = Supabase.instance.client;

  try {
    // Isolamento estrito de YYYY-MM-DD mitigando mutações locais de fuso horário
    final strDataInicio = DateFormat('yyyy-MM-dd').format(dataInicio);
    final strDataFim = DateFormat('yyyy-MM-dd').format(dataFim);

    final response = await supabase.rpc('fn_grafico_dfc_diario', params: {
      'p_org_id': orgId,
      'p_data_inicio': strDataInicio,
      'p_data_fim': strDataFim,
    });

    return (response as List<dynamic>?) ?? [];
  } catch (e) {
    debugPrint('Erro crítico de transporte na Action DFC: $e');
    return [];
  }
}
