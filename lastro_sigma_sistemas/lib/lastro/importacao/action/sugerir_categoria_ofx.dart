// Automatic FlutterFlow imports
import '/backend/schema/structs/index.dart';
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import '/backend/supabase/database/tables/regras_categorizacao.dart';

/// Aplica as regras de categorização salvas sobre a lista de transações OFX,
/// retornando cada item enriquecido com sugestão de planoContasSugeridoId e scoreConfianca.
///
/// Estratégia: match por substring das 3 primeiras palavras da descrição,
/// desempate pelo score = tamanho_padrao + contagem_usos (maior = mais específico e confiável).
Future<List<OfxTransactionStruct>> sugerirCategoriaOfx(
  List<OfxTransactionStruct> transacoes,
  String organizationId,
) async {
  if (transacoes.isEmpty) return transacoes;

  // Carrega TODAS as regras da organização em 1 query (filtragem feita em Dart)
  final List<RegrasCategoriacaoRow> regras = await RegrasCategoriacaoTable()
      .queryRows(
    queryFn: (q) => q.eq('organization_id', organizationId),
  );

  if (regras.isEmpty) {
    // Sem regras salvas ainda (1ª importação): retorna sem sugestões
    return transacoes
        .map((t) => t..scoreConfianca = 'NENHUM')
        .toList();
  }

  return transacoes.map((t) {
    final String descNorm = t.description.toLowerCase().trim();

    RegrasCategoriacaoRow? melhorRegra;
    int melhorScore = 0;

    for (final RegrasCategoriacaoRow regra in regras) {
      // Filtra por tipo_operacao se a regra for específica
      if (regra.tipoOperacao != null &&
          regra.tipoOperacao!.isNotEmpty &&
          regra.tipoOperacao != t.type) {
        continue;
      }

      final String padrao = regra.padraoDescricao.toLowerCase();
      if (padrao.isEmpty) continue;

      if (descNorm.contains(padrao)) {
        // Score: comprimento do padrão + frequência de uso confirmado
        final int score = padrao.length + regra.contagemUsos;
        if (score > melhorScore) {
          melhorScore = score;
          melhorRegra = regra;
        }
      }
    }

    if (melhorRegra != null) {
      t.planoContasSugeridoId = melhorRegra.planoContasId;
      t.centroCustoSugeridoId = melhorRegra.centroCustoId;
      // Score alto: padrão longo (>10 chars) ou muito usado (>5x)
      t.scoreConfianca =
          (melhorScore > 15 || melhorRegra.contagemUsos > 5) ? 'ALTO' : 'MEDIO';
    } else {
      t.scoreConfianca = 'NENHUM';
    }

    return t;
  }).toList();
}

/// Extrai o padrão de aprendizado de uma descrição (3 primeiras palavras, max 30 chars).
/// Usado ao salvar regras após confirmação de importação.
String extrairPadraoAprendizado(String descricao) {
  final List<String> palavras = descricao
      .trim()
      .split(RegExp(r'\s+'))
      .where((p) => p.isNotEmpty)
      .take(3)
      .toList();
  final String padrao = palavras.join(' ');
  // Limita a 30 caracteres para segurança do banco
  return padrao.length > 30 ? padrao.substring(0, 30) : padrao;
}
