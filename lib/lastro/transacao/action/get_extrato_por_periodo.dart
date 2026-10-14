// Automatic FlutterFlow imports
import '/backend/schema/structs/index.dart';
import '/backend/supabase/supabase.dart';
// Imports other custom actions
// Imports custom functions
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

Future<List<DTExtratoPeriodoStruct>> getExtratoPorPeriodo(
  String orgId,
  String contaId,
  DateTime dataInicio,
  DateTime dataFim,
) async {
  final supabase = Supabase.instance.client;

  try {
    // Dispara a RPC otimizada passando as datas convertidas para o padrão do banco
    final response = await supabase.rpc('obter_extrato_por_periodo', params: {
      'p_organization_id': orgId,
      'p_conta_id': contaId,
      'p_data_inicio': dataInicio.toIso8601String(),
      'p_data_fim': dataFim.toIso8601String(),
    });

    // Verifica se a resposta é válida
    if (response == null || response is! List || response.isEmpty) {
      return [];
    }

    // Mapeia o JSON devolvido pelo PostgreSQL para a estrutura do FlutterFlow
    List<DTExtratoPeriodoStruct> extrato = response.map((item) {
      return DTExtratoPeriodoStruct(
        transacaoId: item['transacao_id']?.toString() ?? '',

        // Tratamento seguro de datas
        dataLinhaTempo: item['data_linha_tempo'] != null
            ? DateTime.tryParse(item['data_linha_tempo'].toString())
            : null,

        descricao: item['descricao']?.toString() ?? '',
        categoriaNome: item['categoria_nome']?.toString() ?? 'Sem Categoria',

        // Conversão segura de números decimais
        valorMovimento:
            double.tryParse(item['valor_movimento']?.toString() ?? '0') ?? 0.0,
        saldoProgressivo:
            double.tryParse(item['saldo_progressivo']?.toString() ?? '0') ??
                0.0,

        tipoOperacao: item['tipo_operacao']?.toString() ?? '',
        status: item['status']?.toString() ?? '',

        dataCompetencia: item['data_competencia'] != null
            ? DateTime.tryParse(item['data_competencia'].toString())
            : null,

        comprovativoUrl: item['comprovativo_url']?.toString() ?? '',
      );
    }).toList();

    return extrato;
  } catch (e) {
    print('🔴 [DEBUG - LASTRO] Erro ao buscar extrato por período: $e');
    return [];
  }
}
