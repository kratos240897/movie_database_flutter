import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:movie_database/helpers/utils.dart';
import 'package:movie_database/repo/app_repo.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  var movies = RxList.empty();
  final error = ''.obs;
  final _appRepo = Get.put(AppRepository());
  var selectedCategory = 'Top rated'.obs;
  var isInternetAvailable = false.obs;
  final List<String> categories = [
    'Top rated',
    'Popular',
    'New',
    'Upcoming',
    'GOAT'
  ];

  @override
  void onInit() {
    Utils().getConnectivity.connectivityStream.stream.listen((event) {
      if (event == ConnectivityResult.none) {
        isInternetAvailable.value = false;
        Utils().showSnackBar('Internet Connection', 'No Connection', false);
      } else {
        isInternetAvailable.value = true;
        Utils().showSnackBar('Internet Connection', 'Back Online', true);
        if (movies.isEmpty) {
          getMovies({
            'primary_release_date.gte': '2021-12-15',
            'primary_release_date.lte': '2022-01-10'
          });
        }
      }
    });
    super.onInit();
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
      default:
        getMovies({
          'primary_release_date.gte': '2021-12-15',
          'primary_release_date.lte': '2022-01-10'
        });
        break;
    }
  }

  // It is called just before the controller is deleted from memory.
  @override
  onClose() {
    super.onClose();
  }

  getMovies(Map<String, dynamic> query) {
    _appRepo
        .getMovies(query)
        .then((value) => movies.value = value)
        .onError((error, stackTrace) {
      this.error.value = error.toString();
      return Future.error(error!);
    });
  }
}
