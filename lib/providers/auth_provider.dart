import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthProvider extends ChangeNotifier {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  User? user;

  AuthProvider() {
    _firebaseAuth.authStateChanges().listen((User? user) {
      this.user = user;
      notifyListeners();
    });
  }

  Future<void> signIn(String email, String password) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      throw Exception('Failed to sign in: ${e.message}');
    }
  }
  Future<void> signOut() async {
    try {
      await _firebaseAuth.signOut();
    } on FirebaseAuthException catch (e) {
      throw e;
    }
  }

  Future<void> signUp(String email, String password) async {
    try {
      await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
      await _firestore.collection('users').doc(_firebaseAuth.currentUser?.uid).set({
        'email': email,      
        'createdAt': Timestamp.now(),
      });
    } on FirebaseAuthException catch (e) {
      throw e;
    }
  }

  Future<void> resetPassword(String email) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      throw e;
    }
  }


  bool get isAuthenticated {
    return user != null;
  }
  String get userId {
    return user?.uid ?? '';
  }

  

}