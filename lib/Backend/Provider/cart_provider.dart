import 'package:flutter/material.dart';
import 'package:uas_mobile2/Models/coffee_model.dart';

class CartProvider with ChangeNotifier {
  final List<Map<String, dynamic>> _cartItems = [];

  List<Map<String, dynamic>> get cartItems => _cartItems;

  void addToCart(Coffees coffee, String size, int price) {
    _cartItems.add({
      'coffee': coffee,
      'size': size,
      'price': price,
    });
    notifyListeners();
  }

  // Memperbarui quantity item di keranjang
  void updateQuantity(Coffees coffee, String size, int newQuantity) {
    final itemIndex = _cartItems.indexWhere((item) =>
        item['coffee'] == coffee && item['size'] == size);
    if (itemIndex != -1) {
      _cartItems[itemIndex]['quantity'] = newQuantity;
      notifyListeners();
    }
  }

  // Menghitung total harga berdasarkan quantity
  int get totalPrice {
    int total = 0;
    for (var item in _cartItems) {
      final price = item['price'] as int;
      final quantity = item['quantity'] as int;
      total += price * quantity;
    }
    return total;
  }

  //untuk menghapus item di keranjang
  void clearCart() {
    _cartItems.clear();
    notifyListeners();
  }
}
