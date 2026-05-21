import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseConfig {
  static Future<void> init() async {
    await Supabase.initialize(
      url: 'https://vwqpgcakaftdjrygdezb.supabase.co', // SUBSTITUA PELO SEU URL
      anonKey:
          'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InZ3cXBnY2FrYWZ0ZGpyeWdkZXpiIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzkxMDIxMjgsImV4cCI6MjA5NDY3ODEyOH0.lGPSd3a5HDs8aEXsHOhOktXUzsAOgCSZQEAAmu9Hogg', // SUBSTITUA PELA SUA CHAVE ANÔNIMA
    );
  }

  static SupabaseClient get client => Supabase.instance.client;
}
