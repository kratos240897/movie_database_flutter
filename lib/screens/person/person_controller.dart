import 'package:get/get.dart';
import 'package:movie_database/models/profile_response.dart';
import '../../helpers/utils.dart';
import '../../repo/app_repo.dart';

class PersonController extends GetxController {
  final error = ''.obs;
  final _utils = Utils();
  final Rx<ProfileResponse>? profile = null;
  final AppRepository _appRepo = Get.find<AppRepository>();

  getPerson(String id) {
    _utils.showLoading();
    _appRepo.getPerson(id).then((value) {
      profile!.value = value;
      _utils.hideLoading();
    }).onError((error, stackTrace) {
      this.error.value = error.toString();
      _utils.hideLoading();
    });
  }
}
