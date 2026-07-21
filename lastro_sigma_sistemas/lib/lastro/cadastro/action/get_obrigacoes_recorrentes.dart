// Automatic FlutterFlow imports
import '/backend/schema/structs/index.dart';
import '/backend/supabase/supabase.dart';
// Imports other custom actions
// Imports custom functions
import 'package:flutter/material.dart';
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

Future<List<DTObrigacaoRecorrenteStruct>> getObrigacoesRecorrentes(
  String orgId,
  bool apenasAtivas,
) async {
  final supabase = Supabase.instance.client;

  try {
    debugPrint(
        '🟢 [getObrigacoes] 1. Iniciando RPC para orgId: $orgId | Ativas: $apenasAtivas');

    // Executa a chamada RPC no Supabase
    final response =
        await supabase.rpc('fn_listar_obrigacoes_recorrentes', params: {
      'p_org_id': orgId,
      'p_apenas_ativas': apenasAtivas,
    });

    // SONDA 1: O que o banco devolveu fisicamente?
    debugPrint('🟢 [getObrigacoes] 2. RAW RESPONSE DO SUPABASE: $response');

    if (response == null) {
      debugPrint(
          '⚠️ [getObrigacoes] Resposta é absolutamente NULA. O banco não enviou nada.');
      return [];
    }

    if (response is! List) {
      debugPrint(
          '⚠️ [getObrigacoes] Resposta não é uma Lista. Tipo retornado: ${response.runtimeType}');
      return [];
    }

    final List<dynamic> list = response;
    debugPrint(
        '🟢 [getObrigacoes] 3. O banco devolveu ${list.length} registros. Iniciando varredura...');

    List<DTObrigacaoRecorrenteStruct> resultado = [];

    // Loop com try-catch individual por registro (Se um falhar, os outros salvam-se)
    for (var i = 0; i < list.length; i++) {
      try {
        final data = list[i];
        debugPrint('🔍 [Item $i] Analisando: $data');

        if (data is Map) {
          final Map<String, dynamic> row = Map<String, dynamic>.from(data);

          // Extração crua
          final String catId = row['categoria_id']?.toString() ?? '';
          final String ccId = row['centro_custo_id']?.toString() ?? '';
          final String cbId = row['conta_bancaria_id']?.toString() ?? '';

          final String desc = row['descricao']?.toString() ?? 'Sem descrição';
          final String catNome =
              row['categoria_nome']?.toString() ?? 'Sem Categoria';
          final String ccNome =
              row['centro_custo_nome']?.toString() ?? 'Sem Centro de Custo';
          final String cbNome =
              row['conta_bancaria_nome']?.toString() ?? 'Não Definida';
          final String peri = row['periodicidade']?.toString() ?? 'MENSAL';

          final int diaVenc =
              int.tryParse(row['dia_vencimento']?.toString() ?? '5') ?? 5;

          // Tratamento rigoroso do Mês
          int? mesVenc;
          if (row['mes_vencimento'] != null &&
              row['mes_vencimento'].toString() != 'null') {
            mesVenc = int.tryParse(row['mes_vencimento'].toString());
          }

          final int diasAnte =
              int.tryParse(row['dias_antecedencia']?.toString() ?? '15') ?? 15;
          final double valorEst =
              double.tryParse(row['valor_estimado']?.toString() ?? '0.0') ??
                  0.0;

          bool ativoSeguro = true;
          if (row['ativo'] != null) {
            ativoSeguro = row['ativo'].toString().toLowerCase() == 'true';
          }

          debugPrint(
              '🔍 [Item $i] Parse OK. Instanciando a Struct do FlutterFlow...');

          // Montagem da Struct
          resultado.add(DTObrigacaoRecorrenteStruct(
            id: row['id']?.toString() ?? '',
            descricao: desc,
            categoriaId: catId,
            categoriaNome: catNome,
            centroCustoId: ccId,
            centroCustoNome: ccNome,
            contaBancariaId: cbId,
            contaBancariaNome: cbNome,
            periodicidade: peri,
            diaVencimento: diaVenc,
            // ATENÇÃO: Se na sua Struct do FF o mesVencimento NÃO estiver marcado como nulo (Is List: False, Nullable: False),
            // passar o mesVenc (que pode ser null) fará o código quebrar aqui.
            mesVencimento: mesVenc ?? 0,
            diasAntecedencia: diasAnte,
            valorEstimado: valorEst,
            ativo: ativoSeguro,
          ));

          debugPrint('✅ [Item $i] Struct montada com sucesso!');
        }
      } catch (innerE, innerStack) {
        // Se explodir dentro do loop, nós pegamos o assassino em flagrante
        debugPrint('🔴🔴🔴 [Item $i] FALHA FATAL AO MONTAR STRUCT: $innerE');
        debugPrint('🔴🔴🔴 Linha do Erro: $innerStack');
      }
    }

    debugPrint(
        '🟢 [getObrigacoes] 4. Mapeamento 100% concluído. Itens Válidos: ${resultado.length}');
    return resultado;
  } catch (e, stacktrace) {
    debugPrint('🔴 [getObrigacoes] ERRO GLOBAL NA ACTION: $e');
    debugPrint('🔴 Stacktrace: $stacktrace');
    return [];
  }
}

// Set your action name, define your arguments and return parameter,
// and then add the boilerplate code using the green button on the right!
