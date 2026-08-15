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

//import 'index.dart'; // Imports other custom actions

Future<dynamic> addOrganizationMemberRPC(
  String pProfileId,
  String pOrgId,
  String pFuncao,
) async {
  // Inicializa o  cliente Supabase
  final supabase = SupaFlow.client;

  try {
    // Chama a função no banco de dados passando os parâmetros
    final response = await supabase.rpc(
      'add_organization_member',
      params: {
        'p_profile_id': pProfileId,
        'p_org_id': pOrgId,
        'p_funcao': pFuncao,
      },
    );

    // Retorna o JSON exato que o banco gerou (com sucesso e mensagem)
    return response;
  } catch (e) {
    print('Erro ao adicionar membro: $e');

    // Tratamento de falha nativo: devolve um JSON falso para a tela ler o erro
    return {'sucesso': false, 'mensagem': 'Erro de conexão ou execução: $e'};
  }
}
