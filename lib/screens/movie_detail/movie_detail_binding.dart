import 'package:get/instance_manager.dart';
import '../../repo/movie_detail_repo.dart';
import 'movie_detail_controller.dart';

class MovieDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => MovieDetailRepository(), fenix: true);
    Get.lazyPut(() => MovieDetailController(), fenix: true);
  }
}
