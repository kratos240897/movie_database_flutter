import 'package:get/get.dart';
import '../../base/base_controller.dart';
import '../../data/models/credits_response.dart';
import '../../data/models/review_response.dart';
import '../../repo/movie_detail_repo.dart';

class MovieDetailController extends BaseController {
  final MovieDetailRepository _repo = Get.find<MovieDetailRepository>();
  final RxList<String> videoId = RxList.empty();
  final RxList<ReviewResults> reviews = RxList.empty();
  final RxList<Cast> cast = RxList.empty();
  var movieId = '';

  init() async {
    utils.showLoading();
    await getVideoDetails(movieId);
    await getCredits(movieId);
    await getMovieReviews(movieId);
    utils.hideLoading();
  }

  Future<void> getCredits(String id) async {
    _repo.getCredits(id).then((value) {
      cast.value = value;
    }).onError((error, stackTrace) {
      this.error.value = error.toString();
    });
  }

  Future<void> getMovieReviews(String id) async {
    _repo.getMovieReviews(id).then((value) {
      reviews.value = value;
    }).onError((error, stackTrace) {
      this.error.value = error.toString();
    });
  }

  Future<void> getVideoDetails(String id) async {
    _repo.getVideoDetails(id).then((value) {
      value.every((element) {
        if (element.key != null) {
          videoId.add(element.key!);
        }
        return true;
      });
    }).onError((error, stackTrace) {
      this.error.value = error.toString();
    });
  }
}
