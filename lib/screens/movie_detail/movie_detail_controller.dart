import 'package:get/get.dart';
import 'package:movie_database/models/review_response.dart';
import 'package:movie_database/repo/app_repo.dart';

import '../../helpers/utils.dart';

class MovieDetailController extends GetxController {
  final _utils = Utils();
  final AppRepository _appRepo = Get.find<AppRepository>();
  final error = ''.obs;
  final RxList<ReviewResults> reviews = RxList.empty();

  void getMovieReviews(String id) {
    _utils.showLoading();
    _appRepo.getMovieReviews(id).then((value) {
      _utils.hideLoading();
      reviews.value = value;
    }).onError((error, stackTrace) {
      _utils.hideLoading();
      this.error.value = error.toString();
    });
  }
}
