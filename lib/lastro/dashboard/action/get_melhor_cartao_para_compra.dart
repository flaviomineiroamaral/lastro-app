// Automatic FlutterFlow imports
import '/backend/schema/structs/index.dart';
import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/custom_code/actions/index.dart'; // Imports other custom actions
import '/flutter_flow/custom_functions.dart'; // Imports custom functions
import 'package:flutter/material.dart';
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

DTCartaoResumoStruct? getMelhorCartaoParaCompra(
  List<DTCartaoResumoStruct> listaCartoes,
  double? valorDaCompra,
) {
  // Barreira de segurança: se não há cartões, não há recomendação
  if (listaCartoes.isEmpty) {
    return null;
  }

  // 1. Filtra apenas os cartões que possuem limite suficiente
  // Se o valorDaCompra for nulo, consideramos qualquer cartão com limite > 0
  double valorNecessario = valorDaCompra ?? 0.01;

  List<DTCartaoResumoStruct> cartoesValidos = listaCartoes
      .where((cartao) => cartao.limiteRestante >= valorNecessario)
      .toList();

  // 2. Se nenhum cartão suportar o valor, retorna nulo (o app deve avisar o usuário)
  if (cartoesValidos.isEmpty) {
    return null;
  }

  // 3. A Lógica Financeira (Sorting)
  // O melhor cartão é aquele que está mais LONGE do próximo fechamento (melhorDiaCompra maior),
  // garantindo o maior prazo de pagamento possível (até 40 dias de fôlego).
  cartoesValidos.sort((a, b) {
    // Se algum não tiver o melhor dia configurado, jogamos para o final da fila
    if (a.melhorDiaCompra == null && b.melhorDiaCompra == null) {
      // Desempate por quem tem mais limite
      return b.limiteRestante.compareTo(a.limiteRestante);
    }
    if (a.melhorDiaCompra == null) return 1;
    if (b.melhorDiaCompra == null) return -1;

    // Compara as datas. Queremos a data mais distante no futuro (Descending)
    int dataComparacao = b.melhorDiaCompra!.compareTo(a.melhorDiaCompra!);

    // Se as datas forem exatamente iguais, o desempate é quem tem maior limite sobrando
    if (dataComparacao == 0) {
      return b.limiteRestante.compareTo(a.limiteRestante);
    }

    return dataComparacao;
  });

  // Retorna o campeão (O primeiro da lista ordenada)
  return cartoesValidos.first;
}
