import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:uas_mobile2/Backend/firebase_auth.dart';
import 'package:uas_mobile2/Frontend/Hal_Dashboard/dashboard.dart';
import 'package:uas_mobile2/Frontend/Hal_Dashboard/detail_coffee.dart';
import 'package:uas_mobile2/Frontend/Hal_Login&Register/login.dart';
import 'package:uas_mobile2/Frontend/Hal_Login&Register/register.dart';
import 'package:uas_mobile2/Frontend/Splashscreen/splashcreen.dart';
import 'package:uas_mobile2/Models/coffee.dart';
import 'package:uas_mobile2/Warna_Tema/warna_tema.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: warnaKopi, statusBarBrightness: Brightness.light));
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return Provider<FirebaseAuthService>(
      create: (context) => FirebaseAuthService(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'UAS Pemrograman Mobile II',
        theme: ThemeData(
          scaffoldBackgroundColor: const Color(0xffF9F9F9),
        ),
        home: const Splashcreen(),
        routes: {
          '/dashboard': (context) => const DashboardPage(),
          '/register': (context) => const Register(),
          '/login': (context) => const Login(),
          '/detail': (context) {
            Coffee coffee =
                ModalRoute.of(context)!.settings.arguments as Coffee;
            return DetailCoffee(coffee: coffee);
          }
        },
      ),
    );
  }
}
