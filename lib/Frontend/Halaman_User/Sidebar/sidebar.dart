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

      setState(() {
        username = usernameFromDb ?? '';
        email = emailFromDb ?? '';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(
              color: warnaKopi3,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const CircleAvatar(
                  radius: 35,
                  backgroundColor: Colors.white,
                  child: Icon(
                    Icons.person,
                    size: 40,
                    color: warnaKopi2,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  username,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
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
          const SizedBox(height: 20),
          // Item Menu
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
          const Divider(),
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
        color: warnaKopi3,
      ),
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: Colors.black87,
        ),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      onTap: onTap,
    );
  }
}
