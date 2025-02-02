import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:uas_mobile2/Frontend/Halaman_Admin/Hal_DashboardAdmin/home_admin.dart';
import 'package:uas_mobile2/Warna_Tema/warna_tema.dart';

class DashboardAdminPage extends StatefulWidget {
  const DashboardAdminPage({super.key});

  @override
  State<DashboardAdminPage> createState() => _DashboardAdminPageState();
}

class _DashboardAdminPageState extends State<DashboardAdminPage> {
  int indexMenu = 0;

  @override
  Widget build(BuildContext context) {
    final menu = [
      {
        'icon': 'assets/image/ic_home_border.png',
        'icon_active': 'assets/image/ic_home_filled.png',
        'fragment': const HomeAdmin()
      },
    ];

    return Scaffold(
      body: menu[indexMenu]['fragment'] as Widget,
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Row(
          children: List.generate(menu.length, (index) {
            Map item = menu[index];
            bool isActive = indexMenu == index;
            return Expanded(
              child: InkWell(
                onTap: () {
                  indexMenu = index;
                  setState(() {});
                },
                child: SizedBox(
                  height: 70,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Gap(20),
                      ImageIcon(
                        AssetImage(
                          item[isActive ? 'icon_active' : 'icon'],
                        ),
                        size: 24,
                        color: isActive ? warnaKopi3 : warnaAbu,
                      ),
                      if (isActive) const Gap(6),
                      if (isActive)
                        Container(
                          height: 5,
                          width: 10,
                          decoration: BoxDecoration(
                            color: warnaKopi3,
                            borderRadius: BorderRadius.circular(18),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}
