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

class GraficoDRE extends StatefulWidget {
  const GraficoDRE({
    Key? key,
    this.width,
    this.height,
    required this.dadosDiarios,
  }) : super(key: key);

  final double? width;
  final double? height;
  final List<dynamic>? dadosDiarios;

  @override
  _GraficoDREState createState() => _GraficoDREState();
}

class _GraficoDREState extends State<GraficoDRE> {
  final formatadorReais = NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$');

  String formatarValorResumido(double valor) {
    if (valor.abs() >= 1000000) {
      return '${(valor / 1000000).toStringAsFixed(1)}M';
    } else if (valor.abs() >= 1000) {
      return '${(valor / 1000).toStringAsFixed(1)}k';
    }
    return valor.toStringAsFixed(0);
  }

  @override
  Widget build(BuildContext context) {
    if (widget.dadosDiarios == null || widget.dadosDiarios!.isEmpty) {
      return const Center(
        child: Text(
          'Sem dados de competência neste período',
          style: TextStyle(color: Colors.grey, fontSize: 14),
        ),
      );
    }

    List<BarChartGroupData> barGroups = [];
    double maxY = 0;
    double minY = 0;

    for (int i = 0; i < widget.dadosDiarios!.length; i++) {
      final linha = widget.dadosDiarios![i];

      // MODIFICAÇÃO CONTÁBIL: Lendo Receitas e Despesas do DRE
      double receitas = (linha['total_receitas'] as num?)?.toDouble() ?? 0.0;
      double despesas = (linha['total_despesas'] as num?)?.toDouble() ?? 0.0;

      if (receitas > maxY) maxY = receitas;
      if (despesas > maxY) maxY = despesas;

      barGroups.add(
        BarChartGroupData(
          x: i,
          barRods: [
            // BARRA 1: RECEITAS (VERDE)
            BarChartRodData(
              toY: receitas,
              gradient: const LinearGradient(
                colors: [Color(0xFF1E8A5F), Color(0xFF2ECA8B)],
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
              ),
              width: 12,
              borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(6), topRight: Radius.circular(6)),
            ),
            // BARRA 2: DESPESAS (VERMELHA)
            BarChartRodData(
              toY: despesas,
              gradient: const LinearGradient(
                colors: [Color(0xFF9E3333), Color(0xFFE54D4D)],
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
              ),
              width: 12,
              borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(6), topRight: Radius.circular(6)),
            ),
          ],
        ),
      );
    }

    maxY = maxY == 0 ? 100 : maxY * 1.2;
    minY = 0; // O piso do gráfico é firmemente cravado no zero

    double screenWidth = MediaQuery.of(context).size.width;
    double chartIdealWidth = widget.dadosDiarios!.length * 45.0;
    double finalWidth =
        chartIdealWidth > screenWidth ? chartIdealWidth : screenWidth;

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      child: Container(
        width: finalWidth,
        height: widget.height ?? 300,
        padding: const EdgeInsets.only(top: 20, bottom: 10, left: 0, right: 20),
        child: BarChart(
          BarChartData(
            alignment: BarChartAlignment.spaceAround,
            maxY: maxY,
            minY: minY,
            barTouchData: BarTouchData(
              enabled: true,
              touchTooltipData: BarTouchTooltipData(
                tooltipBgColor: const Color(0xFF1A1D21).withOpacity(0.95),
                fitInsideHorizontally: true,
                fitInsideVertically: true,
                tooltipPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                tooltipMargin: 8,
                getTooltipItem: (group, groupIndex, rod, rodIndex) {
                  String dataLabel =
                      widget.dadosDiarios![group.x.toInt()]['dia'].toString();

                  // Identificamos se é Receita/Despesa pela posição da barra (rodIndex)
                  bool isReceita = rodIndex == 0;

                  String tipo = isReceita
                      ? 'Receita • $dataLabel\n'
                      : 'Despesa • $dataLabel\n';
                  String valorFormatado = formatadorReais.format(rod.toY.abs());

                  return BarTooltipItem(
                    tipo,
                    TextStyle(
                      color: isReceita
                          ? const Color(0xFF2ECA8B)
                          : const Color(0xFFE54D4D),
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                    children: <TextSpan>[
                      TextSpan(
                        text: valorFormatado,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
            titlesData: FlTitlesData(
              show: true,
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 30,
                  getTitlesWidget: (value, meta) {
                    int index = value.toInt();
                    if (index >= 0 && index < widget.dadosDiarios!.length) {
                      return Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text(
                          widget.dadosDiarios![index]['dia'].toString(),
                          style: const TextStyle(
                              fontSize: 11,
                              color: Color(0xFF8E949D),
                              fontWeight: FontWeight.w500),
                        ),
                      );
                    }
                    return const Text('');
                  },
                ),
              ),
              leftTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 45,
                  getTitlesWidget: (value, meta) {
                    if (value == 0 || value == maxY || value == minY) {
                      return const SizedBox.shrink();
                    }
                    return Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: Text(
                        formatarValorResumido(value),
                        style: const TextStyle(
                          color: Color(0xFF5A626C),
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.right,
                      ),
                    );
                  },
                ),
              ),
              topTitles:
                  const AxisTitles(sideTitles: SideTitles(showTitles: false)),
              rightTitles:
                  const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            ),
            gridData: FlGridData(
              show: true,
              drawVerticalLine: false,
              getDrawingHorizontalLine: (value) {
                if (value == 0) {
                  return FlLine(
                      color: const Color(0xFF3D4449), strokeWidth: 1.5);
                }
                return FlLine(
                    color: Colors.white.withOpacity(0.05),
                    strokeWidth: 1,
                    dashArray: [4, 4]);
              },
            ),
            borderData: FlBorderData(show: false),
            barGroups: barGroups,
          ),
          swapAnimationDuration: const Duration(milliseconds: 800),
          swapAnimationCurve: Curves.easeOutQuart,
        ),
      ),
    );
  }
}
