// Automatic FlutterFlow imports
import '/backend/supabase/supabase.dart';
// Imports other custom actions
// Imports custom functions
import 'package:flutter/material.dart' hide RepeatMode;
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

Future<bool> aprovarItemStaging(String stagingId) async {
  final supabase = Supabase.instance.client;

  try {
    final response = await supabase.rpc(
      'fn_aprovar_item_staging',
      params: {
        'p_staging_id': stagingId,
      },
    );

    if (response != null) {
      return response as bool;
    }
    return false;
  } catch (e) {
    debugPrint('Erro ao aprovar transação individual: $e');
    return false;
  }
}
// Set your action name, define your arguments and return parameter,
// and then add the boilerplate code using the `</>` button on the right!
