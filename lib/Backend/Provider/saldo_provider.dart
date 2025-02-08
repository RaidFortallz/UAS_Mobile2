import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SaldoProvider with ChangeNotifier {
  int _saldo = 0;

  int get saldo => _saldo;

  var logger = Logger();

  // Mencari saldo di tabel supabase
  Future<void> fetchSaldo(String userId) async {
    try {
      final response = await Supabase.instance.client
          .from('profile_users')
          .select('saldo')
          .eq('id', userId)
          .maybeSingle();

      if (response != null && response['saldo'] != null) {
        _saldo = response['saldo'];
      } else {
        _saldo = 0;
      }
      notifyListeners();
    } catch (e) {
      logger.e('Gagal mengambil saldo: $e');
      _saldo = 0;
      notifyListeners();
    }
  }

  // Update saldo di supabase dan di lokal
  Future<void> updateSaldo(String userId, int newSaldo) async {
    try {
      await Supabase.instance.client
          .from('profile_users')
          .update({'saldo': newSaldo}).eq('id', userId);

      final updatedSaldo = await Supabase.instance.client
          .from('profile_users')
          .select('saldo')
          .eq('id', userId)
          .maybeSingle();

      if (updatedSaldo != null && updatedSaldo['saldo'] == newSaldo) {
        _saldo = newSaldo;
        notifyListeners();
        logger.i('Saldo berhasil diperbarui: $_saldo');
      } else {
        logger.w('Gagal memperbarui saldo: saldo tidak berubah');
      }
    } catch (e) {
      logger.e('Error saat memperbarui saldo: $e');
    }
  }

  void setSaldo(int amount) {
    _saldo += amount;
    notifyListeners();
  }
}
