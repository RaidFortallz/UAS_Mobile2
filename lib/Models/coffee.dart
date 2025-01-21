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
      image: 'assets/image/kopi2.png',
      name: 'Cafe Mocha',
      type: 'Deep Foam',
      rate: 4.8,
      review: 230,
      description: 'description',
      price: 4.52),
  Coffee(
      image: 'assets/image/kopi2.png',
      name: 'Cafe Mocha',
      type: 'Deep Foam',
      rate: 4.8,
      review: 230,
      description: 'description',
      price: 4.52),
  Coffee(
      image: 'assets/image/kopi2.png',
      name: 'Cafe Mocha',
      type: 'Deep Foam',
      rate: 4.8,
      review: 230,
      description: 'description',
      price: 4.52),
];
