import 'package:get/instance_manager.dart';
import 'package:movie_database/repo/movie_detail_repo.dart';
import 'package:movie_database/screens/movie_detail/movie_detail_controller.dart';

class MovieDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => MovieDetailRepository(), fenix: true);
    Get.lazyPut(() => MovieDetailController(), fenix: true);
  }
}
