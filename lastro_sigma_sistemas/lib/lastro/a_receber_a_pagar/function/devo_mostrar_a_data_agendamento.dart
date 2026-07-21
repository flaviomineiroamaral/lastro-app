
import '/backend/supabase/supabase.dart';

bool devoMostrarADataAgendamento(
  int indiceDaLinha,
  List<VwAgendamentosRow> listaCompleta,
) {
  // 1. Se não houver lista, esconde (Falso)
  if (listaCompleta.isEmpty) {
    return false;
  }

  // 2. A primeira linha (índice 0) SEMPRE mostra a data (Verdadeiro)
  if (indiceDaLinha == 0) {
    return true;
  }

  // 3. A CHAVE: Pega a data de VENCIMENTO (e não de pagamento)
  DateTime? dataAgora = listaCompleta[indiceDaLinha].dataVencimento;
  DateTime? dataDeCima = listaCompleta[indiceDaLinha - 1].dataVencimento;

  // 4. Se a data sumir por erro, mostra por precaução
  if (dataAgora == null || dataDeCima == null) {
    return true;
  }

  // 5. Compara se o dia, mês ou ano são diferentes
  return dataAgora.day != dataDeCima.day ||
      dataAgora.month != dataDeCima.month ||
      dataAgora.year != dataDeCima.year;
}
