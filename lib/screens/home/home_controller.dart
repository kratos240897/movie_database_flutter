import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_app_badger/flutter_app_badger.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../base/base_controller.dart';
import '../../data/cache/cache_constants.dart';
import '../../data/cache/cache_repository.dart';
import '../../data/models/movie_model.dart';
import '../../data/models/movies_response.dart';
import '../../enum/snackbar_status.dart';
import '../../helpers/boxes.dart';
import '../../helpers/end_points.dart';
import '../../repo/home_repo.dart';
import '../../service/theme_service.dart';

class HomeController extends BaseController {
  final RxList<Results> movies = RxList.empty();
  final HomeRepository _repo = Get.find<HomeRepository>();
  final favoritesCount = 0.obs;
  final isLoading = false.obs;
  final selectedIndex = 0.obs;
  RxBool isDarkMode = false.obs;
  late String _startDate;
  late String _endDate;

  @override
  void onInit() async {
    isDarkMode.value = ThemeService().getThemeMode() == ThemeMode.dark;
    favoritesCount.value = Boxes.getFavorites().length;
    _startDate = DateFormat('yyyy-MM-dd')
        .format(DateTime.now().subtract(const Duration(days: 30)));
    _endDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
    super.onInit();
  }

  Future<void> changeTheme() async {
    ThemeService().changeThemeMode().then((_) {
      isDarkMode.value = ThemeService().getThemeMode() == ThemeMode.dark;
      utils.showSnackBar(
          'Theme',
          isDarkMode.value ? 'Switched to Dark Mode' : 'Switched to Light Mode',
          SnackBarStatus.info);
    });
  }

  @override
  void onReady() async {
    Future.delayed(const Duration(seconds: 3), () async {
      if (isNetworkAvailable.value == true) {
        getMovies(EndPoints.trending, {});
      }
    });
    FlutterAppBadger.updateBadgeCount(1);
    super.onReady();
  }

  addFavorite(Results result) {
    favoritesCount.value++;
    final movie = Movie()
      ..adult = result.adult ?? false
      ..backdropPath = result.backdropPath
      ..genreIds = result.genreIds ?? []
      ..id = result.id ?? 0
      ..originalLanguage = result.originalLanguage ?? '--'
      ..overview = result.overview ?? '--'
      ..popularity = result.popularity ?? 0.0
      ..posterPath = result.posterPath
      ..releaseDate = result.releaseDate ?? '--'
      ..title = result.title ?? '--'
      ..video = result.video ?? false
      ..voteAverage = result.voteAverage ?? 0.0
      ..voteCount = result.voteCount ?? 0
      ..originalTitle = result.originalTitle ?? (result.title ?? '--');
    final box = Boxes.getFavorites();
    box.add(movie);
    utils.showSnackBar('Added to Favorites', movie.title, SnackBarStatus.info);
  }

  Future<void> setSelectedCategory(int index) async {
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
            'primary_release_date.gte': _startDate,
            'primary_release_date.lte': _endDate
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
        if (CacheRepo.homeCache.get(CacheConstants.KEY_UPCOMING) != null) {
          movies.value = await CacheRepo.homeCache
              .get(CacheConstants.KEY_UPCOMING) as List<Results>;
        } else {
          getMovies(EndPoints.upcoming, {});
        }
        break;
      case 4:
        if (CacheRepo.homeCache.get(CacheConstants.KEY_TV_SHOWS) != null) {
          movies.value = await CacheRepo.homeCache
              .get(CacheConstants.KEY_TV_SHOWS) as List<Results>;
        } else {
          getMovies(EndPoints.tvShows, {});
        }
        break;
    }
  }

  getMovies(String url, Map<String, dynamic> query) {
    isLoading.value = true;
    _repo.getMovies(url, query).then((value) {
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
