// Automatic FlutterFlow imports
import '/backend/supabase/supabase.dart';
// Imports other custom actions
// Imports custom functions
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

Future<String> liquidarEGerarTransferencia(
  List<String> idsTransacoes,
  DateTime dataDoPagamento,
  double valorTotal,
  String contaOrigemId,
  String contaCartaoId,
  String orgId,
) async {
  final supabase = Supabase.instance.client;

  if (idsTransacoes.isEmpty || valorTotal <= 0) {
    return 'Erro: Nenhuma transação selecionada ou valor zerado.';
  }

  try {
    // 1. ATUALIZAR AS DESPESAS
    await supabase.from('transacoes').update({
      'data_pagamento': dataDoPagamento.toIso8601String(),
      'status': 'CONCILIADO'
    }).inFilter('id', idsTransacoes);

    // 2. GERAR A TRANSFERÊNCIA BANCÁRIA
    await supabase.from('transacoes').insert({
      'organization_id': orgId,
      'tipo_operacao': 'TRANSFERENCIA',
      'conta_bancaria_id': contaOrigemId,
      'conta_destino_id': contaCartaoId,
      'valor': valorTotal,

      // As três datas irmãs (Garantia de segurança no ERP)
      'data_pagamento': dataDoPagamento.toIso8601String(),
      'data_vencimento': dataDoPagamento.toIso8601String(),
      'data_competencia': dataDoPagamento.toIso8601String(),

      'status': 'CONCILIADO',
      'descricao': 'Pagamento de Fatura de Cartão',

      // Se o seu banco exige saber quem criou, envie o ID do utilizador logado.
      // (Se o banco já faz isso sozinho com auth.uid(), pode ignorar esta linha)
      // 'criado_por': Supabase.instance.client.auth.currentUser?.id,
    });

    return 'SUCESSO'; // Se tudo correr bem, devolve esta palavra.
  } catch (e) {
    // CAPTURA O ERRO E DEVOLVE PARA A TELA
    return 'Erro do Supabase: ${e.toString()}';
  }
}
