import 'package:movie_database/repo/app_repo.dart';
import 'package:get/get.dart';
import 'package:movie_database/service/internet_controller.dart';

class HomeController extends GetxController {
  var movies = RxList.empty();
  final error = ''.obs;
  final AppRepository _appRepo = Get.find<AppRepository>();
  final InternetController _internetController = Get.find<InternetController>();
  //final _utils = Utils();
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
    super.onInit();
  }

  @override
  void onReady() {
    _internetController.isInternetAvailable.listen((data) {
      if (data) {
        isInternetAvailable.value = true;
        getMovies({
          'primary_release_date.gte': '2021-12-15',
          'primary_release_date.lte': '2022-01-10'
        });
      } else {
        isInternetAvailable.value = false;
      }
    });
  }

  addFavorite() {
    favoritesCount.value++;
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
  // @override
  // onClose() {
  //   super.onClose();
  // }

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
