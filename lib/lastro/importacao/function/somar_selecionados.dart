
import '/backend/supabase/supabase.dart';

double somarSelecionados(
  List<VwExtratoIndividualRow>? transacoes,
  List<String>? idsSelecionados,
) {
  // 1. Se não houver dados carregados ou nada selecionado, a soma é zero.
  if (transacoes == null ||
      idsSelecionados == null ||
      idsSelecionados.isEmpty) {
    return 0.0;
  }

  double total = 0.0;

  // 2. Percorre todas as linhas da sua View
  for (var t in transacoes) {
    // 3. Na sua View, o ID chama-se transacao_id (no Dart fica transacaoId)
    // Verificamos se este ID está dentro da lista de caixinhas marcadas
    if (t.transacaoId != null && idsSelecionados.contains(t.transacaoId)) {
      // 4. Soma o valor nominal da transação
      total += t.valorMovimento?.toDouble() ?? 0.0;
    }
  }

  return total.abs();
}
