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

Future<String?> validarCodigoContabil(
  String codigoDigitado,
  String categoriaSelecionada,
  List<String> codigosExistentes,
) async {
  if (codigoDigitado.trim().isEmpty) return 'O código é obrigatório.';

  // 1. Validar Prefixo de Categoria (Evita Passivo começando com 1)
  Map<String, String> prefixos = {
    'RECEITA': '1',
    'DESPESA': '2',
    'ATIVO': '3',
    'PASSIVO': '4',
    'PL': '5',
  };

  if (prefixos.containsKey(categoriaSelecionada) &&
      !codigoDigitado.startsWith(prefixos[categoriaSelecionada]!)) {
    return 'Contas do tipo $categoriaSelecionada devem começar com ${prefixos[categoriaSelecionada]}.';
  }

  // 2. Validar Máscara e Formato (Impede letras ou pontuação dupla)
  RegExp regExp = RegExp(r'^[1-5](\.[0-9]{1,3}){0,3}$');
  if (!regExp.hasMatch(codigoDigitado)) {
    return 'Formato inválido. Use números separados por pontos (Ex: 1.1.02)';
  }

  // 3. Validar Duplicidade
  if (codigosExistentes.contains(codigoDigitado)) {
    return 'Este código contábil já está em uso.';
  }

  // 4. Validar Existência do Pai (Se não for conta raiz)
  if (codigoDigitado.contains('.')) {
    List<String> partes = codigoDigitado.split('.');
    partes.removeLast();
    String codigoPai = partes.join('.');

    if (!codigosExistentes.contains(codigoPai)) {
      return 'Você não pode criar a conta $codigoDigitado porque o grupo Pai ($codigoPai) não existe.';
    }
  }

  return null; // Tudo válido do lado da interface!
}
// Set your action name, define your arguments and return parameter,
// and then add the boilerplate code using the green button on the right!
