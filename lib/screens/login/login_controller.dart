import 'package:get/get.dart';
import 'package:movie_database/base/base_controller.dart';
import 'package:movie_database/helpers/constants.dart';
import 'package:movie_database/routes/router.dart';
import 'package:movie_database/service/auth_service.dart';

class LoginController extends BaseController {
  final AuthService _authService = Get.find<AuthService>();

  void login(String email, String password) async {
    utils.showLoading();
    _authService.signIn(email: email, password: password).then((value) {
      utils.hideLoading();
      if (value == AuthStatus.loginSuccess.toString()) {
        utils.showSnackBar('Login', 'success', true);
        Get.offAndToNamed(AppRouter.HOME);
      } else {
        utils.showSnackBar('Login', value, false);
      }
    });
  }
}
