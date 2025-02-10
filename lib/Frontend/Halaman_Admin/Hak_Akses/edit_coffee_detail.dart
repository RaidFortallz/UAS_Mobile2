import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:gap/gap.dart';
import 'package:image_picker/image_picker.dart';
import 'package:logger/logger.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:uas_mobile2/Warna_Tema/warna_tema.dart';
import 'package:uuid/uuid.dart';

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
  File? coffeeImage;
  String? coffeeImageUrl;

  var logger = Logger();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController categoryController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

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
        descriptionController.text = coffeeData['description'];
        coffeeImageUrl = coffeeData['image'];
      });
    } catch (e) {
      logger.e('Error fetching coffee data: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  // Fungsi untuk memilih gambar dari galeri
  Future<void> pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        coffeeImage = File(pickedFile.path);
      });
    }
  }

  Future<String?> uploadCoffeeImage(File imageFile) async {
  try {
    // Gunakan UUID sebagai nama file
    final fileName = 'images_coffee/${const Uuid().v4()}.jpg';

    
    if (!imageFile.existsSync()) {
      throw Exception("File gambar tidak ditemukan di perangkat.");
    }

    
    await supabase.storage.from('images_coffee').upload(fileName, imageFile);

    
    final imageUrl = supabase.storage.from('images_coffee').getPublicUrl(fileName);

    if (imageUrl.isEmpty) {
      throw Exception("Gagal mendapatkan URL gambar dari Supabase.");
    }

    logger.i("✅ Gambar berhasil diunggah: $imageUrl");
    return imageUrl;
  } catch (e) {
    logger.e('❌ Error uploading coffee image: $e');
    return null;
  }
}


  // Fungsi untuk mengupdate data kopi, termasuk gambar
  Future<void> updateCoffee() async {
  int? price = int.tryParse(priceController.text);
  if (price == null || price <= 0) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Harga kopi tidak valid!', style: TextStyle(fontSize: 12, color: Colors.white)),
        backgroundColor: Colors.red,
        duration: Duration(seconds: 1),
      ),
    );
    return;
  }

  String? newImageUrl = coffeeImageUrl;

  
  if (coffeeImage != null) {
    logger.i("Mengunggah gambar baru...");
    final uploadedUrl = await uploadCoffeeImage(coffeeImage!);

    if (uploadedUrl != null && uploadedUrl.isNotEmpty) {
      logger.i("Gambar baru berhasil diunggah: $uploadedUrl");
      newImageUrl = uploadedUrl;
    } else {
      logger.e("Gagal mengunggah gambar, tetap menggunakan gambar lama.");
    }
  } else {
    logger.w("Tidak ada gambar baru yang dipilih.");
  }

  try {
    logger.i("📡 Mengupdate data kopi di database...");
    final response = await supabase.from('coffees').update({
      'name': nameController.text,
      'price': price,
      'category': categoryController.text,
      'description': descriptionController.text,
      'image': newImageUrl, 
    }).eq('id', widget.coffeeId).select();

    if (response.isEmpty) {
      throw Exception('Gagal memperbarui kopi di database.');
    }

    if (!mounted) return;

    logger.i("Kopi berhasil diperbarui di database.");

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Kopi ${nameController.text} berhasil diperbarui', style: const TextStyle(fontSize: 12, color: Colors.white)),
        backgroundColor: warnaKopi2,
        duration: const Duration(seconds: 1),
      ),
    );

    widget.fetchCoffees();
    Navigator.pop(context);
  } catch (e) {
    logger.e('Error memperbarui kopi: $e');

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Terjadi kesalahan saat memperbarui kopi: $e', style: const TextStyle(fontSize: 12, color: Colors.white)),
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
    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: coffeeImage != null
              ? Image.file(coffeeImage!,
                  height: 200, width: double.infinity, fit: BoxFit.cover)
              : CachedNetworkImage(
                  imageUrl: coffeeImageUrl ?? '',
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                ),
        ),
        Positioned(
          bottom: 10,
          right: 10,
          child: IconButton(
            icon: const Icon(
              Icons.add_a_photo,
              color: Colors.white,
              size: 40,
            ),
            onPressed: pickImage,
          ),
        ),
      ],
    );
  }

  // Widget untuk input fields
  Widget buildInputFields() {
    List<String> coffeeCategories = [
      "Espresso",
      "Machiato",
      "Latte",
      "Cappuccino",
      "Mocha"
    ];

    return coffeeData.isEmpty
        ? const Center(child: CircularProgressIndicator())
        : Column(
            children: [
              // Input Nama Kopi
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'Nama Kopi',
                  labelStyle: TextStyle(
                    fontFamily: "poppinsregular",
                    fontSize: 14,
                    color: warnaAbu,
                  ),
                  border: OutlineInputBorder(),
                ),
              ),
              const Gap(16),

              // Input Harga Kopi
              TextField(
                controller: priceController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Harga Kopi',
                  labelStyle: TextStyle(
                    fontFamily: "poppinsregular",
                    fontSize: 14,
                    color: warnaAbu,
                  ),
                  border: OutlineInputBorder(),
                ),
              ),
              const Gap(16),

              // Input Deskripsi Kopi
              TextField(
                controller:
                    TextEditingController(text: coffeeData['description']),
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'Deskripsi Kopi',
                  labelStyle: TextStyle(
                    fontFamily: "poppinsregular",
                    fontSize: 14,
                    color: warnaAbu,
                  ),
                  border: OutlineInputBorder(),
                ),
              ),
              const Gap(16),

              // Dropdown Kategori Kopi dengan ukuran lebih kecil
              SizedBox(
                width: double.infinity, // Lebar mengikuti parent
                child: DropdownButtonFormField<String>(
                  value: coffeeCategories.contains(categoryController.text)
                      ? categoryController.text
                      : null, // Default kategori dari database
                  decoration: const InputDecoration(
                    labelText: 'Kategori Kopi',
                    labelStyle: TextStyle(
                      fontFamily: "poppinsregular",
                      fontSize: 14,
                      color: warnaAbu,
                    ),
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(
                        vertical: 12, horizontal: 16), // Padding lebih kecil
                  ),
                  items: coffeeCategories.map((String category) {
                    return DropdownMenuItem<String>(
                      value: category,
                      child: Text(
                        category,
                        style: const TextStyle(
                          fontFamily: "poppinsregular",
                          fontSize: 14,
                        ),
                      ),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    if (newValue != null) {
                      setState(() {
                        categoryController.text = newValue;
                      });
                    }
                  },
                  menuMaxHeight:
                      250, // Membatasi tinggi dropdown agar tidak terlalu panjang
                  dropdownColor: Colors.white, // Warna dropdown
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
