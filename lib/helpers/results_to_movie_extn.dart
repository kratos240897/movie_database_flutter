import '../data/models/movie_model.dart';
import '../data/models/movies_response.dart';

extension ResultsToMovie on List<Results> {
  List<Movie> parseResults() {
    final List<Movie> movies = [];
    for (var element in this) {
      final movie = Movie()
        ..adult = element.adult ?? false
        ..backdropPath = element.backdropPath
        ..genreIds = element.genreIds ?? []
        ..id = element.id ?? 0
        ..originalLanguage = element.originalLanguage ?? '--'
        ..overview = element.overview ?? '--'
        ..popularity = element.popularity ?? 0.0
        ..posterPath = element.posterPath
        ..releaseDate = element.releaseDate ?? '--'
        ..title = element.title ?? '--'
        ..video = element.video ?? false
        ..voteAverage = element.voteAverage ?? 0.0
        ..voteCount = element.voteCount ?? 0
        ..originalTitle = element.originalTitle ?? (element.title ?? '--');
      movies.add(movie);
    }
    return movies;
  }
}
