import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:movie_database/helpers/styles.dart';
import 'package:movie_database/models/movies_response.dart';
import 'package:movie_database/helpers/constants.dart';

class MovieDetailScreen extends StatelessWidget {
  final Results movie;
  const MovieDetailScreen({Key? key, required this.movie}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text(movie.title),
      ),
      body: SingleChildScrollView(
        child: Column(children: [
          SizedBox(
              width: double.infinity,
              height: mediaQuery.height * 0.5,
              child: Hero(
                tag: movie,
                transitionOnUserGestures: true,
                child: Image.network(
                    movie.backdropPath != null
                        ? Constants.IMAGE_BASE_URL +
                            movie.backdropPath.toString()
                        : Constants.IMAGE_BASE_URL +
                            movie.posterPath.toString(),
                    filterQuality: FilterQuality.high,
                    fit: BoxFit.cover),
              )),
          const SizedBox(height: 5.0),
          RatingBarIndicator(
              rating: (movie.voteAverage / 2).toDouble(),
              direction: Axis.horizontal,
              itemCount: 5,
              itemSize: 30.0,
              itemPadding: const EdgeInsets.symmetric(horizontal: 2.0),
              itemBuilder: (ctx, index) => const Icon(
                    Icons.star,
                    color: Colors.amber,
                  )),
          const SizedBox(height: 3),
          Text((movie.voteAverage / 2).toString(),
              style: Styles.textStyles.f14),
          Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 5, right: 5),
                child: Text('${movie.voteCount} votes',
                    style: TextStyle(
                        fontSize: 12.0,
                        fontFamily: GoogleFonts.jost().fontFamily)),
              ),
              const Icon(Icons.volunteer_activism_sharp, color: Colors.red)
            ],
          ),
          const SizedBox(height: 18),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(movie.title,
                textAlign: TextAlign.start,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Styles.colors.primaryColor,
                    fontFamily: GoogleFonts.actor().fontFamily)),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(movie.overview,
                textAlign: TextAlign.start,
                style: TextStyle(
                    height: 1.2,
                    wordSpacing: 3.0,
                    fontSize: 16,
                    fontFamily: GoogleFonts.actor().fontFamily)),
          )
        ]),
      ),
    );
  }
}
