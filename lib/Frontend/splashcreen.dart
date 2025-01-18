import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
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
        });
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _coffeeControler.dispose();
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
                      style: TextStyle(fontFamily: "poppinsregular" , fontSize: 50.0, color: warnaKopi),
                    ),
                  ),
                )
              ],
            ),
          ),

          //Nampilin text di bawah setelah spashcreen
          Visibility(
            visible: animatedCoffee,
            child: const _BottomPart()),
        ],
      ),
    );
  }
}

class _BottomPart extends StatelessWidget {
  const _BottomPart();

  @override
  Widget build(BuildContext context) {
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
              fontSize: 27.0,
               fontWeight: FontWeight.w700,
                color: Colors.white),
            ),
            const SizedBox(height: 30.0,),
            Text(
              'J: Java (mengacu pada kopi, terutama kopi Jawa yang terkenal). \n'
              'WIR: Warm, Inspiring, Relaxing (Menggambarkan suasana coffee shop yang nyaman dan menyenangkan).',
              style: TextStyle(
                fontFamily: "poppinsregular",
              fontSize: 14.5,
               color: Colors.white.withOpacity(0.8),
                height: 1.5
                ),
            ),
            const SizedBox(height: 50.0,),
            Align(
              alignment: Alignment.centerRight,
              child: Container(
                  height: 85.0,
                  width: 85.0,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2.0),
                  ),
                  child: const Icon(
                    Icons.chevron_right,
                    size: 50.0,
                    color: Colors.white,
                  ),
              ),
            ),
            const SizedBox(height: 50.0,),
          ],
        ),),
    );
  }
}
