import 'package:get/get.dart';
import '../../core/base/base_controller.dart';
import '../../core/constants/enums/auth_status.dart';
import '../../core/constants/enums/snackbar_status.dart';
import '../../core/init/routes/router.dart';
import '../../core/service/auth_service.dart';

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
