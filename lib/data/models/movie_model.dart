import 'package:hive/hive.dart';
part 'movie_model.g.dart';

@HiveType(typeId: 0)
class Movie extends HiveObject {
  @HiveField(0)
  late final bool adult;
  @HiveField(1)
  late final String? backdropPath;
  @HiveField(2)
  late final List<int> genreIds;
  @HiveField(3)
  late final int id;
  @HiveField(4)
  late final String originalLanguage;
  @HiveField(5)
  late final String originalTitle;
  @HiveField(6)
  late final String overview;
  @HiveField(7)
  late final double popularity;
  @HiveField(8)
  late final String? posterPath;
  @HiveField(9)
  late final String releaseDate;
  @HiveField(10)
  late final String title;
  @HiveField(11)
  late final bool video;
  @HiveField(12)
  late final dynamic voteAverage;
  @HiveField(13)
  late final int voteCount;
}
