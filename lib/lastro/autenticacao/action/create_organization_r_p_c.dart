// Automatic FlutterFlow imports
import '/backend/supabase/supabase.dart';
// Imports other custom actions
// Imports custom functions
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!


Future<dynamic> createOrganizationRPC(
  String orgName,
  String orgType,
  String pUserId, // 1. Adicionamos o ID do usuário como argumento obrigatório
) async {
  // Chama a função create_my_organization no Supabase
  final supabase = SupaFlow.client;

  try {
    final response = await supabase.rpc(
      'create_my_organization',
      params: {
        'org_name': orgName,
        'org_type': orgType,
        'p_user_id':
            pUserId, // 2. Passamos o ID no payload do JSON para o banco
      },
    );
    return response;
  } catch (e) {
    print('Erro ao criar organização: $e');
    return null;
  }
}
