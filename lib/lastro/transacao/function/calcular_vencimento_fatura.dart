

DateTime calcularVencimentoFatura(
  DateTime dataCompra,
  int diaFechamento,
  int diaVencimento,
) {
  int mesFatura = dataCompra.month;
  int anoFatura = dataCompra.year;

  // 1. Regra do Fechamento: Se comprou no dia ou após o fechamento, salta 1 mês
  if (dataCompra.day >= diaFechamento) {
    mesFatura += 1;
    if (mesFatura > 12) {
      mesFatura = 1;
      anoFatura += 1;
    }
  }

  // 2. Regra do Vencimento: Descobrir o mês exato em que a fatura é paga
  int mesVenc = mesFatura;
  int anoVenc = anoFatura;

  // Se o dia de vencimento for MENOR que o dia de fechamento (Ex: Fecha dia 25, Vence dia 05)
  // Isso significa que a fatura é paga no mês SEGUINTE ao mês do ciclo.
  if (diaVencimento < diaFechamento) {
    mesVenc += 1;
    if (mesVenc > 12) {
      mesVenc = 1;
      anoVenc += 1;
    }
  }

  // 3. Previne o bug de meses curtos (ex: Vencimento dia 31 em Fevereiro)
  int ultimoDia = DateTime(anoVenc, mesVenc + 1, 0).day;
  int diaVencFinal = diaVencimento > ultimoDia ? ultimoDia : diaVencimento;

  // Devolve a data com a hora cravada ao meio-dia para evitar bugs de fuso horário local
  return DateTime(anoVenc, mesVenc, diaVencFinal, 12, 0, 0);
}
