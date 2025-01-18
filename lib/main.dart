import 'package:flutter/material.dart';
import 'package:uas_mobile2/Frontend/splashcreen.dart';

void main() {
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
