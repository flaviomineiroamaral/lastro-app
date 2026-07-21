// Automatic FlutterFlow imports
import '/backend/schema/structs/index.dart';
// Imports other custom actions
// Imports custom functions
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!


double somarDetalhesDfc(List<DTDetalheDfcCategoriaStruct>? lista) {
  // Proteção contra listas vazias
  if (lista == null || lista.isEmpty) {
    return 0.0;
  }

  double total = 0.0;

  for (var item in lista) {
    total += item.valor;
  }

  return total;
}
