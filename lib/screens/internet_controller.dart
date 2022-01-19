import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get/get.dart';
import 'package:movie_database/helpers/utils.dart';

class InternetController extends SuperController {
  var isInternetAvailable = false.obs;
  StreamSubscription<ConnectivityResult> streamSubscription =
      Utils().getConnectivity.connectivityStream.stream.listen((event) {});
  @override
  void onInit() {
    super.onInit();
    streamSubscription.onData((data) {
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
  void onDetached() {}

  @override
  void onInactive() {}

  @override
  void onPaused() {
    streamSubscription.pause();
  }

  @override
  void onClose() {
    streamSubscription.cancel();
    super.onClose();
  }

  @override
  void onResumed() {
    streamSubscription.resume();
  }
}
