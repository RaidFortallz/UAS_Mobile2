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

  // Fungsi untuk mencari user dengan username admin
  Future<Map<String, dynamic>?> getAdminUser() async {
    try {
      final user = _supabase.auth.currentUser;
      if (user == null) {
        return null;
      }
      final response = await _supabase
          .from('profile_users')
          .select('id, username, email, is_admin')
          .eq('id', user.id)
          .maybeSingle();

      if (response == null) {
        return null;
      }

      return {
        'id': response['id'],
        'email': response['email'],
        'username': response['username'],
        'is_admin': response['is_admin'],
      };
    } catch (e) {
      log("Kesalahan saat mencari admin: $e", name: "SupabaseAuthService");
      throw Exception("Kesalahan saat mencari admin: $e");
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
        log("Tidak ada email yang ditemukan untuk username: $username",
            name: "SupabaseAuthService");
        return null;
      }

      return response['email'] as String?;
    } catch (e) {
      log("Kesalahan saat mengambil email berdasarkan username: $e",
          name: "SupabaseAuthService");
      throw Exception(
          "Kesalahan saat mengambil email berdasarkan username: $e");
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
        log("Username tidak ditemukan untuk user ID: $userId",
            name: "SupabaseAuthService");
        return null;
      }

      return response['username'] as String?;
    } catch (e) {
      log("Kesalahan saat mengambil username berdasarkan user ID: $e",
          name: "SupabaseAuthService");
      throw Exception(
          "Kesalahan saat mengambil username berdasarkan user ID: $e");
    }
  }

  // Fungsi untuk mendapatkan nomor HP berdasarkan user ID dari tabel profile_users
  Future<String?> getPhoneByUserId(String userId) async {
    try {
      final response = await _supabase
          .from('profile_users')
          .select('phone_number')
          .eq('id', userId)
          .maybeSingle();

      if (response == null || response['phone_number'] == null) {
        log("Nomor HP tidak ditemukan untuk user ID: $userId",
            name: "SupabaseAuthService");
        return null;
      }

      return response['phone_number'] as String?;
    } catch (e) {
      log("Error saat mengambil nomor HP untuk user ID: $userId: $e",
          name: "SupabaseAuthService");
      throw Exception("Kesalahan saat mengambil nomor HP: $e");
    }
  }

  // Fungsi untuk memperbarui data profil pengguna
  Future<void> updateUserProfile({
    required String userId,
    required String newUsername,
    required String newEmail,
    required String newPhone,
  }) async {
    try {
      await _supabase.from('profile_users').update({
        'username': newUsername,
        'email': newEmail,
        'phone_number': newPhone,
      }).eq('id', userId);

      log("Profil berhasil diperbarui", name: "SupabaseAuthService");
    } catch (e) {
      log("Error memperbarui profil: $e", name: "SupabaseAuthService");
      throw Exception("Error memperbarui profil: $e");
    }
  }

  Future<void> updateUserPassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    try {
      final user = _supabase.auth.currentUser;

      if (user == null) {
        throw Exception('Pengguna tidak ditemukan');
      }

      // Verifikasi password lama terlebih dahulu
      final isPasswordCorrect = await verifyCurrentPassword(currentPassword);
      if (!isPasswordCorrect) {
        throw Exception('Password lama salah');
      }

      // Jika password lama benar, lanjutkan dengan pembaruan password
      await _supabase.auth.updateUser(
        UserAttributes(password: newPassword),
      );

      log("Password berhasil diperbarui", name: "SupabaseAuthService");
    } catch (e) {
      log("Kesalahan memperbarui password: $e", name: "SupabaseAuthService");
      throw Exception("Kesalahan memperbarui password: $e");
    }
  }

  // Fungsi untuk memverifikasi password lama pengguna
  Future<bool> verifyCurrentPassword(String currentPassword) async {
    final user = _supabase.auth.currentUser;

    if (user == null) {
      return false;
    }

    try {
      final response = await _supabase.auth.signInWithPassword(
        email: user.email!,
        password: currentPassword,
      );

      // Jika responsnya valid (user ditemukan), return true
      return response.user != null;
    } catch (e) {
      // Jika ada kesalahan saat verifikasi, return false
      return false;
    }
  }

  //Fungsi untuk memperbarui alamat dan kota user
  Future<void> updateAddress({
    required String userId,
    required String city,
    required String address,
    required String phoneNumber,
  }) async {
    try {
      final response = await _supabase
          .from('profile_users')
          .select('username, email')
          .eq('id', userId)
          .maybeSingle();

      if (response == null || response['username'] == null) {
        throw Exception('Username tidak ditemukan');
      }

      final username = response['username'];
      final email = response['email'];

      // Lakukan upsert dengan menambahkan username dan email
      await _supabase.from('profile_users').upsert({
        'id': userId,
        'username': username,
        'email': email,
        'city': city,
        'address': address,
        'phone_number': phoneNumber,
      }).eq('id', userId);

      log("Address updated successfully", name: "SupabaseAuthService");
    } catch (e) {
      log("Error updating address: $e", name: "SupabaseAuthService");
      throw Exception('Error updating address: $e');
    }
  }

  // Fungsi untuk mendapatkan alamat pengguna dari Supabase
  Future<Map<String, String>> getUserAddress(String userId) async {
    try {
      final response = await _supabase
          .from('profile_users')
          .select('city, address, phone_number')
          .eq('id', userId)
          .maybeSingle();

      if (response == null) {
        return {
          'city': '',
          'address': '',
          'phoneNumber': '',
        };
      }

      return {
        'city': response['city'] as String? ?? '',
        'address': response['address'] as String? ?? '',
        'phoneNumber': response['phone_number'] as String? ?? '',
      };
    } catch (error) {
      print('Error mengambil alamat pengguna: $error');
      return {
        'city': '',
        'address': '',
        'phoneNumber': '',
      };
    }
  }

  //Fungsi untuk mengisi saldo
  Future<void> isiSaldo({required int jumlahSaldo}) async {
    try {
      final user = _supabase.auth.currentUser;
      if (user == null) {
        throw Exception("Pengguna tidak ditemukan, harap login kembali.");
      }

      final userId = user.id;

      final response = await _supabase
          .from('profile_users')
          .select('saldo')
          .eq('id', userId)
          .maybeSingle();

      int saldoLama = (response != null && response['saldo'] != null)
          ? (response['saldo'] as num).toInt()
          : 0;

      int saldoBaru = saldoLama + jumlahSaldo;

      await _supabase
          .from('profile_users')
          .update({'saldo': saldoBaru}).eq('id', userId);

      log("Saldo berhasil diperbarui: $saldoBaru", name: "SupabaseAuthService");
    } catch (e) {
      log("Kesalahan saat mengisi saldo $e", name: "SupabaseAuthService");
      throw Exception("Kesalahan saat mengisi saldo: $e");
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
    log("signOut method called but not implemented",
        name: "SupabaseAuthService");
  }
}
