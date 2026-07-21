import 'dart:math' as math;


double? sanitizarValor(dynamic amount) {
  if (amount == null) return 0.0;

  String valStr = amount.toString().trim();
  if (valStr.isEmpty) return 0.0;

  // Remove caracteres estranhos, mantendo dígitos, vírgula, ponto e menos
  String apenasNumeros = valStr.replaceAll(RegExp(r'[^0-9,-.]'), '');

  // Localiza o último separador para garantir que o decimal seja o ponto
  int lastComma = apenasNumeros.lastIndexOf(',');
  int lastDot = apenasNumeros.lastIndexOf('.');
  int lastSep = math.max(lastComma, lastDot);

  if (lastSep != -1) {
    // Remove separadores de milhar (qualquer ponto ou vírgula antes do último)
    String parteInteira =
        apenasNumeros.substring(0, lastSep).replaceAll(RegExp(r'[.,]'), '');
    String parteDecimal = apenasNumeros.substring(lastSep + 1);
    return double.tryParse("$parteInteira.$parteDecimal") ?? 0.0;
  }

  return double.tryParse(apenasNumeros) ?? 0.0;
}
