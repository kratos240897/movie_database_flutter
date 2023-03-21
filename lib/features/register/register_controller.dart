import 'dart:io';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../core/base/base_controller.dart';
import '../../core/constants/enums/auth_status.dart';
import '../../core/constants/enums/snackbar_status.dart';
import '../../core/init/routes/router.dart';
import '../../core/service/auth_service.dart';

class RegisterController extends BaseController {
  final ImagePicker _picker = ImagePicker();
  File? file;
  XFile? image;
  var isImageNotNull = false.obs;
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
    utils.showLoading();
    _authService.signUp(email: email, password: password).then((value) {
      utils.hideLoading();
      if (value.state == AuthState.registrationSuccess) {
        utils.showSnackBar('Registration', 'success', SnackBarStatus.success);
        Get.offAndToNamed(PageRouter.HOME);
      } else {
        utils.showSnackBar('Registration', value.message, SnackBarStatus.failure);
      }
    });
  }
}
