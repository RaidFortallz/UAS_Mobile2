import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:uas_mobile2/Backend/Provider/cart_provider.dart';
import 'package:uas_mobile2/Backend/Provider/supabase_auth.dart';
import 'package:uas_mobile2/Frontend/Hal_Dashboard/Alamat/edit_alamat.dart';

import 'package:uas_mobile2/Frontend/PopUp_Dialog/awesome_dialog.dart';
import 'package:uas_mobile2/Models/coffee_model.dart';
import 'package:uas_mobile2/Warna_Tema/warna_tema.dart';

class Keranjang extends StatefulWidget {
  const Keranjang({super.key});

  @override
  State<Keranjang> createState() => _KeranjangState();
}

class _KeranjangState extends State<Keranjang> {
  final int shippingCost = 5000;

  String city = '';
  String address = '';
  String phoneNumber = '';

  @override
  void initState() {
    super.initState();
    _fetchUserAddress();
  }

  void _fetchUserAddress() async {
    final supabaseAuthService =
        Provider.of<SupabaseAuthService>(context, listen: false);
    final userId = supabaseAuthService.getCurrentUser()?.id;

    if (userId != null) {
      try {
        final userAddress = await supabaseAuthService.getUserAddress(userId);

        setState(() {
          city = userAddress['city'] ?? '';
          address = userAddress['address'] ?? '';
          phoneNumber = userAddress['phoneNumber'] ?? '';
        });
      } catch (e) {
        setState(() {
          city = 'Gagal memuat';
          address = 'Gagal memuat';
          phoneNumber = 'Gagal memuat';
        });
      }
    }
  }

