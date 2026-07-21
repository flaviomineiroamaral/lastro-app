// Automatic FlutterFlow imports
import '/flutter_flow/flutter_flow_util.dart';
// Imports other custom widgets
// Imports custom actions
// Imports custom functions
import 'package:flutter/material.dart';
// Begin custom widget code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';

class GraficoAPagarAReceber extends StatefulWidget {
  const GraficoAPagarAReceber({
    Key? key,
    this.width,
    this.height,
    required this.valorAtrasado,
    required this.valorHoje,
    required this.valorVencer,
    required this.isPagar,
  }) : super(key: key);

  final double? width;
  final double? height;
  final double valorAtrasado;
  final double valorHoje;
  final double valorVencer;
  final bool isPagar;

  @override
  _GraficoAPagarAReceberState createState() => _GraficoAPagarAReceberState();
}

class _GraficoAPagarAReceberState extends State<GraficoAPagarAReceber> {
  final formatadorReais = NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$');

  // MÁGICA 1: Abreviação inteligente para o centro do gráfico
  String formatarValorResumido(double valor) {
    if (valor.abs() >= 1000000) {
      return 'R\$ ${(valor / 1000000).toStringAsFixed(2).replaceAll('.', ',')} M';
    } else if (valor.abs() >= 10000) {
      return 'R\$ ${(valor / 1000).toStringAsFixed(1).replaceAll('.', ',')} k';
    }
    return formatadorReais.format(valor);
  }

  // MÁGICA 2: Legenda flexível (Não deixa o texto "Vencido" grudar no valor e evita overflow)
  Widget _construirItemLegenda(Color cor, String titulo, double valor) {
    if (valor <= 0) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(shape: BoxShape.circle, color: cor),
          ),
          const SizedBox(width: 8),
          Text(
            titulo,
            style: const TextStyle(color: Color(0xFF8E949D), fontSize: 12),
          ),
          const SizedBox(width: 8), // Força um espaço mínimo
          Expanded(
            // Empurra o valor todo para a direita
            child: Align(
              alignment: Alignment.centerRight,
              child: FittedBox(
                // Se o número for gigante, ele reduz a fonte em vez de quebrar a tela
                fit: BoxFit.scaleDown,
                child: Text(
                  formatadorReais.format(valor),
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double total = widget.valorAtrasado + widget.valorHoje + widget.valorVencer;
    bool isVazio = total == 0;

    Color corAtrasado = const Color(0xFFE54D4D);
    Color corHoje =
        widget.isPagar ? const Color(0xFFF2994A) : const Color(0xFF2ECA8B);
    Color corVencer =
        widget.isPagar ? const Color(0xFF5A626C) : const Color(0xFF1E8A5F);

    return Container(
      width: widget.width ?? double.infinity,
      height: widget.height ?? 300,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1D21),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              widget.isPagar ? 'A PAGAR' : 'A RECEBER',
              style: const TextStyle(
                  color: Color(0xFF8E949D),
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.0),
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 140,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'TOTAL',
                      style: TextStyle(
                          color: Colors.white.withOpacity(0.5), fontSize: 10),
                    ),
                    const SizedBox(height: 2),
                    // Blindagem do centro do gráfico com largura máxima e scaleDown
                    SizedBox(
                      width:
                          90, // Menor que o buraco da rosca para não encostar nas bordas
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          isVazio ? 'R\$ 0,00' : formatarValorResumido(total),
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),
                PieChart(
                  PieChartData(
                    borderData: FlBorderData(show: false),
                    sectionsSpace: 2,
                    centerSpaceRadius: 55,
                    sections: isVazio
                        ? [
                            PieChartSectionData(
                              color: const Color(0xFF2A2D32),
                              value: 1,
                              title: '',
                              radius: 12,
                            )
                          ]
                        : [
                            if (widget.valorAtrasado > 0)
                              PieChartSectionData(
                                color: corAtrasado,
                                value: widget.valorAtrasado,
                                title: '',
                                radius: 12,
                              ),
                            if (widget.valorHoje > 0)
                              PieChartSectionData(
                                color: corHoje,
                                value: widget.valorHoje,
                                title: '',
                                radius: 12,
                              ),
                            if (widget.valorVencer > 0)
                              PieChartSectionData(
                                color: corVencer,
                                value: widget.valorVencer,
                                title: '',
                                radius: 12,
                              ),
                          ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          if (!isVazio) ...[
            _construirItemLegenda(corAtrasado, 'Vencido', widget.valorAtrasado),
            _construirItemLegenda(corHoje, 'Hoje', widget.valorHoje),
            _construirItemLegenda(corVencer, 'A Vencer', widget.valorVencer),
          ] else ...[
            const Padding(
              padding: EdgeInsets.only(top: 10),
              child: Text('Tudo em dia!',
                  style: TextStyle(color: Color(0xFF8E949D))),
            )
          ]
        ],
      ),
    );
  }
}
