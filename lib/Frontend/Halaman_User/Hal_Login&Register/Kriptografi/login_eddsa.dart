import 'dart:convert';
import 'dart:typed_data';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cryptography/cryptography.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uas_mobile2/Backend/Provider/supabase_auth.dart';
import 'package:uas_mobile2/Frontend/Halaman_User/PopUp_Dialog/awesome_dialog.dart';
import 'package:uas_mobile2/utils/storage_helper.dart';
import 'package:http/http.dart' as http;

class EdDSALogin {
  static Future<void> loginWithEdDSA(
      BuildContext context, String username) async {
    final authService =
        Provider.of<SupabaseAuthService>(context, listen: false);

    if (username.isEmpty) {
      if (!context.mounted) return;
      CustomDialog.showDialog(
        context: context,
        dialogType: DialogType.warning,
        title: "Perhatian",
        desc: "Username harus diisi",
      );
      return;
    }

    FocusScope.of(context).unfocus();

    // Tampilkan loading indikator
    _showLoadingDialog(context);

    //cek server
    final isServerAlive = await _checkServerAlive();
    if (!isServerAlive) {
      if (!context.mounted) return;
      if (Navigator.canPop(context)) Navigator.pop(context);
      CustomDialog.showDialog(
        context: context,
        dialogType: DialogType.error,
        title: "Timeout!",
        desc:
            "Server belum aktif atau tidak bisa dihubungi.\nSilahkan coba lagi nanti.",
      );
      return;
    }

    try {
      final email = await authService.getEmailByUsername(username);
      if (email == null) {
        if (!context.mounted) return;
        if (!context.mounted) return;
        if (Navigator.canPop(context)) Navigator.pop(context);
        CustomDialog.showDialog(
          context: context,
          dialogType: DialogType.error,
          title: "Error",
          desc: "Username belum terdaftar!",
        );
        return;
      }

      final user = await authService.getUserByEmail(email);
      if (user == null) {
        if (!context.mounted) return;
        if (!context.mounted) return;
        if (Navigator.canPop(context)) Navigator.pop(context);
        CustomDialog.showDialog(
          context: context,
          dialogType: DialogType.error,
          title: "Error",
          desc: "User tidak ditemukan!",
        );
        return;
      }
      final userId = user['id'];
      print("User ID: $userId");

      final privateKeyBase64 = await StorageHelper.getPrivateKey();
      if (privateKeyBase64 == null || privateKeyBase64.isEmpty) {
        if (!context.mounted) return;
        if (!context.mounted) return;
        if (Navigator.canPop(context)) Navigator.pop(context);
        CustomDialog.showDialog(
          context: context,
          dialogType: DialogType.error,
          title: "Error",
          desc: "Private Key tidak ditemukan, silahkan login dengan password.",
        );
        return;
      }

      Uint8List? privateKeyBytes;
      try {
        privateKeyBytes = base64Decode(privateKeyBase64);
      } catch (e) {
        if (!context.mounted) return;
        if (!context.mounted) return;
        if (Navigator.canPop(context)) Navigator.pop(context);
        CustomDialog.showDialog(
          context: context,
          dialogType: DialogType.error,
          title: "Error",
          desc: "Format Private Key tidak valid.",
        );
        return;
      }

      final publicKeyBase64 = await authService.getPublicKeyByUserId(userId);
      if (publicKeyBase64 == null) {
        if (!context.mounted) return;
        if (!context.mounted) return;
        if (Navigator.canPop(context)) Navigator.pop(context);
        CustomDialog.showDialog(
          context: context,
          dialogType: DialogType.error,
          title: "Error",
          desc: "Public Key tidak ditemukan, silakan login dengan password.",
        );
        return;
      }

      final publicKeyBytes = base64Decode(publicKeyBase64);
      final publicKey =
          SimplePublicKey(publicKeyBytes, type: KeyPairType.ed25519);
      final privateKey = SimpleKeyPairData(privateKeyBytes,
          publicKey: publicKey, type: KeyPairType.ed25519);

      final message = utf8.encode("LoginChallenge");
      final algorithm = Ed25519();
      final signature = await algorithm.sign(message, keyPair: privateKey);
      final signedMessage = base64Encode(signature.bytes);

      print("Signed Message: $signedMessage");

      final isVerified =
          await authService.loginWithEdDSA(userId, signedMessage);
      print("Hasil verifikasi: $isVerified");

      if (!context.mounted) return;
      
      if (Navigator.canPop(context)) Navigator.pop(context); // Pastikan loading hilang dulu

      if (isVerified) {
        final response = await http.post(
            Uri.parse('http://192.168.100.133:4000/login-eddsa'), //10.0.2.2 ip emulator hp
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({
              'userId': userId,
              'signedMessage': signedMessage,
            }));

        if (response.statusCode == 200) {
          final json = jsonDecode(response.body);
          final accessToken = json['access_token'];
          final refreshToken = json['refresh_token'];

          final sessionMap = {
            'access_token': accessToken,
            'refresh_token': refreshToken,
            'token_type': 'bearer',
            'user': {
              'id': userId,
              'aud': 'authenticated',
              'role': 'authenticated',
              'email': null,
            },
          };

          final result = await Supabase.instance.client.auth.recoverSession(
            jsonEncode(sessionMap),
          );

          if (result.session != null) {
            if (!context.mounted) return;
            CustomDialog.showDialog(
              context: context,
              dialogType: DialogType.success,
              title: "Berhasil",
              desc: "Login berhasil menggunakan kunci EdDSA!",
              btnOkOnPress: () {
                Navigator.pushReplacementNamed(context, '/dashboard');
              },
            );
          } else {
            if (!context.mounted) return;
            CustomDialog.showDialog(
              context: context,
              dialogType: DialogType.error,
              title: "Error",
              desc: "Gagal set session: session null",
            );
          }
        } else {
          if (!context.mounted) return;
          CustomDialog.showDialog(
            context: context,
            dialogType: DialogType.error,
            title: "Error",
            desc: "Gagal login EdDSA: ${response.body}",
          );
        }
      } else {
        CustomDialog.showDialog(
          context: context,
          dialogType: DialogType.error,
          title: "Error",
          desc: "Verifikasi gagal, coba lagi!",
        );
      }
    } catch (e, stack) {
      print("Error: $e");
      print("Stack Trace: $stack");
      if (!context.mounted) return;
      Navigator.pop(context);
      CustomDialog.showDialog(
        context: context,
        dialogType: DialogType.error,
        title: "Error",
        desc: "Terjadi kesalahan, coba lagi!",
      );
    }
  }

  //cek server hidup/mati
  static Future<bool> _checkServerAlive() async {
    try {
      final response = await http
          .get(Uri.parse('http://192.168.100.133:4000/health'))
          .timeout(const Duration(seconds: 1));
      return response.statusCode == 200;
    } catch (_) {
      return false;
    }
  }

  // Fungsi untuk menampilkan loading indikator
  static void _showLoadingDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 16),
              Text(
                "Sedang memproses login...",
                style: TextStyle(fontFamily: "poppinsregular"),
              ),
            ],
          ),
        );
      },
    );
  }
}
