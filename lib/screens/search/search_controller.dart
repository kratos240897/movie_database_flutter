import 'package:get/get.dart';
import 'package:movie_database/enum/snackbar_status.dart';
import 'package:movie_database/helpers/results_to_movie_extn.dart';
import '../../base/base_controller.dart';
import '../../data/models/movie_model.dart';
import '../../data/models/movies_response.dart';
import '../../helpers/boxes.dart';
import '../../helpers/utils.dart';
import '../../repo/search_repo.dart';

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
    final movie = ResultsToMovie([result]).parseResults().first;
    movie.save();
    Utils()
        .showSnackBar('Added to Favorites', movie.title, SnackBarStatus.info);
  }
}
