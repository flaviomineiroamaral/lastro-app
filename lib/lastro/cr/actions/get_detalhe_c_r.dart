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

Future<List<DTDetalheCRStruct>> getDetalheCR(
  String orgId,
  String crId,
  DateTime dataInicio,
  DateTime dataFim,
) async {
  // 1. BLINDAGEM DE PARÂMETROS (Previne Crash no PostgreSQL)
  if (orgId.isEmpty || crId.isEmpty) {
    debugPrint(
        '🔴 [getDetalheCR] Abortado: orgId ($orgId) ou crId ($crId) estão vazios.');
    return [];
  }

  final supabase = Supabase.instance.client;

  double parseDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? 0.0;
    return 0.0;
  }

  DateTime? parseDate(dynamic value) {
    if (value == null) return null;
    if (value is String) return DateTime.tryParse(value);
    return null;
  }

  try {
    final strInicio = DateFormat('yyyy-MM-dd').format(dataInicio);
    final strFim = DateFormat('yyyy-MM-dd').format(dataFim);

    debugPrint(
        '🔵 [getDetalheCR] Consultando CR $crId de $strInicio até $strFim');

    final response = await supabase.rpc(
      'fn_detalhe_cr',
      params: {
        'p_org_id': orgId,
        'p_cr_id': crId,
        'p_data_inicio': strInicio,
        'p_data_fim': strFim,
      },
    );

    if (response != null && response is List) {
      return response.map((item) {
        // 2. CAST SEGURO: Evita erro de tipagem dinâmica do Map
        final data = Map<String, dynamic>.from(item as Map);

        // Extrai o tipo de operação para validação
        final tipoOp = data['tipooperacao']?.toString().toUpperCase() ?? '';
        double valorTratado = parseDouble(data['valor']);

        // Condicional para aplicar o sinal correto no valor
        if (tipoOp == 'DEBITO') {
          valorTratado = -valorTratado.abs(); // Força o sinal negativo
        } else if (tipoOp == 'CREDITO') {
          valorTratado = valorTratado.abs(); // Força o sinal positivo
        }

        return DTDetalheCRStruct(
          transacaoId: data['transacaoid']?.toString() ?? '',
          descricao: data['descricao']?.toString() ?? '',
          valor: parseDouble(data['valor']),
          tipoOperacao: data['tipooperacao']?.toString().toUpperCase() ?? '',
          dataCompetencia: parseDate(data['datacompetencia']),
          dataVencimento: parseDate(data['datavencimento']),
          dataPagamento: parseDate(data['datapagamento']),
          contaNome: data['contanome']?.toString() ?? '',
          tipoConta: data['tipo_conta']?.toString() ?? '',
          categoriaNome: data['categorianome']?.toString() ?? '',
        );
      }).toList();
    }

    return [];
  } catch (e, stackTrace) {
    // 3. EXPOSIÇÃO DO ERRO REAL: Para o desenvolvedor parar de adivinhar
    debugPrint('🔴 [getDetalheCR] ERRO CRÍTICO: $e');
    debugPrint('🔴 [getDetalheCR] StackTrace: $stackTrace');

    // Opcional: Descomente a linha abaixo para forçar a tela a mostrar erro no modo Teste
    // throw Exception('Falha na consulta: $e');

    return [];
  }
}
