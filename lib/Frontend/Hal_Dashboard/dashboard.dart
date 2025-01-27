import 'package:flutter/material.dart';
import 'package:uas_mobile2/Frontend/Hal_Dashboard/home.dart';
import 'package:uas_mobile2/Frontend/Hal_Dashboard/Favorite.dart';
import 'package:gap/gap.dart';
import 'package:uas_mobile2/Warna_Tema/warna_tema.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  int indexMenu = 0;
  final menu = [
    {
      'icon': 'assets/image/ic_home_border.png',
      'icon_active': 'assets/image/ic_home_filled.png',
      'fragment': const HomeFragment()
    },
    {
      'icon': 'assets/image/ic_heart_border.png',
      'icon_active': 'assets/image/ic_heart_border.png',
      'fragment': const FavoritePage()
    },
    {
      'icon': 'assets/image/bike.png',
      'icon_active': 'assets/image/bike.png',
      'fragment': const Center(
        child: Text('PENGIRIMAN'),
      ),
    },
    {
      'icon': 'assets/image/ic_notification_border.png',
      'icon_active': 'assets/image/ic_notification_border.png',
      'fragment': const Center(
        child: Text('NOTIFIKASI'),
      ),
    },
  ];

  @override
  Widget build(BuildContext context) {
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
