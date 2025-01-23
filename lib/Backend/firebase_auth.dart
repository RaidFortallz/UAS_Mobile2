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
  }) async {
    try {
      // Membuat user dengan email dan password
      UserCredential userCredential =
          await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Menyimpan username ke profil user Firebase
      await userCredential.user?.updateDisplayName(username);

      // Menyimpan username dan email di Firestore
      await _firestore.collection('users').doc(userCredential.user?.uid).set({
        'username': username,
        'email': email,
      });

      // User berhasil didaftarkan
      print("User registered: ${userCredential.user?.email}");
    } catch (e) {
      throw Exception("Error during registration: $e");
    }
  }

  // Fungsi untuk login user menggunakan username dan password
  Future<void> loginWithUsername({
    required String username,
    required String password,
    required String email,
  }) async {
    try {
      // Ubah username menjadi pola email agar dapat diproses Firebase
      final email = "$username@example.com";

      await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      print("User logged in: $email");
    } catch (e) {
      throw Exception("Error during login: $e");
    }
  }

  // Fungsi untuk logout user
  Future<void> logout() async {
    try {
      await _firebaseAuth.signOut();
      print("User logged out");
    } catch (e) {
      throw Exception("Error during logout: $e");
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
