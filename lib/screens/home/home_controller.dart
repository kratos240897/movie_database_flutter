// ignore_for_file: avoid_print

import 'package:movie_database/repo/app_repo.dart';
import 'package:get/get.dart';

class HomeController extends SuperController {
  var movies = RxList.empty();
  final error = ''.obs;
  final _appRepo = Get.put(AppRepository());
  var selectedCategory = 'Top rated'.obs;
  final List<String> categories = [
    'Top rated',
    'Popular',
    'New',
    'Upcoming',
    'GOAT'
  ];

  @override
  void onInit() {
    getMovies({
      'primary_release_date.gte': '2021-12-15',
      'primary_release_date.lte': '2022-01-10'
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

  @override
  void onDetached() {
    print('onDetached');
  }

  @override
  void onInactive() {
    print('onInactive');
  }

  @override
  void onPaused() {
    print('onPaused');
  }

  @override
  void onResumed() async {
    //getMovies();
    print('onResumed');
  }
}
