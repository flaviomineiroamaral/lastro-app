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

Future<DTDetalheTransacaoStruct?> getDetalheTransacao(
  String orgId,
  String transacaoId,
) async {
  final supabase = Supabase.instance.client;

  try {
    // Dispara a RPC otimizada
    final response =
        await supabase.rpc('obter_detalhe_transacao_otimizado', params: {
      'p_org_id': orgId,
      'p_transacao_id': transacaoId,
    });

    // A RPC usa RETURNS TABLE, logo o PostgreSQL devolve sempre um Array JSON [{}].
    // Como filtramos por ID, sabemos que só vem 1 posição. Extraímos a posição .first.
    if (response != null && response is List && response.isNotEmpty) {
      final item = response.first;

      return DTDetalheTransacaoStruct(
        transacaoId: item['transacao_id']?.toString() ?? '',

        // Datas com tratamento de nulos
        dataPagamento: item['data_pagamento'] != null
            ? DateTime.tryParse(item['data_pagamento'].toString())
            : null,
        dataVencimento: item['data_vencimento'] != null
            ? DateTime.tryParse(item['data_vencimento'].toString())
            : null,
        dataCompetencia: item['data_competencia'] != null
            ? DateTime.tryParse(item['data_competencia'].toString())
            : null,

        descricao: item['descricao']?.toString() ?? '',
        tipoOperacao: item['tipo_operacao']?.toString() ?? '',
        status: item['status']?.toString() ?? '',
        valor: double.tryParse(item['valor']?.toString() ?? '0') ?? 0.0,

        // Nomes já traduzidos pelo JOIN
        contaOrigemId: item['conta_bancaria_id']?.toString() ?? '',
        contaOrigemNome: item['conta_origem_nome']?.toString() ?? '',
        contaDestinoId: item['conta_destino_id']?.toString() ?? '',
        contaDestinoNome: item['conta_destino_nome']?.toString() ?? '',
        categoriaId: item['plano_contas_id']?.toString() ?? '',
        categoriaNome: item['categoria_nome']?.toString() ?? '',
        centroCustoId: item['centro_custo_id']?.toString() ?? '',
        centroCustoNome: item['centro_custo_nome']?.toString() ?? '',
        membroId: item['membro_id']?.toString() ?? '',
        membroNome: item['membro_nome']?.toString() ?? '',

        observacoes: item['observacoes']?.toString() ?? '',
        comprovativoUrl: item['comprovativo_url']?.toString() ?? '',
      );
    }

    print(
        '🟡 [DEBUG] Transação não encontrada ou fora do escopo da organização.');
    return null;
  } catch (e) {
    print('🔴 [DEBUG] Erro ao buscar detalhe isolado: $e');
    return null;
  }
}
