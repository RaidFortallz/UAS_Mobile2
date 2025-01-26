import 'package:flutter/material.dart';
import 'package:uas_mobile2/Warna_Tema/warna_tema.dart';

class SaldoPage extends StatefulWidget {
  const SaldoPage({super.key});

  @override
  State<SaldoPage> createState() => _SaldoPageState();
}

class _SaldoPageState extends State<SaldoPage> {
  
  double saldo = 0.0;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 12,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.account_balance_wallet,
                        size: 100, color: warnaKopi3),
                    const SizedBox(height: 20),
                    Text(
                      'Saldo Anda',
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1.5,
                        color: Colors.black.withOpacity(0.7),
                        shadows: [
                          Shadow(
                            offset: const Offset(2, 2),
                            blurRadius: 4,
                            color: Colors.grey.withOpacity(0.5),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Rp ${saldo.toStringAsFixed(0)}',
                      style: TextStyle(
                        fontSize: 42,
                        fontWeight: FontWeight.bold,
                        color: warnaKopi3,
                        letterSpacing: 1.5,
                        shadows: [
                          Shadow(
                            offset: const Offset(2, 2),
                            blurRadius: 6,
                            color: Colors.grey.withOpacity(0.4),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),
              // Tombol Top Up
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: const BorderSide(color: warnaKopi3),
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 60, vertical: 15),
                ),
                child: const Text(
                  'Top Up',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: warnaKopi3,
                  ),
                ),
              ),
              const SizedBox(height: 20),

              GestureDetector(
                onTap: () {
                  // Riwayat transaksi
                },
                child: const Chip(
                  backgroundColor: warnaKopi2,
                  label: Text(
                    'Riwayat Transaksi',
                    style: TextStyle(color: Colors.white),
                  ),
                  avatar: Icon(
                    Icons.history,
                    color: Colors.white,
                    size: 18,
                  ),
                ),
              ),
              const SizedBox(height: 40),
              // Tombol Kembali
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
                  padding:
                      const EdgeInsets.symmetric(horizontal: 60, vertical: 15),
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
      ),
    );
  }
}
