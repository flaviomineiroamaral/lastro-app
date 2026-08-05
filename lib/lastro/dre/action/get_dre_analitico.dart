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

import '/custom_code/actions/index.dart';
import '/flutter_flow/custom_functions.dart';

// Renomeado de getDreProfissional para getDreAnalitico
Future<List<DTDreAnaliticoStruct>> getDreAnalitico(
  String orgId,
  DateTime dataInicio,
  DateTime dataFim,
) async {
  final supabase = Supabase.instance.client;
  List<DTDreAnaliticoStruct> dreLista = [];

  try {
    final strDataInicio = dataInicio.toIso8601String().split('T').first;
    final strDataFim = dataFim.toIso8601String().split('T').first;

    // Aponta para a nova RPC renomeada no Supabase
    final response = await supabase.rpc(
      'fn_relatorio_dre_analitico',
      params: {
        'p_org_id': orgId,
        'p_data_inicio': strDataInicio,
        'p_data_fim': strDataFim,
      },
    );

    final List<dynamic> data = response as List<dynamic>;
    if (data.isEmpty) return [];

    double receitaBrutaTotal = 1.0;
    double totalReceitas = 0.0;
    double totalDespesas = 0.0;

    // Como o SQL retorna ordenado por código contábil, a receita raiz (1 ou 1.0)
    // obrigatoriamente estará na primeira linha. Captura linear otimizada O(1):
    final primeiraLinha = data.first;
    final String codRaiz = primeiraLinha['codigo_contabil'].toString();
    if (codRaiz == '1.0' || codRaiz == '1') {
      receitaBrutaTotal =
          (primeiraLinha['valor_total'] as num).toDouble().abs();
      if (receitaBrutaTotal == 0.0) receitaBrutaTotal = 1.0;
    }

    // Passagem única para montagem e acumulação dos dados O(N)
    for (var row in data) {
      final String cod = row['codigo_contabil'].toString();
      final double valor = (row['valor_total'] as num).toDouble();
      final bool isSintetica = row['sintetica'] as bool;
      final String tipo = row['tipo'].toString().toUpperCase();

      // Captura segura de raízes contábeis (trata 1, 1.0, 2, 2.0)
      if (tipo == 'RECEITA' && (cod == '1.0' || cod == '1')) {
        totalReceitas = valor;
      }
      if (tipo == 'DESPESA' && (cod == '2.0' || cod == '2')) {
        totalDespesas = valor;
      }

      // Regra de negócio: Oculta contas analíticas zeradas para limpar o visual da tabela
      if (valor == 0 && !isSintetica) continue;

      final double av = (valor.abs() / receitaBrutaTotal);

      dreLista.add(DTDreAnaliticoStruct(
        idConta: row['plano_contas_id'].toString(),
        codigo: cod,
        nome: row['nome'].toString(),
        tipo: tipo,
        isSintetica: isSintetica,
        nivel: row['nivel'] as int,
        valorTotal: valor,
        analiseVertical: double.parse(av.toStringAsFixed(4)),
      ));
    }

    // Injeção limpa e matemática do Resultado Líquido
    final double lucroLiquido = totalReceitas + totalDespesas;
    final double avLucro = (lucroLiquido / receitaBrutaTotal);

    dreLista.add(DTDreAnaliticoStruct(
      idConta: 'linha-calculada-resultado-final',
      codigo: '',
      nome: lucroLiquido >= 0
          ? 'LUCRO LÍQUIDO DO PERÍODO'
          : 'PREJUÍZO LÍQUIDO DO PERÍODO',
      tipo: 'RESULTADO',
      isSintetica: true,
      nivel: 0,
      valorTotal: lucroLiquido,
      analiseVertical: double.parse(avLucro.toStringAsFixed(4)),
    ));

    return dreLista;
  } catch (e) {
    debugPrint('Erro Crítico ao processar estrutura analítica do DRE: $e');
    return [];
  }
}
