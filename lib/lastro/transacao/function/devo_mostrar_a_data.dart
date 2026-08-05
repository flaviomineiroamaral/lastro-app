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

bool devoMostrarAData(
  int indiceDaLinha,
  List<DTExtratoPeriodoStruct> listaCompleta,
) {
// 1. Se não houver lista, esconde (Falso)
  if (listaCompleta == null || listaCompleta.isEmpty) {
    return false;
  }

  // 2. A primeira linha (índice 0) SEMPRE mostra a data (Verdadeiro)
  if (indiceDaLinha == 0) {
    return true;
  }

  // 3. Pega a data da linha atual e da linha de cima
  DateTime? dataAgora = listaCompleta[indiceDaLinha].dataLinhaTempo;
  DateTime? dataDeCima = listaCompleta[indiceDaLinha - 1].dataLinhaTempo;

  // 4. Se a data de alguma linha sumir por erro, mostra por precaução
  if (dataAgora == null || dataDeCima == null) {
    return true;
  }

  // 5. Compara se o dia, mês ou ano são diferentes
  return dataAgora.day != dataDeCima.day ||
      dataAgora.month != dataDeCima.month ||
      dataAgora.year != dataDeCima.year;
}
