import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uas_mobile2/Backend/Provider/supabase_auth.dart';
import 'package:uas_mobile2/Frontend/Halaman_User/Hal_Login&Register/login.dart';
import 'package:uas_mobile2/Frontend/Halaman_User/Sidebar/about.dart';
import 'package:uas_mobile2/Warna_Tema/warna_tema.dart';

class SidebarPage extends StatefulWidget {
  const SidebarPage({super.key});

  @override
  State<SidebarPage> createState() => _SidebarPageState();
}

class _SidebarPageState extends State<SidebarPage> {
  String username = '';
  String email = '';
  String? profileImageUrl;

  @override
  void initState() {
    super.initState();
    _getUserInfo();
  }

  Future<void> _getUserInfo() async {
    final authService =
        Provider.of<SupabaseAuthService>(context, listen: false);
    final user = authService.getCurrentUser();

    if (user != null) {
      final userId = user.id;
      final usernameFromDb = await authService.getUsernameByUserId(userId);
      final emailFromDb =
          await authService.getEmailByUsername(usernameFromDb ?? '');
      final imageUrl = await authService.getProfileImage();

      if (mounted) {
        setState(() {
          username = usernameFromDb ?? '';
          email = emailFromDb ?? '';
          profileImageUrl = imageUrl;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [warnaKopi3, warnaKopi2],
          ),
        ),
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            Stack(
              children: [
                // Gambar background kopi
                Positioned.fill(
                  child: ClipRRect(
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(30),
                      bottomRight: Radius.circular(30),
                    ),
                    child: Image.asset(
                      'assets/image/bg_kopi4.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),

                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.3),
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(30),
                        bottomRight: Radius.circular(30),
                      ),
                    ),
                  ),
                ),

                // Konten header: Avatar, nama, dan email
                Container(
                  padding: const EdgeInsets.all(25),
                  margin: const EdgeInsets.only(top: 30),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: CircleAvatar(
                          radius: 40,
                          backgroundColor: warnaKopi,
                          backgroundImage: profileImageUrl != null
                              ? NetworkImage(profileImageUrl!)
                              : null,
                          child: profileImageUrl == null
                              ? const Icon(Icons.person,
                                  size: 50, color: warnaLight)
                              : null,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Center(
                        child: Text(
                          username,
                          style: const TextStyle(
                            fontFamily: "poppinsregular",
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      Center(
                        child: Text(
                          email,
                          style: const TextStyle(
                            fontFamily: "poppinsregular",
                            fontSize: 14,
                            color: Colors.white70,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            _buildMenuItem(
              context,
              icon: Icons.person,
              title: 'Profile',
              onTap: () {
                Navigator.pushNamed(context, '/profil');
              },
            ),
            _buildMenuItem(
              context,
              icon: Icons.account_balance_wallet,
              title: 'Saldo',
              onTap: () {
                Navigator.pushNamed(context, '/saldo');
              },
            ),
            _buildMenuItem(
              context,
              icon: Icons.key_outlined,
              title: 'Kunci (EdDSA)',
              onTap: () {
                Navigator.pushNamed(context, '/kunci_eddsa');
              },
            ),
            _buildMenuItem(
              context,
              icon: Icons.settings,
              title: 'Settings',
              onTap: () {
                Navigator.pushNamed(context, '/settings');
              },
            ),
            _buildMenuItem(
              context,
              icon: Icons.info,
              title: 'About',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AboutPage(),
                  ),
                );
              },
            ),
            const Divider(
              indent: 16,
              endIndent: 16,
              color: warnaLight,
              height: 1,
              thickness: 1.5,
            ),
            _buildMenuItem(
              context,
              icon: Icons.logout,
              title: 'Logout',
              onTap: () async {
                try {
                  final authService =
                      Provider.of<SupabaseAuthService>(context, listen: false);
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
      ),
    );
  }

  Widget _buildMenuItem(BuildContext context,
      {required IconData icon,
      required String title,
      required Function() onTap}) {
    return ListTile(
      leading: Icon(
        icon,
        size: 30,
        color: warnaLight,
      ),
      title: Text(
        title,
        style: const TextStyle(
          fontFamily: "poppinsregular",
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: warnaLight,
        ),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      onTap: onTap,
    );
  }
}
