
import '/backend/schema/structs/index.dart';

bool devoMostrarAData(
  int indiceDaLinha,
  List<DTExtratoPeriodoStruct> listaCompleta,
) {
// 1. Se não houver lista, esconde (Falso)
  if (listaCompleta.isEmpty) {
    return false;
  }

  // 2. A primeira linha (índice 0) SEMPRE mostra a data (Verdadeiro)
  if (indiceDaLinha == 0) {
    return true;
  }

  // 3. Pega a data da linha atual e da linha de cima
  DateTime? dataAgora = listaCompleta[indiceDaLinha].dataLinhaTempo;
  DateTime? dataDeCima = listaCompleta[indiceDaLinha - 1].dataLinhaTempo;

  // 4. Se a data de alguma linha sumir por erro, mostra por precaução
  if (dataAgora == null || dataDeCima == null) {
    return true;
  }

  // 5. Compara se o dia, mês ou ano são diferentes
  return dataAgora.day != dataDeCima.day ||
      dataAgora.month != dataDeCima.month ||
      dataAgora.year != dataDeCima.year;
}
