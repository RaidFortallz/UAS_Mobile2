import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uas_mobile2/Backend/Provider/supabase_auth.dart';
import 'package:uas_mobile2/Warna_Tema/warna_tema.dart';

void showEditAddressDialog(BuildContext context, Function updateAddress,
    String currentCity, String currentAddress, String currentPhoneNumber) {
  final TextEditingController cityController =
      TextEditingController(text: currentCity);
  final TextEditingController addressController =
      TextEditingController(text: currentAddress);
  final TextEditingController phoneNumberController =
      TextEditingController(text: currentPhoneNumber);

  AwesomeDialog(
      context: context,
      dialogType: DialogType.info,
      padding: const EdgeInsets.all(12),
      borderSide: const BorderSide(color: Colors.green, width: 2),
      width: 600,
      buttonsBorderRadius: const BorderRadius.all(Radius.circular(2)),
      dismissOnTouchOutside: true,
      dismissOnBackKeyPress: false,
      headerAnimationLoop: false,
      animType: AnimType.bottomSlide,
      title: 'Edit Alamat',
      desc: 'Masukkan alamat baru Anda:',
      body: Column(
        children: [
          TextField(
            controller: cityController,
            style: const TextStyle(
                fontFamily: "poppinsregular", fontSize: 12, color: warnaKopi),
            decoration: const InputDecoration(
              labelText: 'Kota',
            ),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: addressController,
            style: const TextStyle(
                fontFamily: "poppinsregular", fontSize: 12, color: warnaKopi),
            decoration: const InputDecoration(
              labelText: 'Alamat Rumah',
            ),
            maxLines: 5,
            minLines: 1,
          ),
          const SizedBox(height: 10),
          TextField(
            controller: phoneNumberController,
            style: const TextStyle(
                fontFamily: "poppinsregular", fontSize: 12, color: warnaKopi),
            decoration: const InputDecoration(
              labelText: 'Nomor Telepon',
            ),
          ),
        ],
      ),
      btnCancelOnPress: () {},
      btnOkOnPress: () async {
        updateAddress(cityController.text, addressController.text,
            phoneNumberController.text);

        final supabaseAuthService =
            Provider.of<SupabaseAuthService>(context, listen: false);
        final userId = supabaseAuthService.getCurrentUser()?.id;

        if (userId != null) {
          try {
            await supabaseAuthService.updateAddress(
              userId: userId,
              city: cityController.text,
              address: addressController.text,
              phoneNumber: phoneNumberController.text,
            );

            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text(
                    'Alamat Anda berhasil diperbarui',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                  backgroundColor: Colors.green,
                  behavior: SnackBarBehavior.floating,
                  margin: EdgeInsets.only(top: 20, left: 20, right: 20),
                  duration: Duration(seconds: 2),
                ),
              );
            }
          } catch (error) {
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text(
                    'Terjadi Kesalahan',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                  backgroundColor: Colors.red,
                  behavior: SnackBarBehavior.floating,
                  margin: EdgeInsets.only(top: 20, left: 20, right: 20),
                  duration: Duration(seconds: 2),
                ),
              );
            }
          }
        }
      }).show();
}
