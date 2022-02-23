import 'package:get/get.dart';
import 'package:movie_database/models/credits_response.dart';
import 'package:movie_database/models/review_response.dart';
import 'package:movie_database/repo/app_repo.dart';

import '../../helpers/utils.dart';

class MovieDetailController extends GetxController {
  final _utils = Utils();
  final AppRepository _appRepo = Get.find<AppRepository>();
  final error = ''.obs;
  final RxList<String> videoId = RxList.empty();
  final RxList<ReviewResults> reviews = RxList.empty();
  final RxList<Cast> cast = RxList.empty();

  void getCredits(String id) {
    _utils.showLoading();
    _appRepo.getCredits(id).then((value) {
      _utils.hideLoading();
      cast.value = value;
    }).onError((error, stackTrace) {
      _utils.hideLoading();
      this.error.value = error.toString();
    });
  }

  void getMovieReviews(String id) {
    _utils.showLoading();
    _appRepo.getMovieReviews(id).then((value) {
      _utils.hideLoading();
      reviews.value = value;
      getCredits(id);
    }).onError((error, stackTrace) {
      _utils.hideLoading();
      this.error.value = error.toString();
    });
  }

  void getVideoDetails(String id) {
    _utils.showLoading();
    _appRepo.getVideoDetails(id).then((value) {
      _utils.hideLoading();
      value.every((element) {
        if (element.key != null) {
          videoId.add(element.key!);
        }
        return true;
      });
    }).onError((error, stackTrace) {
      _utils.hideLoading();
      this.error.value = error.toString();
    });
  }
}
