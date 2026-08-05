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

bool devoMostrarADataDetalheCategoriaDRE(
  int indiceDaLinha,
  List<DTDetalheDreCategoriaStruct>? listaCompleta,
) {
// 1. Se a lista for nula ou vazia, esconde o cabeçalho
  if (listaCompleta == null || listaCompleta.isEmpty) {
    return false;
  }

  // 2. A primeira linha da tela sempre tem de mostrar a data
  if (indiceDaLinha == 0) {
    return true;
  }

  // 3. Pegamos a data do fluxo real (data_referencia_dre)
  DateTime? dataAgora = listaCompleta[indiceDaLinha].dataReferenciaDre;
  DateTime? dataDeCima = listaCompleta[indiceDaLinha - 1].dataReferenciaDre;

  // 4. Prevenção de nulos
  if (dataAgora == null || dataDeCima == null) {
    return true;
  }

  // 5. A CHAVE: Comparamos o DIA. Se mudou de dia, mostra o cabeçalho!
  return dataAgora.day != dataDeCima.day ||
      dataAgora.month != dataDeCima.month ||
      dataAgora.year != dataDeCima.year;
}
