import 'package:get/get.dart';
import '../../base/base_controller.dart';
import '../../base/custom_late.dart';
import '../../data/models/profile_response.dart';
import '../../repo/movie_detail_repo.dart';

class PersonController extends BaseController {
  final isAppBarExtended = false.obs;
  Late<ProfileResponse> profile = Late();
  final MovieDetailRepository _repo = Get.find<MovieDetailRepository>();

  getPerson(String id) {
    utils.showLoading();
    _repo.getPerson(id).then((value) {
      profile.val = value;
      utils.hideLoading();
    }).onError((error, stackTrace) {
      this.error.value = error.toString();
      utils.hideLoading();
    });
  }
}
