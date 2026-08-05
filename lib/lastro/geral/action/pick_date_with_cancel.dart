// Automatic FlutterFlow imports
import '/backend/schema/structs/index.dart';
import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/custom_code/actions/index.dart'; // Imports other custom actions
import '/flutter_flow/custom_functions.dart'; // Imports custom functions
import 'package:flutter/material.dart';
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

Future<DateTime?> pickDateWithCancel(
  BuildContext context,
  DateTime? initialDate,
) async {
  // 1. Capturamos o Tema Global do FlutterFlow (Ele já sabe se é Light ou Dark)
  final ffTheme = FlutterFlowTheme.of(context);

  final DateTime? pickedDate = await showDatePicker(
    context: context,
    initialDate: initialDate ?? DateTime.now(),
    firstDate: DateTime(2000),
    lastDate: DateTime(2100),

    // 2. O Construtor Visual Dinâmico
    builder: (BuildContext context, Widget? child) {
      return Theme(
        data: Theme.of(context).copyWith(
          colorScheme: Theme.of(context).colorScheme.copyWith(
                // Fundo do cabeçalho e círculo -> Puxa a sua cor "Primary" do painel
                primary: ffTheme.primary,

                // Cor do texto no cabeçalho -> "info" no FF costuma ser a cor Branca pura
                onPrimary: ffTheme.info,

                // Fundo do calendário -> Puxa o fundo secundário (branco no light, cinza escuro no dark)
                surface: ffTheme.secondaryBackground,

                // Cor dos números dos dias -> Puxa o texto principal (preto no light, branco no dark)
                onSurface: ffTheme.primaryText,

                // Cor dos dias da semana (S, M, T...) -> Puxa o texto secundário (cinza)
                onSurfaceVariant: ffTheme.secondaryText,
              ),

          // Botões de Ação (OK / CANCELAR)
          textButtonTheme: TextButtonThemeData(
            style: TextButton.styleFrom(
              // Cor do texto dos botões -> Puxa a cor "Primary"
              foregroundColor: ffTheme.primary,
            ),
          ),

          // Formato do Seletor de Ano
          datePickerTheme: DatePickerThemeData(
            headerBackgroundColor: ffTheme.primary,
            headerForegroundColor: ffTheme.info,
          ),
        ),
        child: child!,
      );
    },
  );

  return pickedDate;
}
