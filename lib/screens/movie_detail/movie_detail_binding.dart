import 'package:get/instance_manager.dart';
import 'package:movie_database/screens/movie_detail/movie_detail_controller.dart';

class MovieDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => MovieDetailController(), fenix: true);
  }
}
