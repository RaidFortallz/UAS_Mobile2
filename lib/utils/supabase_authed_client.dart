import 'package:supabase_flutter/supabase_flutter.dart';

SupabaseClient createAuthedSupabaseClient(String accessToken) {
  const supabaseUrl = 'https://ppniihvttatatvdmzbeo.supabase.co';
  const supabaseAnonKey =
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InBwbmlpaHZ0dGF0YXR2ZG16YmVvIiwicm9sZSI6ImFub24iLCJpYXQiOjE3Mzc4ODI4NDAsImV4cCI6MjA1MzQ1ODg0MH0.rtJpnEVuqSN1jcbOgJPXZ3OsGwEngTzaZCk8NGYHj4Y';

  return SupabaseClient(
    supabaseUrl,
    supabaseAnonKey,
    headers: {
      'Authorization': 'Bearer $accessToken',
    }
  );
}
