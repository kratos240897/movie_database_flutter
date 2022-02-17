import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get/get.dart';

class ConnectivityService {
  final _connectivity = Connectivity();
  final StreamController<ConnectivityResult> connectivityStream =
      StreamController<ConnectivityResult>.broadcast();
 
  init() {
     startConnectivityStream();
  }
  

  void closeConnectivityStream() {
    connectivityStream.close();
  }

  void startConnectivityStream() {
    // onConnectivityChanged can be used to listen internet connectivty
    // also network type
    if (GetPlatform.isAndroid || GetPlatform.isIOS) {
      _connectivity.onConnectivityChanged.listen((event) {
        connectivityStream.add(event);
      });
    }
    // while using on browser platform it is capable of only checking the radio status
    // i.e it can only check whether the internet is connected or not
    else {
      _connectivity
          .checkConnectivity()
          .then((value) => connectivityStream.add(value));
    }
  }
}
