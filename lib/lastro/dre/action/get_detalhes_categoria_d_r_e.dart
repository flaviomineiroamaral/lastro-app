// Automatic FlutterFlow imports
import '/backend/schema/structs/index.dart';
import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_util.dart';
// Imports other custom actions
// Imports custom functions
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

Future<List<DTDetalheDreCategoriaStruct>> getDetalhesCategoriaDRE(
  String orgId,
  DateTime dataInicio,
  DateTime dataFim,
  String categoriaId,
) async {
  final supabase = Supabase.instance.client;
  List<DTDetalheDreCategoriaStruct> lista = [];

  print('🟣 [DEBUG DRE DETALHE] Iniciando busca...');

  try {
    // 1. Isolamento do Fuso Horário (Timezone Mismatch Prevention)
    // O PostgreSQL espera 'YYYY-MM-DD'. O Dart envia milissegundos por defeito.
    // Esta formatação garante que o filtro de data não falha por causa das horas.
    final dataInicioStr = DateFormat('yyyy-MM-dd').format(dataInicio);
    final dataFimStr = DateFormat('yyyy-MM-dd').format(dataFim);

    // 2. Chamada à RPC
    final response =
        await supabase.rpc('obter_detalhes_dre_categoria', params: {
      'p_org_id': orgId,
      'p_data_inicio': dataInicioStr,
      'p_data_fim': dataFimStr,
      'p_categoria_id': categoriaId,
    });

    // 3. Serialização e Tratamento de Nulos
    if (response != null && response is List) {
      for (var item in response) {
        lista.add(DTDetalheDreCategoriaStruct(
          transacaoId: item['transacao_id']?.toString() ?? '',
          descricao: item['descricao']?.toString() ?? '',
          valor: double.tryParse(item['valor']?.toString() ?? '0') ?? 0.0,
          valorMovimento:
              double.tryParse(item['valor_movimento']?.toString() ?? '0') ??
                  0.0,
          tipoOperacao: item['tipo_operacao']?.toString() ?? '',
          status: item['status']?.toString() ?? '',

          // Datas Obrigatórias
          dataReferenciaDre: DateTime.tryParse(
                  item['data_referencia_dre']?.toString() ?? '') ??
              DateTime.now(),
          dataVencimento:
              DateTime.tryParse(item['data_vencimento']?.toString() ?? '') ??
                  DateTime.now(),

          // Datas Opcionais (Prevenção de Null Pointers)
          dataPagamento: item['data_pagamento'] != null
              ? DateTime.tryParse(item['data_pagamento'].toString())
              : null,
          //dataCompetencia: item['data_competencia'] != null
          //? DateTime.tryParse(item['data_competencia'].toString())
          // : null,

          contaNome: item['conta_nome']?.toString() ?? '',
          tipoConta: item['tipo_conta']?.toString() ?? '',
          centroCustoNome: item['centro_custo_nome']?.toString() ?? '',
        ));
      }
    } else {
      print('🔴 [DEBUG DRE DETALHE] Resposta nula ou formato inesperado.');
    }

    return lista;
  } catch (e) {
    print('🔴 [DEBUG DRE DETALHE] Erro CRÍTICO de processamento: $e');
    return [];
  }
}
