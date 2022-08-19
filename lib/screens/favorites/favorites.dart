// ignore_for_file: unused_import

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/state_manager.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:movie_database/data/models/movies_response.dart';
import 'package:movie_database/helpers/boxes.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:movie_database/helpers/constants.dart';
import '../../data/models/movie_model.dart';
import './favorites_controller.dart';

class Favorties extends GetView<FavoritesController> {
  const Favorties({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          centerTitle: false,
          title: Text('Favorites',
              style: TextStyle(
                  fontSize: 22.0,
                  fontFamily:
                      GoogleFonts.josefinSans().copyWith().fontFamily))),
      body: SafeArea(
          child: ValueListenableBuilder(
              valueListenable: Boxes.getFavorites().listenable(),
              builder: (context, Box<Movie> box, child) {
                final favorites = box.values.toList().cast<Movie>();
                return FavoritesListWidget(movies: favorites);
              })),
    );
  }
}

class FavoritesListWidget extends StatelessWidget {
  final List<Movie> movies;
  const FavoritesListWidget({Key? key, required this.movies}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        itemCount: movies.length,
        itemBuilder: (context, index) {
          final movie = movies[index];
          final double vote = (movie.voteAverage / 2.0) as double;
          final String rating = vote.toStringAsFixed(1);
          return FavoritesItem(movie: movie, vote: vote, rating: rating);
        });
  }
}

class FavoritesItem extends StatelessWidget {
  final Movie movie;
  final double vote;
  final String rating;
  const FavoritesItem(
      {Key? key, required this.movie, required this.vote, required this.rating})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: AspectRatio(
              aspectRatio: 16 / 9,
              child: CircleAvatar(
                backgroundImage: CachedNetworkImageProvider(
                  Constants.BASE_IMAGE_URL + movie.posterPath.toString(),
                ),
              ),
            ),
          ),
          const SizedBox(width: 10.0),
          Expanded(
            flex: 7,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(movie.title,
                    style: TextStyle(
                        fontSize: 16.0,
                        fontFamily: GoogleFonts.quicksand().fontFamily,
                        fontWeight: FontWeight.bold)),
                Text(movie.overview,
                    style: TextStyle(
                      fontFamily: GoogleFonts.quicksand().fontFamily,
                    ),
                    maxLines: 4,
                    overflow: TextOverflow.ellipsis),
              ],
            ),
          ),
          const Spacer(),
          Expanded(
            flex: 1,
            child: Text(
              '⭐ ' + rating,
              textAlign: TextAlign.start,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
