import 'package:get/get.dart';
import 'package:movie_database/base/base_controller.dart';
import 'package:movie_database/repo/app_repo.dart';
import '../../data/models/credits_response.dart';
import '../../data/models/review_response.dart';

class MovieDetailController extends BaseController {
  final AppRepository _appRepo = Get.find<AppRepository>();
  final RxList<String> videoId = RxList.empty();
  final RxList<ReviewResults> reviews = RxList.empty();
  final RxList<Cast> cast = RxList.empty();
  final RxBool isLoading = true.obs;
  var movieId = '';

  @override
  void onReady() {
    init();
    super.onReady();
  }

  init() async {
    await getVideoDetails(movieId);
    await getCredits(movieId);
    await getMovieReviews(movieId);
    Future.delayed(const Duration(milliseconds: 400), () {
      isLoading.value = false;
    });
  }

  Future<void> getCredits(String id) async {
    utils.showLoading();
    _appRepo.getCredits(id).then((value) {
      utils.hideLoading();
      cast.value = value;
    }).onError((error, stackTrace) {
      utils.hideLoading();
      this.error.value = error.toString();
    });
  }

  Future<void> getMovieReviews(String id) async {
    utils.showLoading();
    _appRepo.getMovieReviews(id).then((value) {
      utils.hideLoading();
      reviews.value = value;
    }).onError((error, stackTrace) {
      utils.hideLoading();
      this.error.value = error.toString();
    });
  }

  Future<void> getVideoDetails(String id) async {
    utils.showLoading();
    _appRepo.getVideoDetails(id).then((value) {
      utils.hideLoading();
      value.every((element) {
        if (element.key != null) {
          videoId.add(element.key!);
        }
        return true;
      });
    }).onError((error, stackTrace) {
      utils.hideLoading();
      this.error.value = error.toString();
    });
  }
}
