import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseHelper {
  static Future<void> init() async {
    await Supabase.initialize(
      url: 'https://emdrsbvdwazingirktby.supabase.co',
      anonKey:
          'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImVtZHJzYnZkd2F6aW5naXJrdGJ5Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzIzNzc3ODksImV4cCI6MjA4Nzk1Mzc4OX0.KgsFez1Wo6LPxIHqUN4Z6Sti1aWvYUVB69IZL7QsugY',
    );
  }
}
