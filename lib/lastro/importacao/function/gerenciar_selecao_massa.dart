import 'dart:convert';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:timeago/timeago.dart' as timeago;
import '/flutter_flow/custom_functions.dart';
import '/flutter_flow/lat_lng.dart';
import '/flutter_flow/place.dart';
import '/flutter_flow/uploaded_file.dart';
import '/backend/schema/structs/index.dart';
import '/backend/supabase/supabase.dart';
import '/auth/supabase_auth/auth_util.dart';

List<String> gerenciarSelecaoMassa(
  List<VwExtratoIndividualRow> transacoesCarregadas,
  bool marcarTudo,
) {
// 1. Se a ordem for "Desmarcar Tudo" (false) ou não houver dados, devolvemos uma lista em branco
  if (!marcarTudo ||
      transacoesCarregadas == null ||
      transacoesCarregadas.isEmpty) {
    return [];
  }

  // 2. Se a ordem for "Marcar Tudo" (true), extraímos e guardamos todos os IDs
  List<String> idsSelecionados = [];

  for (var linha in transacoesCarregadas) {
    // Na sua View, o ID principal chama-se transacaoId
    if (linha.transacaoId != null) {
      idsSelecionados.add(linha.transacaoId!);
    }
  }

  return idsSelecionados; // Devolve todos os IDs para o Page State de uma vez!
}
