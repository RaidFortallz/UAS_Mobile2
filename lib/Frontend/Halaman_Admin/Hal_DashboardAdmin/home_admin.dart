import 'package:flutter/material.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:gap/gap.dart';
import 'package:uas_mobile2/Backend/Provider/supabase_auth.dart';
import 'package:uas_mobile2/Frontend/Halaman_Admin/Hak_Akses/add_coffee.dart';
import 'package:uas_mobile2/Frontend/Halaman_Admin/Hak_Akses/delete_coffee.dart';
import 'package:uas_mobile2/Frontend/Halaman_Admin/Hak_Akses/edit_coffee.dart';
import 'package:uas_mobile2/Frontend/Halaman_User/Hal_Login&Register/login.dart';
import 'package:uas_mobile2/Warna_Tema/warna_tema.dart';
import 'package:provider/provider.dart';

class HomeAdmin extends StatefulWidget {
  const HomeAdmin({super.key});

  @override
  State<HomeAdmin> createState() => _HomeAdminState();
}

class _HomeAdminState extends State<HomeAdmin> {
  final List<Map<String, dynamic>> menuItems = [
    {'title': 'Tambah Kopi', 'icon': Icons.add},
    {'title': 'Edit Kopi', 'icon': Icons.edit},
    {'title': 'Hapus Kopi', 'icon': Icons.delete},
    {'title': 'Logout', 'icon': Icons.exit_to_app},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.all(0),
        physics: const BouncingScrollPhysics(),
        children: [
          buildHeader(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              children: [
                const Gap(20),
                buildGridMenu(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildHeader() {
    return Container(
      height: 260,
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [warnaKopi, warnaKopi2],
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'assets/image/bg_kopi2.png',
            height: 150,
            width: 150,
            fit: BoxFit.contain,
          ),
          const SizedBox(height: 8),
          const Text(
            'Selamat Datang Admin',
            style: TextStyle(
              fontFamily: "poppinsregular",
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: warnaLight,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildGridMenu() {
    return GridView.builder(
      itemCount: menuItems.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisExtent: 200,
        crossAxisSpacing: 15,
        mainAxisSpacing: 24,
      ),
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        final menu = menuItems[index];

        return Bounceable(
          onTap: () async {
            if (index == 3) {
              // Logout item
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
            } else {
              switch (index) {
                case 0:
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const AddCoffeePage()));
                  break;
                case 1:
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const EditCoffeePage()));
                  break;
                case 2:
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const DeleteCoffeePage()));
                  break;
              }
            }
          },
          child: Container(
            padding: const EdgeInsets.fromLTRB(8, 8, 8, 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  height: 128,
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                    gradient: LinearGradient(
                      begin: Alignment.topRight,
                      end: Alignment.bottomLeft,
                      colors: [warnaKopi, warnaKopi3],
                    ),
                  ),
                  child: Center(
                    child: Icon(
                      menu['icon']!,
                      size: 60,
                      color: Colors.white,
                    ),
                  ),
                ),
                const Gap(8),
                Text(
                  menu['title']!,
                  style: const TextStyle(
                    fontFamily: "poppinsregular",
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    color: warnaKopi2,
                  ),
                  textAlign: TextAlign.center,
                ),
                const Spacer(),
              ],
            ),
          ),
        );
      },
    );
  }
}
