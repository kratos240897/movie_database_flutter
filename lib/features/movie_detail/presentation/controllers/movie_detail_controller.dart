import 'package:get/get.dart';
import '../../../../core/base/base_controller.dart';
import '../../../../core/base/service_locator.dart';
import '../../../../core/constants/enums/snackbar_status.dart';
import '../../data/models/credits_response.dart';
import '../../data/models/review_response.dart';
import '../../domain/usecases/get_credits.dart';
import '../../domain/usecases/get_movie_reviews.dart';
import '../../domain/usecases/get_video_details.dart';

class MovieDetailController extends BaseController {
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
    serviceLocator<GetCredits>().getCredits(id).then((value) {
      value.fold(
          (failure) => utils.showSnackBar(
              'Failure', failure.message, SnackBarStatus.failure),
          (data) => cast.value = data);
    });
  }

  Future<void> getMovieReviews(String id) async {
    serviceLocator<GetMovieReviews>().getMovieReviews(id).then((value) {
      value.fold(
          (failure) => utils.showSnackBar(
              'Failure', failure.message, SnackBarStatus.failure),
          (data) => reviews.value = data);
    });
  }

  Future<void> getVideoDetails(String id) async {
    serviceLocator<GetVideoDetails>().getVideoDetails(id).then((value) {
      value.fold(
          (failure) => utils.showSnackBar(
              'Failure', failure.message, SnackBarStatus.failure), (data) {
        for (var element in data) {
          videoId.add(element.key ?? '');
        }
      });
    });
  }
}
