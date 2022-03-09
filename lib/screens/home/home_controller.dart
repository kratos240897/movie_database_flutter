// ignore: unused_import
// ignore_for_file: unnecessary_import

import 'dart:async';
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

import '../../helpers/connection_util.dart';

class HomeController extends GetxController {
  var movies = RxList.empty();
  final error = ''.obs;
  final _utils = Utils();
  ConnectionUtil connectionStatus = ConnectionUtil.getInstance();
  final AppRepository _appRepo = Get.find<AppRepository>();
  final AuthService _authService = Get.find<AuthService>();
  var favoritesCount = 0.obs;
  var isInternetAvailable = false.obs;
  var isLoading = false.obs;
  var selectedIndex = 0.obs;

  @override
  void onInit() async {
    _appRepo.init();
    connectionStatus.initialize();
    favoritesCount.value = Boxes.getFavorites().length;
    super.onInit();
  }

  @override
  void onReady() {
    connectionStatus.connectionChange.listen((data) {
      isInternetAvailable.value = data;
      if (data) {
        getMovies(EndPoints.trending, {});
      }
    });
    super.onReady();
  }

  void logout() async {
    _utils.showLoading();
    _authService.signOut().then((value) {
      _utils.hideLoading();
      if (value == Constants.SIGNOUT_SUCCESS) {
        Get.offAllNamed(AppRouter.LOGIN);
        _utils.showSnackBar('Logout', 'success', true);
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

  @override
  dispose() {
    connectionStatus.dispose();
    super.dispose();
  }

  // It is called just before the controller is deleted from memory.
  // @override
  // onClose() {
  //   super.onClose();
  // }

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
