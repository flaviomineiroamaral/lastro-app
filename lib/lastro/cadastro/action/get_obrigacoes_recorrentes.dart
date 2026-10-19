// Automatic FlutterFlow imports
import '/backend/schema/structs/index.dart';
import '/backend/supabase/supabase.dart';
// Imports other custom actions
// Imports custom functions
import 'package:flutter/material.dart' hide RepeatMode;
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

/// Lista as obrigações recorrentes (A Pagar e A Receber) da organização
/// via RPC `fn_listar_obrigacoes_recorrentes` e converte para
/// [DTObrigacaoRecorrenteStruct].
Future<List<DTObrigacaoRecorrenteStruct>> getObrigacoesRecorrentes(
  String orgId,
  bool apenasAtivas,
) async {
  final supabase = Supabase.instance.client;
  // Helpers de conversão segura
  String txt(dynamic v, [String padrao = '']) {
    if (v == null) return padrao;
    final s = v.toString();
    return (s.isEmpty || s == 'null') ? padrao : s;
  }

  int inteiro(dynamic v, int padrao) => int.tryParse(txt(v)) ?? padrao;
  double decimal(dynamic v, double padrao) => double.tryParse(txt(v)) ?? padrao;
  bool booleano(dynamic v, bool padrao) =>
      v == null ? padrao : txt(v).toLowerCase() == 'true';
  try {
    final response = await supabase.rpc(
      'fn_listar_obrigacoes_recorrentes',
      params: {
        'p_org_id': orgId,
        'p_apenas_ativas': apenasAtivas,
      },
    );
    if (response == null || response is! List) {
      debugPrint(
          '⚠️ [getObrigacoes] Resposta inválida: ${response.runtimeType}');
      return [];
    }
    final resultado = <DTObrigacaoRecorrenteStruct>[];
    for (var i = 0; i < response.length; i++) {
      try {
        final data = response[i];
        if (data is! Map) continue;
        final row = Map<String, dynamic>.from(data);
        final janela = inteiro(row['janela_meses'], 12);
        resultado.add(DTObrigacaoRecorrenteStruct(
          id: txt(row['id']),
          descricao: txt(row['descricao'], 'Sem descrição'),
          categoriaId: txt(row['categoria_id']),
          categoriaNome: txt(row['categoria_nome'], 'Sem Categoria'),
          centroCustoId: txt(row['centro_custo_id']),
          centroCustoNome: txt(row['centro_custo_nome'], 'Sem Centro de Custo'),
          contaBancariaId: txt(row['conta_bancaria_id']),
          contaBancariaNome: txt(row['conta_bancaria_nome'], 'Não Definida'),
          periodicidade: txt(row['periodicidade'], 'MENSAL'),
          diaVencimento: inteiro(row['dia_vencimento'], 5),
          mesVencimento: inteiro(row['mes_vencimento'], 0),
          diasAntecedencia: inteiro(row['dias_antecedencia'], janela),
          valorEstimado: decimal(row['valor_estimado'], 0.0),
          ativo: booleano(row['ativo'], true),
          tipoOperacao: txt(row['tipo_operacao'], 'DEBITO'),
          janelaMeses: janela,
          membroId: txt(row['membro_id']),
          membroNome: txt(row['membro_nome'], 'Sem Membro'),
        ));
      } catch (e) {
        debugPrint('🔴 [getObrigacoes] Falha ao montar item $i: $e');
      }
    }
    debugPrint('🟢 [getObrigacoes] ${resultado.length} obrigações carregadas.');
    return resultado;
  } catch (e, st) {
    debugPrint('🔴 [getObrigacoes] Erro global: $e\n$st');
    return [];
  }
}

// Set your action name, define your arguments and return parameter,
// and then add the boilerplate code using the green button on the right!
