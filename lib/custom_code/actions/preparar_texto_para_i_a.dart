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

Future<String> prepararTextoParaIA(String textoFatura) async {
  String textoLimpo = textoFatura
      // 1. Remove TODAS as quebras de linha (a IA não precisa delas, o Regex já usou)
      .replaceAll('\r\n', ' ')
      .replaceAll('\r', ' ')
      .replaceAll('\n', ' ')
      // 2. Remove tabulações
      .replaceAll('\t', ' ')
      // 3. Garante que não há aspas duplas que quebrem o JSON
      .replaceAll('"', "'")
      // 4. Remove barras invertidas que possam criar sequências de escape inválidas
      .replaceAll('\\', ' ')
      // 5. Remove outros caracteres de controle invisíveis
      .replaceAll(RegExp(r'[\x00-\x1F\x7F-\x9F]'), ' ')
      // 6. Colapsa múltiplos espaços em um único espaço
      .replaceAll(RegExp(r' {2,}'), ' ')
      .trim();

  debugPrint(
      "prepararTextoParaIA: texto sanitizado, ${textoLimpo.length} chars");
  return textoLimpo;
}

// Set your action name, define your arguments and return parameter,
// and then add the boilerplate code using the `</>` button on the right!
