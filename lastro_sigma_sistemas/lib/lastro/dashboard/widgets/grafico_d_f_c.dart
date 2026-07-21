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
import 'dart:math' as math;

class GraficoDFC extends StatefulWidget {
  const GraficoDFC({
    Key? key,
    this.width,
    this.height,
    required this.dadosDiarios,
  }) : super(key: key);

  final double? width;
  final double? height;
  final List<dynamic>? dadosDiarios;

  @override
  _GraficoDFCState createState() => _GraficoDFCState();
}

class _GraficoDFCState extends State<GraficoDFC> {
  final formatadorReais = NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$');

  // Interpretador defensivo contra mutações de tipo String/Numeric vindas do JSON do Supabase
  double _parseDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is num) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? 0.0;
    return 0.0;
  }

  String formatarValorResumido(double valor) {
    if (valor.abs() >= 1000000) {
      return '${(valor / 1000000).toStringAsFixed(1)}M';
    } else if (valor.abs() >= 1000) {
      return '${(valor / 1000).toStringAsFixed(1)}k';
    }
    return valor.toStringAsFixed(0);
  }

  String formatarDiaExibicao(String dataRaw) {
    try {
      final dataParsed = DateTime.parse(dataRaw);
      return DateFormat('dd/MM').format(dataParsed);
    } catch (e) {
      return dataRaw;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.dadosDiarios == null || widget.dadosDiarios!.isEmpty) {
      return const Center(
        child: Text(
          'Sem movimentos neste período',
          style: TextStyle(color: Colors.grey, fontSize: 14),
        ),
      );
    }

    List<BarChartGroupData> barGroups = [];
    List<FlSpot> trendLineSpots = [];
    double maxY = 0;
    final int totalPontosX = widget.dadosDiarios!.length;

    // 1. Determinação analítica do teto do gráfico (Sincronização de escala de eixos)
    for (int i = 0; i < totalPontosX; i++) {
      final linha = widget.dadosDiarios![i];
      double entradas = _parseDouble(linha['total_entradas']);
      double saidas = _parseDouble(linha['total_saidas']);
      double tendencia = _parseDouble(linha['tendencia_entradas']);
      maxY = [maxY, entradas, saidas, tendencia].reduce(math.max);
    }

    maxY = maxY == 0
        ? 100
        : maxY * 1.25; // Adiciona margem de segurança de 25% no topo
    const double minY = 0.0;

    // 2. Construção estrutural das séries de dados
    for (int i = 0; i < totalPontosX; i++) {
      final linha = widget.dadosDiarios![i];
      double entradas = _parseDouble(linha['total_entradas']);
      double saidas = _parseDouble(linha['total_saidas']);
      double tendencia = _parseDouble(linha['tendencia_entradas']);
      bool isPredicao = linha['is_predicao'] as bool? ?? false;

      trendLineSpots.add(FlSpot(i.toDouble(), tendencia));

      if (isPredicao) {
        // Área de captação de toque futura (Barra fantasma transparente)
        barGroups.add(
          BarChartGroupData(
            x: i,
            barRods: [
              BarChartRodData(
                toY: maxY,
                color: Colors.transparent,
                width: 24,
              ),
            ],
          ),
        );
      } else {
        // Dados operacionais realizados
        barGroups.add(
          BarChartGroupData(
            x: i,
            barRods: [
              BarChartRodData(
                toY: entradas,
                gradient: const LinearGradient(
                  colors: [Color(0xFF1E8A5F), Color(0xFF2ECA8B)],
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                ),
                width: 12,
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(6), topRight: Radius.circular(6)),
              ),
              BarChartRodData(
                toY: saidas,
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
    }

    double screenWidth = MediaQuery.of(context).size.width;
    double chartIdealWidth = totalPontosX * 45.0;
    double finalWidth =
        chartIdealWidth > screenWidth ? chartIdealWidth : screenWidth;

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      child: Container(
        width: finalWidth,
        height: widget.height ?? 300,
        padding: const EdgeInsets.only(top: 20, bottom: 10, left: 0, right: 20),
        child: Stack(
          fit: StackFit.expand,
          children: [
            // CAMADA 1: GRAFICO DE BARRAS (Controlador central absoluto de interação)
            BarChart(
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
                    tooltipPadding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                    getTooltipItem: (group, groupIndex, rod, rodIndex) {
                      final linha = widget.dadosDiarios![group.x.toInt()];
                      bool isPredicao = linha['is_predicao'] as bool? ?? false;
                      String dataLabel =
                          formatarDiaExibicao(linha['dia'].toString());
                      double tendenciaVal =
                          _parseDouble(linha['tendencia_entradas']);

                      if (isPredicao) {
                        return BarTooltipItem(
                          'Previsão • $dataLabel\n',
                          const TextStyle(
                              color: Color(0xFFFFC107),
                              fontSize: 12,
                              fontWeight: FontWeight.bold),
                          children: [
                            TextSpan(
                              text: formatadorReais.format(tendenciaVal),
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        );
                      }

                      bool isEntrada = rodIndex == 0;
                      String tipo = isEntrada
                          ? 'Entrada • $dataLabel\n'
                          : 'Saída • $dataLabel\n';
                      double valorReal = isEntrada
                          ? _parseDouble(linha['total_entradas'])
                          : _parseDouble(linha['total_saidas']);

                      return BarTooltipItem(
                        tipo,
                        TextStyle(
                          color: isEntrada
                              ? const Color(0xFF2ECA8B)
                              : const Color(0xFFE54D4D),
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                        children: <TextSpan>[
                          TextSpan(
                            text: formatadorReais.format(valorReal) + '\n',
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold),
                          ),
                          TextSpan(
                            text:
                                'Previsto/Tendência: ${formatadorReais.format(tendenciaVal)}',
                            style: const TextStyle(
                                color: Color(0xFFFFC107),
                                fontSize: 11,
                                fontStyle: FontStyle.italic),
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
                        if (index >= 0 && index < totalPontosX) {
                          final linha = widget.dadosDiarios![index];
                          bool isPredicao =
                              linha['is_predicao'] as bool? ?? false;
                          String diaLabel =
                              formatarDiaExibicao(linha['dia'].toString());

                          if (isPredicao) {
                            return Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Text(
                                diaLabel,
                                style: const TextStyle(
                                    fontSize: 10,
                                    color: Color(0xFFFFC107),
                                    fontStyle: FontStyle.italic,
                                    fontWeight: FontWeight.bold),
                              ),
                            );
                          } else {
                            return Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Text(diaLabel,
                                  style: const TextStyle(
                                      fontSize: 11,
                                      color: Color(0xFF8E949D),
                                      fontWeight: FontWeight.w500)),
                            );
                          }
                        }
                        return const SizedBox.shrink();
                      },
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 45,
                      getTitlesWidget: (value, meta) {
                        if (value == 0 || value >= maxY * 0.95)
                          return const SizedBox.shrink();
                        return Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: Text(
                            formatarValorResumido(value),
                            style: const TextStyle(
                                color: Color(0xFF5A626C),
                                fontSize: 10,
                                fontWeight: FontWeight.w500),
                            textAlign: TextAlign.right,
                          ),
                        );
                      },
                    ),
                  ),
                  topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false)),
                  rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false)),
                ),
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  getDrawingHorizontalLine: (value) {
                    if (value == 0)
                      return FlLine(
                          color: const Color(0xFF3D4449), strokeWidth: 1.5);
                    return FlLine(
                        color: Colors.white.withOpacity(0.05),
                        strokeWidth: 1,
                        dashArray: [4, 4]);
                  },
                ),
                borderData: FlBorderData(show: false),
                barGroups: barGroups,
              ),
              swapAnimationDuration: const Duration(milliseconds: 250),
            ),

            // CAMADA 2: LINHA PREDITIVA (Envolvida com IgnorePointer para permitir clique passante)
            if (totalPontosX >= 2)
              IgnorePointer(
                ignoring:
                    true, // Força os eventos de mouse a atravessarem a linha e atingirem as barras
                child: LineChart(
                  LineChartData(
                    minY: minY,
                    maxY: maxY,
                    minX: -0.5,
                    maxX: totalPontosX - 0.5,
                    lineTouchData: const LineTouchData(enabled: false),
                    titlesData: FlTitlesData(
                      show: true,
                      bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                              showTitles: true,
                              reservedSize: 30,
                              getTitlesWidget: (v, m) =>
                                  const SizedBox.shrink())),
                      leftTitles: AxisTitles(
                          sideTitles: SideTitles(
                              showTitles: true,
                              reservedSize: 45,
                              getTitlesWidget: (v, m) =>
                                  const SizedBox.shrink())),
                      topTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false)),
                      rightTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false)),
                    ),
                    gridData: const FlGridData(show: false),
                    borderData: FlBorderData(show: false),
                    lineBarsData: [
                      LineChartBarData(
                        spots: trendLineSpots,
                        isCurved: true,
                        curveSmoothness: 0.2,
                        color: const Color(0xFFFFC107),
                        barWidth: 3,
                        isStrokeCapRound: true,
                        dotData: FlDotData(
                          show: true,
                          getDotPainter: (spot, percent, barData, index) {
                            final linha = widget.dadosDiarios![index];
                            if (linha['is_predicao'] == true) {
                              return FlDotCirclePainter(
                                  radius: 4,
                                  color: const Color(0xFFFFC107),
                                  strokeWidth: 2,
                                  strokeColor: Colors.white);
                            }
                            return FlDotCirclePainter(
                                radius: 0,
                                color: Colors.transparent,
                                strokeWidth: 0);
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
