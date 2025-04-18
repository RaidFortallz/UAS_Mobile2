import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:gap/gap.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:uas_mobile2/Backend/Provider/cart_provider.dart';
import 'package:uas_mobile2/Frontend/Halaman_User/Hal_Dashboard/Maps/lacak_pesanan.dart';
import 'package:uas_mobile2/Models/coffee_model.dart';
import 'package:uas_mobile2/Warna_Tema/warna_tema.dart';

class PengirimanFragment extends StatefulWidget {
  const PengirimanFragment({super.key});

  @override
  State<PengirimanFragment> createState() => _PengirimanFragmentState();
}

class _PengirimanFragmentState extends State<PengirimanFragment> {
  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);
    final orderItems = cartProvider.orderItems;
    final totalPrice = cartProvider.orderTotalPrice;

    var logger = Logger();

    logger.d('Order Placed: ${cartProvider.orderPlaced}');
    logger.d('Cart Items: $orderItems');

    return Scaffold(
      body: ListView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 24),
        children: [
          const Gap(60),
          buildHeader(),
          const Gap(18),
          if (cartProvider.orderItems.isEmpty) ...[
            const Gap(180),
            Center(
              child: Column(
                children: [
                  Image.asset(
                    'assets/image/bike.png',
                    height: 150,
                    width: 150,
                    color: warnaKopi2,
                  ),
                  const Text(
                    'Belum ada pengiriman.',
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
            buildDelivery(orderItems, totalPrice, context),
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
          'Pengiriman',
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

  Widget buildDelivery(List<Map<String, dynamic>> orderItems, int totalPrice,
      BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: orderItems.map((item) {
        final coffee = item['coffee'] as Coffees;
        final quantity = item['quantity'] as int;
        final size = item['size'] ?? 'Default';

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                ),
                border: Border.all(
                  color: warnaKopi2,
                  width: 1,
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: CachedNetworkImage(
                      imageUrl: coffee.image,
                      height: 60,
                      width: 60,
                      fit: BoxFit.cover,
                      errorWidget: (context, url, error) =>
                          const Icon(Icons.error),
                    ),
                  ),
                  const Gap(16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          coffee.name,
                          style: const TextStyle(
                            fontFamily: "poppinsregular",
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: warnaKopi,
                          ),
                        ),
                        Text(
                          'Jumlah: $quantity',
                          style: const TextStyle(
                            fontFamily: "poppinsregular",
                            fontSize: 12,
                            color: warnaAbu,
                          ),
                        ),
                        Text(
                          'Ukuran: $size',
                          style: const TextStyle(
                            fontFamily: "poppinsregular",
                            fontSize: 12,
                            color: warnaAbu,
                          ),
                        ),
                        Text(
                          'Harga: Rp${item['totalPrice']}',
                          style: const TextStyle(
                            fontFamily: "poppinsregular",
                            fontSize: 12,
                            color: warnaAbu,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                color: warnaKopi,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(12),
                  bottomRight: Radius.circular(12),
                ),
              ),
              child: Column(
                children: [
                  const Text(
                    'Pesanan anda sedang dalam perjalanan',
                    style: TextStyle(
                      fontFamily: "poppinsregular",
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  const Gap(16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Builder(
                          builder: (context) => Bounceable(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const TrackOrdersMap()));
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: warnaKopi3,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: warnaKopi2,
                                  width: 1,
                                ),
                              ),
                              child: const Text(
                                'Lacak Pesanan',
                                style: TextStyle(
                                  fontFamily: "poppinsregular",
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const Gap(16),
                      Expanded(
                        child: Bounceable(
                          onTap: () {
                            final cartProvider = Provider.of<CartProvider>(
                                context,
                                listen: false);
                            cartProvider.removeOrderItem(item);
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: Colors.green,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Text(
                              'Pesanan Selesai',
                              style: TextStyle(
                                fontFamily: "poppinsregular",
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const Gap(20),
          ],
        );
      }).toList(),
    );
  }
}
