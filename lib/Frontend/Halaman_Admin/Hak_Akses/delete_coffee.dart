import 'package:flutter/material.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:uas_mobile2/Warna_Tema/warna_tema.dart';

class DeleteCoffeePage extends StatefulWidget {
  const DeleteCoffeePage({super.key});

  @override
  State<DeleteCoffeePage> createState() => _DeleteCoffeePageState();
}

class _DeleteCoffeePageState extends State<DeleteCoffeePage> {
  final SupabaseClient supabase = Supabase.instance.client;
  List<dynamic> coffeeList = [];
  bool isLoading = true;

  var logger = Logger();

  @override
  void initState() {
    super.initState();
    fetchCoffees();
  }

  Future<void> fetchCoffees() async {
    try {
      final response = await supabase.from('coffees').select();
      setState(() {
        coffeeList = response;
        isLoading = false;
      });
    } catch (e) {
      logger.e('Error fetching coffees: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> deleteCoffee(int coffeeId, String coffeeName) async {
    try {
      await supabase.from('coffees').delete().eq('id', coffeeId);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Kopi $coffeeName berhasil dihapus',
            style: const TextStyle(
              fontFamily: "poppinsregular",
              fontSize: 12,
              color: Colors.white,
            ),
          ),
          backgroundColor: warnaKopi2,
          duration: const Duration(seconds: 1),
        ),
      );
      fetchCoffees();
    } catch (e) {
      logger.e('Error deleting coffee: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Scaffold(
          body: isLoading
              ? const Center(child: CircularProgressIndicator())
              : ListView(
                  physics: const BouncingScrollPhysics(),
                  children: [
                    const Gap(14),
                    buildHeader(),
                    const Gap(34),
                    buildGridCoffee(),
                  ],
                ),
        ),
      ),
    );
  }

  Widget buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(
                  Icons.arrow_back_ios,
                  color: warnaKopi2,
                ),
              ),
              const Expanded(
                child: Align(
                  alignment: Alignment.center,
                  child: Text(
                    'Hapus Kopi',
                    style: TextStyle(
                      fontFamily: "poppinsregular",
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: warnaKopi2,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 48),
            ],
          ),
          const Gap(16),
          const Divider(
            color: warnaKopi3,
            height: 1,
            thickness: 4,
          ),
        ],
      ),
    );
  }

  Widget buildGridCoffee() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: GridView.builder(
        itemCount: coffeeList.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisExtent: 238,
          crossAxisSpacing: 15,
          mainAxisSpacing: 24,
        ),
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          final coffee = coffeeList[index];

          return GestureDetector(
            onTap: () {},
            child: Container(
              padding: const EdgeInsets.fromLTRB(8, 8, 8, 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: CachedNetworkImage(
                      imageUrl: coffee['image'],
                      height: 128,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorWidget: (context, url, error) =>
                          const Icon(Icons.error),
                    ),
                  ),
                  const Gap(8),
                  Text(
                    coffee['name'],
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
                    coffee['category'],
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
                        coffee['price'] != null
                            ? NumberFormat.currency(
                                    decimalDigits: 0,
                                    locale: 'id_ID',
                                    symbol: 'Rp')
                                .format(coffee['price'])
                            : '0',
                        style: const TextStyle(
                          fontFamily: "poppinsregular",
                          fontWeight: FontWeight.w600,
                          fontSize: 15,
                          color: warnaKopi2,
                        ),
                      ),
                      Bounceable(
                        onTap: () async {
                          await deleteCoffee(coffee['id'], coffee['name']);
                        },
                        child: Container(
                          height: 32,
                          width: 32,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: warnaKopi3,
                          ),
                          child: const Icon(
                            Icons.delete_forever,
                            color: Colors.white,
                            size: 18,
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
