import 'package:flutter/material.dart';
import 'package:uas_mobile2/Backend/koneksi.dart';
import 'package:uas_mobile2/Models/coffee_model.dart';

class CoffeeService with ChangeNotifier {
  final supabase = Koneksi.client;

  // Variabel untuk menyimpan daftar kopi, status loading, dan pesan error
  List<Coffees> _coffees = [];
  bool _isLoading = false;
  String _errorMessage = '';

  List<Coffees> get coffees => _coffees;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;

  // Metode untuk mengambil data kopi dari Supabase
  Future<void> fetchCoffees() async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await supabase.from('coffees').select();

      // Jika data berhasil diambil, parsing data menjadi list Coffee
      _coffees = response.map((item) => Coffees.fromJson(item)).toList();
    } catch (e) {
      _errorMessage = 'Error fetching data: $e';
      print(_errorMessage);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Mengonversi objek Coffee ke dalam Map
  Map<String, dynamic> coffeeToMap(Coffees coffee) {
    return coffee.toJson();
  }
}
