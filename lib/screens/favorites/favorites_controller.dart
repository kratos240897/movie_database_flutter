import 'package:hive_flutter/hive_flutter.dart';
import 'package:movie_database/base/base_controller.dart';

class FavoritesController extends BaseController {
  @override
  void dispose() {
    Hive.close();
    super.dispose();
  }
}
