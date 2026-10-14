// Automatic FlutterFlow imports
import '/backend/schema/structs/index.dart';
import '/backend/supabase/supabase.dart';
// Imports other custom actions
// Imports custom functions
import 'package:flutter/material.dart' hide RepeatMode;
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!


Future<DTAtivacaoSerialStruct?> getContratoB2BBySerial(
    String? serialInput) async {
  // 1. Validação de Guarda (Early Return)
  if (serialInput == null || serialInput.trim().isEmpty) {
    debugPrint('Falha: Serial de ativação ausente.');
    return null;
  }

  final supabase = SupaFlow.client;

  try {
    // 2. Chamada da RPC unificada (B2B e B2C)
    final response = await supabase.rpc(
      'validar_serial',
      params: {'p_serial_ativacao': serialInput.trim()},
    );

    // 3. Validação: A nova RPC devolve um JSON (Map)
    if (response != null && response is Map<String, dynamic>) {
      final data = response;

      // 4. Verifica se o serial é válido e não foi queimado
      if (data['valido'] == true && data['serial_utilizado'] == false) {
        // 5. Retorna o NOVO Struct Universal (B2B e B2C)
        return DTAtivacaoSerialStruct(
          registroId: data['id_registro']?.toString(),
          nomeOrganizacao: data['razao_social']?.toString(),
          nomeUtilizador: data['nome_completo']?.toString(),
          email: data['email']?.toString(),
          tipoPerfil: data['tipo_perfil']?.toString(),
          tabelaOrigem: data['tabela_origem']
              ?.toString(), // Traz 'contratos_b2b' ou 'assinaturas_b2c'
        );
      } else {
        debugPrint('Aviso: Serial inválido, já utilizado ou inexistente.');
        return null;
      }
    }

    debugPrint('Aviso: Resposta nula ou formato inesperado do Supabase.');
    return null;
  } catch (e) {
    debugPrint('Exceção ao invocar validar_serial: $e');
    return null;
  }
}
