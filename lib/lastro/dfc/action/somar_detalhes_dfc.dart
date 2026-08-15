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

double somarDetalhesDfc(List<DTDetalheDfcCategoriaStruct>? lista) {
  // Proteção contra listas vazias
  if (lista == null || lista.isEmpty) {
    return 0.0;
  }

  double total = 0.0;

  for (var item in lista) {
    total += item.valor;
  }

  return total;
}
