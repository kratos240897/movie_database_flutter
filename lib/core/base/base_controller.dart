import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../init/auth/auth_aware.dart';
import '../constants/enums/auth_status.dart';
import '../constants/enums/network_state.dart';
import '../constants/enums/snackbar_status.dart';
import '../init/local_storage/boxes.dart';
import '../init/network/connection_aware.dart';
import '../init/utils/utils.dart';
import '../init/routes/router.dart';
import '../service/auth_service.dart';

abstract class BaseController extends GetxController
    with ConnectionAware, AuthStateAware, WidgetsBindingObserver {
  final error = ''.obs;
  final utils = Utils();
  final isNetworkAvailable = false.obs;
  final _authService = Get.find<AuthService>();

  showLoading() {
    utils.showLoading();
  }

  hideLoading() {
    utils.hideLoading();
  }

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
    WidgetsBinding.instance.addObserver(this);
    connectivitySubscription =
        Connectivity().onConnectivityChanged.listen((result) {
      if (result == ConnectivityResult.mobile ||
          result == ConnectivityResult.wifi) {
        networkState = NetworkState.connected;
        if (isNetworkAvailable.value != true) {
          onNetworkConnected();
        }
      } else if (result == ConnectivityResult.none) {
        networkState = NetworkState.disconnected;
        onNetworkDisconnected();
      }
    });
    authStateSubscription = _authService.authStateChanges.listen((user) {
      debugPrint('authState:' + user.toString());
      // if (user == null) {
      //   loggedOut();
      // }
    });
    super.onInit();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        debugPrint('AppLifecycleState: resumed');
        connectivitySubscription?.resume();
        authStateSubscription?.resume();
        break;
      case AppLifecycleState.paused:
        debugPrint('AppLifecycleState: paused');
        connectivitySubscription?.pause();
        authStateSubscription?.pause();
        break;
      case AppLifecycleState.inactive:
        debugPrint('AppLifecycleState: inactive');
        break;
      case AppLifecycleState.detached:
        debugPrint('AppLifecycleState: detached');
        break;
    }
  }

  @override
  void onReady() async {
    isNetworkAvailable.value = await getIsInternetAvailable();
    super.onReady();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    connectivitySubscription?.cancel();
    super.dispose();
  }

  @override
  void onNetworkConnected() {
    isNetworkAvailable.value = true;
    utils.showSnackBar(
        'Internet Connection', 'Back Online', SnackBarStatus.success);
  }

  @override
  void onNetworkDisconnected() {
    isNetworkAvailable.value = false;
    utils.showSnackBar(
        'Internet Connection', 'You\'re offline', SnackBarStatus.failure);
  }

  @override
  void prepareLogout() {
    // since it is a local DB
    Boxes.getFavorites().clear();
    logout();
  }

  void logout() async {
    showLoading();
    _authService.signOut().then((value) {
      hideLoading();
      if (value.state == AuthState.signoutSuccess) {
        Get.offAllNamed(PageRouter.LOGIN);
        utils.showSnackBar('Logout', 'success', SnackBarStatus.info);
      }
    });
  }
}


