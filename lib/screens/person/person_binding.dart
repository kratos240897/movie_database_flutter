import 'package:get/instance_manager.dart';
import 'package:movie_database/screens/person/person_controller.dart';

class PersonBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => PersonController(), fenix: true);
  }
}
