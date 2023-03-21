import 'package:hive/hive.dart';
import '../../constants/app/app_constants.dart';
import '../../data/models/movie_model.dart';

class Boxes {
  static Box<Movie> getFavorites() => Hive.box(AppConstants.DB_NAME);
}
