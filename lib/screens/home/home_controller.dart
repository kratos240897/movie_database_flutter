// ignore: unused_import
// ignore_for_file: unnecessary_import

import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
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
import 'package:movie_database/service/connectivity_service.dart';

class HomeController extends GetxController {
  var movies = RxList.empty();
  final error = ''.obs;
  final _utils = Utils();
  final ConnectivityService _connectivityService =
      Get.find<ConnectivityService>();
  StreamSubscription<ConnectivityResult>? _streamSubscription;
  final AppRepository _appRepo = Get.find<AppRepository>();
  final AuthService _authService = Get.find<AuthService>();
  var favoritesCount = 0.obs;
  var selectedCategory = 'Now playing'.obs;
  var isInternetAvailable = false.obs;
  var isLoading = false.obs;
  final List<String> categories = [
    'Now playing',
    'New',
    'Top rated',
    'Upcoming',
    'TV shows'
  ];

  @override
  void onInit() async {
    await _connectivityService.init();
    _streamSubscription =
        _connectivityService.connectivityStream.stream.listen((event) {});
    _appRepo.init();
    favoritesCount.value = Boxes.getFavorites().length;
    super.onInit();
  }

  @override
  void onReady() {
    _streamSubscription!.onData((data) {
      if (data != ConnectivityResult.none) {
        isInternetAvailable.value = true;
        getMovies(EndPoints.trending, {});
      }
    });
    super.onReady();
  }

  @override
  void dispose() {
    ConnectivityService().closeConnectivityStream();
    _streamSubscription?.cancel();
    super.dispose();
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

  setSelectedCategory(String category) {
    selectedCategory.value = category;
    switch (selectedCategory.value.toString()) {
      case 'Now playing':
        getMovies(EndPoints.trending, {});
        break;
      case 'New':
        getMovies(EndPoints.discover, {
          'primary_release_date.gte': '2022-01-01',
          'primary_release_date.lte': '2022-02-15'
        });
        break;
      case 'Top rated':
        getMovies(EndPoints.topRated, {});
        break;
      case 'Upcoming':
        getMovies(EndPoints.upcoming, {});
        break;
      case 'TV shows':
        getMovies(EndPoints.tvShows, {});
        break;
    }
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
