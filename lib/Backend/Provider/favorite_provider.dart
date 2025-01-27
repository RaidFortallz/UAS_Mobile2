import 'package:flutter/material.dart';
import 'package:uas_mobile2/Models/coffee_model.dart';

class FavoriteProvider with ChangeNotifier {
  final List<Coffees> _favorites = [];

  List<Coffees> get favorites => _favorites;

  void addFavorite(Coffees coffee) {
    if (!_favorites.contains(coffee)) {
      _favorites.add(coffee);
      notifyListeners();
    }
  }

  void removeFavorite(Coffees coffee) {
    _favorites.remove(coffee);
    notifyListeners();
  }

  bool isFavorite(Coffees coffee) {
    return _favorites.contains(coffee);
  }
}
