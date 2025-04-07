import 'dart:convert';
import 'package:cryptography/cryptography.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uas_mobile2/Backend/Provider/supabase_auth.dart';
import 'package:uas_mobile2/utils/storage_helper.dart';

class KunciEdDSA extends StatefulWidget {
  const KunciEdDSA({super.key});

  @override
  KunciEdDSAState createState() => KunciEdDSAState();
}

class KunciEdDSAState extends State<KunciEdDSA> {
  String? publicKey;
  String? privateKey;
  bool isLoading = false;

  Future<void> generateKeys() async {
    setState(() => isLoading = true);
    final algorithm = Ed25519();
    final keyPair = await algorithm.newKeyPair();
    final publicKeyBytes = await keyPair.extractPublicKey();
    final privateKeyBytes = await keyPair.extractPrivateKeyBytes();

    final publicKeyBase64 = base64Encode(publicKeyBytes.bytes);
    final privateKeyBase64 = base64Encode(privateKeyBytes);

    await StorageHelper.savePrivateKey(privateKeyBase64);
    final authService = Provider.of<SupabaseAuthService>(context, listen: false);
    final userId = authService.user?.id;
    if (userId != null) {
      await authService.savePublicKeyToSupabase(userId, publicKeyBase64);
    }

    setState(() {
      publicKey = publicKeyBase64;
      privateKey = privateKeyBase64;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Generate Kunci EdDSA")),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ElevatedButton(
              onPressed: isLoading ? null : generateKeys,
              child: isLoading ? CircularProgressIndicator() : Text("Buat Kunci EdDSA"),
            ),
            SizedBox(height: 20),
            if (publicKey != null) ...[
              Text("Kunci Publik:", style: TextStyle(fontWeight: FontWeight.bold)),
              SelectableText(publicKey!),
              SizedBox(height: 10),
            ],
            if (privateKey != null) ...[
              Text("Kunci Privat (Simpan baik-baik!):", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red)),
              SelectableText(privateKey!),
            ]
          ],
        ),
      ),
    );
  }
}
