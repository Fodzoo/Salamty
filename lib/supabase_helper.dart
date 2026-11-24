import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseHelper {
  static Future<void> init() async {
    await Supabase.initialize(
      url: 'https://emdrsbvdwazingirktby.supabase.co',
      anonKey:
          '###',
    );
  }
}
