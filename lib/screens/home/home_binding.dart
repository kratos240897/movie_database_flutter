import 'package:get/instance_manager.dart';
import 'package:movie_database/repo/home_repo.dart';
import 'package:movie_database/screens/home/home_controller.dart';
import 'package:movie_database/service/api_service.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(() => ApiService());
    Get.lazyPut(() => HomeRepository(), fenix: true);
    Get.lazyPut(() => HomeController(), fenix: true);
  }
}
