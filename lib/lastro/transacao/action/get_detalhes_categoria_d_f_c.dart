// Automatic FlutterFlow imports
import '/backend/schema/structs/index.dart';
import '/backend/supabase/supabase.dart';
// Imports other custom actions
// Imports custom functions
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

Future<List<DTDetalheDfcCategoriaStruct>> getDetalhesCategoriaDFC(
  String orgId,
  DateTime dataInicio,
  DateTime dataFim,
  String categoriaId,
) async {
  final supabase = Supabase.instance.client;
  List<DTDetalheDfcCategoriaStruct> lista = [];

  try {
    // Formatação para evitar erros de Timezone no PostgreSQL
    final dataInicioStr =
        DateTime.utc(dataInicio.year, dataInicio.month, dataInicio.day)
            .toIso8601String();
    final dataFimStr =
        DateTime.utc(dataFim.year, dataFim.month, dataFim.day, 23, 59, 59)
            .toIso8601String();

    final response =
        await supabase.rpc('obter_detalhes_dfc_categoria', params: {
      'p_org_id': orgId,
      'p_data_inicio': dataInicioStr,
      'p_data_fim': dataFimStr,
      'p_categoria_id': categoriaId,
    });

    if (response != null && response is List) {
      for (var item in response) {
        lista.add(DTDetalheDfcCategoriaStruct(
          transacaoId: item['transacao_id']?.toString() ?? '',
          descricao: item['descricao']?.toString() ?? '',
          valor: double.tryParse(item['valor']?.toString() ?? '0') ?? 0.0,
          tipoOperacao: item['tipo_operacao']?.toString() ?? '',
          dataVencimento:
              DateTime.tryParse(item['data_vencimento']?.toString() ?? '') ??
                  DateTime.now(),
          dataPagamento:
              DateTime.tryParse(item['data_pagamento']?.toString() ?? '') ??
                  DateTime.now(),
          dataCompetencia:
              DateTime.tryParse(item['data_competencia']?.toString() ?? '') ??
                  DateTime.now(),
          contaNome: item['conta_nome']?.toString() ?? '',
          tipoConta: item['tipo_conta']?.toString() ?? '',
          centroCustoNome: item['centro_custo_nome']?.toString() ?? '',
        ));
      }
    }
    return lista;
  } catch (e) {
    print('Erro Crítico ao buscar detalhes da categoria: $e');
    return [];
  }
}
