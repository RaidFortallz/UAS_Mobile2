import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:uas_mobile2/Warna_Tema/warna_tema.dart';

class HomeFragment extends StatelessWidget {
  const HomeFragment({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(0),
      children: [
        Stack(
          children: [
            buildBackground(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  const Gap(68),
                  buildHeader(),
                  const Gap(30),
                  buildSearch(),
                  const Gap(24),
                  buildBannerPromo(),
                ],
              ),
            )
          ],
        ),
        const Gap(20),
        // buildCategories(),
        const Gap(16),
        // buildGridCoffee(),
        const Gap(30)
      ],
    );
  }

  Widget buildBackground() {
    return Container(
      height: 280,
      decoration: const BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: [warnaKopi, warnaKopi2])),
    );
  }

  Widget buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'SELAMAT DATANG',
          style: TextStyle(
              fontFamily: "poppinsregular", fontSize: 14, color: warnaAbu),
        ),
        Row(
          children: [
            const Text(
              'USER',
              style: TextStyle(
                  fontFamily: "poppinsregular",
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                  color: warnaAbu2),
            ),
            const Gap(4),
            Image.asset(
              'assets/image/ic_arrow_down.png',
              height: 16,
              width: 16,
            )
          ],
        )
      ],
    );
  }

  Widget buildSearch() {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 50,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: const Color(0xffF9F9F9),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: const Row(
              children: [
                ImageIcon(
                  AssetImage('assets/image/ic_search.png'),
                  color: warnaKopi3,
                ),
                Gap(8),
                Expanded(
                  child: TextField(
                    style: TextStyle(
                        fontFamily: "poppinsregular",
                        fontSize: 14,
                        color: Colors.black12),
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.all(0),
                      isDense: true,
                      border: InputBorder.none,
                      hintText: "Cari Kopi . . .",
                      hintStyle: TextStyle(
                          fontFamily: "poppinsregular",
                          fontSize: 14,
                          color: warnaAbu),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
        const Gap(16),
        InkWell(
          onTap: () {},
          child: Container(
            height: 52,
            width: 52,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: warnaKopi3,
            ),
            alignment: Alignment.center,
            child: const ImageIcon(
              AssetImage('assets/image/ic_filter.png'),
              size: 20,
              color: Colors.white,
            ),
          ),
        )
      ],
    );
  }

  Widget buildBannerPromo() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: Image.asset(
        'assets/image/banner_coffee.png',
        width: double.infinity,
        height: 140,
      ),
    );
  }
}
