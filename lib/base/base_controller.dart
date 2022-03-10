import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get/get.dart';

import '../helpers/connection_aware.dart';

abstract class BaseController extends GetxController {
  @override
  void onInit() {
     if(this is ConnectionAware) {
      ConnectionAware awareObj = this as ConnectionAware;
      awareObj.connectivitySubscription = Connectivity().onConnectivityChanged.listen((event) {
        if (event == ConnectivityResult.mobile || event == ConnectivityResult.wifi) {
          awareObj.networkState = NetworkState.connected;
          awareObj.onNetworkConnected();
        } else if (event == ConnectivityResult.none) {
          awareObj.networkState = NetworkState.disconnected;
          awareObj.onNetworkDisconnected();
        }
      });
    }
    super.onInit();
  }

  @override
  void dispose() {
     if(this is ConnectionAware) {
      (this as ConnectionAware).connectivitySubscription?.cancel();
    }
    super.dispose();
  }
}