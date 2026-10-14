

DateTime getUltimoDiaDoMesAtual() {
  DateTime agora = DateTime.now();
  // Pede o mês atual + 1 (próximo mês), mas pede o dia 0.
  // O Dart volta para o último dia do mês atual. Hora 23:59:59.
  return DateTime(agora.year, agora.month + 1, 0, 23, 59, 59);
}
