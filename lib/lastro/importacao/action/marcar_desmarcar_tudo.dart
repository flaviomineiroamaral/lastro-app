// Automatic FlutterFlow imports
import '/backend/schema/structs/index.dart';
// Imports other custom actions
// Imports custom functions
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

// --- ATENÇÃO: Se houver uma linha 'import /actions/actions.dart' lá em cima, APAGUE ELA MANUALMENTE ---
Future<List<OfxTransactionStruct>> marcarDesmarcarTudo(
  List<OfxTransactionStruct> listaAtual,
  bool novoStatus,
) async {
  List<OfxTransactionStruct> listaAtualizada = [];

  for (var item in listaAtual) {
    // 1. Transforma o item em um Mapa de dados editável
    // O 'Map.from' garante que criamos uma cópia que pode ser mexida
    Map<String, dynamic> dados = Map<String, dynamic>.from(item.toMap());

    // 2. Altera o valor manualmente no Mapa
    dados['selecionado'] = novoStatus;

    // 3. Reconstrói o struct a partir do Mapa alterado
    listaAtualizada.add(OfxTransactionStruct.fromMap(dados));
  }

  return listaAtualizada;
}
