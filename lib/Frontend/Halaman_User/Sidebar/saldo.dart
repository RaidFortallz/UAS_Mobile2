import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uas_mobile2/Backend/Provider/saldo_provider.dart';
import 'package:uas_mobile2/Frontend/Halaman_User/Hal_Dashboard/Saldo/isi_saldo.dart';
import 'package:uas_mobile2/Warna_Tema/warna_tema.dart';

class SaldoPage extends StatefulWidget {
  const SaldoPage({super.key});

  @override
  State<SaldoPage> createState() => _SaldoPageState();
}

class _SaldoPageState extends State<SaldoPage> {
  @override
  void initState() {
    super.initState();
    _loadSaldo();
  }

  Future<void> _loadSaldo() async {
    final userId = Supabase.instance.client.auth.currentUser!.id;
    await Provider.of<SaldoProvider>(context, listen: false).fetchSaldo(userId);
  }

  @override
  Widget build(BuildContext context) {
    final saldo = Provider.of<SaldoProvider>(context).saldo;

    final formattedSaldo = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp',
      decimalDigits: 0,
    ).format(saldo);

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
                        size: 100, color: warnaKopi2),
                    const SizedBox(height: 20),
                    Text(
                      'Saldo Anda',
                      style: TextStyle(
                        fontFamily: "poppinsregular",
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
                      formattedSaldo,
                      style: TextStyle(
                        fontFamily: "poppinsregular",
                        fontSize: 25,
                        fontWeight: FontWeight.w600,
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
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const IsiSaldoPage()));
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: warnaKopi2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: const BorderSide(color: warnaKopi2),
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 60, vertical: 15),
                ),
                child: const Text(
                  'Top Up',
                  style: TextStyle(
                    fontFamily: "poppinsregular",
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Tombol Kembali
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: const BorderSide(color: warnaKopi2),
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 60, vertical: 15),
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
            ],
          ),
        ),
      ),
    );
  }
}
