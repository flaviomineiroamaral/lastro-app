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
import 'dart:math' as math;

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
    if (totalParcelas <= 0) return false;

    String regra = (regraCompetencia ?? "Mesmo Mês do Vencimento").trim();
    String grupoId = "GRP-${DateTime.now().millisecondsSinceEpoch}";
    List<Map<String, dynamic>> listaParaInserir = [];
    String statusOperacao = (tipoConta == 'CARTAO') ? 'CONCILIADO' : 'PENDENTE';

    // A DATA QUE VOCÊ DIGITOU É A LEI
    // Se você não digitou nada, usamos o vencimento como plano B
    DateTime baseComp = dataPrimeiraCompetencia ?? dataPrimeiroVencimento;

    for (int i = 0; i < totalParcelas; i++) {
      // --- 1. CÁLCULO DO VENCIMENTO (Sempre avança i meses) ---
      DateTime v = DateTime(dataPrimeiroVencimento.year,
          dataPrimeiroVencimento.month + i, dataPrimeiroVencimento.day);
      if (v.month != (dataPrimeiroVencimento.month + i - 1) % 12 + 1)
        v = DateTime(v.year, v.month, 0);

      // --- 2. CÁLCULO DA COMPETÊNCIA (Lógica Literal) ---
      DateTime c;

      if (regra == "Mesmo Mês da Competência") {
        // Se você digitou 07/02, aqui garantimos que o DIA 07 seja preservado
        if (manterCompetenciaFixa) {
          c = baseComp; // Todas as parcelas ficam com o dia/mês que você digitou
        } else {
          c = DateTime(baseComp.year, baseComp.month + i,
              baseComp.day); // Avança o mês mas MANTÉM O DIA digitado
        }
      } else {
        // Regras baseadas no Vencimento (Mês Anterior/Seguinte/Mesmo)
        int offset = 0;
        if (regra == "Mês Anterior") offset = -1;
        if (regra == "Mês Seguinte") offset = 1;

        if (manterCompetenciaFixa) {
          c = DateTime(v.year, v.month + offset,
              v.day); // Usa o dia do vencimento da primeira, mas trava o mês
          // Para ser fixo de verdade na primeira parcela:
          if (i == 0) baseComp = DateTime(v.year, v.month + offset, v.day);
          c = baseComp;
        } else {
          c = DateTime(v.year, v.month + offset,
              v.day); // Acompanha o dia do vencimento da parcela atual
        }
      }

      // --- 3. FORMATAÇÃO "BLINDADA" (YYYY-MM-DD) ---
      String strVenc =
          "${v.year.toString().padLeft(4, '0')}-${v.month.toString().padLeft(2, '0')}-${v.day.toString().padLeft(2, '0')}";
      String strComp =
          "${c.year.toString().padLeft(4, '0')}-${c.month.toString().padLeft(2, '0')}-${c.day.toString().padLeft(2, '0')}";

      listaParaInserir.add({
        'organization_id': organizationId,
        'conta_bancaria_id': contaId,
        'descricao':
            isParcelamento ? "$descricao (${i + 1}/$totalParcelas)" : descricao,
        'valor': valor,
        'data_vencimento': strVenc,
        'data_competencia': strComp, // Agora vai o DIA certo!
        'tipo_operacao': tipoOperacao,
        'status': statusOperacao,
        'grupo_recorrencia_id': grupoId,
        'parcela_atual': i + 1,
        'total_parcelas': totalParcelas,
        'plano_contas_id': (categoriaId?.isEmpty ?? true) ? null : categoriaId,
        'centro_custo_id':
            (centroCustoId?.isEmpty ?? true) ? null : centroCustoId,
      });
    }

    await Supabase.instance.client.from('transacoes').insert(listaParaInserir);
    return true;
  } catch (e) {
    return false;
  }
}
// Set your action name, define your arguments and return parameter,
// and then add the boilerplate code using the green button on the right!
