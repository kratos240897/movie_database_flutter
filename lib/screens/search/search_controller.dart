import 'package:get/get.dart';
import 'package:movie_database/models/movies_response.dart';
import 'package:movie_database/repo/app_repo.dart';

class SearchController extends GetxController {
  RxList<Results> searchResults = RxList.empty();
  final error = ''.obs;
  final AppRepository _appRepo = Get.find<AppRepository>();
  var isSearchHasFocus = false.obs;

  searchMovies(String query) {
    _appRepo.searchMovies({'query': query}).then((value) {
      searchResults.value = value;
    }).onError((error, stackTrace) {
      this.error.value = error.toString();
      return Future.error(error!);
    });
  }
}
