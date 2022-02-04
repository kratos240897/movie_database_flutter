import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';

class FavoritesController extends GetxController {
  @override
  void dispose() {
    Hive.close();
    super.dispose();
  }
}
