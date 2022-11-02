import 'package:get/get.dart';
import 'register_controller.dart';

class RegisterBiding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => RegisterController(), fenix: true);
  }
}
