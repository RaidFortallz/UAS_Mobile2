import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:cryptography/cryptography.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseAuthService with ChangeNotifier {
  final SupabaseClient _supabase = Supabase.instance.client;

  // Status pengguna saat ini
  User? _user;
  User? get user => _user;

  var logger = Logger();

  // Simpan public key ke supabase
  Future<void> savePublicKeyToSupabase(
      String userId, String publicKeyBase64) async {
    await _supabase
        .from('profile_users')
        .update({'public_key': publicKeyBase64}).eq('id', userId);
  }

  // Fungsi untuk register user
  Future<String?> registerUser({
    required String username,
    required String email,
    required String password,
    required String phoneNumber,
  }) async {
    try {
      // Cek apakah email sudah terdaftar di tabel profile_users
      final existingUser = await _supabase
          .from('profile_users')
          .select('id')
          .eq('email', email)
          .maybeSingle();

      if (existingUser != null) {
        throw Exception("Email sudah digunakan, silahkan pakai email lain.");
      }

      // Register di Supabase Auth
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

      try {
        // Simpan user ke tabel profile_users dulu
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

        return userId; // Kembalikan userId jika registrasi berhasil
      } catch (dbError) {
        // Jika gagal menyimpan data di profile_users, hapus user dari Auth Supabase
        await _supabase.auth.admin.deleteUser(userId);
        throw Exception("Terjadi kesalahan, coba registrasi ulang.");
      }
    } catch (e) {
      log("Kesalahan saat registrasi: $e", name: "SupabaseAuthService");

      if (e is AuthException && e.message.contains("User already registered")) {
        throw Exception("Email sudah digunakan, silahkan pakai email lain.");
      }

      throw Exception("Kesalahan saat registrasi: ${e.toString()}");
    }
  }

  // mengambil public key dari tabel profile_users
  Future<String?> getPublicKeyByUserId(String userId) async {
    final response = await _supabase
        .from('profile_users')
        .select('public_key')
        .eq('id', userId)
        .maybeSingle();

    if (response == null || !response.containsKey('public_key')) {
      return null;
    }

    return response['public_key'] as String?;
  }

  //Fungsi Login dengan EdDSA
  Future<bool> loginWithEdDSA(String userId, String signedMessage) async {
    final publicKeyBase64 = await getPublicKeyByUserId(userId);
    if (publicKeyBase64 == null) return false;

    final publicKeyBytes = base64Decode(publicKeyBase64);
    final publicKey =
        SimplePublicKey(publicKeyBytes, type: KeyPairType.ed25519);

    final signatureBytes = base64Decode(signedMessage);

    final message = utf8.encode("LoginChallenge");

    final algorithm = Ed25519();
    final signature = Signature(signatureBytes, publicKey: publicKey);

    return await algorithm.verify(message, signature: signature);
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

  // Fungsi untuk mendapatkan user berdasarkan email
  Future<Map<String, dynamic>?> getUserByEmail(String email) async {
    final response = await _supabase
        .from('profile_users')
        .select()
        .eq('email', email)
        .maybeSingle();

    if (response == null) return null;
    return response;
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
      logger.e('Error mengambil alamat pengguna: $error');
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

  // Fungsi untuk mengunggah gambar profil ke Supabase Storage
  Future<String?> uploadProfileImage(File imageFile) async {
    try {
      final user = _supabase.auth.currentUser;
      if (user == null) throw Exception("Pengguna tidak ditemukan");

      final fileName = 'images_users/${user.id}.jpg';

      // Hapus gambar lama jika ada
      await _supabase.storage.from('images_users').remove([fileName]);

      // Upload gambar baru
      await _supabase.storage.from('images_users').upload(fileName, imageFile);

      // Ambil URL publik gambar
      final imageUrl =
          _supabase.storage.from('images_users').getPublicUrl(fileName);

      log("Gambar berhasil diunggah: $imageUrl", name: "SupabaseAuthService");
      return imageUrl;
    } catch (e) {
      log("Kesalahan saat mengunggah gambar: $e", name: "SupabaseAuthService");
      return null;
    }
  }

  // Fungsi untuk memperbarui gambar profil di tabel profile_users
  Future<void> updateProfileImage(File imageFile) async {
    try {
      final user = _supabase.auth.currentUser;
      if (user == null) throw Exception("Pengguna tidak ditemukan");

      final imageUrl = await uploadProfileImage(imageFile);
      if (imageUrl == null) throw Exception("Gagal mengunggah gambar");

      await _supabase.from('profile_users').update({
        'profile_img': imageUrl,
      }).eq('id', user.id);

      log("Gambar profil berhasil diperbarui", name: "SupabaseAuthService");
    } catch (e) {
      log("Kesalahan saat memperbarui gambar profil: $e",
          name: "SupabaseAuthService");
      throw Exception("Kesalahan saat memperbarui gambar profil: $e");
    }
  }

  // Fungsi untuk mendapatkan URL gambar profil
  Future<String?> getProfileImage() async {
    try {
      final user = _supabase.auth.currentUser;
      if (user == null) return null;

      final response = await _supabase
          .from('profile_users')
          .select('profile_img')
          .eq('id', user.id)
          .maybeSingle();

      return response?['profile_img'] as String?;
    } catch (e) {
      log("Kesalahan mengambil gambar profil: $e", name: "SupabaseAuthService");
      return null;
    }
  }

  // fungsi untuk mendapatkan JWT setelah EdDSA login
  Future<String?> getJwtToken(String userId) async {
    final response = await Supabase.instance.client
        .rpc('login_with_eddsa', params: {'user_id': userId});

    if (response.error != null) {
      print("Gagal mendapatkan JWT: ${response.error!.message}");
      return null;
    }
    return response.data['token'];
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
