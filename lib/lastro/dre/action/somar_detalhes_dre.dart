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

import 'dart:math' as math;

double somarDetalhesDre(List<DTDetalheDreCategoriaStruct>? lista) {
  // Retorna 0 se a lista for nula ou estiver vazia para evitar Null Pointers
  if (lista == null || lista.isEmpty) {
    return 0.0;
  }

  double total = 0.0;

  // Laço O(N) para somar os valores
  for (var item in lista) {
    // Nota: Vi na sua imagem que você tem 'valor' e 'valorMovimento'.
    // Estou a usar o 'valor', altere se a sua regra de negócio pedir o outro.
    total += item.valor;
  }

  return total;
}
