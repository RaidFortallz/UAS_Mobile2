import 'package:flutter/material.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:uas_mobile2/Warna_Tema/warna_tema.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  bool _isSecurePassword = true;
  bool _isSecureConfirmPassword = true;

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
                            "DAFTAR AKUN",
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
                          // Input Nama Lengkap
                          buildTextField(
                            hintText: "Nama Lengkap",
                            icon: Icons.person,
                            obscureText: false,
                          ),
                          // Input Email
                          buildTextField(
                            hintText: "Email",
                            icon: Icons.email,
                            obscureText: false,
                          ),
                          // Input Password
                          buildTextField(
                            hintText: "Password",
                            icon: Icons.lock,
                            obscureText: _isSecurePassword,
                            toggle: () => setState(() {
                              _isSecurePassword = !_isSecurePassword;
                            }),
                          ),
                          // Input Konfirmasi Password
                          buildTextField(
                            hintText: "Konfirmasi Password",
                            icon: Icons.lock,
                            obscureText: _isSecureConfirmPassword,
                            toggle: () => setState(() {
                              _isSecureConfirmPassword = !_isSecureConfirmPassword;
                            }),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 30),
                    Bounceable(
                      onTap: () {
                        // Logika untuk tombol register
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
                            "Daftar",
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
                    Bounceable(
                      onTap: () {
                        // Navigasi ke halaman Login
                        Navigator.pop(context); // Kembali ke halaman Login
                      },
                      child: const Text(
                        "Sudah Punya Akun? LOGIN",
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

  Widget buildTextField({
    required String hintText,
    required IconData icon,
    required bool obscureText,
    VoidCallback? toggle,
  }) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Colors.grey[350] ?? Colors.grey,
          ),
        ),
      ),
      child: TextField(
        obscureText: obscureText,
        style: const TextStyle(fontFamily: "poppinsregular"),
        decoration: InputDecoration(
          prefixIcon: Icon(
            icon,
            color: warnaKopi,
          ),
          suffixIcon: toggle != null
              ? IconButton(
                  onPressed: toggle,
                  icon: Icon(
                    obscureText ? Icons.visibility_off : Icons.visibility,
                    color: warnaKopi,
                  ),
                )
              : null,
          border: InputBorder.none,
          hintText: hintText,
          hintStyle: TextStyle(
            fontFamily: "poppinsregular",
            color: Colors.grey[400],
          ),
        ),
      ),
    );
  }
}
