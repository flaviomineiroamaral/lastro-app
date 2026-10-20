import 'package:supabase_flutter/supabase_flutter.dart' hide Provider;
import '/flutter_flow/flutter_flow_util.dart';

export 'database/database.dart';
export 'storage/storage.dart';

const String _kSupabaseEnv =
    String.fromEnvironment('SUPABASE_ENV', defaultValue: 'producao');

String _kSupabaseUrl = _kSupabaseEnv == 'homologacao'
    ? 'https://cbpqjhrdecxkvipziuvy.supabase.co'
    : 'https://gbnttcvfotitztxqllev.supabase.co';

String _kSupabaseAnonKey = _kSupabaseEnv == 'homologacao'
    ? 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImNicHFqaHJkZWN4a3ZpcHppdXZ5Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3ODQ2NTQyNjgsImV4cCI6MjEwMDIzMDI2OH0.R23oufwk7hoXkYjI_n4BE7sUkS_5RPSB9BDhtA3iNLc'
    : 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImdibnR0Y3Zmb3RpdHp0eHFsbGV2Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzAwNTU3MTEsImV4cCI6MjA4NTYzMTcxMX0.eK0eDdr9pIm1Tt6uzuxag-UkYDlyV5jWmz1HTGOCs9M';

class SupaFlow {
  SupaFlow._();

  static SupaFlow? _instance;
  static SupaFlow get instance => _instance ??= SupaFlow._();

  final _supabase = Supabase.instance.client;
  static SupabaseClient get client => instance._supabase;

  static Future initialize() => Supabase.initialize(
        url: _kSupabaseUrl,
        headers: {
          'X-Client-Info': 'flutterflow',
        },
        anonKey: _kSupabaseAnonKey,
        debug: false,
        authOptions:
            FlutterAuthClientOptions(authFlowType: AuthFlowType.implicit),
      );
}
