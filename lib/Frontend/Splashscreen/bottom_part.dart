import 'package:flutter/material.dart';
import 'package:uas_mobile2/Frontend/Halaman_User/Hal_Login&Register/login.dart';
import 'package:uas_mobile2/Frontend/Halaman_User/Hal_Login&Register/register.dart';
import 'package:uas_mobile2/Warna_Tema/warna_tema.dart';

class BottomPart extends StatefulWidget {
  final bool showLoginRegister;

  const BottomPart({required this.showLoginRegister, super.key});

  @override
  BottomPartState createState() => BottomPartState();
}

class BottomPartState extends State<BottomPart> {
  
  final PageController _pageController = PageController(initialPage: 1);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Align(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'J-WIR COFFEE',
              style: TextStyle(
                  fontFamily: "poppinsregular",
                  fontSize: 22.0,
                  fontWeight: FontWeight.w700,
                  color: Colors.white),
            ),
            const SizedBox(
              height: 30.0,
            ),
            RichText(
              text: TextSpan(
                  style: TextStyle(
                    fontFamily: "poppinsregular",
                    fontSize: 15.0,
                    color: Colors.white.withOpacity(0.8),
                    height: 1.5,
                  ),
                  children: const [
                    TextSpan(
                      text: 'J: ',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    TextSpan(
                        text:
                            'Java (mengacu pada kopi, terutama kopi Jawa yang terkenal). \n'),
                    TextSpan(
                      text: 'WIR: ',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    TextSpan(
                        text:
                            'Warm, Inspiring, Relaxing (Menggambarkan suasana aplikasi coffee shop yang nyaman dan menyenangkan).')
                  ]),
            ),
            const SizedBox(
              height: 40.0,
            ),
            AnimatedOpacity(
              opacity: widget.showLoginRegister ? 1 : 0,
              duration: const Duration(seconds: 1),
              child: Flexible(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: Container(
                    height: 50,
                    width: size.width,
                    color: Colors.transparent,
                    child: PageView(
                      controller: _pageController, 
                      children: [
                        // Halaman Login
                        GestureDetector(
                          onTap: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const Login(),
                              ),
                            );
                          },
                          child: Container(
                            color: Colors.white,
                            child: const Center(
                              child: Text(
                                "Login",
                                style: TextStyle(
                                  fontFamily: "poppinsregular",
                                  fontWeight: FontWeight.w600,
                                  fontSize: 17,
                                  color: warnaKopi,
                                ),
                              ),
                            ),
                          ),
                        ),

                        // Halaman Tengah
                        Container(
                          color: Colors.white,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              // Ikon Kiri
                              Padding(
                                padding: const EdgeInsets.only(left: 10.0),
                                child: GestureDetector(
                                  onTap: () {
                                    // Pindah ke halaman Login (halaman 0)
                                    _pageController.previousPage(
                                      duration: const Duration(milliseconds: 300),
                                      curve: Curves.easeInOut,
                                    );
                                  },
                                  child: const Icon(
                                    Icons.arrow_left_rounded,
                                    color: warnaKopi,
                                    size: 34,
                                  ),
                                ),
                              ),
                              const Text(
                                "SWIPE",
                                style: TextStyle(
                                    fontFamily: "poppinsregular",
                                    fontSize: 18,
                                    color: warnaKopi,
                                    fontWeight: FontWeight.w600),
                              ),
                              // Ikon Kanan
                              Padding(
                                padding: const EdgeInsets.only(right: 10.0),
                                child: GestureDetector(
                                  onTap: () {
                                    // Pindah ke halaman Register (halaman 2)
                                    _pageController.nextPage(
                                      duration: const Duration(milliseconds: 300),
                                      curve: Curves.easeInOut,
                                    );
                                  },
                                  child: const Icon(
                                    Icons.arrow_right_rounded,
                                    color: warnaKopi,
                                    size: 34,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Halaman Register
                        GestureDetector(
                          onTap: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const Register(),
                              ),
                            );
                          },
                          child: Container(
                            color: Colors.white,
                            child: const Center(
                              child: Text(
                                "Register",
                                style: TextStyle(
                                  fontFamily: "poppinsregular",
                                  fontWeight: FontWeight.w600,
                                  fontSize: 17,
                                  color: warnaKopi,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 50.0,
            )
          ],
        ),
      ),
    );
  }
}
