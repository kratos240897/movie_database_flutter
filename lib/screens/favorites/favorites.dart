// ignore_for_file: unused_import

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/state_manager.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:movie_database/helpers/boxes.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:movie_database/helpers/constants.dart';
import 'package:movie_database/models/movie_model.dart';
import './favorites_controller.dart';

class Favorties extends GetView<FavoritesController> {
  const Favorties({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text('Favorites',
              style: TextStyle(
                  fontSize: 25.0,
                  fontFamily: GoogleFonts.caveat().copyWith().fontFamily))),
      body: SafeArea(
          child: ValueListenableBuilder(
              valueListenable: Boxes.getFavorites().listenable(),
              builder: (context, Box<Movie> box, child) {
                final favorites = box.values.toList().cast<Movie>();
                return SearchedMovieItem(movies: favorites);
              })),
    );
  }
}

class SearchedMovieItem extends StatelessWidget {
  final List<Movie> movies;
  const SearchedMovieItem({Key? key, required this.movies}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: movies.length,
        itemBuilder: (context, index) {
          double vote = (movies[index].voteAverage / 2.0) as double;
          String rating = vote.toStringAsFixed(1);
          return LayoutBuilder(builder: (context, constraints) {
            return Container(
              margin: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: constraints.maxWidth * 0.2 / 2,
                    backgroundImage: CachedNetworkImageProvider(
                        Constants.BASE_IMAGE_URL +
                            movies[index].posterPath.toString()),
                  ),
                  const SizedBox(width: 10.0),
                  SizedBox(
                    width: constraints.maxWidth * 0.53,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(movies[index].title,
                            style: TextStyle(
                                fontSize: 16.0,
                                fontFamily: GoogleFonts.quicksand().fontFamily,
                                fontWeight: FontWeight.bold)),
                        Text(movies[index].overview,
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
                    flex: 3,
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
          });
        });
  }
}
