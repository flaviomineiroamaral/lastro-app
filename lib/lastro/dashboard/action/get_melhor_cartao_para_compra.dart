// Automatic FlutterFlow imports
import '/backend/schema/structs/index.dart';
// Imports other custom actions
// Imports custom functions
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

DTCartaoResumoStruct? getMelhorCartaoParaCompra(
  List<DTCartaoResumoStruct> listaCartoes,
  double? valorDaCompra,
) {
  // 1. Barreira de segurança: se não há cartões, aborta instantaneamente
  if (listaCartoes.isEmpty) {
    return null;
  }

  // 2. Blindagem contra Nulos, Zeros e Valores Negativos
  double valorNecessario =
      (valorDaCompra != null && valorDaCompra > 0) ? valorDaCompra : 0.01;

  // 3. Filtra apenas os cartões que aguentam a pancada
  List<DTCartaoResumoStruct> cartoesValidos = listaCartoes
      .where((cartao) => (cartao.limiteRestante ?? 0.0) >= valorNecessario)
      .toList();

  // Se nenhum cartão suportar o valor, retorna nulo (o App deve exibir um alerta)
  if (cartoesValidos.isEmpty) {
    return null;
  }

  // 4. A Lógica Financeira de Ouro (Sorting)
  cartoesValidos.sort((a, b) {
    // Tratamento para datas nulas (empurra para o fim da fila)
    if (a.melhorDiaCompra == null && b.melhorDiaCompra == null) {
      return (b.limiteRestante ?? 0.0).compareTo(a.limiteRestante ?? 0.0);
    }
    if (a.melhorDiaCompra == null) return 1;
    if (b.melhorDiaCompra == null) return -1;

    // Compara as datas: Traz a data mais distante no futuro para o topo da lista
    int dataComparacao = b.melhorDiaCompra!.compareTo(a.melhorDiaCompra!);

    // Desempate de Ouro: Se fecham no mesmo dia, usa o que tem mais limite disponível
    if (dataComparacao == 0) {
      return (b.limiteRestante ?? 0.0).compareTo(a.limiteRestante ?? 0.0);
    }

    return dataComparacao;
  });

  // Retorna o grande campeão
  return cartoesValidos.first;
}
