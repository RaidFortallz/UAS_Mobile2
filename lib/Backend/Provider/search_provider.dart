import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:uas_mobile2/Models/coffee_model.dart';

class SearchProvider extends ChangeNotifier{
  final Dio dio = Dio();

  var logger = Logger();

  List<Coffees> _searchResults = [];
  bool _isLoading = false;
  String _errorMessage = '';

  List<Coffees> get searchResult => _searchResults;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;

  // Fungsi pencarian kopi berdasarkan nama
  Future<void> searchCoffees(String query) async {
    _isLoading = true;
    Future.microtask(() => notifyListeners());

    try {
      final response = await dio.get(
        'https://ppniihvttatatvdmzbeo.supabase.co/rest/v1/coffees',
        queryParameters: {'name': 'ilike.%$query%'},
        options: Options(
          headers: {
            'apikey': 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InBwbmlpaHZ0dGF0YXR2ZG16YmVvIiwicm9sZSI6ImFub24iLCJpYXQiOjE3Mzc4ODI4NDAsImV4cCI6MjA1MzQ1ODg0MH0.rtJpnEVuqSN1jcbOgJPXZ3OsGwEngTzaZCk8NGYHj4Y',
            'Authorization': 'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InBwbmlpaHZ0dGF0YXR2ZG16YmVvIiwicm9sZSI6ImFub24iLCJpYXQiOjE3Mzc4ODI4NDAsImV4cCI6MjA1MzQ1ODg0MH0.rtJpnEVuqSN1jcbOgJPXZ3OsGwEngTzaZCk8NGYHj4Y'
          }
        )
      );

      logger.d(response.data);

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        _searchResults = data.map((item) => Coffees.fromJson(item)).toList();
      }
    } catch (e) {
      _errorMessage = 'Error pencarian data: $e';
      logger.e(_errorMessage);
    } finally {
      _isLoading = false;
      Future.microtask(() => notifyListeners());
    }
  }
}