  void updateAddress(String newCity, String newAddress, String newPhoneNumber) {
    setState(() {
      city = newCity;
      address = newAddress;
      phoneNumber = newPhoneNumber;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<CartProvider>(
        builder: (context, cartProvider, child) {
          final cartItems = cartProvider.cartItems;

          // Jika ada item dalam keranjang
          return ListView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 24),
            children: [
              const Gap(40),
              buildHeader(),
              const Gap(24),
              if (cartItems.isEmpty) ...[
                const Gap(270),
                const Center(
                  child: Text(
                    'Keranjang mu kosong',
                    style: TextStyle(
                      fontFamily: "poppinsregular",
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: warnaKopi2,
                    ),
                  ),
                ),
              ] else ...[
                buildAddress(),
                const Gap(20),
                buildPurchasedCoffee(cartItems),
                const Gap(24),
                buildPayment(cartProvider),
                const Gap(24),
              ],
            ],
          );
        },
      ),
      bottomNavigationBar: Consumer<CartProvider>(
        builder: (context, cartProvider, child) {
          if (cartProvider.cartItems.isEmpty) {
            return const SizedBox.shrink();
          }
          return buildOrder(cartProvider);
        },
      ),
    );
  }

  Widget buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const ImageIcon(
            AssetImage('assets/image/ic_arrow_left.png'),
          ),
        ),
        const Expanded(
          child: Align(
            alignment: Alignment.center,
            child: Text(
              'Keranjang',
              style: TextStyle(
                  fontFamily: "poppinsregular",
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: warnaKopi2),
            ),
          ),
        ),
        const SizedBox(width: 48),
      ],
    );
  }

  Widget buildAddress() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Alamat Pengiriman',
          style: TextStyle(
              fontFamily: "poppinsregular",
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: warnaKopi),
        ),
        const Gap(6),
         Text(
          city.isNotEmpty ? city : 'Kota: Belum diisi.',
          style: const TextStyle(
              fontFamily: "poppinsregular",
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: warnaKopi),
        ),
        const Gap(4),
         Text(
          address.isNotEmpty ? address : 'Alamat: Belum diisi.',
          style: const TextStyle(
              fontFamily: "poppinsregular",
              fontSize: 12,
              
              color: warnaKopi2),
        ),
        const Gap(4),
         Text(
          phoneNumber.isNotEmpty ? 'No Hp: $phoneNumber' : 'No Hp: Belum diisi',
          style: const TextStyle(
              fontFamily: "poppinsregular",
              fontSize: 12,
              
              color: warnaKopi2),
        ),
        const Gap(12),
        Row(
          children: [
            Bounceable(
              onTap: () {
                showEditAddressDialog(context, updateAddress, city, address, phoneNumber);
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                alignment: Alignment.center,
                height: 28,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.white,
                    border: Border.all(
                      color: warnaKopi2,
                      width: 1,
                    )),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.edit_square,
                      color: warnaKopi,
                      size: 15,
                    ),
                    Gap(4),
                    Text(
                      'Edit Alamat',
                      style: TextStyle(
                          fontFamily: "poppinsregular",
                          fontSize: 12,
                          color: warnaKopi),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        const Gap(16),
        const Divider(
          indent: 16,
          endIndent: 16,
          color: warnaKopi3,
          height: 1,
          thickness: 1,
        ),
      ],
    );
  }

  Widget buildPurchasedCoffee(List<Map<String, dynamic>> cartItems) {
    return Column(
      children: cartItems.map((item) {
        final coffee = item['coffee'] as Coffees;
        final size = item['size'] as String;
        int quantity = item['quantity'] != null ? item['quantity'] as int : 1;

        return Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    coffee.image,
                    width: 55,
                    height: 55,
                    fit: BoxFit.cover,
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
                        '${coffee.category} , $size',
                        style: const TextStyle(
                          fontFamily: "poppinsregular",
                          fontSize: 12,
                          color: warnaAbu,
                        ),
                      ),
                    ],
                  ),
                ),
                const Gap(18),
                Column(
                  children: [
                    Bounceable(
                        onTap: () {
                          Provider.of<CartProvider>(context, listen: false)
                              .removeFromCart(coffee, size);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                'Pesanan ${coffee.name} dihapus',
                                style: const TextStyle(
                                    fontFamily: "poppinsregular",
                                    fontSize: 12,
                                    color: Colors.white),
                              ),
                              backgroundColor: warnaKopi,
                              duration: const Duration(seconds: 3),
                            ),
                          );
                        },
                        child: const Icon(
                          Icons.delete_forever,
                          color: warnaKopi,
                          size: 24,
                        ))
                  ],
                ),
                const Gap(8),
                Bounceable(
                  onTap: null,
                  child: Row(
                    children: [
                      // Button Decrement
                      GestureDetector(
                        onTap: () {
                          if (quantity > 1) {
                            setState(() {
                              Provider.of<CartProvider>(context, listen: false)
                                  .updateQuantity(coffee, size, quantity - 1);
                            });
                          }
                        },
                        child: Container(
                          width: 24,
                          height: 24,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: quantity > 1 ? warnaKopi : warnaAbu,
                            ),
                            color: quantity > 1
                                ? Colors.white
                                : warnaAbu.withOpacity(0.35),
                          ),
                          child: Icon(
                            Icons.remove,
                            size: 15,
                            color: quantity > 1 ? warnaKopi : warnaAbu,
                          ),
                        ),
                      ),
                      const Gap(8),
                      SizedBox(
                        width: 28,
                        child: Center(
                          child: Text(
                            '$quantity',
                            style: const TextStyle(
                              fontFamily: "poppinsregular",
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: warnaKopi,
                            ),
                          ),
                        ),
                      ),
                      const Gap(8),
                      // Button Increment
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            Provider.of<CartProvider>(context, listen: false)
                                .updateQuantity(coffee, size, quantity + 1);
                          });
                        },
                        child: Container(
                          width: 24,
                          height: 24,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: warnaKopi,
                            ),
                          ),
                          child: const Icon(
                            Icons.add,
                            color: warnaKopi,
                            size: 15,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const Gap(20),
            const Divider(
              color: warnaKopi3,
              height: 1,
              thickness: 4,
            ),
            const Gap(12),
          ],
        );
      }).toList(),
    );
  }

  Widget buildPayment(CartProvider cartProvider) {
    final cartItems = cartProvider.cartItems;
    int totalPrice = 0;

    // Menghitung total harga berdasarkan item dalam keranjang
    for (var item in cartItems) {
      final price = item['price'] as int;
      final quantity = (item['quantity'] ?? 1) as int;
      totalPrice += price * quantity;
    }

    // Tambahkan biaya pengiriman
    final int totalWithShipping = totalPrice + shippingCost;

    // Format harga dalam format Rupiah
    final NumberFormat currencyFormat =
        NumberFormat.currency(decimalDigits: 0, locale: 'id_ID', symbol: 'Rp');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Ringkasan Pembayaran',
          style: TextStyle(
              fontFamily: "poppinsregular",
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: warnaKopi),
        ),
        const Gap(24),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Harga',
              style: TextStyle(
                  fontFamily: "poppinsregular", fontSize: 14, color: warnaKopi),
            ),
            Text(
              currencyFormat.format(totalPrice),
              style: const TextStyle(
                  fontFamily: "poppinsregular", fontSize: 14, color: warnaKopi),
            ),
          ],
        ),
        const Gap(12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Biaya Pengiriman',
              style: TextStyle(
                  fontFamily: "poppinsregular", fontSize: 14, color: warnaKopi),
            ),
            Text(
              currencyFormat.format(shippingCost),
              style: const TextStyle(
                  fontFamily: "poppinsregular", fontSize: 14, color: warnaKopi),
            ),
          ],
        ),
        const Gap(13),
        const Divider(
          color: warnaKopi3,
          height: 1,
          thickness: 1,
        ),
        const Gap(10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Total Harga',
              style: TextStyle(
                  fontFamily: "poppinsregular",
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                  color: warnaKopi3),
            ),
            Text(
              currencyFormat.format(totalWithShipping),
              style: const TextStyle(
                  fontFamily: "poppinsregular",
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                  color: warnaKopi3),
            ),
          ],
        ),
      ],
    );
  }

  Widget buildOrder(CartProvider cartProvider) {
    return Bounceable(
      onTap: () {

        cartProvider.placeOrder();

        CustomDialog.showDialog(
          context: context,
          dialogType: DialogType.success,
          animType: AnimType.bottomSlide,
          title: "Sukses",
          desc: "Berhasil Pesan Coffee",
          btnOkOnPress: () {
            cartProvider.clearCart();
          },
        );
      },
      child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(16),
              topRight: Radius.circular(16),
            ),
          ),
          child: Container(
            height: 48,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: warnaKopi2,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/image/bike.png',
                  height: 24,
                  width: 24,
                  color: Colors.white,
                ),
                const SizedBox(
                  width: 8,
                ),
                const Text(
                  'Order',
                  style: TextStyle(
                      fontFamily: "poppinsregular",
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white),
                ),
              ],
            ),
          )),
    );
  }
}
