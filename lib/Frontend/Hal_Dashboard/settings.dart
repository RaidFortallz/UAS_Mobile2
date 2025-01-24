import 'package:flutter/material.dart';
import 'package:uas_mobile2/Warna_Tema/warna_tema.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool isDarkMode = false;
  bool isNotificationsEnabled = true;
  bool isAutoLoginEnabled = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          children: [
            // Header
            const Center(
              child: Column(
                children: [
                  Icon(
                    Icons.settings,
                    size: 80,
                    color: warnaKopi3,
                  ),
                  SizedBox(height: 16),
                ],
              ),
            ),
            const SizedBox(height: 40),

            // Dark Mode Switch
            Card(
              elevation: 5,
              margin: const EdgeInsets.symmetric(vertical: 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: ListTile(
                contentPadding: const EdgeInsets.all(16),
                title: const Text(
                  'Mode Gelap',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
                trailing: Switch(
                  value: isDarkMode,
                  onChanged: (value) {
                    setState(() {
                      isDarkMode = value;
                    });
                  },
                  activeColor: warnaKopi3,
                ),
              ),
            ),

            // Notification Settings
            Card(
              elevation: 5,
              margin: const EdgeInsets.symmetric(vertical: 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: ListTile(
                contentPadding: const EdgeInsets.all(16),
                title: const Text(
                  'Notifikasi',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
                trailing: Switch(
                  value: isNotificationsEnabled,
                  onChanged: (value) {
                    setState(() {
                      isNotificationsEnabled = value;
                    });
                  },
                  activeColor: warnaKopi3,
                ),
              ),
            ),

            // Auto-login Setting
            Card(
              elevation: 5,
              margin: const EdgeInsets.symmetric(vertical: 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: ListTile(
                contentPadding: const EdgeInsets.all(16),
                title: const Text(
                  'Login Otomatis',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
                trailing: Switch(
                  value: isAutoLoginEnabled,
                  onChanged: (value) {
                    setState(() {
                      isAutoLoginEnabled = value;
                    });
                  },
                  activeColor: warnaKopi3,
                ),
              ),
            ),

            const SizedBox(height: 40),

            // Tombol Kembali
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: const BorderSide(color: warnaKopi3),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 80,
                  vertical: 15,
                ),
              ),
              child: const Text(
                'Kembali',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: warnaKopi3,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
