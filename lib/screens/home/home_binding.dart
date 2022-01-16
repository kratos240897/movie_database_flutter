import 'package:get/instance_manager.dart';
import 'package:movie_database/screens/home/home_controller.dart';
import 'package:movie_database/service/connectivity_service.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(ConnectivityService(), permanent: true);
    Get.lazyPut(() => HomeController(), fenix: true);
  }
}
