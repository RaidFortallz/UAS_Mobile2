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
                    color: warnaKopi2,
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Pengaturan Aplikasi',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: warnaKopi2,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),

            // Dark Mode Switch
            _buildSettingTile(
              title: 'Mode Gelap',
              description:
                  'Aktifkan mode gelap untuk tampilan yang lebih nyaman di malam hari.',
              value: isDarkMode,
              onChanged: (value) {
                setState(() {
                  isDarkMode = value;
                });
              },
            ),

            // Notification Settings
            _buildSettingTile(
              title: 'Notifikasi',
              description:
                  'Aktifkan notifikasi untuk mendapatkan pembaruan terbaru.',
              value: isNotificationsEnabled,
              onChanged: (value) {
                setState(() {
                  isNotificationsEnabled = value;
                });
              },
            ),

            // Auto-login Setting
            _buildSettingTile(
              title: 'Login Otomatis',
              description: 'Aktifkan login otomatis untuk masuk lebih cepat.',
              value: isAutoLoginEnabled,
              onChanged: (value) {
                setState(() {
                  isAutoLoginEnabled = value;
                });
              },
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
                  side: const BorderSide(color: warnaKopi2),
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
                  color: warnaKopi2,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingTile({
    required String title,
    required String description,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Card(
      elevation: 8,
      margin: const EdgeInsets.symmetric(vertical: 10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              description,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.black54,
              ),
            ),
            const SizedBox(height: 10),
            Switch(
              value: value,
              onChanged: onChanged,
              activeColor: warnaKopi2,
            ),
          ],
        ),
      ),
    );
  }
}
