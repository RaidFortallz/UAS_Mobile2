import 'package:supabase_flutter/supabase_flutter.dart';

class Koneksi {
  static final SupabaseClient _supabaseClient = SupabaseClient(
      'https://ppniihvttatatvdmzbeo.supabase.co',
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InBwbmlpaHZ0dGF0YXR2ZG16YmVvIiwicm9sZSI6ImFub24iLCJpYXQiOjE3Mzc4ODI4NDAsImV4cCI6MjA1MzQ1ODg0MH0.rtJpnEVuqSN1jcbOgJPXZ3OsGwEngTzaZCk8NGYHj4Y'
      );

      static SupabaseClient get client => _supabaseClient;
}
