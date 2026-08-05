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

Future<bool> acionarGeradorRecorrencias() async {
  /// Executa a rotina RPC no motor do PostgreSQL via Supabase.
  try {
    // Acessa o cliente do Supabase já instanciado no FlutterFlow
    final supabase = SupaFlow.client;

    // Dispara a Remote Procedure Call. O nome deve ser estritamente igual ao do banco.
    await supabase.rpc('fn_gerar_transacoes_recorrentes');

    // Retorna verdadeiro para confirmar à interface que a carga foi disparada
    return true;
  } catch (e) {
    // Em caso de falha de conexão ou erro no banco, registra no console e retorna falso.
    debugPrint('Erro ao disparar gerador de transações: $e');
    return false;
  }
}
// Set your action name, define your arguments and return parameter,
// and then add the boilerplate code using the `</>` button on the right!
