// Automatic FlutterFlow imports
import '/flutter_flow/flutter_flow_theme.dart';
// Imports other custom widgets
// Imports custom actions
// Imports custom functions
import 'package:flutter/material.dart';
// Begin custom widget code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'dart:math' as math;

class ProgressBarFundoGeral extends StatefulWidget {
  const ProgressBarFundoGeral({
    Key? key,
    this.width,
    this.height,
    required this.arrecadado,
    required this.repassado,
  }) : super(key: key);

  final double? width;
  final double? height;
  final double arrecadado;
  final double repassado;

  @override
  _ProgressBarFundoGeralState createState() => _ProgressBarFundoGeralState();
}

class _ProgressBarFundoGeralState extends State<ProgressBarFundoGeral> {
  @override
  Widget build(BuildContext context) {
    // 1. Estados Lógicos do Mês
    final bool isSemMovimentacao =
        widget.arrecadado == 0.0 && widget.repassado == 0.0;
    final bool isUsandoReservas = widget.repassado > widget.arrecadado;

    // 2. Cálculo Blindado (Prevenção de Divisão por Zero)
    double indiceRepasse = 0.0;

    if (!isSemMovimentacao) {
      if (widget.arrecadado == 0.0 && widget.repassado > 0.0) {
        // Cenário extremo: Arrecadou nada, mas repassou (Infinito% matemático)
        // Setamos visualmente como a porcentagem de uso puro
        indiceRepasse = 100.0; // A barra encherá toda
      } else {
        // Cálculo padrão
        indiceRepasse = (widget.repassado / widget.arrecadado) * 100;
      }
    }

    // 3. Trava Matemática Visual
    double progressoSeguro = math.min(indiceRepasse / 100.0, 1.0);
    progressoSeguro = math.max(progressoSeguro, 0.0);

    // 4. Semântica de Cores Inteligente
    Color corBarra;
    if (isSemMovimentacao) {
      corBarra =
          FlutterFlowTheme.of(context).secondaryBackground; // Invisível/Cinza
    } else if (isUsandoReservas) {
      corBarra = FlutterFlowTheme.of(context)
          .tertiary; // Informativo (Transferência Interna)
    } else if (indiceRepasse < 50.0) {
      corBarra =
          FlutterFlowTheme.of(context).warning; // Atenção (Retendo muito)
    } else {
      corBarra = FlutterFlowTheme.of(context).success; // Verde Saudável
    }

    // 5. Montagem do Rótulo Dinâmico
    String textoExibido;
    if (isSemMovimentacao) {
      textoExibido = 'SEM MOVIMENTAÇÃO';
    } else if (isUsandoReservas) {
      // Quando usa reservas com arrecadação 0, exibe o valor repassado direto para não dar % infinita
      if (widget.arrecadado == 0.0) {
        textoExibido =
            'REPASSE: R\$ ${widget.repassado.toStringAsFixed(2)} (USOU RESERVAS)';
      } else {
        textoExibido =
            'REPASSE: ${indiceRepasse.toStringAsFixed(1)}% (USOU RESERVAS)';
      }
    } else {
      textoExibido = 'REPASSE: ${indiceRepasse.toStringAsFixed(1)}%';
    }

    // 6. Acessibilidade Visual (Contraste)
    Color corTexto;
    if (isSemMovimentacao) {
      corTexto =
          FlutterFlowTheme.of(context).secondaryText; // Cinza claro/escuro
    } else if (isUsandoReservas || progressoSeguro > 0.5) {
      corTexto = Colors.white;
    } else {
      corTexto = FlutterFlowTheme.of(context).primaryText;
    }

    return Container(
      width: widget.width,
      height: widget.height ?? 24.0,
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context).secondaryBackground,
        borderRadius: BorderRadius.circular(4.0),
        border: isSemMovimentacao
            ? Border.all(
                color: FlutterFlowTheme.of(context).alternate, width: 1.0)
            : null,
      ),
      child: Stack(
        alignment: AlignmentDirectional.center,
        children: [
          // A Barra de Progresso Renderizada em Fundo
          Align(
            alignment: Alignment.centerLeft,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(4.0),
              child: LinearProgressIndicator(
                value: isSemMovimentacao ? 0.0 : progressoSeguro,
                backgroundColor: FlutterFlowTheme.of(context).alternate,
                valueColor: AlwaysStoppedAnimation<Color>(corBarra),
                minHeight: widget.height ?? 24.0,
              ),
            ),
          ),

          // O Texto Exato Sobreposto
          Text(
            textoExibido,
            style: FlutterFlowTheme.of(context).bodyMedium.override(
                  fontFamily: 'Readex Pro',
                  color: corTexto,
                  fontSize: 12.0,
                  fontWeight: FontWeight.bold,
                ),
          ),
        ],
      ),
    );
  }
}
// Set your widget name, define your parameter, and then add the
// boilerplate code using the green button on the right!
