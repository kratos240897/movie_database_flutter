import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';

class Utils {

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

  showLoading() {
    Get.dialog(
        const Center(
          child: CupertinoActivityIndicator(
            radius: 25.0,
          ),
        ),
        barrierDismissible: false);
  }

  hideLoading() {
    Navigator.pop(Get.context!);
  }
}
