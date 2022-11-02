import 'package:get/instance_manager.dart';
import '../../repo/home_repo.dart';
import 'login_controller.dart';

class LoginBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => LoginController(), fenix: true);
    Get.lazyPut(() => HomeRepository(), fenix: true);
  }
}
