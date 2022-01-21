import 'package:flutter/material.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/route_manager.dart';
import 'package:movie_database/service/connectivity_service.dart';

class Utils {
  final ConnectivityService _connectivityService =
      Get.find<ConnectivityService>();

  showSnackBar(String title, String message, bool isSuccess) {
    Get.showSnackbar(GetSnackBar(
      margin: const EdgeInsets.all(8.0),
      duration: const Duration(seconds: 2),
      title: title,
      message: message,
      borderRadius: 10.0,
      backgroundColor: isSuccess ? Colors.green : Colors.red,
    ));
  }

  void closeConnectivity() => _connectivityService.closeConnectivityStream();

  ConnectivityService get getConnectivity => _connectivityService;
}
