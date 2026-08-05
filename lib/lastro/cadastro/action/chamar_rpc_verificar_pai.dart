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

import 'package:supabase_flutter/supabase_flutter.dart';

Future<bool> chamarRpcVerificarPai(
  String orgId,
  String codigoFilho,
) async {
  // Pega a instância global do cliente Supabase configurada no FlutterFlow
  final supabase = Supabase.instance.client;

  try {
    // Faz a chamada para a função RPC criada no banco de dados
    final response = await supabase.rpc(
      'verificar_pai_tem_transacoes', // Nome exato da função no Postgres
      params: {
        'p_organization_id': orgId,
        'p_codigo_filho': codigoFilho,
      },
    );

    // O retorno da nossa função SQL é um BOOLEAN
    // Convertendo com segurança para evitar null checks
    return response == true;
  } catch (e) {
    // Em caso de erro de rede ou SQL, logamos no console
    print('Erro ao executar RPC verificar_pai_tem_transacoes: $e');
    // Retornamos true (Pai Inválido) por segurança, para bloquear a criação
    // caso o banco de dados esteja inacessível.
    return true;
  }
}
// Set your action name, define your arguments and return parameter,
// and then add the boilerplate code using the green button on the right!
