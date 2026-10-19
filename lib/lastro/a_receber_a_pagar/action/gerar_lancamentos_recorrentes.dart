// Automatic FlutterFlow imports
import '/backend/supabase/supabase.dart';
// Imports other custom actions
// Imports custom functions
import 'package:flutter/material.dart' hide RepeatMode;
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!


Future<bool> gerarLancamentosRecorrentes(
  String organizationId,
  String? contaId,
  String? tipoConta,
  String descricao,
  double valor,
  DateTime dataPrimeiroVencimento,
  DateTime? dataPrimeiraCompetencia,
  String? regraCompetencia,
  bool manterCompetenciaFixa,
  String tipoOperacao,
  int totalParcelas,
  bool isParcelamento,
  String? categoriaId,
  String? centroCustoId,
) async {
  try {
    if (isParcelamento && totalParcelas <= 0) return false;
    String regra = (regraCompetencia ?? "Mesmo Mês do Vencimento").trim();
    DateTime baseComp = dataPrimeiraCompetencia ?? dataPrimeiroVencimento;
    String strPrimeiroVenc =
        "${dataPrimeiroVencimento.year.toString().padLeft(4, '0')}-${dataPrimeiroVencimento.month.toString().padLeft(2, '0')}-${dataPrimeiroVencimento.day.toString().padLeft(2, '0')}";
    String strPrimeiraComp =
        "${baseComp.year.toString().padLeft(4, '0')}-${baseComp.month.toString().padLeft(2, '0')}-${baseComp.day.toString().padLeft(2, '0')}";
    final response = await Supabase.instance.client.rpc(
      'fn_criar_lancamento_recorrente',
      params: {
        'p_org_id': organizationId,
        'p_conta_id': (contaId?.isEmpty ?? true) ? null : contaId,
        'p_tipo_conta': tipoConta,
        'p_descricao': descricao,
        'p_valor': valor,
        'p_data_primeiro_vencimento': strPrimeiroVenc,
        'p_data_primeira_competencia': strPrimeiraComp,
        'p_regra_competencia': regra,
        'p_manter_competencia_fixa': manterCompetenciaFixa,
        'p_tipo_operacao': tipoOperacao,
        'p_total_parcelas': isParcelamento ? totalParcelas : 12,
        'p_is_parcelamento': isParcelamento,
        'p_categoria_id': (categoriaId?.isEmpty ?? true) ? null : categoriaId,
        'p_centro_custo_id':
            (centroCustoId?.isEmpty ?? true) ? null : centroCustoId,
        'p_membro_id': null,
        'p_primeira_paga': (contaId != null && contaId.isNotEmpty),
        'p_data_pagamento': null,
      },
    );
    if (response is Map && response['sucesso'] == true) {
      return true;
    }
    return response != null;
  } catch (e) {
    debugPrint('Erro em gerarLancamentosRecorrentes (RPC): $e');
    return false;
  }
}
// Set your action name, define your arguments and return parameter,
// and then add the boilerplate code using the green button on the right!
