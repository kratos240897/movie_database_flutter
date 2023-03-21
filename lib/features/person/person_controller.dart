import 'package:get/get.dart';
import '../../core/base/base_controller.dart';
import '../../core/base/service_locator.dart';
import '../../core/components/custom_late.dart';
import '../../core/constants/enums/snackbar_status.dart';
import '../movie_detail/data/models/profile_response.dart';
import '../movie_detail/domain/usecases/get_person.dart';

class PersonController extends BaseController {
  final isAppBarExtended = false.obs;
  Late<ProfileResponse> profile = Late();

  getPerson(String id) {
    utils.showLoading();
    serviceLocator<GetPerson>().getPerson(id).then((value) {
      value.fold((failure) {
        utils.hideLoading();
        utils.showSnackBar('Failure', failure.message, SnackBarStatus.failure);
      }, (data) {
        profile.val = data;
        utils.hideLoading();
      });
    });
  }
}
