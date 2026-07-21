

DateTime getPrimeiroDiaDoAnoPassado() {
  DateTime agora = DateTime.now();
  return DateTime(agora.year - 1, 1, 1, 0, 0, 0);
}
