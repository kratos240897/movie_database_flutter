import 'dart:async';
import '../enum/auth_status.dart';



class AuthStatus {
  final AuthState state;
  final String message;

  AuthStatus({required this.state, required this.message});
}

abstract class AuthStateAware {
  AuthState? authState;
  StreamSubscription? authStateSubscription;

  void prepareLogout();
}
