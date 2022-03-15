// ignore_for_file: constant_identifier_names

class Constants {
  static const BASE_URL = 'https://api.themoviedb.org/3';
  static const BASE_IMAGE_URL = 'https://image.tmdb.org/t/p/original';
  static const API_KEY =
      'eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiI3MGFmMGIwNzUyZjE5Yzg4OTRiYzJlMjk3M2ZmZjM1NiIsInN1YiI6IjYxY2RhZDdjNzQ2NDU3MDAxYzdjYjlhMiIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.pn0m7QG6P8zfm0hELtEbuiq6v52g-qQcshcm-QstG1Q';
  static const BASE_YOUTUBE_URL = 'https://www.youtube.com/watch?v=';
  static const DB_NAME = 'favorites';
  static const USER_PREFS = 'user_prefs';
  static const KEY_LOGIN = 'login';
}

enum AuthStatus{
  loginSuccess,
  registrationSuccess,
  signoutSuccess
}
