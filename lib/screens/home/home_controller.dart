// ignore: unused_import
// ignore_for_file: unnecessary_import

import 'dart:async';
import 'package:movie_database/base/base_controller.dart';
import 'package:movie_database/helpers/boxes.dart';
import 'package:movie_database/helpers/constants.dart';
import 'package:movie_database/helpers/helpers.dart';
import 'package:movie_database/helpers/utils.dart';
import 'package:movie_database/models/movies_response.dart';
import 'package:movie_database/repo/app_repo.dart';
import 'package:get/get.dart';
import 'package:movie_database/models/movie_model.dart';
import 'package:movie_database/routes/router.dart';
import 'package:movie_database/service/auth_service.dart';

class HomeController extends BaseController {
  final movies = RxList.empty();
  final AppRepository _appRepo = Get.find<AppRepository>();
  final AuthService _authService = Get.find<AuthService>();
  final favoritesCount = 0.obs;
  
  final isLoading = false.obs;
  final selectedIndex = 0.obs;

  @override
  void onInit() async {
    _appRepo.init();
    favoritesCount.value = Boxes.getFavorites().length;
    super.onInit();
  }

  @override
  void onReady() async {
    Future.delayed(const Duration(seconds: 3), () async {
      if (isNetworkAvailable.value == true) {
        getMovies(EndPoints.trending, {});
      }
    });
    super.onReady();
  }

  void logout() async {
    utils.showLoading();
    _authService.signOut().then((value) {
      utils.hideLoading();
      if (value == AuthStatus.signoutSuccess.toString()) {
        Get.offAllNamed(AppRouter.LOGIN);
        utils.showSnackBar('Logout', 'success', true);
      }
    });
  }

  addFavorite(Results result) {
    favoritesCount.value++;
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

  setSelectedCategory(int index) {
    selectedIndex.value = index;
    switch (selectedIndex.value) {
      case 0:
        getMovies(EndPoints.trending, {});
        break;
      case 1:
        getMovies(EndPoints.discover, {
          'primary_release_date.gte': '2022-01-01',
          'primary_release_date.lte': '2022-02-15'
        });
        break;
      case 2:
        getMovies(EndPoints.topRated, {});
        break;
      case 3:
        getMovies(EndPoints.upcoming, {});
        break;
      case 4:
        getMovies(EndPoints.tvShows, {});
        break;
    }
  }

  getMovies(String url, Map<String, dynamic> query) {
    isLoading.value = true;
    _appRepo.getMovies(url, query).then((value) {
      isLoading.value = false;
      movies.value = value;
    }).onError((error, stackTrace) {
      isLoading.value = false;
      this.error.value = error.toString();
      return Future.error(error!);
    });
  }
}
