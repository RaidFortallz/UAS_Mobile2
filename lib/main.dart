import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:uas_mobile2/Frontend/Hal_Dashboard/dashboard.dart';
import 'package:uas_mobile2/Frontend/Hal_Dashboard/detail_coffee.dart';
import 'package:uas_mobile2/Frontend/Splashscreen/splashcreen.dart';
import 'package:uas_mobile2/Models/coffee.dart';
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
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xffF9F9F9),
      ),
      home: const Splashcreen(),
      routes: {
        '/dashboard': (context) => const DashboardPage(),
        'detail': (context) {
          Coffee coffee = ModalRoute.of(context)!.settings.arguments as Coffee;
          return DetailCoffee(coffee: coffee);
        }
      },
    );
  }
}
