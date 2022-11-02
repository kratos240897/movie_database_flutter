import 'package:get/get.dart';
import '../../repo/search_repo.dart';
import 'search_controller.dart';

class SearchBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => SearchRepository(), fenix: true);
    Get.lazyPut(() => SearchController(), fenix: true);
  }
}
