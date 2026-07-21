
import '/backend/schema/structs/index.dart';

List<String> formatarDropdownContas(List<DTCachePlanoContasStruct>? contas) {
  // 1. Barreira de segurança: se a lista vier nula ou vazia, aborta e devolve vazio.
  if (contas == null || contas.isEmpty) {
    return [];
  }

  // 2. Transforma (mapeia) cada linha do banco de dados num texto formatado
  return contas.map((conta) {
    final String nome = (conta.nome ?? "").trim();
    final String tipo = (conta.tipo ?? "").toUpperCase().trim();

    String emoji;

    // 3. O "Switch" avalia o tipo instantaneamente e atribui o ícone correto
    switch (tipo) {
      case 'RECEITA':
        emoji = "🟢"; // Entrada de dinheiro no DRE
        break;
      case 'DESPESA':
        emoji = "🔴"; // Saída de dinheiro no DRE
        break;
      case 'ATIVO':
        emoji = "🔵"; // Bens, direitos, contas bancárias, veículos
        break;
      case 'PASSIVO':
        emoji = "🟠"; // Dívidas, empréstimos, cartões a pagar
        break;
      case 'PL':
        emoji = "🟣"; // Capital Social, Lucros distribuídos
        break;
      default:
        emoji = "⚪"; // Categoria genérica ou sem classificação
    }

    // 4. Junta o emoji e o nome
    return "$emoji $nome";
  }).toList(); // O .toList() converte o resultado de volta para uma List<String>
}
