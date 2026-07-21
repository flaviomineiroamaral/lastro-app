// Automatic FlutterFlow imports
import '/backend/schema/structs/index.dart';
import '/backend/supabase/supabase.dart';
// Imports other custom actions
// Imports custom functions
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

Future<DTDreSinteticoStruct> getDreSintetico(
  String orgId,
  DateTime dataInicio,
  DateTime dataFim,
) async {
  final supabase = Supabase.instance.client;

  try {
    // Formata as datas para YYYY-MM-DD garantindo a leitura correta no PostgreSQL
    final strDataInicio =
        DateTime.utc(dataInicio.year, dataInicio.month, dataInicio.day)
            .toIso8601String();
    final strDataFim =
        DateTime.utc(dataFim.year, dataFim.month, dataFim.day, 23, 59, 59)
            .toIso8601String();

    // Aponta para a nova função de performance otimizada no banco de dados
    final response = await supabase.rpc('fn_relatorio_dre_sintetico', params: {
      'p_org_id': orgId,
      'p_data_inicio': strDataInicio,
      'p_data_fim': strDataFim,
    });

    // Como garantimos no banco que sempre voltará 1 linha agregada, lemos o índice [0]
    if (response != null && response is List && response.isNotEmpty) {
      final data = response[0];

      // Mapeia os novos nomes de retorno (soma_receitas) para a Struct original do FlutterFlow
      return DTDreSinteticoStruct(
        totalReceitas: data['soma_receitas']?.toDouble() ?? 0.0,
        totalDespesas: data['soma_despesas']?.toDouble() ?? 0.0,
        resultadoLiquido: data['soma_liquido']?.toDouble() ?? 0.0,
        margemLucro: data['margem_lucro_percentual']?.toDouble() ?? 0.0,
      );
    }

    // Retorno zerado de segurança caso o banco retorne um array vazio
    return DTDreSinteticoStruct();
  } catch (e) {
    // É recomendado usar log ou integração com Sentry/Crashlytics em vez de apenas print
    // para não perder rastreabilidade em produção.
    print('Erro crítico ao buscar DRE Sintético no período: $e');
    return DTDreSinteticoStruct();
  }
}
// Set your action name, define your arguments and return parameter,
// and then add the boilerplate code using the green button on the right!
