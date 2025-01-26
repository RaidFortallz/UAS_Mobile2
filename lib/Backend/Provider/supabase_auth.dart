import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseAuthService with ChangeNotifier {
  final SupabaseClient _supabase = Supabase.instance.client;

  // Status pengguna saat ini
  User? _user;

  User? get user => _user;

  // Fungsi untuk register user
  Future<void> registerUser({
    required String username,
    required String email,
    required String password,
    required String phoneNumber,
  }) async {
    try {
      final response = await _supabase.auth.signUp(
        email: email,
        password: password,
        data: {
          'username': username,
          'phone_number': phoneNumber,
          'created_at': DateTime.now().toIso8601String(),
        },
      );

      if (response.user == null) {
        throw Exception("Kesalahan saat registrasi: Register tidak berhasil");
      }

      // Simpan data tambahan di tabel profile_users
      final userId = response.user!.id;
      await _supabase.from('profile_users').insert({
        'id': userId,
        'username': username,
        'email': email,
        'phone_number': phoneNumber,
        'created_at': DateTime.now().toIso8601String(),
      }).select();

      _user = response.user;
      notifyListeners();

      log("User registered successfully", name: "SupabaseAuthService");
      log("Email: $email", name: "SupabaseAuthService");
    } catch (e) {
      log("Kesalahan saat registrasi: $e", name: "SupabaseAuthService");
      throw Exception("Kesalahan saat registrasi: $e");
    }
  }

  // Fungsi untuk login user menggunakan email dan password
  Future<void> loginWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );

      if (response.user == null) {
        throw Exception("Kesalahan saat login: Login tidak berhasil");
      }

      _user = response.user;
      notifyListeners();

      log("User logged in successfully", name: "SupabaseAuthService");
      log("Email: $email", name: "SupabaseAuthService");
    } catch (e) {
      log("Kesalahan saat login: $e", name: "SupabaseAuthService");
      throw Exception("Kesalahan saat login: $e");
    }
  }

  // Fungsi untuk mendapatkan email berdasarkan username dari tabel profile_users
  Future<String?> getEmailByUsername(String username) async {
    try {
      final response = await _supabase
          .from('profile_users') 
          .select('email')
          .ilike('username', username)
          .limit(1)
          .maybeSingle();

      if (response == null) {
        log("Tidak ada email yang ditemukan untuk username: $username", name: "SupabaseAuthService");
        return null;
      }

      return response['email'] as String?;
    } catch (e) {
      log("Kesalahan saat mengambil email berdasarkan username: $e", name: "SupabaseAuthService");
      throw Exception("Kesalahan saat mengambil email berdasarkan username: $e");
    }
  }

  // Fungsi untuk mendapatkan username berdasarkan user ID dari tabel profile_users
  Future<String?> getUsernameByUserId(String userId) async {
    try {
      final response = await _supabase
          .from('profile_users') 
          .select('username')
          .eq('id', userId)
          .maybeSingle();

      if (response == null || response['username'] == null) {
        log("Username tidak ditemukan untuk user ID: $userId", name: "SupabaseAuthService");
        return null;
      }

      return response['username'] as String?;
    } catch (e) {
      log("Kesalahan saat mengambil username berdasarkan user ID: $e", name: "SupabaseAuthService");
      throw Exception("Kesalahan saat mengambil username berdasarkan user ID: $e");
    }
  }

  // Fungsi untuk logout user
  Future<void> logout() async {
    try {
      await _supabase.auth.signOut();

      _user = null;
      notifyListeners();

      log("User logged out successfully", name: "SupabaseAuthService");
    } catch (e) {
      log("Kesalahan saat logout: $e", name: "SupabaseAuthService");
      throw Exception("Kesalahan saat logout: $e");
    }
  }

  // Mendapatkan user saat ini
  User? getCurrentUser() {
    return _supabase.auth.currentUser;
  }

  // Mengecek apakah user sudah login
  bool isUserLoggedIn() {
    return _supabase.auth.currentUser != null;
  }

  void signOut() {
    log("signOut method called but not implemented", name: "SupabaseAuthService");
  }
}
