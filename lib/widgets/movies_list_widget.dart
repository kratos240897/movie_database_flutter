import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../data/models/movie_model.dart';
import '../helpers/constants.dart';

class MovieListWidget extends StatelessWidget {
  final List<Movie> movies;
  const MovieListWidget({Key? key, required this.movies}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
        separatorBuilder: (context, index) => Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.w),
              child: Divider(
                thickness: 0.1.h,
              ),
            ),
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        itemCount: movies.length,
        itemBuilder: (context, index) {
          final movie = movies[index];
          final double vote = (movie.voteAverage / 2.0) as double;
          final String rating = vote.toStringAsFixed(1);
          return MovieItem(movie: movie, vote: vote, rating: rating);
        });
  }
}

class MovieItem extends StatelessWidget {
  final Movie movie;
  final double vote;
  final String rating;
  const MovieItem(
      {Key? key, required this.movie, required this.vote, required this.rating})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(12.w, 8.h, 12.w, 8.h),
      child: Row(
        children: [
          CircleAvatar(
            radius: 30.r,
            backgroundImage: CachedNetworkImageProvider(
              Constants.BASE_IMAGE_URL + movie.posterPath.toString(),
            ),
          ),
          8.horizontalSpace,
          Expanded(
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
          8.horizontalSpace,
          Text(
            '⭐ ' + rating,
            textAlign: TextAlign.start,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context)
                .textTheme
                .headline6
                ?.copyWith(fontSize: 14.sp),
          ),
        ],
      ),
    );
  }
}
