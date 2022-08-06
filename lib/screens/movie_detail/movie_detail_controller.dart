import 'package:get/get.dart';
import 'package:movie_database/base/base_controller.dart';
import 'package:movie_database/models/credits_response.dart';
import 'package:movie_database/models/review_response.dart';
import 'package:movie_database/repo/app_repo.dart';

class MovieDetailController extends BaseController {
  final AppRepository _appRepo = Get.find<AppRepository>();
  final RxList<String> videoId = RxList.empty();
  final RxList<ReviewResults> reviews = RxList.empty();
  final RxList<Cast> cast = RxList.empty();
  var movieId = '';


  @override
  void onReady() async {
    getVideoDetails(movieId);
    getCredits(movieId);
    getMovieReviews(movieId);
    super.onReady();
  }

  void getCredits(String id) {
    utils.showLoading();
    _appRepo.getCredits(id).then((value) {
      utils.hideLoading();
      cast.value = value;
    }).onError((error, stackTrace) {
      utils.hideLoading();
      this.error.value = error.toString();
    });
  }

  void getMovieReviews(String id) {
    utils.showLoading();
    _appRepo.getMovieReviews(id).then((value) {
      utils.hideLoading();
      reviews.value = value;
    }).onError((error, stackTrace) {
      utils.hideLoading();
      this.error.value = error.toString();
    });
  }

  void getVideoDetails(String id) {
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
