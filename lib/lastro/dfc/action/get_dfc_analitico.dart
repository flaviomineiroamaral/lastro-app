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

Future<List<DTDfcAnaliticoStruct>> getDfcAnalitico(
  String orgId,
  DateTime dataInicio,
  DateTime dataFim,
) async {
  final supabase = Supabase.instance.client;
  List<DTDfcAnaliticoStruct> listaDfc = [];

  try {
    // Substituímos a dependência do intl/DateFormat pelo split nativo
    // garantindo performance e nenhuma falha de importação no FF.
    final strDataInicio = dataInicio.toIso8601String().split('T').first;
    final strDataFim = dataFim.toIso8601String().split('T').first;

    // Aponta para a nova RPC otimizada com tabela temporária na RAM
    final response = await supabase.rpc('fn_relatorio_dfc_analitico', params: {
      'p_org_id': orgId,
      'p_data_inicio': strDataInicio,
      'p_data_fim': strDataFim,
    });

    if (response != null && response is List) {
      for (var linha in response) {
        listaDfc.add(DTDfcAnaliticoStruct(
          ordem: int.tryParse(linha['ordem']?.toString() ?? '0') ?? 0,
          tipoLinha: linha['tipo_linha']?.toString() ?? '',
          descricao: linha['descricao']?.toString() ?? '',
          entradas:
              double.tryParse(linha['entradas']?.toString() ?? '0') ?? 0.0,
          saidas: double.tryParse(linha['saidas']?.toString() ?? '0') ?? 0.0,
          saldo: double.tryParse(linha['saldo']?.toString() ?? '0') ?? 0.0,
          contaId: linha['conta_id']?.toString(),
          contaCodigo: linha['conta_codigo']?.toString() ?? '',
          contaNome: linha['conta_nome']?.toString() ?? '',
          contaTipo: linha['conta_tipo']?.toString() ?? '',
        ));
      }
      return listaDfc;
    } else {
      debugPrint(
          '🔴 [DEBUG DFC] Banco não retornou dados ou formato inválido.');
      return [];
    }
  } catch (e) {
    debugPrint('🔴 [DEBUG DFC] Erro CRÍTICO no carregamento estruturado: $e');
    return [];
  }
}
