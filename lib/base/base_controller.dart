import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

import '../helpers/connection_aware.dart';
import '../helpers/utils.dart';

abstract class BaseController extends GetxController with ConnectionAware {
  final error = ''.obs;
  final utils = Utils();
  final isNetworkAvailable = false.obs;

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
    ConnectionAware awareObj = this;
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
    super.onInit();
  }

  @override
  void onReady() async {
    isNetworkAvailable.value = await getIsInternetAvailable();
    super.onReady();
  }

  @override
  void dispose() {
    connectivitySubscription?.cancel();
    super.dispose();
  }

  @override
  void onNetworkConnected() {
    isNetworkAvailable.value = true;
    utils.showSnackBar('Internet Connection', 'Back Online', true);
  }

  @override
  void onNetworkDisconnected() {
    isNetworkAvailable.value = false;
    utils.showSnackBar('Internet Connection', 'You\'re offline', false);
  }
}

class NoInternetWidget extends StatelessWidget {
  const NoInternetWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Lottie.asset('assets/lottie/no_internet.json',
            width: 400.0, height: 400.0));
  }
}
