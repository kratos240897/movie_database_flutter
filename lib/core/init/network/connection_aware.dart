import 'dart:async';
import '../../constants/enums/network_state.dart';

abstract class ConnectionAware {
  NetworkState? networkState;
  StreamSubscription? connectivitySubscription;

  void onNetworkConnected();
  void onNetworkDisconnected();
}
