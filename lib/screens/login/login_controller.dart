import 'package:get/get.dart';
import 'package:movie_database/base/base_controller.dart';
import 'package:movie_database/helpers/connection_aware.dart';
import 'package:movie_database/helpers/constants.dart';
import 'package:movie_database/helpers/utils.dart';
import 'package:movie_database/routes/router.dart';
import 'package:movie_database/service/auth_service.dart';

class LoginController extends BaseController with ConnectionAware {
  final _utils = Utils();
  final AuthService _authService = Get.find<AuthService>();

  void login(String email, String password) async {
    _utils.showLoading();
    _authService.signIn(email: email, password: password).then((value) {
      _utils.hideLoading();
      if (value == Constants.LOGIN_SUCCESS) {
        _utils.showSnackBar('Login', 'success', true);
        Get.offAndToNamed(AppRouter.HOME);
      } else {
        _utils.showSnackBar('Login', value, false);
      }
    });
  }

  @override
  void onNetworkConnected() {
    // TODO: implement onNetworkConnected
  }

  @override
  void onNetworkDisconnected() {
    // TODO: implement onNetworkDisconnected
  }
}
