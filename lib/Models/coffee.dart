class Coffee {
  final String image;
  final String name;
  final String type;
  final double rate;
  final int review;
  final String description;
  final double price;

  Coffee({
    required this.image,
    required this.name,
    required this.type,
    required this.rate,
    required this.review,
    required this.description,
    required this.price,
  });
}

final listGridCoffee = [
  Coffee(
      image: 'assets/image/kopi3.png',
      name: 'Kopi Eko Jawir',
      type: 'Jawa',
      rate: 4.8,
      review: 230,
      description:
          'Nikmati sensasi rasa kopi yang kaya dan lembut dengan Kopi Latte Premium kami. Dibuat dari biji kopi pilihan yang dipadukan dengan susu segar, kopi latte kami menawarkan keseimbangan sempurna antara rasa espresso yang kuat dan kelezatan creamy dari susu steamed. Setiap cangkir disajikan dengan sentuhan latte art yang memikat, menjadikan momen ngopi Anda lebih istimewa. Cocok untuk dinikmati kapan saja, baik di pagi hari untuk memulai hari Anda, atau di sore hari untuk menyegarkan pikiran.',
      price: 15000),
  Coffee(
      image: 'assets/image/kopi4.png',
      name: 'Kopi Jawa Blora',
      type: 'Jawir',
      rate: 4.2,
      review: 230,
      description: 'Nikmati sentuhan elegan dengan Macchiato kami! Dibuat dari espresso pilihan yang diberi sedikit susu berbusa, minuman ini menghadirkan pengalaman kopi yang kaya dan lembut. Cocok untuk Anda yang ingin merasakan keaslian kopi dengan sedikit sentuhan manis. Datang dan coba sendiri kelezatan Macchiato kami hari ini!',
      price: 23000),
  Coffee(
      image: 'assets/image/kopi5.png',
      name: 'Kopi Jawa Ireng',
      type: 'Blora',
      rate: 4.5,
      review: 230,
      description: 'Rasakan kesederhanaan yang memikat dengan Americano kami. Kombinasi sempurna antara espresso dan air panas, menciptakan minuman dengan rasa kopi yang kuat namun ringan di setiap tegukannya. Ideal untuk pencinta kopi yang menginginkan energi ekstra tanpa tambahan rasa manis. Segarkan hari Anda dengan segelas Americano yang nikmat!',
      price: 18000),
  Coffee(
      image: 'assets/image/kopi6.png',
      name: 'Kopi Jawa Icikiwir',
      type: 'Latte',
      rate: 4.6,
      review: 230,
      description: 'Manjakan diri Anda dengan Latte kami yang creamy dan lembut. Terbuat dari perpaduan espresso berkualitas dan susu kukus, Latte kami menawarkan rasa yang halus dan memuaskan. Ditambah dengan seni latte yang menawan di atasnya, minuman ini tidak hanya lezat, tetapi juga indah dipandang. Temukan kenyamanan dalam setiap cangkir Latte yang kami sajikan.',
      price: 13000),
];
