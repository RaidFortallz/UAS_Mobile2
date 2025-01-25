import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseAuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Fungsi untuk register user
  Future<void> registerUser({
    required String username,
    required String email,
    required String password,
    required String phoneNumber,
  }) async {
    try {
      // Membuat user dengan email dan password
      UserCredential userCredential =
          await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Ambil UID dari user
      String uid = userCredential.user!.uid;

      // Simpan data tambahan ke Firestore dengan UID sebagai Document ID
      await _firestore.collection('users').doc(uid).set({
        'username': username,
        'email': email,
        'phoneNumber': phoneNumber,
        'createdAt': FieldValue.serverTimestamp(),
      });

      print("User registered: $email");
    } catch (e) {
      throw Exception("Kesalahan saat registrasi: $e");
    }
  }

  // Fungsi untuk login user menggunakan email dan password
  Future<void> loginWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      print("User logged in: $email");
    } catch (e) {
      throw Exception("Kesalahan saat login: $e");
    }
  }

  // Fungsi untuk login menggunakan username
  Future<String?> getEmailByUsername(String username) async {
    try {
      final querySnapshot = await _firestore
      .collection('users')
      .where('username', isEqualTo: username)
      .get();

      if (querySnapshot.docs.isNotEmpty) {
        return querySnapshot.docs.first.data()['email'] as String?;
      } else {
        return null;
      }
    } catch (e) {
      throw Exception("Terjadi kesalahan saat mengambil email berdasarkan username: $e");
    }
  }

  // Fungsi untuk logout user
  Future<void> logout() async {
    try {
      await _firebaseAuth.signOut();
      print("User logged out");
    } catch (e) {
      throw Exception("Kesalahan saat logout: $e");
    }
  }

  // Mendapatkan user saat ini
  User? getCurrentUser() {
    return _firebaseAuth.currentUser;
  }

  // Mengecek apakah user sudah login
  bool isUserLoggedIn() {
    return _firebaseAuth.currentUser != null;
  }
}
