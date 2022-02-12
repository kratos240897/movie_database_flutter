import 'dart:io';

import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:movie_database/helpers/constants.dart';
import 'package:movie_database/helpers/utils.dart';
import 'package:movie_database/routes/router.dart';
import 'package:movie_database/service/auth_service.dart';

class RegisterController extends GetxController {
  final ImagePicker _picker = ImagePicker();
  File? file;
  XFile? image;
  var isImageNotNull = false.obs;
  final _utils = Utils();
  final AuthService _authService = Get.find<AuthService>();

  void pickImage() async {
    image = await _picker.pickImage(source: ImageSource.gallery);
    file = File(image!.path);
    if (file != null) {
      isImageNotNull.value = false;
      isImageNotNull.value = true;
    } else {
      isImageNotNull.value = false;
    }
  }

  void register(String email, String password) async {
    _authService.signUp(email: email, password: password).then((value) {
      if (value == Constants.REGISTRATION_SUCCESS) {
        _utils.showSnackBar('Registration', 'success', true);
        Get.offAndToNamed(AppRouter.HOME);
      } else {
        _utils.showSnackBar('Registration', value, false);
      }
    });
  }
}
