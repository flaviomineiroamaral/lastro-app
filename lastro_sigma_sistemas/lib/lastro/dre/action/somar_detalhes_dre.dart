// Automatic FlutterFlow imports
import '/backend/schema/structs/index.dart';
// Imports other custom actions
// Imports custom functions
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!


double somarDetalhesDre(List<DTDetalheDreCategoriaStruct>? lista) {
  // Retorna 0 se a lista for nula ou estiver vazia para evitar Null Pointers
  if (lista == null || lista.isEmpty) {
    return 0.0;
  }

  double total = 0.0;

  // Laço O(N) para somar os valores
  for (var item in lista) {
    // Nota: Vi na sua imagem que você tem 'valor' e 'valorMovimento'.
    // Estou a usar o 'valor', altere se a sua regra de negócio pedir o outro.
    total += item.valor;
  }

  return total;
}
