class Coffees {
  final int id;
  final String image;
  final String name;
  final String category;
  final double rate;
  final int review;
  final String description;
  final int price;

  Coffees({
    required this.id,
    required this.image,
    required this.name,
    required this.category,
    required this.rate,
    required this.review,
    required this.description,
    required this.price,
  });

  // Mengonversi data dari JSON 
  factory Coffees.fromJson(Map<String, dynamic> json) {
    return Coffees(
      id: json['id'] as int,
      image: json['image'] as String,
      name: json['name'] as String,
      category: json['category'] as String,
      rate: json['rate'] as double,
      review: json['review'] as int,
      description: json['description'] as String,
      price: json['price'] as int,
    );
  }

  // Mengonversi objek Coffee ke dalam Map 
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'image': image,
      'name': name,
      'category': category,
      'rate': rate,
      'review': review,
      'description': description,
      'price': price,
    };
  }
}
