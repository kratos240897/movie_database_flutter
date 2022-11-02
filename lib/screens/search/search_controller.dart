import 'package:get/get.dart';
import 'package:movie_database/enum/snackbar_status.dart';
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
    final movie = Movie()
      ..adult = result.adult
      ..backdropPath = result.backdropPath
      ..genreIds = result.genreIds
      ..id = result.id
      ..originalLanguage = result.originalLanguage
      ..overview = result.overview
      ..popularity = result.popularity
      ..posterPath = result.posterPath
      ..releaseDate = result.releaseDate
      ..title = result.title
      ..video = result.video
      ..voteAverage = result.voteAverage
      ..voteCount = result.voteCount
      ..originalTitle = result.originalTitle;
    final box = Boxes.getFavorites();
    box.add(movie);
    Utils().showSnackBar('Added to Favorites', movie.title, SnackBarStatus.info);
  }
}
