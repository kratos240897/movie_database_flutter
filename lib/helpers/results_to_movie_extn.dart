import '../data/models/movie_model.dart';
import '../data/models/movies_response.dart';

extension ResultsToMovie on List<Results> {
  List<Movie> parseResults() {
    final List<Movie> movies = [];
    for (var element in this) {
      final movie = Movie()
        ..adult = element.adult
        ..backdropPath = element.backdropPath
        ..genreIds = element.genreIds
        ..id = element.id
        ..originalLanguage = element.originalLanguage
        ..overview = element.overview
        ..popularity = element.popularity
        ..posterPath = element.posterPath
        ..releaseDate = element.releaseDate
        ..title = element.title
        ..video = element.video
        ..voteAverage = element.voteAverage
        ..voteCount = element.voteCount
        ..originalTitle = element.originalTitle;
      movies.add(movie);
    }
    return movies;
  }
}
