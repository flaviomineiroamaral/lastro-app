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

List<String> formatarDropdownContas(List<DTCachePlanoContasStruct>? contas) {
  // 1. Barreira de segurança: se a lista vier nula ou vazia, aborta e devolve vazio.
  if (contas == null || contas.isEmpty) {
    return [];
  }

  // 2. Transforma (mapeia) cada linha do banco de dados num texto formatado
  return contas.map((conta) {
    final String nome = (conta.nome ?? "").trim();
    final String tipo = (conta.tipo ?? "").toUpperCase().trim();

    String emoji;

    // 3. O "Switch" avalia o tipo instantaneamente e atribui o ícone correto
    switch (tipo) {
      case 'RECEITA':
        emoji = "🟢"; // Entrada de dinheiro no DRE
        break;
      case 'DESPESA':
        emoji = "🔴"; // Saída de dinheiro no DRE
        break;
      case 'ATIVO':
        emoji = "🔵"; // Bens, direitos, contas bancárias, veículos
        break;
      case 'PASSIVO':
        emoji = "🟠"; // Dívidas, empréstimos, cartões a pagar
        break;
      case 'PL':
        emoji = "🟣"; // Capital Social, Lucros distribuídos
        break;
      default:
        emoji = "⚪"; // Categoria genérica ou sem classificação
    }

    // 4. Junta o emoji e o nome
    return "$emoji $nome";
  }).toList(); // O .toList() converte o resultado de volta para uma List<String>
}
