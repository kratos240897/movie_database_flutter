import 'package:get/get.dart';
import '../../base/base_controller.dart';
import '../../enum/auth_status.dart';
import '../../enum/snackbar_status.dart';
import '../../routes/router.dart';
import '../../service/auth_service.dart';

class LoginController extends BaseController {
  final AuthService _authService = Get.find<AuthService>();

  void login(String email, String password) async {
    utils.showLoading();
    _authService.signIn(email: email, password: password).then((value) {
      utils.hideLoading();
      if (value.state == AuthState.loginSuccess) {
        utils.showSnackBar('Login', 'success', SnackBarStatus.success);
        Get.offAndToNamed(PageRouter.HOME);
      } else {
        utils.showSnackBar('Login', value.message, SnackBarStatus.failure);
      }
    });
  }
}
