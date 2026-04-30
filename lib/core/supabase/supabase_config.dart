import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseConfig {
  static const String _url = String.fromEnvironment(
    'SUPABASE_URL',
    defaultValue: 'https://mrcynipmpismyneyhdwh.supabase.co',
  );
  static const String _anonKey = String.fromEnvironment(
    'SUPABASE_ANON_KEY',
    defaultValue:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im1yY3luaXBtcGlzbXluZXloZHdoIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzQzNTMxNDMsImV4cCI6MjA4OTkyOTE0M30.8yR4BZ4bMDHTQJCVRKnM_sFTGpw6xJAsdmzpRhb0gpo',
  );

  static Future<void> initialize() async {
    await Supabase.initialize(url: _url, anonKey: _anonKey);
  }

  static SupabaseClient get client => Supabase.instance.client;
}





























