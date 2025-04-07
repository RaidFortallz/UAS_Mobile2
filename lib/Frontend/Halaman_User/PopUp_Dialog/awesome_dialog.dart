import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:uas_mobile2/Warna_Tema/warna_tema.dart';

class CustomDialog {
  static void showDialog({
    required BuildContext context,
    required DialogType dialogType,
    required String title,
    required String desc,
    AnimType? animType,
    VoidCallback? btnOkOnPress,
  }) {
    FocusScope.of(context).unfocus();

    AwesomeDialog(
      context: context,
      dialogType: dialogType,
      animType: animType ?? AnimType.scale,
      title: title,
      desc: desc,
      btnOkOnPress: btnOkOnPress != null
          ? () {
              btnOkOnPress();
              FocusScope.of(context).requestFocus(FocusNode());
            }
          : () {
              FocusScope.of(context).requestFocus(FocusNode());
            },
      btnOkColor: warnaKopi2,
      headerAnimationLoop: true,
      padding: const EdgeInsets.all(16.0),
      dialogBorderRadius: BorderRadius.circular(10),
      titleTextStyle: const TextStyle(
        fontFamily: "poppinsregular",
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: warnaHitam2,
      ),
      descTextStyle: const TextStyle(
        fontFamily: "poppinsregular",
        fontSize: 15,
        color: warnaHitam2,
      ),
    ).show();
  }
}
