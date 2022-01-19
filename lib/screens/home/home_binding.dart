import 'package:get/instance_manager.dart';
import 'package:movie_database/repo/app_repo.dart';
import 'package:movie_database/screens/home/home_controller.dart';
import 'package:movie_database/screens/internet_controller.dart';
import 'package:movie_database/service/connectivity_service.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(ConnectivityService(), permanent: true);
    Get.put(InternetController(), permanent: true);
    Get.lazyPut(() => AppRepository(), fenix: true);
    Get.lazyPut(() => HomeController(), fenix: true);
  }
}
