import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:uas_mobile2/Backend/Provider/supabase_auth.dart';
import 'package:uas_mobile2/Frontend/Halaman_User/Hal_Login&Register/Kriptografi/login_eddsa.dart';
import 'package:uas_mobile2/Frontend/Halaman_User/PopUp_Dialog/awesome_dialog.dart';
import 'package:uas_mobile2/Warna_Tema/warna_tema.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> with TickerProviderStateMixin {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isSecurePassword = true;
  int _currentPage = 1;

  final PageController _pageController = PageController(initialPage: 1);

  var logger = Logger();

  void _loginUser() async {
    final authService =
        Provider.of<SupabaseAuthService>(context, listen: false);
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
      final email = await authService.getEmailByUsername(username);

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

      await authService.loginWithEmail(email: email, password: password);

      final adminData = await authService.getAdminUser();
      logger.d("Admin Data: $adminData");
      if (adminData != null && adminData['is_admin'] == true) {
        // Arahkan ke dashboard admin
        if (mounted) {
          CustomDialog.showDialog(
            context: context,
            dialogType: DialogType.success,
            title: "Sukses",
            desc: "Login Berhasil sebagai Admin",
            btnOkOnPress: () {
              Navigator.pushReplacementNamed(context, '/dashboard_admin');
            },
          );
        }
      } else {
        // Arahkan ke dashboard pengguna biasa
        if (mounted) {
          CustomDialog.showDialog(
            context: context,
            dialogType: DialogType.success,
            title: "Sukses",
            desc: "Login Berhasil",
            btnOkOnPress: () {
              Navigator.pushReplacementNamed(context, '/dashboard');
            },
          );
        }
      }
    } catch (e) {
      if (mounted) {
        CustomDialog.showDialog(
          context: context,
          dialogType: DialogType.error,
          title: "Gagal",
          desc: "Username atau Password Salah",
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

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
                      left: 7,
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
                    // Form Login (Username + Password)
                    Container(
                      padding: const EdgeInsets.all(5),
                      decoration: _formBoxDecoration(),
                      child: AnimatedSize(
                        duration: const Duration(milliseconds: 500),
                        curve: Curves.easeInOut,
                        alignment: Alignment.topCenter,
                        child: Column(
                          children: [
                            _buildUsernameTextField(),
                            AnimatedSwitcher(
                              duration: const Duration(milliseconds: 400),
                              switchInCurve: Curves.easeInOut,
                              switchOutCurve: Curves.easeInOut,
                              transitionBuilder:
                                  (Widget child, Animation<double> animaton) {
                                final offsetAnimation = Tween<Offset>(
                                  begin: const Offset(0.0, 0.2),
                                  end: Offset.zero,
                                ).animate(CurvedAnimation(
                                    parent: animaton,
                                    curve: Curves.easeInOutCubic));

                                final scaleAnim =
                                    Tween<double>(begin: 0.95, end: 1.0)
                                        .animate(CurvedAnimation(
                                            parent: animaton,
                                            curve: Curves.easeInOutBack));

                                return SlideTransition(
                                  position: offsetAnimation,
                                  child: ScaleTransition(
                                    scale: scaleAnim,
                                    child: FadeTransition(
                                      opacity: animaton,
                                      child: child,
                                    ),
                                  ),
                                );
                              },
                              child: _currentPage == 1
                                  ? _buildPasswordTextField()
                                  : const SizedBox.shrink(),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 40),

                    // Tombol Login dengan EdDSA
                    SizedBox(
                      height: 50,
                      width: size.width,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: PageView(
                          controller: _pageController,
                          physics: const BouncingScrollPhysics(),
                          onPageChanged: (index) {
                            setState(() {
                              _currentPage = index;
                            });
                          },
                          children: [
                            ClipRRect(
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(15),
                                bottomLeft: Radius.circular(15),
                              ),
                              child: Container(
                                color: warnaKopi,
                                padding: const EdgeInsets.only(left: 45),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: GestureDetector(
                                        onTap: () {
                                          FocusScope.of(context).unfocus();
                                          EdDSALogin.loginWithEdDSA(context,
                                              _usernameController.text);
                                        },
                                        child: const Center(
                                          child: Text(
                                            "LOGIN (EdDSA)",
                                            style: TextStyle(
                                              fontFamily: "poppinsregular",
                                              fontWeight: FontWeight.w600,
                                              fontSize: 17,
                                              color: Colors
                                                  .white, // Ganti dengan warnaKopi jika ada
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        _pageController.nextPage(
                                          duration:
                                              const Duration(milliseconds: 300),
                                          curve: Curves.easeInOut,
                                        );
                                      },
                                      child: const Padding(
                                        padding: EdgeInsets.only(right: 10.0),
                                        child: Icon(
                                          Icons.arrow_right_rounded,
                                          color: Colors.white,
                                          size: 34,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),

                            //LOGIN dengan username dan paswword
                            ClipRRect(
                              borderRadius: const BorderRadius.only(
                                topRight: Radius.circular(15),
                                bottomRight: Radius.circular(15),
                              ),
                              child: Container(
                                color: warnaKopi,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        _pageController.previousPage(
                                            duration: const Duration(
                                                milliseconds: 300),
                                            curve: Curves.easeInOut);
                                      },
                                      child: const Padding(
                                        padding: EdgeInsets.only(left: 10.0),
                                        child: Icon(
                                          Icons.arrow_left_rounded,
                                          color: Colors.white,
                                          size: 34,
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: GestureDetector(
                                        onTap: () {
                                          _loginUser();
                                        },
                                        child: Container(
                                          color: warnaKopi,
                                          padding:
                                              const EdgeInsets.only(right: 45),
                                          child: const Center(
                                            child: Text(
                                              "LOGIN",
                                              style: TextStyle(
                                                fontFamily: "poppinsregular",
                                                fontWeight: FontWeight.w600,
                                                fontSize: 17,
                                                color: Colors
                                                    .white, // Ganti dengan warnaKopi jika ada
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 50),
                    // Tombol Daftar
                    Bounceable(
                      onTap: () {
                        Navigator.pushNamed(context,
                            '/register'); // Arahkan ke halaman register
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

  Widget _buildUsernameOnlyForm() {
    return Container(
      key: const ValueKey('username-only'),
      padding: const EdgeInsets.all(5),
      decoration: _formBoxDecoration(),
      child: Column(
        children: [
          _buildUsernameTextField(),
        ],
      ),
    );
  }

  Widget _buildUsernameAndPasswordForm() {
    return Container(
      key: const ValueKey('username-password'),
      padding: const EdgeInsets.all(5),
      decoration: _formBoxDecoration(),
      child: Column(
        children: [
          _buildUsernameTextField(),
          _buildPasswordTextField(),
        ],
      ),
    );
  }

  BoxDecoration _formBoxDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(10),
      boxShadow: const [
        BoxShadow(
          color: warnaKopi,
          blurRadius: 2.5,
          offset: Offset(0, 0.1),
        ),
      ],
    );
  }

  Widget _buildUsernameTextField() {
    return Container(
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.grey[350]!),
        ),
      ),
      child: TextField(
        controller: _usernameController,
        autofocus: false,
        style: const TextStyle(fontFamily: "poppinsregular", fontSize: 15),
        decoration: InputDecoration(
          prefixIcon: const Icon(Icons.person_3_outlined, color: warnaKopi),
          border: InputBorder.none,
          hintText: "Username",
          hintStyle: TextStyle(
            fontFamily: "poppinsregular",
            color: Colors.grey[400],
          ),
        ),
      ),
    );
  }

  Widget _buildPasswordTextField() {
    return Container(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        key: const ValueKey("password visible"),
        controller: _passwordController,
        obscureText: _isSecurePassword,
        style: const TextStyle(fontFamily: "poppinsregular", fontSize: 15),
        decoration: InputDecoration(
          prefixIcon: const Icon(Icons.lock_outline, color: warnaKopi),
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
              _isSecurePassword ? Icons.visibility_off : Icons.visibility,
              color: warnaKopi,
            ),
          ),
        ),
      ),
    );
  }
}
