import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uas_mobile2/Backend/Provider/firebase_auth.dart';
import 'package:uas_mobile2/Backend/Provider/supabase_auth.dart';
import 'package:uas_mobile2/Frontend/Hal_Dashboard/dashboard.dart';
import 'package:uas_mobile2/Frontend/Hal_Dashboard/detail_coffee.dart';
import 'package:uas_mobile2/Frontend/Hal_Dashboard/keranjang.dart';
import 'package:uas_mobile2/Frontend/Sidebar/profil.dart';
import 'package:uas_mobile2/Frontend/Sidebar/saldo.dart';
import 'package:uas_mobile2/Frontend/Sidebar/settings.dart';
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

  await Supabase.initialize(
    url: 'https://ppniihvttatatvdmzbeo.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InBwbmlpaHZ0dGF0YXR2ZG16YmVvIiwicm9sZSI6ImFub24iLCJpYXQiOjE3Mzc4ODI4NDAsImV4cCI6MjA1MzQ1ODg0MH0.rtJpnEVuqSN1jcbOgJPXZ3OsGwEngTzaZCk8NGYHj4Y',
  );
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => SupabaseAuthService()),
    ],
    child: const MyApp(),
  ));
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
          '/saldo': (context) => const SaldoPage(),
          '/settings': (context) => const SettingsPage(),
          '/profil': (context) => const ProfilePage(),
          '/detail': (context) {
            Coffee coffee =
                ModalRoute.of(context)!.settings.arguments as Coffee;
            return DetailCoffee(coffee: coffee);
          },
          '/keranjang': (context) {
            Coffee coffee =
                ModalRoute.of(context)!.settings.arguments as Coffee;
            return Keranjang(coffee: coffee);
          }
        },
      ),
    );
  }
}
