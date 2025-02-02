import 'package:flutter/material.dart';
import 'package:uas_mobile2/Warna_Tema/warna_tema.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          children: [
            // Header
            const Center(
              child: Column(
                children: [
                  Icon(
                    Icons.coffee,
                    size: 80,
                    color: warnaKopi3,
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Tentang J-WIR COFFEE',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: warnaKopi3,
                    ),
                  ),
                  SizedBox(height: 8),
                ],
              ),
            ),
            const SizedBox(height: 40),

            // Deskripsi Kedai Kopi
            Card(
              elevation: 5,
              margin: const EdgeInsets.symmetric(vertical: 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Selamat datang di J_WIR Coffee!',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Di J_WIR COFFEE, kami percaya dalam menyajikan campuran kopi terbaik khas jawa untuk menciptakan pengalaman sempurna bagi pelanggan kami. Apakah Anda di sini untuk sekadar menikmati kopi cepat atau bersantai di sore hari, kami berjanji akan memberikan kualitas dan pelayanan terbaik setiap saat.',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black54,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Kopi kami diperoleh dari produsen lokal terbaik, dan kami menawarkan berbagai macam minuman mulai dari espresso hingga latte yang lembut. Kunjungi kami dan nikmati kehangatan kopi yang lezat!',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 40),

            // Informasi Kontak
            Card(
              elevation: 5,
              margin: const EdgeInsets.symmetric(vertical: 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Hubungi Kami',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Alamat: Jl.terbaik no.69, Bandung, jawa Barat\nTelepon: +6287 7654 7890\nEmail: J-wircoffee@gmail.com',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 40),

            // Tombol kembali
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: const BorderSide(color: warnaKopi3),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 80,
                  vertical: 15,
                ),
              ),
              child: const Text(
                'Kembali',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: warnaKopi3,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
