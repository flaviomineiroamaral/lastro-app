
import 'package:intl/intl.dart';

String formatarMoeda(
  double? valor,
  bool resumir,
) {
// 1. Trava de segurança contra dados nulos
  if (valor == null) {
    return 'R\$ 0,00';
  }

  // 2. Formatador padrão para reais
  final formatador = NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$');

  // 3. Se não for para resumir, entrega o valor contábil exato
  if (!resumir) {
    return formatador.format(valor);
  }

  // 4. Lógica de Abreviação Inteligente (Para Milhões e Milhares)
  double absValor = valor.abs();
  String prefixoR = valor < 0 ? '-R' : 'R';

  if (absValor >= 1000000) {
    // Ex: 1.250.000 -> R$ 1,25 M
    String numFormatado =
        (absValor / 1000000).toStringAsFixed(2).replaceAll('.', ',');
    return '$prefixoR\$ $numFormatado M';
  } else if (absValor >= 10000) {
    // Ex: 15.400 -> R$ 15,4 k (Aplica só acima de 10 mil para não resumir valores pequenos como 1.500)
    String numFormatado =
        (absValor / 1000).toStringAsFixed(1).replaceAll('.', ',');
    return '$prefixoR\$ $numFormatado k';
  } else {
    // Abaixo de 10 mil, mostra o valor normal (Ex: R$ 8.450,20)
    return formatador.format(valor);
  }
}
