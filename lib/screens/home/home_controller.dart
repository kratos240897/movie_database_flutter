// ignore: unused_import
// ignore_for_file: unnecessary_import

import 'dart:async';
import 'package:movie_database/base/base_controller.dart';
import 'package:movie_database/data/cache/cache_constants.dart';
import 'package:movie_database/data/cache/cache_repository.dart';
import 'package:movie_database/helpers/boxes.dart';
import 'package:movie_database/helpers/constants.dart';
import 'package:movie_database/helpers/helpers.dart';
import 'package:movie_database/helpers/utils.dart';
import 'package:movie_database/repo/app_repo.dart';
import 'package:get/get.dart';
import 'package:movie_database/routes/router.dart';
import 'package:movie_database/service/auth_service.dart';

import '../../data/models/movie_model.dart';
import '../../data/models/movies_response.dart';

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

  setSelectedCategory(int index) async {
    selectedIndex.value = index;
    switch (selectedIndex.value) {
      case 0:
        if (CacheRepo.homeCache.get(CacheConstants.KEY_NOW_PLAYING) != null) {
          movies.value = await CacheRepo.homeCache
              .get(CacheConstants.KEY_NOW_PLAYING) as List<Results>;
        } else {
          getMovies(EndPoints.trending, {});
        }
        break;
      case 1:
        if (CacheRepo.homeCache.get(CacheConstants.KEY_NEW) != null) {
          movies.value = await CacheRepo.homeCache.get(CacheConstants.KEY_NEW)
              as List<Results>;
        } else {
          getMovies(EndPoints.discover, {
            'primary_release_date.gte': '2022-07-01',
            'primary_release_date.lte': '2022-08-09'
          });
        }
        break;
      case 2:
        if (CacheRepo.homeCache.get(CacheConstants.KEY_TOP_RATED) != null) {
          movies.value = await CacheRepo.homeCache
              .get(CacheConstants.KEY_TOP_RATED) as List<Results>;
        } else {
          getMovies(EndPoints.topRated, {});
        }
        break;
      case 3:
        if (CacheRepo.homeCache.get(CacheConstants.KEY_TV_SHOWS) != null) {
          movies.value = await CacheRepo.homeCache
              .get(CacheConstants.KEY_TV_SHOWS) as List<Results>;
        } else {
          getMovies(EndPoints.upcoming, {});
        }
        break;
      case 4:
        if (CacheRepo.homeCache.get(CacheConstants.KEY_UPCOMING) != null) {
          movies.value = await CacheRepo.homeCache
              .get(CacheConstants.KEY_UPCOMING) as List<Results>;
        } else {
          getMovies(EndPoints.tvShows, {});
        }
        break;
    }
  }

  getMovies(String url, Map<String, dynamic> query) {
    isLoading.value = true;
    _appRepo.getMovies(url, query).then((value) {
      cacheResponse(value);
      isLoading.value = false;
      movies.value = value;
    }).onError((error, stackTrace) {
      isLoading.value = false;
      this.error.value = error.toString();
      return Future.error(error!);
    });
  }

  cacheResponse(List<Results> value) {
    switch (selectedIndex.value) {
      case 0:
        CacheRepo.homeCache.set(CacheConstants.KEY_NOW_PLAYING, value);
        break;
      case 1:
        CacheRepo.homeCache.set(CacheConstants.KEY_NEW, value);
        break;
      case 2:
        CacheRepo.homeCache.set(CacheConstants.KEY_TOP_RATED, value);
        break;
      case 3:
        CacheRepo.homeCache.set(CacheConstants.KEY_TV_SHOWS, value);
        break;
      case 4:
        CacheRepo.homeCache.set(CacheConstants.KEY_UPCOMING, value);
        break;
    }
  }
}
