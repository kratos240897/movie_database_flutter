import 'package:get/instance_manager.dart';
import 'video_controller.dart';

class VideoBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => VideoController(), fenix: true);
  }
}
