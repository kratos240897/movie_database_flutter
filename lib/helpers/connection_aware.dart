import 'dart:async';

enum NetworkState { connected, disconnected }

abstract class ConnectionAware {
  NetworkState? networkState;
  StreamSubscription? connectivitySubscription;

  void onNetworkConnected();
  void onNetworkDisconnected();
}
