import 'package:get/get.dart';
import 'package:movie_database/helpers/boxes.dart';
import 'package:movie_database/helpers/utils.dart';
import 'package:movie_database/models/movies_response.dart';
import 'package:movie_database/repo/app_repo.dart';
import 'package:movie_database/models/movie_model.dart';

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
    Utils().showSnackBar('Added to Favorites', movie.title, true);
  }
}
