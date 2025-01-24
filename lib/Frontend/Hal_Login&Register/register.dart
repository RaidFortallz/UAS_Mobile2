import 'package:flutter/material.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:uas_mobile2/Backend/firebase_auth.dart';
import 'package:uas_mobile2/Warna_Tema/warna_tema.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final FirebaseAuthService _authService = FirebaseAuthService();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isSecurePassword = true;

  void _registerUser() async {
    final username = _usernameController.text.trim();
    final email = _emailController.text.trim();
    final phoneNumber = _phoneController.text.trim();
    final password = _passwordController.text.trim();

    if (username.isEmpty ||
        email.isEmpty ||
        phoneNumber.isEmpty ||
        password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Semua kolom harus diisi!")),
      );
      return;
    }

    try {
      await _authService.registerUser(
        username: username,
        email: email,
        password: password,
        phoneNumber: phoneNumber,
      );
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Berhasil daftar!")),
        );
        Navigator.pushReplacementNamed(context, '/login');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Gagal daftar: $e")),
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
                height: 280,
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
                      width: 210,
                      height: 210,
                      left: 90,
                      top: 20,
                      child: Container(
                        decoration: const BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage('assets/image/bg_kopi3.png'),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      child: Container(
                        margin: const EdgeInsets.only(top: 200),
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
              // Bagian Form Register
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
                              style:
                                  const TextStyle(fontFamily: "poppinsregular"),
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
                          // Input Email
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
                              controller: _emailController,
                              style:
                                  const TextStyle(fontFamily: "poppinsregular"),
                              textCapitalization: TextCapitalization.none,
                              decoration: InputDecoration(
                                prefixIcon: const Icon(
                                  Icons.email_outlined,
                                  color: warnaKopi,
                                ),
                                border: InputBorder.none,
                                hintText: "Email",
                                hintStyle: TextStyle(
                                  fontFamily: "poppinsregular",
                                  color: Colors.grey[400],
                                ),
                              ),
                            ),
                          ),
                          // Input Phone Number
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
                              controller: _phoneController,
                              keyboardType: TextInputType.phone,
                              style:
                                  const TextStyle(fontFamily: "poppinsregular"),
                              decoration: InputDecoration(
                                prefixIcon: const Icon(
                                  Icons.phone_android_outlined,
                                  color: warnaKopi,
                                ),
                                border: InputBorder.none,
                                hintText: "Nomor HP",
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
                              style:
                                  const TextStyle(fontFamily: "poppinsregular"),
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
                    // Tombol Register
                    Bounceable(
                      onTap: _registerUser,
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
                    // Tombol Kembali
                    Bounceable(
                      onTap: () {
                        Navigator.pushNamed(context, '/login');
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

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    required IconData icon,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: const Color(0xffF9F9F9),
      ),
      child: TextField(
        controller: controller,
        style: const TextStyle(fontFamily: "poppinsregular"),
        decoration: InputDecoration(
          border: InputBorder.none,
          prefixIcon: Icon(icon, color: warnaKopi),
          hintText: hintText,
          hintStyle: const TextStyle(
            fontFamily: "poppinsregular",
            color: Colors.grey,
          ),
        ),
      ),
    );
  }

  Widget _buildPasswordField({
    required TextEditingController controller,
    required String hintText,
    required bool isSecure,
    required VoidCallback toggleSecure,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: const Color(0xffF9F9F9),
      ),
      child: TextField(
        controller: controller,
        obscureText: isSecure,
        style: const TextStyle(fontFamily: "poppinsregular"),
        decoration: InputDecoration(
          border: InputBorder.none,
          prefixIcon: const Icon(Icons.lock_outlined, color: warnaKopi),
          hintText: hintText,
          hintStyle: const TextStyle(
            fontFamily: "poppinsregular",
            color: Colors.grey,
          ),
          suffixIcon: IconButton(
            onPressed: toggleSecure,
            icon: Icon(
              isSecure ? Icons.visibility_off : Icons.visibility,
              color: warnaKopi,
            ),
          ),
        ),
      ),
    );
  }
}
