import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';
import 'package:uas_mobile2/Backend/Provider/saldo_provider.dart';
import 'package:uas_mobile2/Backend/Provider/supabase_auth.dart';
import 'package:uas_mobile2/Frontend/Halaman_User/PopUp_Dialog/awesome_dialog.dart';
import 'package:uas_mobile2/Warna_Tema/warna_tema.dart';
import 'package:intl/intl.dart';

class IsiSaldoPage extends StatefulWidget {
  const IsiSaldoPage({super.key});

  @override
  State<IsiSaldoPage> createState() => _IsiSaldoPageState();
}

class _IsiSaldoPageState extends State<IsiSaldoPage> {
  final TextEditingController _saldoController = TextEditingController();

  void _setSaldo(int amount) {
    final formatCurrency = NumberFormat.decimalPattern('id_ID');
    setState(() {
      _saldoController.text = formatCurrency.format(amount);
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        body: ListView(
          physics: const BouncingScrollPhysics(),
          children: [
            buildHeader(),
            buildBackground(),
            const Gap(30),
            buildButtonBalance(),
            const Gap(60),
            buildButtonOk(),
          ],
        ),
      ),
    );
  }

  Widget buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [warnaKopi, warnaKopi2],
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(
              Icons.arrow_back_ios,
              color: Colors.white,
            ),
          ),
          const Expanded(
            child: Align(
              alignment: Alignment.center,
              child: Text(
                'Isi Saldo',
                style: TextStyle(
                  fontFamily: "poppinsregular",
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          const SizedBox(width: 48),
        ],
      ),
    );
  }

  Widget buildBackground() {
    return Container(
      height: 190,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [warnaKopi, warnaKopi2],
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Saldo yang diinginkan:",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _saldoController,
              keyboardType: TextInputType.number,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                hintText: "Masukkan Jumlah Saldo",
                hintStyle: TextStyle(color: Colors.white70),
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildButtonBalance() {
    return Center(
      child: Wrap(
        alignment: WrapAlignment.center,
        spacing: 20,
        runSpacing: 20,
        children: [
          ElevatedButton(
            onPressed: () => _setSaldo(20000),
            style: buttonStyle(),
            child: const Text("Rp 20.000"),
          ),
          ElevatedButton(
            onPressed: () => _setSaldo(50000),
            style: buttonStyle(),
            child: const Text("Rp 50.000"),
          ),
          ElevatedButton(
            onPressed: () => _setSaldo(100000),
            style: buttonStyle(),
            child: const Text("Rp 100.000"),
          ),
          ElevatedButton(
            onPressed: () => _setSaldo(200000),
            style: buttonStyle(),
            child: const Text("Rp 200.000"),
          ),
          ElevatedButton(
            onPressed: () => _setSaldo(300000),
            style: buttonStyle(),
            child: const Text("Rp 300.000"),
          ),
          ElevatedButton(
            onPressed: () => _setSaldo(400000),
            style: buttonStyle(),
            child: const Text("Rp 400.000"),
          ),
        ],
      ),
    );
  }

  Widget buildButtonOk() {
    return Center(
      child: ElevatedButton(
        onPressed: () async {
          int jumlahSaldo = int.tryParse(
                  _saldoController.text.replaceAll(RegExp(r'[^\d]'), '')) ??
              0;

          if (jumlahSaldo > 0) {
            try {
              Provider.of<SaldoProvider>(context, listen: false)
                  .setSaldo(jumlahSaldo);

              await Provider.of<SupabaseAuthService>(context, listen: false)
                  .isiSaldo(jumlahSaldo: jumlahSaldo);

              if (!mounted) return;
              CustomDialog.showDialog(
                context: context,
                dialogType: DialogType.success,
                animType: AnimType.bottomSlide,
                title: "Berhasil",
                desc: "Saldo berhasil ditambahkan!",
                btnOkOnPress: () {},
              );
            } catch (e) {
              CustomDialog.showDialog(
                context: context,
                dialogType: DialogType.error,
                animType: AnimType.bottomSlide,
                title: "Gagal",
                desc: "Gagal mengisi saldo: $e",
                btnOkOnPress: () {},
              );
            }
          } else {
            CustomDialog.showDialog(
              context: context,
              dialogType: DialogType.warning,
              animType: AnimType.bottomSlide,
              title: "Perhatian",
              desc: "Masukkan jumlah saldo yang valid!",
              btnOkOnPress: () {},
            );
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: warnaKopi2,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          minimumSize: const Size(150, 50),
        ),
        child: const Text("OK"),
      ),
    );
  }

  ButtonStyle buttonStyle() {
    return ElevatedButton.styleFrom(
      backgroundColor: Colors.white,
      foregroundColor: warnaKopi2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
        side: const BorderSide(color: warnaKopi2, width: 1),
      ),
      minimumSize: const Size(150, 50),
    );
  }
}
