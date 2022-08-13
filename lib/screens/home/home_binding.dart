import 'package:get/instance_manager.dart';
import 'package:movie_database/repo/home_repo.dart';
import 'package:movie_database/screens/home/home_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => HomeRepository(), fenix: true);
    Get.lazyPut(() => HomeController(), fenix: true);
  }
}
