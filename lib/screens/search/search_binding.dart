import 'package:get/get.dart';
import 'package:movie_database/repo/search_repo.dart';
import 'package:movie_database/screens/search/search_controller.dart';

class SearchBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => SearchRepository(), fenix: true);
    Get.lazyPut(() => SearchController(), fenix: true);
  }
}
