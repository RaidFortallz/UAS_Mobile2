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
          Consumer<CartProvider>(
            builder: (context, cartProvider, child) {
              if (!cartProvider.orderPlaced || cartProvider.orderItems.isEmpty) {
                return const Center(
                  child: Text(
                    'Belum ada notifikasi',
                    style: TextStyle(
                      fontFamily: "poppinsregular",
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: warnaKopi,
                    ),
                  ),
                );
              }

              return ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding: const EdgeInsets.all(16),
                itemCount: cartProvider.orderItems.length,
                itemBuilder: (context, index) {
                  final orderItem = cartProvider.orderItems[index];
                  final coffee = orderItem['coffee'];
                  final quantity = orderItem['quantity'];
                  final totalPrice = orderItem['totalPrice'];

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
                            child: Image.network(
                              coffee.image,
                              width: 50,
                              height: 50,
                              fit: BoxFit.cover,
                            ),
                          ),
                          const Gap(12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Pesanan Berhasil! 🎉',
                                  style: const TextStyle(
                                    fontFamily: "poppinsregular",
                                    fontSize: 14,
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
                                Text(
                                  'Total: Rp$totalPrice',
                                  style: const TextStyle(
                                    fontFamily: "poppinsregular",
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: warnaKopi3,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.close, color: warnaAbu),
                            onPressed: () {
                              Provider.of<CartProvider>(context, listen: false)
                                  .removeOrderItem(orderItem);
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
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
}
