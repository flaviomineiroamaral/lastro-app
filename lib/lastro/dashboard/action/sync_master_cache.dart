// Automatic FlutterFlow imports
import '/backend/schema/structs/index.dart';
import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_util.dart';
// Imports other custom actions
// Imports custom functions
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

Future syncMasterCache(
  String orgId,
  bool syncPlano,
  bool syncBancos,
  bool syncCentros,
  bool syncMembros,
) async {
  final supabase = Supabase.instance.client;

  // Lista de processos que serão executados em paralelo
  List<Future<dynamic>> tarefas = [];

  // Mapa para identificar a posição de cada resultado
  Map<String, int> ordem = {};

  // Adiciona apenas as tarefas solicitadas pelas flags
  if (syncPlano) {
    ordem['plano'] = tarefas.length;
    tarefas.add(
        supabase.rpc('obter_cache_plano_contas', params: {'p_org_id': orgId}));
  }
  if (syncBancos) {
    ordem['bancos'] = tarefas.length;
    tarefas.add(supabase
        .rpc('obter_cache_contas_bancarias', params: {'p_org_id': orgId}));
  }
  if (syncCentros) {
    ordem['centros'] = tarefas.length;
    tarefas.add(
        supabase.rpc('obter_cache_centros_custo', params: {'p_org_id': orgId}));
  }
  if (syncMembros) {
    ordem['membros'] = tarefas.length;
    tarefas.add(
        supabase.rpc('obter_cache_membros_light', params: {'p_org_id': orgId}));
  }

  if (tarefas.isEmpty) return;

  try {
    // DISPARO PARALELO: O motor do Dart executa tudo simultaneamente
    final resultados = await Future.wait(tarefas);

// Atualização cirúrgica do App State para o Plano de Contas
    if (syncPlano && ordem.containsKey('plano')) {
      final data = resultados[ordem['plano']!] as List;
      FFAppState().cachePlanoContas = data
          .map((d) => DTCachePlanoContasStruct(
                id: d['id']?.toString() ?? '',
                codigoContabil: d['codigo_contabil']?.toString() ?? '',
                nome: d['nome']?.toString() ?? '',
                tipo: d['tipo']?.toString() ?? '',
                nomeExibicao: d['nome_exibicao']?.toString() ?? '',
                // Novos campos mapeados abaixo
                naturezaFluxo: d['natureza_fluxo']?.toString() ?? '',
                permiteLancamento: d['permite_lancamento'] == true,
                instrucaoUso: d['instrucao_uso']?.toString() ?? '',
              ))
          .toList();
    }

// Atualização cirúrgica do App State para Contas Bancárias
    if (syncBancos && ordem.containsKey('bancos')) {
      final data = resultados[ordem['bancos']!] as List;
      FFAppState().cacheContasBancarias = data
          .map((d) => DTCacheContasBancariasStruct(
                id: d['id']?.toString() ?? '', // Blindagem de UUID
                nome: d['nome']?.toString() ?? '',
                tipo: d['tipo']?.toString() ?? '',

                // Novos campos mapeados:
                bancoCodigo: d['banco_codigo']?.toString() ?? '',
                agenciaConta: d['agencia_conta']?.toString() ?? '',
                saldoInicial:
                    double.tryParse(d['saldo_inicial']?.toString() ?? '0') ??
                        0.0,
                ativo: d['ativo'] == true,
                limiteCredito:
                    double.tryParse(d['limite_credito']?.toString() ?? '0') ??
                        0.0,
                diaVencimento:
                    int.tryParse(d['dia_vencimento']?.toString() ?? '0') ?? 0,
                diaFechamento:
                    int.tryParse(d['dia_fechamento']?.toString() ?? '0') ?? 0,
              ))
          .toList();
    }
// Atualização cirúrgica do App State para Centros de Resutlado
    if (syncCentros && ordem.containsKey('centros')) {
      final data = resultados[ordem['centros']!] as List;
      FFAppState().cacheCentrosDeResultado = data
          .map((d) => DTCacheCentrosDeResultadoStruct(
                id: d['id']?.toString() ?? '', // Blindagem do UUID
                nome: d['nome']?.toString() ?? '',
                // Novos campos mapeados abaixo:
                descricao: d['descricao']?.toString() ?? '',
                ativo: d['ativo'] == true,
                isPadrao: d['is_padrao'] == true,
                isFundo: d['is_fundo'] == true,
                permiteAcumulo: d['permite_acumulo'] == true,
                corHex: d['cor_hex']?.toString() ?? '',
              ))
          .toList();
    }
    if (syncMembros && ordem.containsKey('membros')) {
      final data = resultados[ordem['membros']!] as List;
      FFAppState().cacheMembros = data
          .map((d) => DTCacheMembrosLightStruct(
                id: d['id'],
                nomeCompleto: d['nome_completo']?.toString() ?? '',
                ativo: d['ativo'] == true,
              ))
          .toList();
    }

    // Notifica a UI de que os dados globais mudaram
    // (Opcional: você pode desativar o rebuild global se preferir controlar na página)
    FFAppState().update(() {});
  } catch (e) {
    print('🔴 [MASTER CACHE] Erro Crítico na Sincronização: $e');
  }
}
