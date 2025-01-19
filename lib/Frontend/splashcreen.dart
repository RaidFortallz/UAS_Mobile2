import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:uas_mobile2/Frontend/login.dart';
import 'package:uas_mobile2/Warna_Tema/warna_tema.dart';

class Splashcreen extends StatefulWidget {
  const Splashcreen({super.key});

  @override
  State<Splashcreen> createState() => _SplashcreenState();
}

class _SplashcreenState extends State<Splashcreen>
    with TickerProviderStateMixin {
  late AnimationController _coffeeControler;
  bool animatedCoffee = false;
  bool animatedCoffeeText = false;
  bool showLoginRegister = false;

  @override
  void initState() {
    super.initState();

    _coffeeControler = AnimationController(vsync: this);

    _coffeeControler.addListener(() {
      if (_coffeeControler.value > 0.7) {
        _coffeeControler.stop();
        
        animatedCoffee = true;
        setState(() {});

        Future.delayed(const Duration(seconds: 1), () {
          animatedCoffeeText = true;
          setState(() {});
          
          Future.delayed(const Duration(seconds: 1), () {
            showLoginRegister = true;
            setState(() {});
          });
        });
      }
    });
  }

  @override
  void dispose() {
    _coffeeControler.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var tinggiLayar = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: warnaKopi,
      body: Stack(
        children: [
          AnimatedContainer(
            duration: const Duration(seconds: 1),
            height: animatedCoffee ? tinggiLayar / 1.9 : tinggiLayar,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(animatedCoffee ? 40.0 : 0.0),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Visibility(
                  visible: !animatedCoffee,
                  child: Lottie.asset(
                    'assets/image/splashscreen_kopi.json',
                    controller: _coffeeControler,
                    onLoaded: (composition) {
                      // Memulai animasi dari awal
                      _coffeeControler
                        ..duration = composition.duration
                        ..reset()
                        ..forward();
                    },
                  ),
                ),
                Visibility(
                  visible: animatedCoffee,
                  child: Image.asset(
                    'assets/image/kopi1.png',
                    height: 190.0,
                    width: 190.0,
                  ),
                ),
                Center(
                  child: AnimatedOpacity(
                    opacity: animatedCoffeeText ? 1 : 0,
                    duration: const Duration(seconds: 1),
                    child: const Text(
                      'J - W I R \n'
                      'C O F F E E',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontFamily: "poppinsregular",
                          fontSize: 50.0,
                          color: warnaKopi),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Nampilin text di bawah setelah spashscreen
          Visibility(visible: animatedCoffee, child: _BottomPart(showLoginRegister: showLoginRegister,)),
        ],
      ),
    );
  }
}

class _BottomPart extends StatelessWidget {
  final bool showLoginRegister;
  const _BottomPart({required this.showLoginRegister});

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
                      text: 'Java (mengacu pada kopi, terutama kopi Jawa yang terkenal). \n'
                    ),
                      TextSpan(
                        text: 'WIR: ',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      TextSpan(
                        text: 'Warm, Inspiring, Relaxing (Menggambarkan suasana aplikasi coffee shop yang nyaman dan menyenangkan).'
                      )
                  ]
              ),
            ),
            const SizedBox(
              height: 40.0,
            ),
            AnimatedOpacity(
              opacity: showLoginRegister ? 1 : 0,
              duration: const Duration(seconds: 1),
              child: Flexible(
                child: Container(
                  height: 50,
                  width: size.width,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: bgwarna.withOpacity(0.9),
                      border: Border.all(
                        color: Colors.white,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12.withOpacity(
                            0.05,
                          ),
                          spreadRadius: 1,
                          blurRadius: 7,
                          offset: const Offset(0, -1),
                        )
                      ]),
                  child: Padding(
                    padding: const EdgeInsets.only(right: 5),
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const Login()));
                          },
                          child: Container(
                            height: 50,
                            width: size.width / 2.4,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: const Center(
                                child: Text(
                              "Login",
                              style: TextStyle(
                                  fontFamily: "poppinsregular",
                                  fontWeight: FontWeight.w600,
                                  fontSize: 17,
                                  color: warnaKopi),
                            )),
                          ),
                        ),
                        const Spacer(),
                        GestureDetector(
                          onTap: () {},
                          child: const Text(
                            "Register",
                            style: TextStyle(
                                fontFamily: "poppinsregular",
                                fontSize: 17,
                                fontWeight: FontWeight.w600,
                                color: warnaKopi),
                          ),
                        ),
                        const Spacer(),
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
