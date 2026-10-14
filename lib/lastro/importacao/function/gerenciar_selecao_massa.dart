
import '/backend/supabase/supabase.dart';

List<String> gerenciarSelecaoMassa(
  List<VwExtratoIndividualRow> transacoesCarregadas,
  bool marcarTudo,
) {
// 1. Se a ordem for "Desmarcar Tudo" (false) ou não houver dados, devolvemos uma lista em branco
  if (!marcarTudo ||
      transacoesCarregadas.isEmpty) {
    return [];
  }

  // 2. Se a ordem for "Marcar Tudo" (true), extraímos e guardamos todos os IDs
  List<String> idsSelecionados = [];

  for (var linha in transacoesCarregadas) {
    // Na sua View, o ID principal chama-se transacaoId
    if (linha.transacaoId != null) {
      idsSelecionados.add(linha.transacaoId!);
    }
  }

  return idsSelecionados; // Devolve todos os IDs para o Page State de uma vez!
}
