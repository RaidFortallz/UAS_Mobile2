import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'package:uas_mobile2/Backend/firebase_auth.dart';
import 'package:uas_mobile2/Frontend/Sidebar/sidebar.dart';
import 'package:uas_mobile2/Models/coffee.dart';
import 'package:uas_mobile2/Warna_Tema/warna_tema.dart';

class HomeFragment extends StatefulWidget {
  const HomeFragment({super.key});

  @override
  State<HomeFragment> createState() => _HomeFragmentState();
}

class _HomeFragmentState extends State<HomeFragment> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  int _currentIndex = 0;
  String categorySelected = 'All Coffee';
  String username = '';

  // Instansiasi FirebaseAuthService dan FirebaseFirestore
  final FirebaseAuthService _authService = FirebaseAuthService();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final List<String> banners = [
    'assets/image/banner_kopi1.png',
    'assets/image/banner_kopi2.png',
    'assets/image/banner_kopi3.png',
    'assets/image/banner_kopi4.png',
    'assets/image/banner_kopi5.png',
  ];

  @override
  void initState() {
    super.initState();
    _getUserInfo();
  }

  Future<void> _getUserInfo() async {
    User? user = _authService.getCurrentUser();

    if (user != null) {
      DocumentSnapshot userDoc =
          await _firestore.collection('users').doc(user.uid).get();

      setState(() {
        username = userDoc['username'] ?? 'Pengguna';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: const SidebarPage(),
      body: ListView(
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
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 221),
                child: buildBannerPromo(),
              )
            ],
          ),
          const Gap(20),
          buildCategories(),
          const Gap(16),
          buildGridCoffee(),
          const Gap(30)
        ],
      ),
    );
  }

  Widget buildBackground() {
    return Container(
      height: 270,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [warnaKopi, warnaKopi2],
        ),
      ),
    );
  }

  Widget buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              icon: const Icon(Icons.menu, color: warnaAbu),
              onPressed: () {
                _scaffoldKey.currentState?.openDrawer();
              },
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                const Text(
                  'SELAMAT DATANG',
                  style: TextStyle(
                      fontFamily: "poppinsregular",
                      fontSize: 16,
                      color: warnaAbu),
                ),
                Text(
                  username.isEmpty ? 'USER' : username,
                  style: const TextStyle(
                      fontFamily: "poppinsregular",
                      fontWeight: FontWeight.w600,
                      fontSize: 20,
                      color: warnaAbu2),
                ),
              ],
            ),
          ],
        ),
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
              AssetImage('assets/image/ic_bag_border.png'),
              size: 28,
              color: Colors.white,
            ),
          ),
        )
      ],
    );
  }

  Widget buildBannerPromo() {
    return Column(
      children: [
        CarouselSlider(
          items: banners.map((image) {
            return ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.asset(
                image,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            );
          }).toList(),
          options: CarouselOptions(
            height: 140,
            autoPlay: true,
            autoPlayInterval: const Duration(seconds: 4),
            autoPlayAnimationDuration: const Duration(milliseconds: 800),
            autoPlayCurve: Curves.easeInOut,
            enableInfiniteScroll: true,
            viewportFraction: 0.8,
            enlargeCenterPage: true,
            onPageChanged: (index, reason) {
              setState(() {
                _currentIndex = index;
              });
            },
          ),
        ),
        const Gap(12),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: banners.asMap().entries.map((entry) {
            return GestureDetector(
              onTap: () => setState(() {
                _currentIndex = entry.key;
              }),
              child: Container(
                width: 7.0,
                height: 7.0,
                margin: const EdgeInsets.symmetric(horizontal: 4.0),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _currentIndex == entry.key
                      ? warnaKopi3
                      : warnaKopi.withOpacity(0.4),
                ),
              ),
            );
          }).toList(),
        )
      ],
    );
  }

  Widget buildCategories() {
    final categories = [
      'All Coffee',
      'Machiato',
      'Latte',
      'Americano',
    ];

    return SizedBox(
      height: 29,
      child: ListView.builder(
        itemCount: categories.length,
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemBuilder: (context, index) {
          String category = categories[index];
          bool isActive = categorySelected == category;
          return Bounceable(
            onTap: () {
              categorySelected = category;
              setState(() {});
            },
            child: Container(
              margin: EdgeInsets.only(
                left: index == 0 ? 24 : 8,
                right: index == categories.length - 1 ? 24 : 8,
              ),
              decoration: BoxDecoration(
                color: isActive ? warnaKopi3 : warnaAbu3.withOpacity(0.35),
                borderRadius: BorderRadius.circular(6),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 8),
              alignment: Alignment.center,
              child: Text(
                category,
                style: TextStyle(
                    fontFamily: "poppinsregular",
                    fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
                    fontSize: 14,
                    color: isActive ? Colors.white : warnaHitam),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget buildGridCoffee() {
    return GridView.builder(
      itemCount: listGridCoffee.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisExtent: 238,
          crossAxisSpacing: 15,
          mainAxisSpacing: 24),
      shrinkWrap: true,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        Coffee coffee = listGridCoffee[index];

        return GestureDetector(
          onTap: () {
            Navigator.pushNamed(context, '/detail', arguments: coffee);
          },
          child: Container(
            padding: const EdgeInsets.fromLTRB(8, 8, 8, 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.asset(
                        coffee.image,
                        height: 128,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Align(
                      alignment: Alignment.topRight,
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topRight,
                            end: Alignment.bottomLeft,
                            colors: [
                              warnaHitam2.withOpacity(0.3),
                              warnaHitam.withOpacity(0.3),
                            ],
                          ),
                          borderRadius: const BorderRadius.only(
                            topRight: Radius.circular(12),
                            bottomLeft: Radius.circular(24),
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Image.asset(
                              'assets/image/ic_star.png',
                              height: 12,
                              width: 12,
                            ),
                            const Gap(4),
                            Text(
                              '${coffee.rate}',
                              style: const TextStyle(
                                  fontFamily: "poppinsregular",
                                  fontSize: 8,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const Gap(8),
                Text(
                  coffee.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontFamily: "poppinsregular",
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                    color: warnaKopi2,
                  ),
                ),
                const Gap(4),
                Text(
                  coffee.type,
                  style: const TextStyle(
                    fontFamily: "poppinsregular",
                    fontSize: 12,
                    color: warnaAbu,
                  ),
                ),
                const Spacer(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      NumberFormat.currency(
                              decimalDigits: 0, locale: 'id_ID', symbol: 'Rp')
                          .format(coffee.price),
                      style: const TextStyle(
                        fontFamily: "poppinsregular",
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                        color: warnaKopi2,
                      ),
                    ),
                    Bounceable(
                      onTap: () {},
                      child: Container(
                        height: 32,
                        width: 32,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: warnaKopi3,
                        ),
                        child: const Icon(
                          Icons.add,
                          color: Colors.white,
                          size: 18,
                        ),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
