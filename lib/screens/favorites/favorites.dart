// ignore_for_file: unused_import

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/state_manager.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../data/models/movie_model.dart';
import '../../helpers/boxes.dart';
import '../../helpers/constants.dart';
import './favorites_controller.dart';

class Favorties extends GetView<FavoritesController> {
  const Favorties({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          leading: IconButton(
            onPressed: () => Get.back(),
            icon: Icon(
              CupertinoIcons.back,
              size: 20.h,
              color: Theme.of(context).textTheme.headline6?.color,
            ),
          ),
          centerTitle: false,
          title: Text('Favorites',
              style: Theme.of(context).textTheme.headline6?.copyWith(
                  fontSize: 22.sp,
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
      padding: const EdgeInsets.only(right: 8.0),
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
          Expanded(
            flex: 4,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(movie.title,
                    style: Theme.of(context).textTheme.headline6?.copyWith(
                        fontSize: 14.sp,
                        fontFamily: GoogleFonts.quicksand().fontFamily,
                        fontWeight: FontWeight.bold)),
                Text(movie.overview,
                    style: Theme.of(context).textTheme.headline6?.copyWith(
                          fontSize: 14.sp,
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
              style: Theme.of(context)
                  .textTheme
                  .headline6
                  ?.copyWith(fontSize: 14.sp),
            ),
          ),
        ],
      ),
    );
  }
}
