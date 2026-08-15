import 'package:flutter/material.dart';
import 'flutter_flow/flutter_flow_util.dart';

abstract class FFAppConstants {
  static const int LarguraMaxima = 500;
  static const List<String> PerfilAcesso = [
    'Dono',
    'Administrador',
    'Operador',
    'Leitor'
  ];
  static const List<String> PlanoUsoLastro = ['Gratuito', 'Básico', 'Plus'];
  static const List<String> NaturezaFluxo = ['ENTRDA', 'SAIDA'];

  /// Project URL do SUPABASE local
  static const String ApiUrlProjectSupabase = 'http://127.0.0.1:54321';

  /// Authentication Keys Publishable
  static const String AnonKey =
      'sb_publishable_ACJWlzQHLZjBrEguHvfOxg_3BJgxAaH';
}
