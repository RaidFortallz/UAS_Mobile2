import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:uas_mobile2/Backend/firebase_auth.dart';
import 'package:uas_mobile2/Frontend/PopUp_Dialog/awesome_dialog.dart';
import 'package:uas_mobile2/Warna_Tema/warna_tema.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final FirebaseAuthService _authService = FirebaseAuthService();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isSecurePassword = true;

  void _loginUser() async {
    final username = _usernameController.text.trim();
    final password = _passwordController.text.trim();

    if (username.isEmpty || password.isEmpty) {
      CustomDialog.showDialog(
        context: context,
        dialogType: DialogType.warning,
        title: "Perhatian",
        desc: "Username dan password harus diisi",
      );
      return;
    }

    try {
      final email = await _authService.getEmailByUsername(username);

      if (email == null) {
        if (mounted) {
          CustomDialog.showDialog(
            context: context,
            dialogType: DialogType.error,
            title: "Error",
            desc: "Username belum terdaftar!",
          );
        }
        return;
      }

      await _authService.loginWithEmail(email: email, password: password);

      if (mounted) {
        CustomDialog.showDialog(
            context: context,
            dialogType: DialogType.success,
            title: "Sukses",
            desc: "Login Berhasil",
            btnOkOnPress: () {
              Navigator.pushReplacementNamed(context, '/dashboard');
            });
      }
    } catch (e) {
      if (mounted) {
        CustomDialog.showDialog(
          context: context,
          dialogType: DialogType.error,
          title: "Gagal",
          desc: "Gagal login: $e",
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: ListView(
            children: [
              // Bagian Atas
              Container(
                height: 400,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(70.0),
                    bottomRight: Radius.circular(70.0),
                  ),
                  gradient: LinearGradient(
                    begin: Alignment.topRight,
                    end: Alignment.bottomLeft,
                    colors: [
                      warnaKopi,
                      warnaKopi2,
                    ],
                  ),
                ),
                child: Stack(
                  children: [
                    Positioned(
                      width: 300,
                      height: 300,
                      left: 10,
                      child: Container(
                        decoration: const BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage('assets/image/bg_kopi.png'),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      child: Container(
                        margin: const EdgeInsets.only(top: 280),
                        child: const Center(
                          child: Text(
                            "SELAMAT DATANG",
                            style: TextStyle(
                              fontFamily: "poppinsregular",
                              fontSize: 25,
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // Bagian Form Login
              Padding(
                padding: const EdgeInsets.all(30.0),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: const [
                          BoxShadow(
                            color: warnaKopi,
                            blurRadius: 2.5,
                            offset: Offset(0, 0.1),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          // Input Username
                          Container(
                            padding: const EdgeInsets.all(8.0),
                            decoration: BoxDecoration(
                              border: Border(
                                bottom: BorderSide(
                                  color: Colors.grey[350] ?? Colors.grey,
                                ),
                              ),
                            ),
                            child: TextField(
                              controller: _usernameController,
                              style: const TextStyle(
                                  fontFamily: "poppinsregular", fontSize: 15),
                              textCapitalization: TextCapitalization.none,
                              decoration: InputDecoration(
                                prefixIcon: const Icon(
                                  Icons.person_3_outlined,
                                  color: warnaKopi,
                                ),
                                border: InputBorder.none,
                                hintText: "Username",
                                hintStyle: TextStyle(
                                  fontFamily: "poppinsregular",
                                  color: Colors.grey[400],
                                ),
                              ),
                            ),
                          ),
                          // Input Password
                          Container(
                            padding: const EdgeInsets.all(8.0),
                            child: TextField(
                              controller: _passwordController,
                              obscureText: _isSecurePassword,
                              style: const TextStyle(
                                  fontFamily: "poppinsregular", fontSize: 15),
                              decoration: InputDecoration(
                                prefixIcon: const Icon(
                                  Icons.lock_outline,
                                  color: warnaKopi,
                                ),
                                border: InputBorder.none,
                                hintText: "Password",
                                hintStyle: TextStyle(
                                  fontFamily: "poppinsregular",
                                  color: Colors.grey[400],
                                ),
                                suffixIcon: IconButton(
                                  onPressed: () {
                                    setState(() {
                                      _isSecurePassword = !_isSecurePassword;
                                    });
                                  },
                                  icon: Icon(
                                    _isSecurePassword
                                        ? Icons.visibility_off
                                        : Icons.visibility,
                                    color: warnaKopi,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 30),
                    // Tombol Login
                    Bounceable(
                      onTap: () {
                        _loginUser();
                      },
                      child: Container(
                        margin: const EdgeInsets.only(top: 20),
                        height: 50,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          gradient: const LinearGradient(
                            colors: [
                              warnaKopi,
                              warnaKopi2,
                            ],
                          ),
                        ),
                        child: const Center(
                          child: Text(
                            "Login",
                            style: TextStyle(
                              fontFamily: "poppinsregular",
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 50),
                    // Tombol Daftar
                    Bounceable(
                      onTap: () {
                        Navigator.pushNamed(context,
                            '/register'); // Arahkan ke halaman register
                      },
                      child: const Text(
                        "Belum Punya Akun? REGISTER",
                        style: TextStyle(
                          fontFamily: "poppinsregular",
                          color: warnaKopi,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
