import 'package:get/instance_manager.dart';
import '../../repo/home_repo.dart';
import 'home_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => HomeRepository(), fenix: true);
    Get.lazyPut(() => HomeController(), fenix: true);
  }
}
