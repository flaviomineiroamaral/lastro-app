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

DateTime getUltimoDiaDoMesPassado() {
  DateTime agora = DateTime.now();
  // Pede o mês atual + 1 (próximo mês), mas pede o dia 0.
  // O Dart volta para o último dia do mês atual. Hora 23:59:59.
  return DateTime(agora.year, agora.month, 0, 23, 59, 59);
}
