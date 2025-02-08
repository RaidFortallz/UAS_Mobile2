import 'package:flutter/material.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:uas_mobile2/Frontend/Halaman_Admin/Hak_Akses/edit_coffee_detail.dart';
import 'package:uas_mobile2/Warna_Tema/warna_tema.dart';

class EditCoffeePage extends StatefulWidget {
  const EditCoffeePage({super.key});

  @override
  State<EditCoffeePage> createState() => _EditCoffeePageState();
}

class _EditCoffeePageState extends State<EditCoffeePage> {
  final SupabaseClient supabase = Supabase.instance.client;
  List<dynamic> coffeeList = [];
  bool isLoading = true;

  var logger = Logger();

  @override
  void initState() {
    super.initState();
    fetchCoffees();
  }

  // Fungsi untuk mengambil semua data kopi
  Future<void> fetchCoffees() async {
    try {
      final response = await supabase.from('coffees').select();
      setState(() {
        coffeeList = response;
        isLoading = false;
      });
    } catch (e) {
      logger.e('Error fetching coffee data: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  // Fungsi untuk menavigasi ke halaman edit kopi berdasarkan ID
  void navigateToEditPage(int coffeeId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditCoffeeDetailPage(
          coffeeId: coffeeId,
          fetchCoffees: fetchCoffees,
        ),
      ),
    );
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

  // Widget untuk membangun Header
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
                    'Edit Kopi',
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

  // Widget untuk menampilkan grid kopi
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

          return Bounceable(
            onTap: () => navigateToEditPage(coffee['id']),
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
                      imageUrl: coffee['image'] ?? '', // Validasi jika null
                      height: 128,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => const Center(
                        child: CircularProgressIndicator(),
                      ),
                      errorWidget: (context, url, error) => const Icon(
                        Icons.image_not_supported,
                        size: 50,
                        color: Colors.grey,
                      ),
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
                  Text(
                    NumberFormat.currency(
                      locale: 'id_ID',
                      symbol: 'Rp',
                      decimalDigits: 0,
                    ).format(coffee['price'] ?? 0),
                    style: const TextStyle(
                      fontFamily: "poppinsregular",
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                      color: warnaKopi2,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
