class EndPoints {
  static const topRated = '/movie/top_rated';
  static const trending = '/trending/movie/day';
  static const tvShows = '/tv/top_rated';
  static const discover = '/discover/movie';
  static const upcoming = '/movie/upcoming';
  static const search = '/search/movie';
  static reviews(String movieId) => '/movie/$movieId/reviews';
  static videos(String movieId) => '/movie/$movieId/videos';
  static credits(String movieId) => '/movie/$movieId/credits';
  static person(String personId) => '/person/$personId';
  static providers(String movieId) => '/movie/$movieId/watch/providers';
  static details(String movieId) => '/movie/$movieId';
}
