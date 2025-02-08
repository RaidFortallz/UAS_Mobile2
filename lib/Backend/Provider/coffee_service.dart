import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:uas_mobile2/Backend/koneksi.dart';
import 'package:uas_mobile2/Models/coffee_model.dart';

class CoffeeService with ChangeNotifier {
  final supabase = Koneksi.client;

  var logger = Logger();

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
      logger.e(_errorMessage);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Mengambil kopi berdasarkan kategori
  Future<void> fetchCoffeeByCategory(String category) async {
    _isLoading = true;
    notifyListeners();

    try {
      if (category == "All Coffee") {
        await fetchCoffees();
      } else {
        final response = await supabase
        .from('coffees')
        .select()
        .eq('category', category);

        _coffees = response.map((item) => Coffees.fromJson(item)).toList();
      }
    } catch (e) {
      _errorMessage = 'Error saat mengambil data by category: $e';
      logger.e(_errorMessage);
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
