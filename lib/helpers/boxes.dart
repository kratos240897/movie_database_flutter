import 'package:hive/hive.dart';
import '../data/models/movie_model.dart';
import 'constants.dart';

class Boxes {
  static Box<Movie> getFavorites() => Hive.box(Constants.DB_NAME);
}
