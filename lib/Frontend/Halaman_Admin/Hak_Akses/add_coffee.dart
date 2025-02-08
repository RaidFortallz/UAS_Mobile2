import 'dart:io';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:gap/gap.dart';
import 'package:image_picker/image_picker.dart';
import 'package:logger/logger.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uas_mobile2/Frontend/Halaman_User/PopUp_Dialog/awesome_dialog.dart';
import 'package:uas_mobile2/Warna_Tema/warna_tema.dart';

class AddCoffeePage extends StatefulWidget {
  const AddCoffeePage({super.key});

  @override
  State<AddCoffeePage> createState() => _AddCoffeePageState();
}

class _AddCoffeePageState extends State<AddCoffeePage> {
  final SupabaseClient supabase = Supabase.instance.client;
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();

  File? _image;
  String _category = 'Espresso';
  bool isLoading = false;

  var logger = Logger();

  final List<String> categories = [
    'Espresso',
    'Machiato',
    'Latte',
    'Cappuccino',
    'Mocha',
  ];

  // Fungsi untuk memilih gambar dari galeri
  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final XFile? pickedFile =
        await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  // Fungsi untuk mengunggah gambar ke Supabase Storage
  Future<String?> _uploadCoffeeImage(File imageFile, int coffeeId) async {
    try {
      final fileName = 'images_coffee/$coffeeId.jpg';

      // Hapus gambar lama jika ada
      await supabase.storage.from('images_coffee').remove([fileName]);

      // Upload gambar baru
      await supabase.storage.from('images_coffee').upload(fileName, imageFile);

      // Ambil URL publik gambar
      final imageUrl =
          supabase.storage.from('images_coffee').getPublicUrl(fileName);
      return imageUrl;
    } catch (e) {
      logger.e('Error uploading coffee image: $e');
      return null;
    }
  }

