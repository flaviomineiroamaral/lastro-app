// Automatic FlutterFlow imports
import '/backend/supabase/supabase.dart';
// Imports other custom actions
// Imports custom functions
import 'package:flutter/material.dart';
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

Future<bool> repassarArrecadacao(
  String orgId,
  String crProjetoId, // O projeto que gerou a riqueza
  double valor,
  String descricao,
  DateTime dataOperacao,
) async {
  final supabase = Supabase.instance.client;

  try {
    // =========================================================================
    // 1. OTIMIZAÇÃO DE REDE: Consultas Paralelas (Future.wait)
    // Dispara todas as buscas ao mesmo tempo. Reduz o tempo de loading em até 75%.
    // =========================================================================
    final results = await Future.wait([
      // Index 0: Busca a Matriz
      supabase
          .from('centros_custo')
          .select('id, nome')
          .eq('organization_id', orgId)
          .eq('is_fundo', true)
          .single(),
      // Index 1: Busca o Projeto Origem
      supabase
          .from('centros_custo')
          .select('nome')
          .eq('id', crProjetoId)
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

    // Extração segura dos resultados baseada na ordem do array acima
    final crFundoGeral = results[0];
    final crProjeto = results[1];
    final planoContas = results[2];
    final contaVirtual = results[3];

    final String crFundoGeralId = crFundoGeral['id'].toString();
    final String nomeProjeto = crProjeto['nome'].toString();
    final String transitId = planoContas['id'].toString();
    final String contaVirtualId = contaVirtual['id'].toString();

    // =========================================================================
    // 2. VALIDAÇÃO LÓGICA (Gatekeeper)
    // =========================================================================
    if (crProjetoId == crFundoGeralId) {
      debugPrint(
          'Erro Lógico: O Fundo Geral não pode repassar lucro para si próprio.');
      return false;
    }

    // 3. A SEMÂNTICA DA RIQUEZA (Extrato Contabilístico)
    final String descSaida =
        'Arrecadação/Lucro repassado ao Fundo Geral ($descricao)';
    final String descEntrada =
        'Retorno Institucional / Receita Interna do: $nomeProjeto ($descricao)';

    // 4. A VACINA DO FUSO HORÁRIO
    final dataSegura = DateTime.utc(
        dataOperacao.year, dataOperacao.month, dataOperacao.day, 12, 0, 0);
    final String timestampOperacao = dataSegura.toIso8601String();

    // =========================================================================
    // 5. ATOMICIDADE FINANCEIRA (Bulk Insert)
    // Envia o débito e o crédito numa única "viagem" ao banco.
    // Garante que não haverá perda de dados em caso de falha de conexão no telemóvel.
    // =========================================================================
    await supabase.from('transacoes').insert([
      // A. DÉBITO NO PROJETO
      {
        'organization_id': orgId,
        'centro_custo_id': crProjetoId,
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
      // B. CRÉDITO NA MATRIZ
      {
        'organization_id': orgId,
        'centro_custo_id': crFundoGeralId,
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
    debugPrint('Erro estrutural ao repassar arrecadação: $e');
    return false;
  }
}
