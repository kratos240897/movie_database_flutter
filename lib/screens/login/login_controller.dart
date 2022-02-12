import 'package:get/get.dart';
import 'package:movie_database/helpers/constants.dart';
import 'package:movie_database/helpers/utils.dart';
import 'package:movie_database/routes/router.dart';
import 'package:movie_database/service/auth_service.dart';

class LoginController extends GetxController {
  final _utils = Utils();
  final AuthService _authService = Get.find<AuthService>();

  void login(String email, String password) async {
    _authService.signIn(email: email, password: password).then((value) {
      if (value == Constants.LOGIN_SUCCESS) {
        _utils.showSnackBar('Login', 'success', true);
        Get.offAndToNamed(AppRouter.HOME);
      } else {
        _utils.showSnackBar('Login', value, false);
      }
    });
  }
}
