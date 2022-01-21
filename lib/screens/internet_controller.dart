import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get/get.dart';
import 'package:movie_database/helpers/utils.dart';

class InternetController extends SuperController {
  final _utils = Utils();
  var isInternetAvailable = false.obs;
  final StreamSubscription<ConnectivityResult> _streamSubscription =
      Utils().getConnectivity.connectivityStream.stream.listen((event) {});
  @override
  void onInit() {
    super.onInit();
    _streamSubscription.onData((data) {
      setInternetStatus(data);
    });
  }

  void setInternetStatus(ConnectivityResult event) {
    if (event == ConnectivityResult.none) {
      isInternetAvailable.value = false;
      Utils().showSnackBar('Internet Connection', 'No Connection', false);
    } else {
      isInternetAvailable.value = true;
      Utils().showSnackBar('Internet Connection', 'Back Online', true);
    }
  }

  @override
  void onDetached() {
    _utils.closeConnectivity();
  }

  @override
  void onInactive() {}

  @override
  void onPaused() {
    _streamSubscription.pause();
  }

  @override
  void onClose() {
    _streamSubscription.cancel();
    super.onClose();
  }

  @override
  void onResumed() {
    _streamSubscription.resume();
  }
}
