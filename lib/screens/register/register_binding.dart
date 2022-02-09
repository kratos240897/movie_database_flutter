import 'package:get/get.dart';
import 'package:movie_database/screens/register/register_controller.dart';

class RegisterBiding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => RegisterController(), fenix: true);
  }
}
