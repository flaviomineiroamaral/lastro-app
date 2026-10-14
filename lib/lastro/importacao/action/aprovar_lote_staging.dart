// Automatic FlutterFlow imports
import '/backend/supabase/supabase.dart';
// Imports other custom actions
// Imports custom functions
import 'package:flutter/material.dart' hide RepeatMode;
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

Future<int> aprovarLoteStaging(
  String orgId,
  String contaId,
  int minConfidence,
) async {
  final supabase = Supabase.instance.client;

  try {
    // Aciona a RPC passando os parâmetros mapeados exatamente como no PostgreSQL
    final response = await supabase.rpc(
      'fn_aprovar_lote_staging',
      params: {
        'p_org_id': orgId,
        'p_conta_id': contaId,
        'p_min_confidence': minConfidence,
      },
    );

    // Converte o retorno do banco de dados para inteiro
    if (response != null) {
      return response as int;
    }

    return 0;
  } catch (e) {
    debugPrint('Erro crítico ao processar conciliação em lote: $e');
    return 0; // Em caso de falha de conexão ou erro no SQL, retorna 0 linhas afetadas
  }
}
// Set your action name, define your arguments and return parameter,
// and then add the boilerplate code using the `</>` button on the right!
