import 'package:hive/hive.dart';
import 'package:movie_database/helpers/constants.dart';
import 'package:movie_database/models/movie_model.dart';

class Boxes {
  static Box<Movie> getFavorites() => Hive.box(Constants.DB_NAME);
}
