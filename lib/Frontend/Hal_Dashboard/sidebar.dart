import 'package:flutter/material.dart';
import 'package:uas_mobile2/Backend/firebase_auth.dart';
import 'package:uas_mobile2/Frontend/Hal_Login&Register/login.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:uas_mobile2/Warna_Tema/warna_tema.dart';

class SidebarPage extends StatefulWidget {
  const SidebarPage({super.key});

  @override
  State<SidebarPage> createState() => _SidebarPageState();
}

class _SidebarPageState extends State<SidebarPage> {
  String username = 'Pengguna';
  String email = 'email@contoh.com';

  final FirebaseAuthService authService = FirebaseAuthService();
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    _getUserInfo();
  }

  Future<void> _getUserInfo() async {
    User? user = authService.getCurrentUser();
    if (user != null) {
      try {
        DocumentSnapshot userDoc =
            await firestore.collection('users').doc(user.uid).get();
        setState(() {
          username = userDoc['username'] ?? 'Pengguna';
          email = userDoc['email'] ?? 'email@contoh.com';
        });
      } catch (e) {
        if (e is FirebaseException) {
        } else {}
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(color: warnaKopi3),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.person, size: 80, color: Colors.white),
                const SizedBox(height: 8),
                Text(
                  username,
                  style: const TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                  ),
                ),
                Text(
                  email,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.white70,
                  ),
                ),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Logout'),
            onTap: () async {
              try {
                await authService.logout();
                if (context.mounted) {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const Login(),
                    ),
                  );
                }
              } catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Logout gagal: $e')),
                  );
                }
              }
            },
          ),
        ],
      ),
    );
  }
}
