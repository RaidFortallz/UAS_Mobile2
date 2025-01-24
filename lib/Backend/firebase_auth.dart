import 'dart:developer';
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

      log("User registered successfully", name: "FirebaseAuthService");
      log("Email: $email", name: "FirebaseAuthService");
    } catch (e) {
      // Logging error
      log("Error during registration: $e",
          level: 1000, name: "FirebaseAuthService");
      throw Exception("Error during registration: $e");
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

      log("User logged in successfully", name: "FirebaseAuthService");
      log("Email: $email", name: "FirebaseAuthService");
    } catch (e) {
      // Logging error
      log("Error during login: $e", level: 1000, name: "FirebaseAuthService");
      throw Exception("Error during login: $e");
    }
  }

  // Fungsi untuk logout user
  Future<void> logout() async {
    try {
      await _firebaseAuth.signOut();

      log("User logged out successfully", name: "FirebaseAuthService");
    } catch (e) {
      // Logging error
      log("Error during logout: $e", level: 1000, name: "FirebaseAuthService");
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

  void signOut() {
    log("signOut method called but not implemented",
        name: "FirebaseAuthService");
  }
}
