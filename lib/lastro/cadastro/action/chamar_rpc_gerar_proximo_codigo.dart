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

Future<String> chamarRpcGerarProximoCodigo(
  String orgId,
  String codigoPai,
) async {
  final supabase = Supabase.instance.client;

  try {
    final response = await supabase.rpc(
      'gerar_proximo_codigo_subconta',
      params: {
        'p_organization_id': orgId,
        'p_codigo_pai': codigoPai,
      },
    );

    // Retorna a string do novo código (ex: "2.5.11")
    return response.toString();
  } catch (e) {
    print('Erro ao gerar código: $e');
    return 'ERRO';
  }
}
// Set your action name, define your arguments and return parameter,
// and then add the boilerplate code using the green button on the right!
