import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:uas_mobile2/Frontend/Splashscreen/bottom_part.dart'; // Impor class BottomPart
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

          // Menampilkan kelas bottom_part setelah splashscreen
          Visibility(
            visible: animatedCoffee,
            child: BottomPart(showLoginRegister: showLoginRegister),
          ),
        ],
      ),
    );
  }
}
