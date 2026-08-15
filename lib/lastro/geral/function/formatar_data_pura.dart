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

String formatarDataPura(String? dataBanco) {
// Se a data vier nula, retorna um traço
  if (dataBanco == null || dataBanco.trim().isEmpty) {
    return '-';
  }

  try {
    // Exemplo do banco: "2026-02-01"
    // Pega apenas os 10 primeiros caracteres para ignorar qualquer lixo de horas
    String dataLimpa = dataBanco.substring(0, 10);

    // Divide a string em Ano, Mês e Dia
    List<String> partes = dataLimpa.split('-');
    if (partes.length == 3) {
      String ano = partes[0];
      String mes = partes[1];
      String dia = partes[2];

      // Monta e devolve a string engessada no padrão brasileiro (DD/MM/YYYY)
      // Nenhuma matemática de tempo é aplicada, impedindo o recuo do fuso horário.
      return '$dia/$mes/$ano';
    }
    return dataBanco; // Fallback se o formato for estranho
  } catch (e) {
    return dataBanco;
  }
}
