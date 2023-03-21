import 'package:get/instance_manager.dart';
import 'person_controller.dart';

class PersonBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => PersonController(), fenix: true);
  }
}
