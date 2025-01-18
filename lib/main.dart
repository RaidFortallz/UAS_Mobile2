import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:uas_mobile2/Frontend/splashcreen.dart';
import 'package:uas_mobile2/Warna_Tema/warna_tema.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: warnaKopi,
      statusBarBrightness: Brightness.light
    ));
  runApp(const MyApp());
  
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'UAS Pemrograman Mobile II',
      theme: ThemeData(),
      home: const Splashcreen(),
    );
  }
}
