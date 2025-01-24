import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:uas_mobile2/Models/coffee.dart';
import 'package:uas_mobile2/Warna_Tema/warna_tema.dart';

class DetailCoffee extends StatefulWidget {
  const DetailCoffee({super.key, required this.coffee});
  final Coffee coffee;

  @override
  State<DetailCoffee> createState() => _DetailCoffeeState();
}

class _DetailCoffeeState extends State<DetailCoffee> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        children: [
          const Gap(68),
          buildHeader(),
          const Gap(24),
          buildImage(),
          const Gap(24),
          // buildTitle(),
          const Gap(24),
          // buidDescription(),
          const Gap(24),
          // buildSize(),
          const Gap(24),
        ],
      ),
      // bottomNavigationBar: buildPrice(),
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
      child: Image.asset(
        widget.coffee.image,
        width: double.infinity,
        height: 202,
        fit: BoxFit.cover,
      ),
    );
  }
}
