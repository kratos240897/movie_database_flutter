import 'package:get/instance_manager.dart';
import 'package:movie_database/screens/video/video_controller.dart';

class VideoBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => VideoController(), fenix: true);
  }
}
