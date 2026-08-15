// Automatic FlutterFlow imports
import '/backend/schema/structs/index.dart';
import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/custom_code/widgets/index.dart'; // Imports other custom widgets
import '/custom_code/actions/index.dart'; // Imports custom actions
import '/flutter_flow/custom_functions.dart'; // Imports custom functions
import 'package:flutter/material.dart';
// Begin custom widget code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

class GraficoSaudeGlobalCRBar extends StatelessWidget {
  const GraficoSaudeGlobalCRBar({
    super.key,
    this.width,
    this.height,
    required this.qtdVerde,
    required this.qtdAmarelo,
    required this.qtdVermelho,
  });

  final double? width;
  final double? height;
  final int qtdVerde;
  final int qtdAmarelo;
  final int qtdVermelho;

  @override
  Widget build(BuildContext context) {
    final int totalAtivos = qtdVerde + qtdAmarelo + qtdVermelho;

    // Ajuste Arquitetural: Aumentado de 16.0 para 28.0 para comportar os números com respiro visual.
    final double defaultHeight = height ?? 28.0;

    // Proteção: Se não houver dados, exibe uma barra neutra com texto explicativo.
    if (totalAtivos == 0) {
      return Container(
        width: width ?? double.infinity,
        height: defaultHeight,
        decoration: BoxDecoration(
          color: Theme.of(context).brightness == Brightness.dark
              ? const Color(0xFF262D34)
              : const Color(0xFFE0E3E7),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Center(
          child: Text(
            'Sem dados no período',
            style: TextStyle(
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.white54
                  : Colors.black54,
              fontSize: 12.0,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      );
    }

    // Estilo tipográfico unificado para os números dentro da barra
    const TextStyle textStyle = TextStyle(
      color: Colors.white,
      fontSize: 14.0,
      fontWeight: FontWeight.bold,
    );

    return Container(
      width: width ?? double.infinity,
      height: defaultHeight,
      clipBehavior: Clip.antiAlias, // Força o corte arredondado nas pontas
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          // Barra Verde (Superávit)
          if (qtdVerde > 0)
            Expanded(
              flex: qtdVerde,
              child: Container(
                color: const Color(0xFF10B981),
                child: Center(
                  child: Text('$qtdVerde', style: textStyle),
                ),
              ),
            ),

          // Gap Condicional 1
          if (qtdVerde > 0 && (qtdAmarelo > 0 || qtdVermelho > 0))
            const SizedBox(width: 3),

          // Barra Amarela (Empate / Neutro)
          if (qtdAmarelo > 0)
            Expanded(
              flex: qtdAmarelo,
              child: Container(
                color: const Color(0xFFF59E0B),
                child: Center(
                  child: Text('$qtdAmarelo', style: textStyle),
                ),
              ),
            ),

          // Gap Condicional 2
          if (qtdAmarelo > 0 && qtdVermelho > 0) const SizedBox(width: 3),

          // Barra Vermelha (Déficit)
          if (qtdVermelho > 0)
            Expanded(
              flex: qtdVermelho,
              child: Container(
                color: const Color(0xFFEF4444),
                child: Center(
                  child: Text('$qtdVermelho', style: textStyle),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
