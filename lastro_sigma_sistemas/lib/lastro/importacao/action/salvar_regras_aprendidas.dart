// Automatic FlutterFlow imports
import '/backend/schema/structs/index.dart';
import '/flutter_flow/flutter_flow_util.dart';
// Imports other custom actions
import '/flutter_flow/custom_functions.dart'; // Imports custom functions
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'package:flutter/foundation.dart' show debugPrint;
import '/backend/supabase/database/tables/regras_categorizacao.dart';
import 'sugerir_categoria_ofx.dart' show extrairPadraoAprendizado;

/// Persiste as associações descrição -> categoria confirmadas pelo usuário.
/// Chamada após o usuário confirmar a importação.
/// Usa UPSERT: cria nova regra ou incrementa o contador se já existir.
Future<void> salvarRegrasAprendidas(
  List<OfxTransactionStruct> transacoesSalvas,
  String organizationId,
) async {
  for (final OfxTransactionStruct t in transacoesSalvas) {
    // Só aprende se o item tinha uma categoria definida (sugerida ou escolhida manualmente)
    final String? planoId = t.planoContasSugeridoId;
    if (planoId == null || planoId.isEmpty) continue;
    if (t.description.isEmpty || t.description == 'Sem descrição') continue;

    final String padrao = extrairPadraoAprendizado(t.description);
    if (padrao.isEmpty) continue;

    final String? tipoOp = t.type.isEmpty ? null : t.type;

    try {
      // Busca regra existente para esta org + padrão (filtra tipo em Dart)
      final List<RegrasCategoriacaoRow> todasRegras =
          await RegrasCategoriacaoTable().queryRows(
        queryFn: (q) => q
            .eq('organization_id', organizationId)
            .eq('padrao_descricao', padrao),
      );

      // Filtra por tipo_operacao em Dart (pode ser null)
      final List<RegrasCategoriacaoRow> existentes = todasRegras
          .where((r) => r.tipoOperacao == tipoOp)
          .toList();

      if (existentes.isNotEmpty) {
        // Incrementa o contador de uso
        await RegrasCategoriacaoTable().update(
          data: {
            'plano_contas_id': planoId,
            'centro_custo_id': t.centroCustoSugeridoId,
            'contagem_usos': existentes.first.contagemUsos + 1,
          },
          matchingRows: (q) => q.eq('id', existentes.first.id!),
        );
      } else {
        // Cria nova regra
        await RegrasCategoriacaoTable().insert({
          'organization_id':  organizationId,
          'padrao_descricao': padrao,
          'plano_contas_id':  planoId,
          'centro_custo_id':  t.centroCustoSugeridoId,
          'tipo_operacao':    tipoOp,
          'contagem_usos':    1,
        });
      }
    } catch (e) {
      debugPrint('[Lastro] Erro ao salvar regra de aprendizado: $e');
      // Não interrompe a importação por erro de aprendizado
    }
  }
}
