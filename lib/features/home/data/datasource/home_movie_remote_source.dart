import 'dart:io';
import 'package:dartz/dartz.dart';
import '../../../../core/base/failure.dart';
import '../../../../core/base/service_locator.dart';
import '../../../../core/service/api_service.dart';
import '../models/movies_response.dart';

abstract class HomeMovieRemoteDataSource {
  Future<Either<Failure, List<Results>>> getMoviesFromServer(
      String url, Map<String, dynamic> query);
}

class HomeMovieRemoteDataSourceImpl extends HomeMovieRemoteDataSource {
  @override
  Future<Either<Failure, List<Results>>> getMoviesFromServer(
      String url, Map<String, dynamic> query) async {
    try {
      final apiService = serviceLocator<ApiService>();
      final res = await apiService.getRequest(url, query);
      if (res.statusCode == 200) {
        final movies = MoviesResponse.fromJson(res.data).results;
        return Right(movies);
      }
      return Left(ConnectionFailure(message: res.data['message']));
    } on SocketException {
      return const Left(
          ConnectionFailure(message: 'Please check your internet connection'));
    } catch (e) {
      return const Left(
          ParsingFailure(message: 'Unable to parse the response'));
    }
  }
}
