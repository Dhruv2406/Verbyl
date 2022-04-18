import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthenticationController{

  String userEmail = "";
  String userPassword = "";

  final FirebaseAuth _firebaseAuth;

  AuthenticationController(this._firebaseAuth);

  // static String get userEmail => _userEmail;
  // set setEmail(String value) {
  //   _userEmail = value;
  // }
  //
  // static String get userPassword => _userPassword;
  // set setPassword(String value) {
  //   _userPassword = value;
  // }

  // String? get email => userEmail;
  // String? get password => userPassword;

  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }

  Future<void> sendPasswordResetEmail() async {
    return _firebaseAuth.sendPasswordResetEmail(email: userEmail);
  }

  Future<bool> signIn() async {
    try{
      await _firebaseAuth.signInWithEmailAndPassword(email: userEmail, password: userPassword);
      return true;
    } on FirebaseAuthException catch (e){
      debugPrint(e.message);
      return false;
    }
  }

  Future<bool> signUp() async {
    try{
      await _firebaseAuth.createUserWithEmailAndPassword(email: userEmail, password: userPassword);
      return true;
    } on FirebaseAuthException catch (e){
      debugPrint(e.message);
      return false;
    }
  }

}
