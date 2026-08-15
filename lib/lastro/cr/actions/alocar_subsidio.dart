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

Future<bool> alocarSubsidio(
  String orgId,
  String crDestinoId, // A origem foi removida; a UI envia apenas o destino
  double valor,
  String descricao,
  DateTime dataOperacao,
) async {
  final supabase = Supabase.instance.client;

  try {
    // =========================================================================
    // 1. OTIMIZAÇÃO DE REDE: Consultas Paralelas (Future.wait)
    // =========================================================================
    final results = await Future.wait([
      // Index 0: Busca a Matriz (O Gatekeeper Automático)
      supabase
          .from('centros_custo')
          .select('id, nome')
          .eq('organization_id', orgId)
          .eq('is_fundo', true)
          .single(),
      // Index 1: Busca o Projeto Destino
      supabase
          .from('centros_custo')
          .select('nome')
          .eq('id', crDestinoId)
          .single(),
      // Index 2: Busca a Conta Contábil de Trânsito
      supabase
          .from('plano_contas')
          .select('id')
          .eq('organization_id', orgId)
          .eq('codigo_contabil', '9.9.99')
          .single(),
      // Index 3: Busca a Conta Bancária Virtual
      supabase
          .from('contas_bancarias')
          .select('id')
          .eq('organization_id', orgId)
          .eq('tipo', 'VIRTUAL')
          .single(),
    ]);

    // Extração baseada na ordem estrutural
    final crOrigem = results[0];
    final crDestino = results[1];
    final planoContas = results[2];
    final contaVirtual = results[3];

    final String crOrigemId = crOrigem['id'].toString();
    final String nomeDestino = crDestino['nome'].toString();
    final String transitId = planoContas['id'].toString();
    final String contaVirtualId = contaVirtual['id'].toString();

    // =========================================================================
    // 2. VALIDAÇÃO DE AUTO-TRANSFERÊNCIA
    // =========================================================================
    if (crOrigemId == crDestinoId) {
      debugPrint(
          'Erro: O projeto de destino não pode ser o próprio Fundo Geral.');
      return false;
    }

    // 3. SEMÂNTICA FIXA (Fluxo Único Top-Down)
    final String descSaida = 'Subsídio Alocado para: $nomeDestino ($descricao)';
    final String descEntrada = 'Subsídio Recebido do Fundo Geral ($descricao)';

    // 4. A VACINA DO FUSO HORÁRIO
    final dataSegura = DateTime.utc(
        dataOperacao.year, dataOperacao.month, dataOperacao.day, 12, 0, 0);
    final String timestampOperacao = dataSegura.toIso8601String();

    // =========================================================================
    // 5. ATOMICIDADE FINANCEIRA (Bulk Insert)
    // Executa a saída e a entrada no mesmo milissegundo.
    // =========================================================================
    await supabase.from('transacoes').insert([
      // A. DÉBITO NO FUNDO GERAL (Sai da Matriz)
      {
        'organization_id': orgId,
        'centro_custo_id': crOrigemId,
        'plano_contas_id': transitId,
        'conta_bancaria_id': contaVirtualId,
        'valor': valor,
        'tipo_operacao': 'DEBITO',
        'descricao': descSaida,
        'data_pagamento': timestampOperacao,
        'data_vencimento': timestampOperacao,
        'data_competencia': timestampOperacao,
        'status': 'CONCILIADO'
      },
      // B. CRÉDITO NO PROJETO DESTINO (Entra no Projeto)
      {
        'organization_id': orgId,
        'centro_custo_id': crDestinoId,
        'plano_contas_id': transitId,
        'conta_bancaria_id': contaVirtualId,
        'valor': valor,
        'tipo_operacao': 'CREDITO',
        'descricao': descEntrada,
        'data_pagamento': timestampOperacao,
        'data_vencimento': timestampOperacao,
        'data_competencia': timestampOperacao,
        'status': 'CONCILIADO'
      }
    ]);

    return true;
  } catch (e) {
    debugPrint('Erro estrutural ao alocar subsídio: $e');
    return false;
  }
}
