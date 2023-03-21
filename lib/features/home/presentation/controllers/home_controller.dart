import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_app_badger/flutter_app_badger.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../../core/base/base_controller.dart';
import '../../../../core/base/service_locator.dart';
import '../../../../core/constants/app/end_points.dart';
import '../../../../core/constants/enums/snackbar_status.dart';
import '../../../../core/data/cache/cache_constants.dart';
import '../../../../core/data/models/movie_model.dart';
import '../../data/models/movies_response.dart';
import '../../../../core/init/local_storage/boxes.dart';
import '../../../../core/service/theme_service.dart';
import '../../domain/usecases/get_movies_from_cache.dart';
import '../../domain/usecases/get_movies_from_server.dart';
import '../../domain/usecases/put_movies_to_cache.dart';

class HomeController extends BaseController {
  final _getCacheUsecase = serviceLocator<GetMoviesFromCache>();
  final _putCacheUsecase = serviceLocator<PutMoviesToCache>();
  final RxList<Results> movies = RxList.empty();
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
        _getCacheUsecase
            .getMoviesFromCache(CacheConstants.KEY_NOW_PLAYING)
            .then((value) {
          value.fold((_) => getMovies(EndPoints.trending, {}),
              (data) => movies.value = data);
        });
        break;
      case 1:
        _getCacheUsecase
            .getMoviesFromCache(CacheConstants.KEY_NEW)
            .then((value) {
          value.fold(
              (_) => getMovies(EndPoints.discover, {
                    'primary_release_date.gte': _startDate,
                    'primary_release_date.lte': _endDate
                  }),
              (data) => movies.value = data);
        });
        break;
      case 2:
        _getCacheUsecase
            .getMoviesFromCache(CacheConstants.KEY_TOP_RATED)
            .then((value) {
          value.fold((_) => getMovies(EndPoints.topRated, {}),
              (data) => movies.value = data);
        });
        break;
      case 3:
        _getCacheUsecase
            .getMoviesFromCache(CacheConstants.KEY_UPCOMING)
            .then((value) {
          value.fold((_) => getMovies(EndPoints.upcoming, {}),
              (data) => movies.value = data);
        });
        break;
      case 4:
        _getCacheUsecase
            .getMoviesFromCache(CacheConstants.KEY_TV_SHOWS)
            .then((value) {
          value.fold((_) => getMovies(EndPoints.tvShows, {}),
              (data) => movies.value = data);
        });
        break;
    }
  }

  getMovies(String url, Map<String, dynamic> query) async {
    isLoading.value = true;
    final result = await serviceLocator<GetMoviesFromServer>()
        .getMoviesFromServer(url, query);
    result.fold((failure) {
      isLoading.value = false;
      utils.showSnackBar('Failure', failure.message, SnackBarStatus.failure);
    }, (data) {
      isLoading.value = false;
      cacheResponse(data);
      movies.value = data;
    });
  }

  cacheResponse(List<Results> value) {
    switch (selectedIndex.value) {
      case 0:
        _putCacheUsecase.putMoviesToCache(
            CacheConstants.KEY_NOW_PLAYING, value);
        break;
      case 1:
        _putCacheUsecase.putMoviesToCache(CacheConstants.KEY_NEW, value);
        break;
      case 2:
        _putCacheUsecase.putMoviesToCache(CacheConstants.KEY_TOP_RATED, value);
        break;
      case 3:
        _putCacheUsecase.putMoviesToCache(CacheConstants.KEY_UPCOMING, value);
        break;
      case 4:
        _putCacheUsecase.putMoviesToCache(CacheConstants.KEY_TV_SHOWS, value);
        break;
    }
  }
}
