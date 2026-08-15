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

Future<DTResumoContasAPagarReceberStruct> getProjecaoTitulosRetroativa(
  String orgId,
  DateTime dataFim,
) async {
  final supabase = Supabase.instance.client;

  double parseDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? 0.0;
    return 0.0;
  }

  try {
    final response =
        await supabase.rpc('obter_projecao_titulos_retroativa', params: {
      'p_org_id': orgId,
      'p_data_fim': dataFim.toIso8601String(),
    });

    if (response != null && response is List && response.isNotEmpty) {
      final data = response.first;

      return DTResumoContasAPagarReceberStruct(
        totalPagar: parseDouble(data['total_pagar']),
        totalPagarAtrasado: parseDouble(data['total_pagar_atrasado']),
        totalPagarHoje: parseDouble(data['total_pagar_hoje']),
        totalPagarVencer: parseDouble(data['total_pagar_vencer']),
        totalReceber: parseDouble(data['total_receber']),
        totalReceberAtrasado: parseDouble(data['total_receber_atrasado']),
        totalReceberHoje: parseDouble(data['total_receber_hoje']),
        totalReceberVencer: parseDouble(data['total_receber_vencer']),
      );
    }

    return DTResumoContasAPagarReceberStruct();
  } catch (e) {
    debugPrint('🔴 Erro na Máquina do Tempo do Contas a Pagar: $e');
    return DTResumoContasAPagarReceberStruct();
  }
}
// Set your action name, define your arguments and return parameter,
// and then add the boilerplate code using the `</>` button on the right!
