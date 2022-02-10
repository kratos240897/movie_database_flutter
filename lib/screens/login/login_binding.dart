import 'package:get/instance_manager.dart';
import 'package:movie_database/repo/app_repo.dart';

class LoginBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => AppRepository(), fenix: true);
  }
}
