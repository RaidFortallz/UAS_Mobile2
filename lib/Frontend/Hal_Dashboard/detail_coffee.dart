import 'package:flutter/material.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'package:readmore/readmore.dart';
import 'package:uas_mobile2/Models/coffee_model.dart';
import 'package:uas_mobile2/Warna_Tema/warna_tema.dart';

class DetailCoffee extends StatefulWidget {
  const DetailCoffee({super.key, required this.coffee});
  final Coffees coffee;

  @override
  State<DetailCoffee> createState() => _DetailCoffeeState();
}

class _DetailCoffeeState extends State<DetailCoffee> {
  String sizeSelected = 'S';
 int price = 0;

  @override
  void initState() {
    super.initState();
    price = widget.coffee.price;
  }

  void updatePrice(String size) {
    int additionalPrice = 0;
    if (size == 'M') {
      additionalPrice = 3000;
    } else if (size == 'L') {
      additionalPrice = 5000;
    }
    setState(() {
      sizeSelected = size;
      price = widget.coffee.price + additionalPrice;
    });
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
          buildImage(),
          const Gap(24),
          buildTitle(),
          const Gap(24),
          buidDescription(),
          const Gap(30),
          buildSize(),
          const Gap(24),
        ],
      ),
      bottomNavigationBar: buildPrice(),
    );
  }

  Widget buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const ImageIcon(
            AssetImage('assets/image/ic_arrow_left.png'),
          ),
        ),
        const Text(
          'Detail',
          style: TextStyle(
              fontFamily: "poppinsregular",
              fontWeight: FontWeight.w600,
              fontSize: 16,
              color: warnaKopi2),
        ),
        IconButton(
          onPressed: () {},
          icon: const ImageIcon(
            AssetImage('assets/image/ic_heart_border.png'),
          ),
        ),
      ],
    );
  }

  Widget buildImage() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: Image.network(
        widget.coffee.image,
        width: double.infinity,
        height: 202,
        fit: BoxFit.cover,
      ),
    );
  }

  Widget buildTitle() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.coffee.name,
          style: const TextStyle(
              fontFamily: "poppinsregular",
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: warnaHitam),
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Gap(4),
                  Text(
                    widget.coffee.category,
                    style: const TextStyle(
                        fontFamily: "poppinsregular",
                        fontSize: 12,
                        color: warnaAbu),
                  ),
                  const Gap(16),
                  Row(
                    children: [
                      Image.asset(
                        'assets/image/ic_star.png',
                        height: 20,
                        width: 20,
                      ),
                      const Gap(4),
                      Text(
                        '${widget.coffee.rate} ',
                        style: const TextStyle(
                            fontFamily: "poppinsregular",
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: warnaHitam),
                      ),
                      Text(
                        '(${widget.coffee.review})',
                        style: const TextStyle(
                            fontFamily: "poppinsregular",
                            fontSize: 12,
                            color: warnaAbu),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Row(
              children: [
                'assets/image/bike.png',
                'assets/image/bean.png',
                'assets/image/milk.png'
              ].map((e) {
                return Container(
                  margin: const EdgeInsets.only(left: 12),
                  height: 44,
                  width: 44,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: warnaAbu3.withOpacity(0.35),
                  ),
                  alignment: Alignment.center,
                  child: Image.asset(
                    e,
                    height: 24,
                    width: 24,
                  ),
                );
              }).toList(),
            )
          ],
        ),
        const Gap(16),
        const Divider(
          indent: 16,
          endIndent: 16,
          color: warnaAbu2,
          height: 1,
          thickness: 1,
        ),
      ],
    );
  }

  Widget buidDescription() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Deskripsi',
          style: TextStyle(
              fontFamily: "poppinsregular",
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: warnaHitam),
        ),
        const Gap(8),
        ReadMoreText(
          widget.coffee.description,
          trimLength: 130,
          trimMode: TrimMode.Length,
          trimCollapsedText: ' Read More',
          trimExpandedText: ' Read Less',
          style: const TextStyle(
              fontFamily: "poppinsregular", fontSize: 13, color: warnaKopi),
          moreStyle: const TextStyle(
              fontFamily: "poppinsregular",
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: warnaKopi3),
          lessStyle: const TextStyle(
              fontFamily: "poppinsregular",
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: warnaKopi3),
        )
      ],
    );
  }

  Widget buildSize() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Ukuran Cup',
          style: TextStyle(
              fontFamily: "poppinsregular",
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: warnaHitam),
        ),
        const Gap(16),
        Row(
          children: ['S', '', 'M', '', 'L'].map((e) {
            if (e == '') return const Gap(16);

            bool isSelected = sizeSelected == e;
            return Expanded(
              child: Bounceable(
                onTap: () {
                  updatePrice(e);
                },
                child: Container(
                  height: 41,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: isSelected ? warnaKopi3 : warnaLight,
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    e,
                    style: TextStyle(
                        fontFamily: "poppinsregular",
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: isSelected ? Colors.white : warnaKopi),
                  ),
                ),
              ),
            );
          }).toList(),
        )
      ],
    );
  }

  Widget buildPrice() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
      decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
          )),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Harga',
                  style: TextStyle(
                      fontFamily: "poppinsregular",
                      fontSize: 14,
                      color: warnaKopi2),
                ),
                const Gap(4),
                Text(
                  NumberFormat.currency(
                          decimalDigits: 0, locale: 'id_ID', symbol: 'Rp')
                      .format(price),
                  style: const TextStyle(
                      fontFamily: "poppinsregular",
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: warnaKopi2),
                ),
              ],
            ),
          ),
          SizedBox(
            width: 185,
            child: Bounceable(
              onTap: () {
                Navigator.pushNamed(context, '/keranjang',
                    arguments: {
                      'coffee': widget.coffee,
                      'size': sizeSelected,
                      'price': price,
                    });
              },
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
                      'assets/image/ic_bag_border.png',
                      height: 24,
                      width: 24,
                      color: Colors.white,
                    ),
                    const SizedBox(width: 8,),
                    const Text(
                      'Pesan',
                      style: TextStyle(
                          fontFamily: "poppinsregular",
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