  // Fungsi untuk menambahkan kopi ke database
  Future<void> _addCoffee() async {
    if (!_formKey.currentState!.validate()) return;

    // Validasi apakah gambar sudah dipilih
    if (_image == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Silakan pilih gambar terlebih dahulu!',
            style: TextStyle(fontSize: 12, color: Colors.white),
          ),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 1),
        ),
      );
      return;
    }

    SystemChannels.textInput.invokeMethod('TextInput.hide');
    FocusScope.of(context).unfocus();

    int? price = int.tryParse(_priceController.text);
    if (price == null || price <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Harga kopi tidak valid!',
            style: TextStyle(fontSize: 12, color: Colors.white),
          ),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 1),
        ),
      );
      return;
    }

    try {
      setState(() {
        isLoading = true;
      });

      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      );

      // Tambahkan data kopi ke Supabase tanpa gambar dulu untuk mendapatkan ID
      final response = await supabase.from('coffees').insert({
        'name': _nameController.text,
        'description': _descriptionController.text,
        'price': price,
        'category': _category,
        'rate': 1.1,
        'review': 0,
      }).select();

      if (response.isEmpty) {
        throw Exception('Gagal menambahkan kopi.');
      }

      final coffeeId = response[0]['id'];

      // Upload gambar ke storage
      String? imageUrl = await _uploadCoffeeImage(_image!, coffeeId);

      if (imageUrl != null) {
        await supabase.from('coffees').update({
          'image': imageUrl,
        }).eq('id', coffeeId);
      }

      if (!mounted) return;
      Navigator.pop(context);

      CustomDialog.showDialog(
        context: context,
        dialogType: DialogType.success,
        title: "Sukses",
        desc: "Kopi berhasil ditambahkan",
        btnOkOnPress: () {
          if (context.mounted) {
            Navigator.pop(context);
          }
        },
      );
    } catch (e) {
      logger.e('Error adding coffee: $e');

      if (context.mounted) {
        Navigator.pop(context);

        CustomDialog.showDialog(
          context: context,
          dialogType: DialogType.error,
          title: "Error",
          desc: "Gagal menambahkan kopi!",
          btnOkOnPress: () {},
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
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
        body: ListView(
          physics: const BouncingScrollPhysics(),
          children: [
            const Gap(14),
            buildHeader(),
            const Gap(34),
            buildListData(),
          ],
        ),
      ),
    ));
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
                    'Tambah Kopi',
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

  Widget buildListData() {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: 'Nama Kopi',
                    labelStyle: const TextStyle(fontFamily: "poppinsregular"),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14.0),
                      borderSide: const BorderSide(
                        color: warnaKopi,
                        width: 4.0,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14.0),
                      borderSide: const BorderSide(
                        color: warnaKopi2,
                        width: 2,
                      ),
                    ),
                    floatingLabelStyle: const TextStyle(
                      color: warnaKopi3,
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Nama kopi tidak boleh kosong';
                    }
                    return null;
                  },
                ),
                const Gap(20),
                // Dropdown untuk memilih kategori kopi
                IntrinsicHeight(
                  child: DropdownButtonFormField<String>(
                    value: _category,
                    onChanged: (String? newValue) {
                      setState(() {
                        _category = newValue!;
                      });
                    },
                    items: categories.map((String category) {
                      return DropdownMenuItem<String>(
                        value: category,
                        child: Text(
                          category,
                          style: const TextStyle(fontFamily: "poppinsregular"),
                        ),
                      );
                    }).toList(),
                    decoration: InputDecoration(
                      labelText: 'Kategori Kopi',
                      labelStyle: const TextStyle(fontFamily: "poppinsregular"),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14.0),
                        borderSide: const BorderSide(
                          color: warnaKopi,
                          width: 4.0,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14.0),
                        borderSide: const BorderSide(
                          color: warnaKopi2,
                          width: 2,
                        ),
                      ),
                      floatingLabelStyle: const TextStyle(
                        color: warnaKopi3,
                      ),
                    ),
                    isDense: true,
                  ),
                ),
                const Gap(20),
                TextFormField(
                  controller: _descriptionController,
                  maxLines: 3,
                  decoration: InputDecoration(
                    labelText: 'Deskripsi Kopi',
                    labelStyle: const TextStyle(fontFamily: "poppinsregular"),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14.0),
                      borderSide: const BorderSide(
                        color: warnaKopi,
                        width: 4.0,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14.0),
                      borderSide: const BorderSide(
                        color: warnaKopi2,
                        width: 2,
                      ),
                    ),
                    floatingLabelStyle: const TextStyle(
                      color: warnaKopi3,
                    ),
                  ),
                ),
                const Gap(20),
                TextFormField(
                  controller: _priceController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Harga Kopi',
                    labelStyle: const TextStyle(fontFamily: "poppinsregular"),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14.0),
                      borderSide: const BorderSide(
                        color: warnaKopi,
                        width: 4.0,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14.0),
                      borderSide: const BorderSide(
                        color: warnaKopi2,
                        width: 2,
                      ),
                    ),
                    floatingLabelStyle: const TextStyle(
                      color: warnaKopi3,
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Harga kopi tidak boleh kosong!';
                    }
                    return null;
                  },
                ),
                const Gap(20),
                Bounceable(
                  onTap: _pickImage,
                  child: Container(
                    height: 150,
                    color: Colors.grey[300],
                    child: _image == null
                        ? const Center(
                            child: Text(
                            'Pilih Gambar',
                            style: TextStyle(
                                fontFamily: "poppinsregular",
                                color: warnaKopi,
                                fontWeight: FontWeight.w600),
                          ))
                        : Image.file(
                            File(_image!.path),
                            fit: BoxFit.cover,
                          ),
                  ),
                ),
                const Gap(26),
                const Divider(
                  color: warnaKopi3,
                  height: 1,
                  thickness: 4,
                ),
                const Gap(37),
                ElevatedButton(
                  onPressed: isLoading ? null : _addCoffee,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: warnaKopi2,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 30, vertical: 14),
                  ),
                  child: isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                          'Tambah Kopi',
                          style: TextStyle(
                              fontFamily: "poppinsregular",
                              color: Colors.white,
                              fontWeight: FontWeight.w600),
                        ),
                ),
              ],
            ),
          ),
        ));
  }
}
