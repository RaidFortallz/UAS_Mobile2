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
                    color: warnaKopi2,
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Tentang J-WIR COFFEE',
                    style: TextStyle(
                      fontFamily: "poppinsregular",
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: warnaKopi2,
                    ),
                  ),
                  SizedBox(height: 8),
                ],
              ),
            ),
            const SizedBox(height: 10),

            
            _buildCard(
              title: 'Selamat datang di J-WIR Coffee!',
              content:
                  'Di J-WIR COFFEE, kami percaya dalam menyajikan campuran kopi terbaik khas Jawa untuk menciptakan pengalaman sempurna bagi pelanggan kami. '
                  'Apakah Anda di sini untuk sekadar menikmati kopi cepat atau bersantai di sore hari, kami berjanji akan memberikan kualitas dan pelayanan terbaik setiap saat.\n\n',
            ),

            
            _buildCard(
              title: 'Anggota Kelompok',
              content: '''
                1. Ageng Eko Widitya - 2255011082
                2. Hikam Sirrul Arifin - 22552011066
                3. M Dimas Daniswara Putra - 22552011263
                4. Naufal Pratista Sugandhi - 22552011077
              '''.split("\n").map((e) => e.trim()).join("\n"), 
            ),

            
            _buildCard(
              title: 'Hubungi Kami',
              content: '''
              Alamat: Jl. Terbaik No. 69, Bandung, Jawa Barat
              Telepon: +62 877 654 7890
              Email: J-wircoffee@gmail.com
              '''.split("\n").map((e) => e.trim()).join("\n"), 
            ),

            const SizedBox(height: 20),

            // Tombol Kembali
            Center(
              child: ElevatedButton(
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
                    fontFamily: "poppinsregular",
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: warnaKopi2,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  
  Widget _buildCard({required String title, required String content}) {
    return Card(
      elevation: 5,
      margin: const EdgeInsets.symmetric(vertical: 10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontFamily: "poppinsregular",
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              content,
              textAlign: TextAlign.start, 
              style: const TextStyle(
                fontFamily: "poppinsregular",
                fontSize: 16,
                color: Colors.black54,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
