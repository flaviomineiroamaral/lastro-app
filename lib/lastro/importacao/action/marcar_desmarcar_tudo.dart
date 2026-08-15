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

// --- ATENÇÃO: Se houver uma linha 'import /actions/actions.dart' lá em cima, APAGUE ELA MANUALMENTE ---
Future<List<OfxTransactionStruct>> marcarDesmarcarTudo(
  List<OfxTransactionStruct> listaAtual,
  bool novoStatus,
) async {
  List<OfxTransactionStruct> listaAtualizada = [];

  for (var item in listaAtual) {
    // 1. Transforma o item em um Mapa de dados editável
    // O 'Map.from' garante que criamos uma cópia que pode ser mexida
    Map<String, dynamic> dados = Map<String, dynamic>.from(item.toMap());

    // 2. Altera o valor manualmente no Mapa
    dados['selecionado'] = novoStatus;

    // 3. Reconstrói o struct a partir do Mapa alterado
    listaAtualizada.add(OfxTransactionStruct.fromMap(dados));
  }

  return listaAtualizada;
}
