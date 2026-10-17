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

Future<bool> atualizarAgendamentoRecorrente(
  BuildContext context,
  String organizationId,
  String transacaoId,
  double valor,
  String? descricao,
  String? descricaoPadraoCategoria,
  String? categoriaId,
  String? centroCustoId,
  String? membroId,
  DateTime? dataVencimento,
  bool? isPago,
  String? contaBancariaId,
  String? tipoConta,
  DateTime? dataPagamento,
  String? comprovativoUrl,
) async {
  try {
    final supabase = SupaFlow.client;

    // 1. Verifica no banco se o lançamento faz parte de uma recorrência (FIXO ou PARCELADO)
    final row = await supabase
        .from('transacoes')
        .select('recorrencia_id, grupo_recorrencia_id, tipo_recorrencia')
        .eq('id', transacaoId)
        .eq('organization_id', organizationId)
        .maybeSingle();

    final bool isRecorrente = row != null &&
        ((row['recorrencia_id'] != null &&
                row['recorrencia_id'].toString().isNotEmpty) ||
            (row['grupo_recorrencia_id'] != null &&
                row['grupo_recorrencia_id'].toString().isNotEmpty) ||
            row['tipo_recorrencia'] == 'FIXO' ||
            row['tipo_recorrencia'] == 'PARCELADO');

    String escopoEdicao = 'APENAS_ESTE';

    // 2. Se for recorrente e ainda estiver pendente (edição de previsão), pergunta o escopo
    if (isRecorrente && isPago != true) {
      final escolhaEscopo = await showDialog<String>(
        context: context,
        builder: (alertDialogContext) {
          return AlertDialog(
            title: const Text('Lançamento Recorrente'),
            content: const Text(
              'Deseja aplicar estas alterações apenas a este lançamento ou também aos próximos pendentes?',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(alertDialogContext, 'CANCELAR'),
                child: const Text('Cancelar'),
              ),
              TextButton(
                onPressed: () =>
                    Navigator.pop(alertDialogContext, 'APENAS_ESTE'),
                child: const Text('Apenas este'),
              ),
              TextButton(
                onPressed: () =>
                    Navigator.pop(alertDialogContext, 'ESTE_E_PROXIMOS'),
                child: const Text('Este e os próximos'),
              ),
            ],
          );
        },
      );

      if (escolhaEscopo == null || escolhaEscopo == 'CANCELAR') {
        return false;
      }
      escopoEdicao = escolhaEscopo;
    }

    final String descricaoFinal =
        (descricao == null || descricao.trim().isEmpty)
            ? (descricaoPadraoCategoria ?? 'Sem descrição')
            : descricao.trim();

    final bool pago = isPago == true;

    await supabase.rpc(
      'fn_atualizar_agendamento_recorrente',
      params: {
        'p_org_id': organizationId,
        'p_transacao_id': transacaoId,
        'p_escopo': escopoEdicao,
        'p_valor': valor,
        'p_descricao': descricaoFinal,
        'p_categoria_id':
            (categoriaId?.isEmpty ?? true) ? null : categoriaId,
        'p_centro_custo_id':
            (centroCustoId?.isEmpty ?? true) ? null : centroCustoId,
        'p_membro_id': (membroId?.isEmpty ?? true) ? null : membroId,
        'p_data_vencimento': supaSerialize<DateTime>(dataVencimento),
        'p_status': pago ? 'CONCILIADO' : 'PENDENTE',
        'p_conta_bancaria_id':
            pago && !(contaBancariaId?.isEmpty ?? true)
                ? contaBancariaId
                : null,
        'p_data_pagamento': supaSerialize<DateTime>(
          pago && (tipoConta != 'CARTAO') ? dataPagamento : null,
        ),
        'p_comprovativo_url':
            (comprovativoUrl?.isEmpty ?? true) ? null : comprovativoUrl,
      },
    );

    return true;
  } catch (e) {
    debugPrint('Erro em atualizarAgendamentoRecorrente: $e');
    return false;
  }
}
