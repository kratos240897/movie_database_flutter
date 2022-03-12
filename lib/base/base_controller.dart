import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

import '../helpers/connection_aware.dart';
import '../helpers/utils.dart';

abstract class BaseController extends GetxController {
  final error = ''.obs;
  final utils = Utils();

  get getNoInternetWidget => const NoInternetWidget();

  Future<bool> getIsInternetAvailable() async {
    final value = await Connectivity().checkConnectivity();
    if (value == ConnectivityResult.none) {
      return false;
    } else {
      return true;
    }
  }

  @override
  void onInit() {
    if (this is ConnectionAware) {
      ConnectionAware awareObj = this as ConnectionAware;
      awareObj.connectivitySubscription =
          Connectivity().onConnectivityChanged.listen((event) {
        if (event == ConnectivityResult.mobile ||
            event == ConnectivityResult.wifi) {
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
    if (this is ConnectionAware) {
      (this as ConnectionAware).connectivitySubscription?.cancel();
    }
    super.dispose();
  }
}

class NoInternetWidget extends StatelessWidget {
  const NoInternetWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: Center(
            child: Lottie.asset('assets/lottie/no_internet.json',
                width: 400.0, height: 400.0)));
  }
}
