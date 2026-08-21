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

double? sanitizarValor(dynamic amount) {
  if (amount == null) return 0.0;

  String valStr = amount.toString().trim();
  if (valStr.isEmpty) return 0.0;

  // Verifica se o valor é negativo (prefixo -, sufixo -, ou sufixo D / DEBITO)
  bool isNegative = false;
  String upperStr = valStr.toUpperCase();
  if (valStr.startsWith('-') ||
      valStr.endsWith('-') ||
      upperStr.endsWith(' D') ||
      upperStr.endsWith('D') ||
      upperStr.endsWith('DEBITO') ||
      upperStr.endsWith('DÉBITO')) {
    isNegative = true;
  }

  // Remove caracteres que não sejam dígitos, vírgula ou ponto
  String clean = valStr.replaceAll(RegExp(r'[^0-9,.]'), '');
  if (clean.isEmpty) return 0.0;

  int lastComma = clean.lastIndexOf(',');
  int lastDot = clean.lastIndexOf('.');

  double parsed = 0.0;
  if (lastComma > lastDot) {
    // Formato brasileiro: vírgula é o separador decimal (ex: 1.234,56 ou 1234,56)
    String parteInteira = clean.substring(0, lastComma).replaceAll('.', '');
    String parteDecimal = clean.substring(lastComma + 1);
    parsed = double.tryParse("$parteInteira.$parteDecimal") ?? 0.0;
  } else if (lastDot > lastComma) {
    // Formato americano/OFX: ponto é o separador decimal (ex: 1,234.56 ou 1234.56)
    String parteInteira = clean.substring(0, lastDot).replaceAll(',', '');
    String parteDecimal = clean.substring(lastDot + 1);
    parsed = double.tryParse("$parteInteira.$parteDecimal") ?? 0.0;
  } else {
    // Sem separador decimal (ex: 1500)
    parsed = double.tryParse(clean) ?? 0.0;
  }

  return isNegative ? -parsed.abs() : parsed.abs();
}
