import 'package:flutter/material.dart';
import 'package:uas_mobile2/Models/coffee_model.dart';

class CartProvider with ChangeNotifier {
  final List<Map<String, dynamic>> _cartItems = [];
  final List<Map<String, dynamic>> _orderItems = [];
  final List<Map<String, dynamic>> _notificationItems = [];
  bool _orderPlaced = false;
  int _totalPrice = 0;

  List<Map<String, dynamic>> get cartItems => _cartItems;
  List<Map<String, dynamic>> get orderItems => _orderItems;
  List<Map<String, dynamic>> get notificationItems => _notificationItems;
  bool get orderPlaced => _orderPlaced;
  int get totalPrice => _totalPrice;

  void addToCart(Coffees coffee, String size, int price) {
    int index = _cartItems.indexWhere(
        (item) => item['coffee'].name == coffee.name && item['size'] == size);

    if (index != -1) {
      _cartItems[index]['quantity'] += 1;
    } else {
      _cartItems.add({
        'coffee': coffee,
        'size': size,
        'quantity': 1,
        'price': price,
      });
    }
    calculateTotalPrice();
  }

  void updateQuantity(Coffees coffee, String size, int newQuantity) {
    final itemIndex = _cartItems
        .indexWhere((item) => item['coffee'] == coffee && item['size'] == size);
    if (itemIndex != -1) {
      _cartItems[itemIndex]['quantity'] = newQuantity;
      calculateTotalPrice();
    }
  }

  int get orderTotalPrice {
    int total = 0;
    for (var item in _orderItems) {
      final price = (item['price'] ?? 0) as int;
      final quantity = (item['quantity'] ?? 0) as int;
      total += price * quantity;
    }
    return total;
  }

  void calculateTotalPrice() {
    _totalPrice = 0;
    for (var item in _cartItems) {
      final price = item['price'] as int;
      final quantity = item['quantity'] as int;
      _totalPrice += price * quantity;
    }
    notifyListeners();
  }

  void clearCart() {
    _cartItems.clear();
    _orderPlaced = false;
    _totalPrice = 0;
    notifyListeners();
  }

  void removeFromCart(Coffees coffee, String size) {
    _cartItems.removeWhere(
        (item) => item['coffee'] == coffee && item['size'] == size);
    calculateTotalPrice();
  }

  void removeOrderItem(Map<String, dynamic> item) {
    _orderItems.remove(item);
    if (_orderItems.isEmpty) {
      _orderPlaced = false;
    }
    notifyListeners();
  }

  void removeNotificationItem(Map<String, dynamic> item) {
    _notificationItems.remove(item);
    notifyListeners();
  }

  void placeOrder() {
    _orderPlaced = true;

    for (var item in _cartItems) {
      var orderItem = {
        'coffee': item['coffee'],
        'size': item['size'],
        'quantity': item['quantity'],
        'price': item['price'],
        'totalPrice': item['price'] * item['quantity'],
      };

      _orderItems.add(orderItem);

      _notificationItems.add(orderItem);
    }

    notifyListeners();
  }

  void resetOrder() {
    _orderPlaced = false;
    _orderItems.clear();
    _notificationItems.clear();
    _totalPrice = 0;
    notifyListeners();
  }
}
