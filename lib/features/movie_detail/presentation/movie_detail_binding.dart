import 'package:get/instance_manager.dart';
import 'controllers/movie_detail_controller.dart';

class MovieDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => MovieDetailController(), fenix: true);
  }
}
