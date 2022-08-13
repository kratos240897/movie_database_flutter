import 'package:get/instance_manager.dart';
import 'package:movie_database/repo/home_repo.dart';
import 'package:movie_database/screens/login/login_controller.dart';

class LoginBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => LoginController(), fenix: true);
    Get.lazyPut(() => HomeRepository(), fenix: true);
  }
}
