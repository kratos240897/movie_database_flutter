import 'package:get/get.dart';
import 'package:movie_database/core/extensions/results_to_movie_extn.dart';
import '../../core/base/base_controller.dart';
import '../../core/constants/enums/snackbar_status.dart';
import '../home/data/models/movies_response.dart';
import '../../core/init/utils/utils.dart';
import '../../core/repository/search_repo.dart';

class SearchController extends BaseController {
  RxList<Results> searchResults = RxList.empty();
  final SearchRepository _repo = Get.find<SearchRepository>();
  var isSearchHasFocus = false.obs;

  searchMovies(String query) {
    utils.showLoading();
    _repo.searchMovies({'query': query}).then((value) {
      utils.hideLoading();
      searchResults.value = value;
    }).onError((error, stackTrace) {
      utils.hideLoading();
      this.error.value = error.toString();
      return Future.error(error!);
    });
  }

  addFavorite(Results result) {
    final movie = [result].parseResults().first;
    movie.save();
    Utils()
        .showSnackBar('Added to Favorites', movie.title, SnackBarStatus.info);
  }
}
