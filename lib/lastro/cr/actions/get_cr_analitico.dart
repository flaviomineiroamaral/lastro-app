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

import 'package:intl/intl.dart';

Future<List<DTCrAnaliticoStruct>> getCrAnalitico(
  String orgId,
  DateTime dataInicio,
  DateTime dataFim,
) async {
  final supabase = Supabase.instance.client;

  // Blindagem defensiva para conversão de tipos numéricos do Supabase
  double parseDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? 0.0;
    return 0.0;
  }

  try {
    // Sanitização de data imune a fuso horário (YYYY-MM-DD rigoroso)
    final strInicio = DateFormat('yyyy-MM-dd').format(dataInicio);
    final strFim = DateFormat('yyyy-MM-dd').format(dataFim);

    final response = await supabase.rpc(
      'fn_relatorio_cr_analitico',
      params: {
        'p_org_id': orgId,
        'p_data_inicio': strInicio,
        'p_data_fim': strFim,
      },
    );

    if (response != null && response is List) {
      return response.map((item) {
        final data = Map<String, dynamic>.from(item as Map);

        return DTCrAnaliticoStruct(
          // Mapeamento estrutural do Centro de Custo
          crId: data['cc_id']?.toString() ?? '',
          crNome: data['cc_nome']?.toString() ?? 'Sem Nome',
          corHex: data['cor_hex']?.toString() ?? '#8E949D',

          // Mapeamento de booleanos de configuração
          permiteAcumulo: data['permite_acumulo'] == true,
          isFundo: data['is_fundo'] == true,
          isPadrao: data['is_padrao'] == true,
          isAtivo: data['ativo'] == true,

          // Mapeamento das métricas operacionais diretas
          despesaRealizada: parseDouble(data['calc_despesa']),
          receitaPropria: parseDouble(data['calc_receita']),

          // [NOVO]: Separação contábil estrita dos Subsídios Internos
          subsidioRecebido: parseDouble(data['calc_subsidio_recebido']),
          subsidioConcedido: parseDouble(data['calc_subsidio_concedido']),

          // O saldo final do período e indicador de autossuficiência
          saldoCaixa: parseDouble(data['saldo_caixa']),
          autossuficiencia: parseDouble(data['autossuficiencia']),
        );
      }).toList();
    }

    return [];
  } catch (e) {
    debugPrint('🔴 [getCrAnalitico] Erro crítico ao processar o relatório: $e');
    return [];
  }
}
