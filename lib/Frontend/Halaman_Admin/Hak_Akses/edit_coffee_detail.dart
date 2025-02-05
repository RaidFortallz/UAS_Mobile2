import 'package:flutter/material.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:gap/gap.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:uas_mobile2/Warna_Tema/warna_tema.dart';

class EditCoffeeDetailPage extends StatefulWidget {
  final int coffeeId;
  final Function fetchCoffees;

  const EditCoffeeDetailPage(
      {super.key, required this.coffeeId, required this.fetchCoffees});

  @override
  State<EditCoffeeDetailPage> createState() => _EditCoffeeDetailPageState();
}

class _EditCoffeeDetailPageState extends State<EditCoffeeDetailPage> {
  final SupabaseClient supabase = Supabase.instance.client;
  Map<String, dynamic> coffeeData = {};
  bool isLoading = true;

  final TextEditingController nameController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController categoryController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchCoffeeDetails();
  }

  // Fungsi untuk mengambil data kopi berdasarkan ID
  Future<void> fetchCoffeeDetails() async {
    try {
      final response = await supabase
          .from('coffees')
          .select()
          .eq('id', widget.coffeeId)
          .single();
      setState(() {
        coffeeData = response;
        isLoading = false;
        nameController.text = coffeeData['name'];
        priceController.text = coffeeData['price'].toString();
        categoryController.text = coffeeData['category'];
      });
    } catch (e) {
      print('Error fetching coffee data: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  // Fungsi untuk mengupdate data kopi
  Future<void> updateCoffee() async {
    int? price = int.tryParse(priceController.text);
    if (price == null || price <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Harga kopi tidak valid!',
              style: TextStyle(fontSize: 12, color: Colors.white)),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 1),
        ),
      );
      return;
    }

    try {
      final response = await supabase
          .from('coffees')
          .update({
            'name': nameController.text,
            'price': price,
            'category': categoryController.text,
          })
          .eq('id', widget.coffeeId)
          .select();

      // Cek apakah terdapat error pada response Supabase
      if (response.isEmpty) {
        throw Exception('Failed to update coffee');
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Kopi ${nameController.text} berhasil diperbarui',
              style: const TextStyle(fontSize: 12, color: Colors.white)),
          backgroundColor: warnaKopi2,
          duration: const Duration(seconds: 1),
        ),
      );

      // Panggil fungsi fetchCoffees untuk memperbarui data di halaman utama
      widget.fetchCoffees();
      Navigator.pop(context);
    } catch (e) {
      print('Error updating coffee: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Terjadi kesalahan saat memperbarui kopi: $e',
              style: const TextStyle(fontSize: 12, color: Colors.white)),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 1),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Edit Kopi',
                style: TextStyle(
                    fontFamily: "poppinsregular",
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: warnaKopi2)),
            leading: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.arrow_back_ios, color: warnaKopi2),
            ),
          ),
          body: isLoading
              ? const Center(child: CircularProgressIndicator())
              : Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: ListView(
                    physics: const BouncingScrollPhysics(),
                    children: [
                      const Gap(14),
                      buildCoffeeImage(),
                      const Gap(24),
                      buildInputFields(),
                      const Gap(32),
                      buildUpdateButton(),
                    ],
                  ),
                ),
        ),
      ),
    );
  }

  // Widget untuk menampilkan gambar kopi
  Widget buildCoffeeImage() {
    return coffeeData.isEmpty
        ? const Center(child: CircularProgressIndicator())
        : ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: CachedNetworkImage(
              imageUrl: coffeeData['image'],
              height: 200,
              width: double.infinity,
              fit: BoxFit.cover,
              errorWidget: (context, url, error) => const Icon(Icons.error),
            ),
          );
  }

  // Widget untuk input fields
  Widget buildInputFields() {
    return coffeeData.isEmpty
        ? const Center(child: CircularProgressIndicator())
        : Column(
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'Nama Kopi',
                  labelStyle: TextStyle(
                      fontFamily: "poppinsregular",
                      fontSize: 14,
                      color: warnaAbu),
                  border: OutlineInputBorder(),
                ),
              ),
              const Gap(16),
              TextField(
                controller: priceController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Harga Kopi',
                  labelStyle: TextStyle(
                      fontFamily: "poppinsregular",
                      fontSize: 14,
                      color: warnaAbu),
                  border: OutlineInputBorder(),
                ),
              ),
              const Gap(16),
              TextField(
                controller: categoryController,
                decoration: const InputDecoration(
                  labelText: 'Kategori Kopi',
                  labelStyle: TextStyle(
                      fontFamily: "poppinsregular",
                      fontSize: 14,
                      color: warnaAbu),
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          );
  }

  // Widget untuk tombol update
  Widget buildUpdateButton() {
    return Bounceable(
      onTap: () => updateCoffee(),
      child: Container(
        height: 50,
        decoration: BoxDecoration(
          color: warnaKopi2,
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Center(
          child: Text(
            'Perbarui Kopi',
            style: TextStyle(
                fontFamily: "poppinsregular",
                fontWeight: FontWeight.w600,
                fontSize: 16,
                color: Colors.white),
          ),
        ),
      ),
    );
  }
}
