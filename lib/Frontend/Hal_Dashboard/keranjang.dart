import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'package:uas_mobile2/Frontend/PopUp_Dialog/awesome_dialog.dart';
import 'package:uas_mobile2/Models/coffee.dart';
import 'package:uas_mobile2/Warna_Tema/warna_tema.dart';

class Keranjang extends StatefulWidget {
  const Keranjang({super.key, required this.coffee});
  final Coffee coffee;

  @override
  State<Keranjang> createState() => _KeranjangState();
}

class _KeranjangState extends State<Keranjang> {
  int _quantity = 1;
  final int shippingCost = 5000;

  void _incrementQuantity() {
    setState(() {
      _quantity++;
    });
  }

  void _decrementQuantity() {
    if (_quantity > 1) {
      setState(() {
        _quantity--;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 24),
        children: [
          const Gap(48),
          buildHeader(),
          const Gap(24),
          buildAddress(),
          const Gap(20),
          buildPurchasedCoffee(),
          const Gap(24),
          buildPayment(),
          const Gap(24)
        ],
      ),
      bottomNavigationBar: buildOrder(),
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
        const Gap(14),
        const Text(
          'Jl. Moh Toha',
          style: TextStyle(
              fontFamily: "poppinsregular",
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: warnaKopi),
        ),
        const Gap(4),
        const Text(
          'Jl. Moh Toha, Gg Jawir, no.27, rt03/rw04',
          style: TextStyle(
              fontFamily: "poppinsregular",
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: warnaAbu),
        ),
        const Gap(12),
        Row(
          children: [
            Bounceable(
              onTap: () {},
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

  Widget buildPurchasedCoffee() {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(
                widget.coffee.image,
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
                    widget.coffee.name,
                    style: const TextStyle(
                        fontFamily: "poppinsregular",
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: warnaKopi),
                  ),
                  Text(
                    '${widget.coffee.type} , S',
                    style: const TextStyle(
                        fontFamily: "poppinsregular",
                        fontSize: 12,
                        color: warnaAbu),
                  ),
                ],
              ),
            ),
            const Gap(16),
            Bounceable(
              onTap: null,
              child: Row(
                children: [
                  // Button Decrement
                  GestureDetector(
                    onTap: _quantity > 1 ? _decrementQuantity : null,
                    child: Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: _quantity > 1 ? warnaKopi : warnaAbu,
                        ),
                        color: _quantity > 1
                            ? Colors.white
                            : warnaAbu.withOpacity(0.35),
                      ),
                      child: Icon(
                        Icons.remove,
                        size: 15,
                        color: _quantity > 1 ? warnaKopi : warnaAbu,
                      ),
                    ),
                  ),
                  const Gap(16),
                  SizedBox(
                    width: 28,
                    child: Center(
                      child: Text(
                        '$_quantity',
                        style: const TextStyle(
                          fontFamily: "poppinsregular",
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: warnaKopi,
                        ),
                      ),
                    ),
                  ),
                  const Gap(16),
                  // Button Increment
                  GestureDetector(
                    onTap: _incrementQuantity,
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
        const Gap(26),
        const Divider(
          color: warnaKopi3,
          height: 1,
          thickness: 4,
        ),
      ],
    );
  }

  Widget buildPayment() {
    final int coffeePrice = widget.coffee.price.toInt() * _quantity;
    final int totalPrice = coffeePrice + shippingCost;
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
              currencyFormat.format(coffeePrice),
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
            )
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
              currencyFormat.format(totalPrice),
              style: const TextStyle(
                  fontFamily: "poppinsregular",
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                  color: warnaKopi3),
            )
          ],
        )
      ],
    );
  }

  Widget buildOrder() {
    return Bounceable(
      onTap: () {
        CustomDialog.showDialog(
            context: context,
            dialogType: DialogType.success,
            title: "Sukses",
            desc: "Berhasil Pesan Coffee",
            btnOkOnPress: () {
              Navigator.pop(context);
            });
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
            child: const Center(
              child: Text(
                'Order',
                style: TextStyle(
                    fontFamily: "poppinsregular",
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white),
              ),
            ),
          )),
    );
  }
}
