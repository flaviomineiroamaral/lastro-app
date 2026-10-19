// Automatic FlutterFlow imports
import '/backend/supabase/supabase.dart';
// Imports other custom actions
// Imports custom functions
import 'package:flutter/material.dart' hide RepeatMode;
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

Future<bool> excluirAgendamentoRecorrente(
  BuildContext context,
  String organizationId,
  String transacaoId,
) async {
  try {
    final supabase = SupaFlow.client;
    // 1. Verifica se o lançamento é recorrente (FIXO ou PARCELADO)
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
    String escopoExclusao = 'APENAS_ESTE';
    if (isRecorrente) {
      final escolha = await showDialog<String>(
        context: context,
        builder: (alertDialogContext) {
          return AlertDialog(
            title: const Text('Excluir Lançamento Recorrente'),
            content: const Text(
              'Deseja excluir apenas este lançamento ou encerrar este e todos os próximos pendentes?',
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
      if (escolha == null || escolha == 'CANCELAR') {
        return false;
      }
      escopoExclusao = escolha;
    }
    await supabase.rpc(
      'fn_excluir_agendamento_recorrente',
      params: {
        'p_org_id': organizationId,
        'p_transacao_id': transacaoId,
        'p_escopo': escopoExclusao,
      },
    );
    return true;
  } catch (e) {
    debugPrint('Erro em excluirAgendamentoRecorrente: $e');
    return false;
  }
}
// Set your action name, define your arguments and return parameter,
// and then add the boilerplate code using the `</>` button on the right!
