import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uas_mobile2/Backend/Provider/cart_provider.dart';
import 'package:uas_mobile2/Frontend/Halaman_User/Hal_Dashboard/favorite.dart';
import 'package:uas_mobile2/Frontend/Halaman_User/Hal_Dashboard/home.dart';
import 'package:gap/gap.dart';
import 'package:uas_mobile2/Frontend/Halaman_User/Hal_Dashboard/notifikasi.dart';
import 'package:uas_mobile2/Frontend/Halaman_User/Hal_Dashboard/pengiriman.dart';
import 'package:uas_mobile2/Frontend/Halaman_User/Sidebar/sidebar.dart';
import 'package:uas_mobile2/Warna_Tema/warna_tema.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  int indexMenu = 0;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final menu = [
      {
        'icon': 'assets/image/ic_home_border.png',
        'icon_active': 'assets/image/ic_home_filled.png',
        'fragment': const HomeFragment()
      },
      {
        'icon': 'assets/image/ic_heart_border.png',
        'icon_active': 'assets/image/ic_heart_active.png',
        'fragment': const FavoriteFragment()
      },
      {
        'icon': 'assets/image/bike.png',
        'icon_active': 'assets/image/bike.png',
        'fragment': const PengirimanFragment()
      },
      {
        'icon': 'assets/image/ic_notification_border.png',
        'icon_active': 'assets/image/ic_notification_active.png',
        'fragment': const NotifikasiFragment()
      },
    ];

    return Scaffold(
      key: _scaffoldKey,
      drawer: const SidebarPage(),
      body: Stack(
        children: [
          menu[indexMenu]['fragment'] as Widget,
          if (indexMenu == 0)
            Positioned(
              top: 70,
              left: 0,
              child: Container(
                decoration: BoxDecoration(
                  color: warnaKopi3,
                  borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 4,
                      offset: const Offset(2, 2),
                    ),
                  ],
                ),
                padding:
                    const EdgeInsets.symmetric(vertical: 6, horizontal: 10),
                child: IconButton(
                  icon: const Icon(Icons.menu, color: warnaLight, size: 30),
                  onPressed: () {
                    _scaffoldKey.currentState?.openDrawer();
                  },
                ),
              ),
            ),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(left: 30, right: 30, bottom: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(menu.length, (index) {
            Map item = menu[index];
            bool isActive = indexMenu == index;

            return Expanded(
              child: InkWell(
                onTap: () {
                  setState(() {
                    indexMenu = index;
                  });
                },
                child: SizedBox(
                  height: 70,
                  child: Stack(
                    clipBehavior: Clip.none,
                    alignment: Alignment.center,
                    children: [
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Gap(15),
                          ImageIcon(
                            AssetImage(
                              item[isActive ? 'icon_active' : 'icon'],
                            ),
                            size: 28,
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
                      if (index == 3)
                        Positioned(
                          top: 19,
                          right: 18,
                          child: Consumer<CartProvider>(
                            builder: (context, cartProvider, child) {
                              if (cartProvider.notificationItems.isNotEmpty) {
                                return Container(
                                  width: 10,
                                  height: 10,
                                  decoration: const BoxDecoration(
                                    color: Colors.red,
                                    shape: BoxShape.circle,
                                  ),
                                );
                              }
                              return const SizedBox();
                            },
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
