
import 'package:flutter/material.dart';
import '/backend/schema/structs/index.dart';

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
