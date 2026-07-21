
import '/backend/schema/structs/index.dart';

bool? devoMostrarADataDetalheCR(
  int indiceDaLinha,
  List<DTDetalheCRStruct>? listaCompleta,
) {
// 1. Se a lista for nula ou vazia, esconde o cabeçalho
  if (listaCompleta == null || listaCompleta.isEmpty) {
    return false;
  }

  // 2. A primeira linha da tela sempre tem de mostrar a data
  if (indiceDaLinha == 0) {
    return true;
  }

  // 3. Pegamos a data do fluxo real (data_referencia_dre)
  DateTime? dataAgora = listaCompleta[indiceDaLinha].dataPagamento;
  DateTime? dataDeCima = listaCompleta[indiceDaLinha - 1].dataPagamento;

  // 4. Prevenção de nulos
  if (dataAgora == null || dataDeCima == null) {
    return true;
  }

  // 5. A CHAVE: Comparamos o DIA. Se mudou de dia, mostra o cabeçalho!
  return dataAgora.day != dataDeCima.day ||
      dataAgora.month != dataDeCima.month ||
      dataAgora.year != dataDeCima.year;
}
