import 'package:flutter/material.dart';
import 'package:uas_mobile2/Models/coffee_model.dart';

class CartService with ChangeNotifier {
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

  void removeFromCart(Coffees coffee) {
    _cartItems.removeWhere((item) => item['coffee'] == coffee);
    notifyListeners();
  }

  void clearCart() {
    _cartItems.clear();
    notifyListeners();
  }
}
