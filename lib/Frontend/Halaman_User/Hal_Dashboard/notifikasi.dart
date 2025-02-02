import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uas_mobile2/Backend/Provider/cart_provider.dart';
import 'package:uas_mobile2/Warna_Tema/warna_tema.dart';
import 'package:gap/gap.dart';

class NotifikasiFragment extends StatelessWidget {
  const NotifikasiFragment({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 24),
        children: [
          const Gap(60),
          buildHeader(),
          const Gap(18),

          // Menambahkan pengecekan untuk kondisi kosong atau ada notifikasi
          Consumer<CartProvider>(
            builder: (context, cartProvider, child) {
              if (cartProvider.notificationItems.isEmpty) {
                return  Center(
                  child: Column(
                    children: [
                      const SizedBox(height: 180),
                      Image.asset(
                    'assets/image/ic_notification_border.png',
                    height: 150,
                    width: 150,
                    color: warnaKopi2,
                  ),
                      const Text(
                        'Belum ada notifikasi.',
                        style: TextStyle(
                          fontFamily: "poppinsregular",
                          fontSize: 16,
                          color: warnaKopi2,
                        ),
                      ),
                    ],
                  ),
                );
              } else {
                return buildListNotification(cartProvider);
              }
            },
          ),
        ],
      ),
    );
  }

  Widget buildHeader() {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          'Notifikasi',
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

  Widget buildListNotification(CartProvider cartProvider) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.only(top: 16),
      itemCount: cartProvider.notificationItems.length,
      itemBuilder: (context, index) {
        final orderItem = cartProvider.notificationItems[index];
        final coffee = orderItem['coffee'];
        final quantity = orderItem['quantity'];

        return Card(
          elevation: 3,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: CachedNetworkImage(
                    imageUrl: coffee.image,
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.error, color: Colors.red),
                  ),
                ),
                const Gap(12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Berhasil Pesan Kopi! ☕',
                        style: TextStyle(
                          fontFamily: "poppinsregular",
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: warnaKopi,
                        ),
                      ),
                      Text(
                        '${coffee.name} x$quantity',
                        style: const TextStyle(
                          fontFamily: "poppinsregular",
                          fontSize: 13,
                          color: warnaKopi2,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close, color: warnaAbu),
                  onPressed: () {
                    cartProvider.removeNotificationItem(orderItem);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
