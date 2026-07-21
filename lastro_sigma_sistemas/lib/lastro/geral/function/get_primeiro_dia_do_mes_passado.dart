

DateTime getPrimeiroDiaDoMesPassado() {
  DateTime agora = DateTime.now();
  return DateTime(agora.year, agora.month - 1, 1, 0, 0, 0);
}
