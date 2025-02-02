import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:uas_mobile2/Backend/Provider/favorite_provider.dart';
import 'package:uas_mobile2/Warna_Tema/warna_tema.dart';

class FavoriteFragment extends StatelessWidget {
  const FavoriteFragment({super.key});

  @override
  Widget build(BuildContext context) {
    final favoriteProvider = Provider.of<FavoriteProvider>(context);
    final favorite = favoriteProvider.favorites;

    return Scaffold(
      body: ListView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 24),
        children: [
          const Gap(60),
          buildHeader(),
          const Gap(18),
          if (favorite.isEmpty) ...[
            const Gap(180),
            Center(
              child: Column(
                children: [
                  Image.asset(
                    'assets/image/ic_heart_border.png',
                    height: 150,
                    width: 150,
                    color: warnaKopi2,
                  ),
                  const Text(
                    'Belum ada kopi favorit.',
                    style: TextStyle(
                      fontFamily: "poppinsregular",
                      fontSize: 16,
                      color: warnaKopi2,
                    ),
                  ),
                ],
              ),
            ),
          ] else ...[
            buildGridCoffee(context),
          ],
        ],
      ),
    );
  }

  Widget buildHeader() {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.center,      
      children: [
        Text(
          'Favorite',
          style: TextStyle(
            fontFamily: "poppinsregular",
            fontWeight: FontWeight.w600,
            fontSize: 16,
            color: warnaKopi2,
          ),
        ),
        Gap(20),
        Divider(
          color: warnaKopi3,
          height: 1,
          thickness: 4,
        ),
      ],
    );
  }

  Widget buildGridCoffee(BuildContext context) {
    return Consumer<FavoriteProvider>(
      builder: (context, favoriteProvider, child) {
        final favorites = favoriteProvider.favorites;

        return GridView.builder(
          itemCount: favorites.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisExtent: 238,
            crossAxisSpacing: 15,
            mainAxisSpacing: 24,
          ),
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            final coffee = favorites[index];

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
                          child: CachedNetworkImage(
                            imageUrl: coffee.image,
                            height: 128,
                            width: double.infinity,
                            fit: BoxFit.cover,
                            errorWidget: (context, url, error) =>
                                const Icon(Icons.error),
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
                                  coffee.rate.toString(),
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
                        fontSize: 12,
                        color: warnaKopi2,
                      ),
                    ),
                    const Gap(4),
                    Text(
                      coffee.category,
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
                                  decimalDigits: 0,
                                  locale: 'id_ID',
                                  symbol: 'Rp')
                              .format(coffee.price),
                          style: const TextStyle(
                            fontFamily: "poppinsregular",
                            fontWeight: FontWeight.w600,
                            fontSize: 15,
                            color: warnaKopi2,
                          ),
                        ),
                        Bounceable(
                          onTap: () {
                            favoriteProvider.removeFavorite(coffee);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  'Kopi ${coffee.name} dihapus dari favorit',
                                  style: const TextStyle(
                                      fontFamily: "poppinsregular",
                                      fontSize: 12,
                                      color: Colors.white),
                                ),
                                backgroundColor: warnaKopi2,
                                duration: const Duration(seconds: 1),
                              ),
                            );
                          },
                          child: Container(
                            height: 32,
                            width: 32,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: warnaKopi3,
                            ),
                            child: const Icon(
                              Icons.favorite,
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
      },
    );
  }
}
