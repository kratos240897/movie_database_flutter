// ignore_for_file: non_constant_identifier_names
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/instance_manager.dart';
import '../init/auth/auth_aware.dart';
import '../constants/enums/auth_status.dart';

class AuthService {
  final FirebaseAuth _firebaseAuth = Get.find<FirebaseAuth>();

  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  Future<AuthStatus> signIn(
      {required String email, required String password}) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      return AuthStatus(state: AuthState.loginSuccess, message: '');
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        return AuthStatus(
            state: AuthState.loginFailed,
            message: 'No user found for this email.');
      } else if (e.code == 'wrong-password') {
        return AuthStatus(
            state: AuthState.loginFailed,
            message: 'Wrong password provided for this user.');
      }
    }
    return AuthStatus(
        state: AuthState.loginFailed, message: 'Something went wrong');
  }

  Future<AuthStatus> signUp(
      {required String email, required String password}) async {
    try {
      await _firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);
      return AuthStatus(state: AuthState.registrationSuccess, message: '');
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        return AuthStatus(
            state: AuthState.registrationFailed,
            message: 'The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        return AuthStatus(
            state: AuthState.registrationFailed,
            message: 'This email already exists');
      }
    }
    return AuthStatus(
        state: AuthState.registrationFailed, message: 'Something went wrong');
  }

  Future<AuthStatus> signOut() async {
    try {
      await _firebaseAuth.signOut();
      return AuthStatus(state: AuthState.signoutSuccess, message: '');
    } on FirebaseAuthException catch (e) {
      return AuthStatus(
          state: AuthState.signoutFailed, message: e.message.toString());
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
