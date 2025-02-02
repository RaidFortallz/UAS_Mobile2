import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uas_mobile2/Backend/Provider/cart_provider.dart';
import 'package:uas_mobile2/Backend/Provider/coffee_service.dart';
import 'package:uas_mobile2/Backend/Provider/saldo_provider.dart';
import 'package:uas_mobile2/Backend/Provider/search_provider.dart';
import 'package:uas_mobile2/Backend/Provider/supabase_auth.dart';
import 'package:uas_mobile2/Frontend/Halaman_Admin/Hal_DashboardAdmin/dashboard_admin.dart';
import 'package:uas_mobile2/Frontend/Halaman_User/Hal_Dashboard/dashboard.dart';
import 'package:uas_mobile2/Frontend/Halaman_User/Hal_Dashboard/detail_coffee.dart';
import 'package:uas_mobile2/Frontend/Halaman_User/Sidebar/profile.dart';
import 'package:uas_mobile2/Frontend/Halaman_User/Sidebar/saldo.dart';
import 'package:uas_mobile2/Frontend/Halaman_User/Sidebar/settings.dart';
import 'package:uas_mobile2/Frontend/Halaman_User/Hal_Login&Register/login.dart';
import 'package:uas_mobile2/Frontend/Halaman_User/Hal_Login&Register/register.dart';
import 'package:uas_mobile2/Frontend/Splashscreen/splashcreen.dart';
import 'package:uas_mobile2/Models/coffee_model.dart';
import 'package:uas_mobile2/Warna_Tema/warna_tema.dart';
import 'package:uas_mobile2/Backend/Provider/favorite_provider.dart';

void main() async {
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: warnaKopi, statusBarBrightness: Brightness.light));
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://ppniihvttatatvdmzbeo.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InBwbmlpaHZ0dGF0YXR2ZG16YmVvIiwicm9sZSI6ImFub24iLCJpYXQiOjE3Mzc4ODI4NDAsImV4cCI6MjA1MzQ1ODg0MH0.rtJpnEVuqSN1jcbOgJPXZ3OsGwEngTzaZCk8NGYHj4Y',
  );

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => SupabaseAuthService()),
      ChangeNotifierProvider(create: (_) => CoffeeService()),
      ChangeNotifierProvider(create: (_) => CartProvider()),
      ChangeNotifierProvider(create: (_) => FavoriteProvider()),
      ChangeNotifierProvider(create: (_) => SearchProvider()),
      ChangeNotifierProvider(create: (_) => SaldoProvider()),
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
    return AnnotatedRegion(
      value: const SystemUiOverlayStyle(
        statusBarColor: warnaKopi2,
        statusBarIconBrightness: Brightness.light,
      ),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'UAS Pemrograman Mobile II',
        theme: ThemeData(
          scaffoldBackgroundColor: const Color(0xffF9F9F9),
        ),
        home: const Splashcreen(),
        routes: {
          '/dashboard': (context) => const DashboardPage(),
          '/dashboard_admin': (context) => const DashboardAdminPage(),
          '/register': (context) => const Register(),
          '/login': (context) => const Login(),
          '/saldo': (context) => const SaldoPage(),
          '/settings': (context) => const SettingsPage(),
          '/profil': (context) => const ProfilePage(),
          '/detail': (context) {
            Coffees coffee =
                ModalRoute.of(context)!.settings.arguments as Coffees;
            return DetailCoffee(coffee: coffee);
          },
        },
      ),
    );
  }
}
