// ignore: unused_import
import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:movie_database/helpers/boxes.dart';
import 'package:movie_database/helpers/utils.dart';
import 'package:movie_database/models/movies_response.dart';
import 'package:movie_database/repo/app_repo.dart';
import 'package:get/get.dart';
import 'package:movie_database/models/movie_model.dart';
import 'package:movie_database/service/connectivity_service.dart';

class HomeController extends GetxController {
  var movies = RxList.empty();
  final error = ''.obs;
  final StreamSubscription<ConnectivityResult> _streamSubscription =
      ConnectivityService().connectivityStream.stream.listen((event) {});
  final AppRepository _appRepo = Get.find<AppRepository>();
  var favoritesCount = 0.obs;
  var selectedCategory = 'Top rated'.obs;
  var isInternetAvailable = false.obs;
  var isLoading = false.obs;
  final List<String> categories = [
    'Top rated',
    'Popular',
    'New',
    'Upcoming',
    'GOAT'
  ];

  @override
  void onInit() {
    _appRepo.init();
    favoritesCount.value = Boxes.getFavorites().length;
    super.onInit();
  }

  @override
  void onReady() {
    _streamSubscription.onData((data) {
      if (data != ConnectivityResult.none) {
        isInternetAvailable.value = true;
        getMovies({
          'primary_release_date.gte': '2021-12-15',
          'primary_release_date.lte': '2022-01-10'
        });
      }
    });
    super.onReady();
  }

  @override
  void dispose() {
    ConnectivityService().closeConnectivityStream();
    _streamSubscription.cancel();
    super.dispose();
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
      case 'Popular':
        getMovies({'sort_by': 'popularity.desc'});
        break;
      case 'GOAT':
        getMovies({
          'with_genres': '18',
          'sort_by': 'vote_average.desc',
          'vote_count.gte': '10'
        });
        break;
      case 'Upcoming':
        getUpcomingMovies({});
        break;
      default:
        getMovies({
          'primary_release_date.gte': '2022-01-10',
          'primary_release_date.lte': '2022-02-10'
        });
        break;
    }
  }

  // It is called just before the controller is deleted from memory.
  // @override
  // onClose() {
  //   super.onClose();
  // }

  getUpcomingMovies(Map<String, dynamic> query) {
    isLoading.value = true;
    _appRepo.getMovies(query).then((value) {
      isLoading.value = false;
      movies.value = value;
    }).onError((error, stackTrace) {
      isLoading.value = false;
      this.error.value = error.toString();
      return Future.error(error!);
    });
  }

  getMovies(Map<String, dynamic> query) {
    isLoading.value = true;
    _appRepo.getMovies(query).then((value) {
      isLoading.value = false;
      movies.value = value;
    }).onError((error, stackTrace) {
      isLoading.value = false;
      this.error.value = error.toString();
      return Future.error(error!);
    });
  }
}
