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

Future<String?> createAccountSupabase(
  String email,
  String password,
  String confirmPassword, // Novo parâmetro adicionado
) async {
  // 1. Validação de Front-end interceptada no código
  if (password != confirmPassword) {
    return 'As senhas não coincidem. Verifique e tente novamente.';
  }

  // 2. Validação de segurança mínima (Opcional, mas recomendado)
  if (password.length < 6) {
    return 'A senha deve ter pelo menos 6 caracteres.';
  }

  try {
    // 3. Comunicação com a infraestrutura
    final response = await Supabase.instance.client.auth.signUp(
      email: email,
      password: password,
    );

    return null; // Sucesso
  } on AuthException catch (e) {
    final errorMsg = e.message.toLowerCase();

    if (errorMsg.contains('already registered') ||
        errorMsg.contains('already in use')) {
      return 'Este e-mail já está em uso. Tente recuperar a sua senha.';
    } else if (errorMsg.contains('invalid email')) {
      return 'O formato do e-mail é inválido.';
    }

    return 'Falha na autenticação: ${e.message}';
  } catch (e) {
    return 'Ocorreu um erro inesperado. Verifique a sua ligação à internet.';
  }
}
// Set your action name, define your arguments and return parameter,
// and then add the boilerplate code using the `</>` button on the right!
