import 'package:get/get.dart';
import 'package:movie_database/base/base_controller.dart';
import '../../data/models/profile_response.dart';
import '../../repo/app_repo.dart';

class PersonController extends BaseController {
  final isLoaded = false.obs;
  late final ProfileResponse profile;
  final AppRepository _appRepo = Get.find<AppRepository>();

  getPerson(String id) {
    utils.showLoading();
    _appRepo.getPerson(id).then((value) {
      isLoaded.value = true;
      profile = value;
      utils.hideLoading();
    }).onError((error, stackTrace) {
      this.error.value = error.toString();
      utils.hideLoading();
    });
  }
}
