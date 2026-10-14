// Automatic FlutterFlow imports
import '/backend/schema/structs/index.dart';
import '/flutter_flow/ff_builtin_enums.dart';
import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/custom_code/actions/index.dart'; // Imports other custom actions
import '/flutter_flow/custom_functions.dart'; // Imports custom functions
import 'package:flutter/material.dart' hide RepeatMode;
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'package:supabase_flutter/supabase_flutter.dart';

Future<dynamic> ativarSerialCustomAction(
  String? serialAtivacao,
  String? userId,
) async {
  // 1. Validação estrita de Front-end (Impede que strings vazias cheguem ao banco)
  if (serialAtivacao == null || serialAtivacao.trim().isEmpty) {
    return {
      'sucesso': false,
      'mensagem': 'Serial não informado pelo aplicativo.'
    };
  }

  if (userId == null || userId.trim().isEmpty) {
    return {
      'sucesso': false,
      'mensagem': 'Sessão de usuário inválida ou não encontrada.'
    };
  }

  try {
    // 2. Chamada RPC com mapeamento explícito e blindado
    final response = await Supabase.instance.client.rpc(
      'fn_ativar_serial_e_criar_org',
      params: {
        'p_serial_ativacao': serialAtivacao.trim(),
        'p_user_id': userId.trim(),
      },
    );

    // O banco devolveu sucesso e o JSON populado
    return response;
  } on PostgrestException catch (e) {
    // 3. A GRANDE VANTAGEM: Captura o motivo exato do erro 400
    print('🔥 ERRO POSTGREST - Código: ${e.code}');
    print('Mensagem: ${e.message}');
    print('Detalhes: ${e.details}');

    return {
      'sucesso': false,
      'mensagem': 'Recusa do banco de dados: ${e.message}'
    };
  } catch (e) {
    // Falha de rede ou timeout
    print('🔥 ERRO GENÉRICO: $e');
    return {
      'sucesso': false,
      'mensagem': 'Falha na comunicação com o servidor. Verifique a internet.'
    };
  }
}
// Set your action name, define your arguments and return parameter,
// and then add the boilerplate code using the `</>` button on the right!
