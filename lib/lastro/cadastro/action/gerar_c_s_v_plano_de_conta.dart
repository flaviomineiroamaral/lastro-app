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

import 'dart:convert';
import 'package:share_plus/share_plus.dart';

Future<void> gerarCSVPlanoDeConta(
  String orgId,
  String nomeOrganizacao,
) async {
  final supabase = Supabase.instance.client;

  try {
    debugPrint('🟢 [CSV] Iniciando extração do Plano de Contas para: $orgId');

    // 1. Extração dos Dados via RPC
    final response = await supabase.rpc('obter_cache_plano_contas', params: {
      'p_org_id': orgId,
    });

    if (response == null || !(response is List)) {
      debugPrint('⚠️ [CSV] RPC retornou vazio ou nulo.');
      return;
    }

    final List<dynamic> registros = response;

    // 2. Construção do Buffer CSV
    StringBuffer csvBuffer = StringBuffer();

    // CRÍTICO: Inserir o BOM (Byte Order Mark) do UTF-8.
    // Isso é obrigatório para que o Excel em português reconheça acentos (ç, á, ão) nativamente.
    csvBuffer.write('\uFEFF');

    // Cabeçalho: O Excel no Brasil exige PONTO E VÍRGULA (;) como separador de colunas, não vírgula.
    csvBuffer
        .writeln('CÓDIGO;DESCRIÇÃO DA CONTA;TIPO;NATUREZA;ACEITA LANÇAMENTO');

    // 3. Processamento e Sanitização das Linhas
    for (var r in registros) {
      final row = Map<String, dynamic>.from(r as Map);

      // Função aninhada para sanitizar textos que possam quebrar a estrutura do CSV
      String sanitize(dynamic value) {
        if (value == null) return '';
        String str =
            value.toString().replaceAll('\n', ' ').replaceAll('\r', '');

        // Se a string contiver o próprio delimitador (;) ou aspas, devemos envelopar e escapar de acordo com a RFC 4180
        if (str.contains(';') || str.contains('"')) {
          str = str.replaceAll('"', '""');
          return '"$str"';
        }
        return str;
      }

      final codigo = sanitize(row['codigo_contabil']);
      final nome = sanitize(row['nome']);
      final tipo = sanitize(row['tipo']);
      final natureza = sanitize(row['natureza_fluxo']);
      final isAnalitica =
          sanitize(row['permite_lancamento'] == true ? 'SIM' : 'NÃO');

      csvBuffer.writeln('$codigo;$nome;$tipo;$natureza;$isAnalitica');
    }

    debugPrint(
        '🟢 [CSV] Layout em memória finalizado. Invocando SO para salvar/compartilhar...');

    // 4. Invocação Nativa de Compartilhamento/Salvamento
    // Convertendo a string para bytes preservando o UTF-8
    final bytes = utf8.encode(csvBuffer.toString());

    // Cria um arquivo virtual para o sistema operacional gerenciar
    final xFile = XFile.fromData(
      bytes,
      mimeType: 'text/csv',
      name: 'Plano_de_Contas_${nomeOrganizacao.replaceAll(' ', '_')}.csv',
    );

    // Abre a gaveta de compartilhamento/salvamento do dispositivo (iOS/Android/Web)
    await Share.shareXFiles(
      [xFile],
      text: 'Plano de Contas - $nomeOrganizacao',
    );
  } catch (e, stacktrace) {
    debugPrint('🔴 [CSV] Erro fatal na geração do CSV: $e');
    debugPrint(stacktrace.toString());
  }
}
// Set your action name, define your arguments and return parameter,
// and then add the boilerplate code using the `</>` button on the right!
