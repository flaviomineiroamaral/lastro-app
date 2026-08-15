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

Color hexToColor(String? hexString) {
  // 1. Verificação de segurança (Null Safety): se vier nulo ou vazio, devolve Cinza
  if (hexString == null || hexString.isEmpty) {
    return const Color(0xFF9E9E9E);
  }

  final buffer = StringBuffer();

  // 2. Como já garantimos que não é nulo acima, o Dart agora permite usar o .length
  if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
  buffer.write(hexString.replaceFirst('#', ''));

  // 3. Corrigido o "S" maiúsculo no toString()
  return Color(int.parse(buffer.toString(), radix: 16));
}
