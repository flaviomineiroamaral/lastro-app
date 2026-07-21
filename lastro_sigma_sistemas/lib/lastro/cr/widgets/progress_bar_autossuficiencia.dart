// Automatic FlutterFlow imports
import '/flutter_flow/flutter_flow_theme.dart';
// Imports other custom widgets
// Imports custom actions
// Imports custom functions
import 'package:flutter/material.dart';
// Begin custom widget code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'dart:math' as math;

class ProgressBarAutossuficiencia extends StatefulWidget {
  const ProgressBarAutossuficiencia({
    Key? key,
    this.width,
    this.height,
    required this.valorAutossuficiencia,
  }) : super(key: key);

  final double? width;
  final double? height;
  final double valorAutossuficiencia;

  @override
  _ProgressBarAutossuficienciaState createState() =>
      _ProgressBarAutossuficienciaState();
}

class _ProgressBarAutossuficienciaState
    extends State<ProgressBarAutossuficiencia> {
  @override
  Widget build(BuildContext context) {
    // 1. A Trava Matemática (O Fim do Ecrã Cinzento)
    // Se vier 125.45, ele divide por 100 (1.2545) e o math.min trava em 1.0
    double progressoSeguro = math.min(widget.valorAutossuficiencia / 100, 1.0);
    // Impede que valores negativos (se existirem) quebrem a barra
    progressoSeguro = math.max(progressoSeguro, 0.0);

    // 2. Inteligência de Governança (Cores Dinâmicas)
    Color corBarra;
    if (widget.valorAutossuficiencia < 30.0) {
      corBarra = FlutterFlowTheme.of(context).error; // Vermelho de Risco
    } else if (widget.valorAutossuficiencia < 80.0) {
      corBarra = FlutterFlowTheme.of(context).warning; // Amarelo de Atenção
    } else {
      corBarra = FlutterFlowTheme.of(context).success; // Verde de Saúde
    }

    return Container(
      width: widget.width,
      height: widget.height ?? 24.0,
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context).secondaryBackground,
        borderRadius: BorderRadius.circular(4.0),
      ),
      child: Stack(
        alignment: AlignmentDirectional.center,
        children: [
          // A Barra de Progresso Renderizada em Fundo
          ClipRRect(
            borderRadius: BorderRadius.circular(4.0),
            child: LinearProgressIndicator(
              value: progressoSeguro,
              backgroundColor: FlutterFlowTheme.of(context).alternate,
              valueColor: AlwaysStoppedAnimation<Color>(corBarra),
              minHeight: widget.height ?? 24.0,
            ),
          ),

          // O Texto Exato Sobreposto (Ex: "125.45%")
          Text(
            '${widget.valorAutossuficiencia.toStringAsFixed(1)}% Autossuficiente',
            style: FlutterFlowTheme.of(context).bodyMedium.override(
                  fontFamily: 'Readex Pro',
                  color: widget.valorAutossuficiencia > 50.0
                      ? Colors.white
                      : FlutterFlowTheme.of(context).primaryText,
                  fontSize: 12.0,
                  fontWeight: FontWeight.bold,
                ),
          ),
        ],
      ),
    );
  }
}
