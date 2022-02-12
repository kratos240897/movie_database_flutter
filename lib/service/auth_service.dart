// ignore_for_file: non_constant_identifier_names

import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/instance_manager.dart';
import 'package:movie_database/helpers/constants.dart';

class AuthService {
  final FirebaseAuth _firebaseAuth = Get.find<FirebaseAuth>();

  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  Future<String> signIn(
      {required String email, required String password}) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      return Constants.LOGIN_SUCCESS;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        return 'No user found for this email.';
      } else if (e.code == 'wrong-password') {
        return 'Wrong password provided for this user.';
      }
    }
    return 'Something went wrong';
  }

  Future<String> signUp(
      {required String email, required String password}) async {
    try {
      await _firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);
      return Constants.REGISTRATION_SUCCESS;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        return 'The password provided is too weak.';
      } else if (e.code == 'email-already-in-use') {
        return 'This email already exists';
      }
    }
    return 'Something went wrong';
  }

  Future<String> signOut() async {
    try {
      await _firebaseAuth.signOut();
      return Constants.SIGNOUT_SUCCESS;
    } on FirebaseAuthException catch (e) {
      return e.message!;
    }
  }

  User? getUser() {
    try {
      return _firebaseAuth.currentUser;
    } on FirebaseAuthException {
      return null;
    }
  }
}
