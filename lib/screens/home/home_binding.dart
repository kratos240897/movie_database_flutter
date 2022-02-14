import 'package:get/instance_manager.dart';
import 'package:movie_database/repo/app_repo.dart';
import 'package:movie_database/screens/home/home_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => AppRepository(), fenix: true);
    Get.lazyPut(() => HomeController(), fenix: true);
  }
}
