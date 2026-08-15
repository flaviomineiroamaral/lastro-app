// Automatic FlutterFlow imports
import '/backend/schema/structs/index.dart';
import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/custom_code/actions/index.dart'; // Imports other custom actions
import '/flutter_flow/custom_functions.dart'; // Imports custom functions
import 'package:flutter/material.dart';
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

Future<DTSaldoTotalOrgStruct> getSaldoTotalOrg(String orgId) async {
  final supabase = Supabase.instance.client;

  double parseDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? 0.0;
    return 0.0;
  }

  try {
    final response = await supabase.rpc('obter_saldo_total_org', params: {
      'p_org_id': orgId,
    });

    if (response != null && response is List && response.isNotEmpty) {
      final data = response.first as Map<String, dynamic>;

      // 1. Extração Base dos Valores
      double entradas = parseDouble(data['total_entradas_geral']);
      double saidas = parseDouble(data['total_saidas_geral']);
      double disponivelReal = parseDouble(data['saldo_disponivel_real']);
      double faturasCartao = parseDouble(data['total_faturas_cartao']);
      double aReceber = parseDouble(data['total_a_receber']);
      double aPagar = parseDouble(data['total_a_pagar']);
      double resumoAtivoPassivo = parseDouble(data['resumo_ativo_passivo']);

      // ==========================================
      // MOTOR DE INTELIGÊNCIA E ALERTAS
      // ==========================================

      // 1) BURN RATE (Taxa de Queima)
      double burnRate = 0.0;
      if (entradas > 0) {
        burnRate = saidas / entradas;
      } else if (saidas > 0) {
        burnRate = 1.0;
      }

      // 2) ALAVANCAGEM DE CRÉDITO
      bool isAlavancado = faturasCartao > (disponivelReal * 0.30);
      String msgAlavancagem = isAlavancado
          ? 'ALERTA DE ALAVANCAGEM: As faturas ultrapassam 30% do saldo disponível. A instituição está a viver de crédito, não de arrecadação.'
          : 'Crédito Saudável: Uso do cartão está dentro da margem de segurança (Abaixo de 30%).';

      // 3) PREVISÃO DE ALÍVIO
      String msgAlivioCaixa = aReceber > 0
          ? 'ALÍVIO DE FLUXO: Há R\$ ${aReceber.toStringAsFixed(2)} previstos para entrar, trazendo oxigénio para o caixa.'
          : 'ATENÇÃO: Não há previsão de entrada de receitas no curto prazo (A Receber está zerado).';

      // 4) RÉGUA DE RETENÇÃO
      bool isCaixaComprometido = disponivelReal < aPagar;
      String msgRetencao = isCaixaComprometido
          ? 'BLOQUEIO DE GASTOS: O saldo real (R\$ ${disponivelReal.toStringAsFixed(2)}) não cobre as contas a pagar (R\$ ${aPagar.toStringAsFixed(2)}). PROIBIDO autorizar compras não essenciais.'
          : 'CAIXA LIVRE: O saldo disponível é suficiente para cobrir as contas a pagar atuais.';

      // ==========================================
      // 5) O VEREDITO DE SOLVÊNCIA (MÉTRICA DE OURO)
      // ==========================================
      String statusSolvencia = '';
      String msgSolvencia = '';
      bool isInsolvente = resumoAtivoPassivo < 0;

      if (isInsolvente) {
        // Cenário C: Negativo
        statusSolvencia = 'CENÁRIO C (ALERTA VERMELHO)';
        msgSolvencia =
            'INSOLVÊNCIA TÉCNICA: Mesmo com o dinheiro no banco, há um buraco de R\$ ${resumoAtivoPassivo.toStringAsFixed(2)}. O caixa já pertence aos credores. Entre em regime de guerra: corte despesas e foque na arrecadação imediata.';
      } else if (!isInsolvente && burnRate > 1.0) {
        // Cenário B: Positivo, mas máquina está inchada (Gastando mais do que arrecada)
        statusSolvencia = 'CENÁRIO B (ATENÇÃO)';
        msgSolvencia =
            'DESCAPITALIZAÇÃO: A solvência é positiva (R\$ ${resumoAtivoPassivo.toStringAsFixed(2)}), mas a máquina está a inchar (gastos > receitas). O custo fixo está a corroer o património. Freie a expansão de novos centros de resultado.';
      } else {
        // Cenário A: Positivo e máquina saudável
        statusSolvencia = 'CENÁRIO A (SAUDÁVEL)';
        msgSolvencia =
            'SUPERÁVIT REAL: Solvência forte (R\$ ${resumoAtivoPassivo.toStringAsFixed(2)}) e máquina eficiente. Momento ideal para expansões físicas, infraestrutura (Gigabit) ou aumento de repasses e subsídios institucionais.';
      }

      // ==========================================
      // RETORNO ESTRUTURADO PARA O FLUTTERFLOW
      // ==========================================
      return DTSaldoTotalOrgStruct(
        // Dados Financeiros Brutos
        totalSaldoInicial: parseDouble(data['total_saldo_inicial']),
        totalEntradas: entradas,
        totalSaidas: saidas,
        saldoLiquidoGeral: parseDouble(data['saldo_liquido_geral']),
        saldoDisponivelReal: disponivelReal,
        totalFaturasCartao: faturasCartao,
        totalAReceber: aReceber,
        totalAPagar: aPagar,
        resumoAtivoPassivo: resumoAtivoPassivo,

        // Alertas Anteriores
        burnRate: burnRate,
        isAlavancado: isAlavancado,
        msgAlertaAlavancagem: msgAlavancagem,
        msgAlivioCaixa: msgAlivioCaixa,
        isCaixaComprometido: isCaixaComprometido,
        msgAlertaRetencao: msgRetencao,

        // Novos Alertas de Solvência
        statusSolvencia: statusSolvencia,
        msgSolvencia: msgSolvencia,
        isInsolvente: isInsolvente,
      );
    }

    return DTSaldoTotalOrgStruct();
  } catch (e) {
    debugPrint('🔴 Erro ao processar Saldo e Alertas: $e');
    return DTSaldoTotalOrgStruct();
  }
}
// Set your action name, define your arguments and return parameter,
// and then add the boilerplate code using the green button on the right!
