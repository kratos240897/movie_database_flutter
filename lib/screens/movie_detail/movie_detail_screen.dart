import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/utils.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:movie_database/helpers/helpers.dart';
import 'package:movie_database/helpers/styles.dart';
import 'package:movie_database/models/movies_response.dart';
import 'package:movie_database/helpers/constants.dart';
import 'package:movie_database/routes/router.dart';
import 'package:movie_database/screens/movie_detail/movie_detail_controller.dart';

class MovieDetailScreen extends StatefulWidget {
  final Results movie;
  final MovieDetailController controller = Get.find<MovieDetailController>();
  MovieDetailScreen({Key? key, required this.movie}) : super(key: key);

  @override
  State<MovieDetailScreen> createState() => _MovieDetailScreenState();
}

class _MovieDetailScreenState extends State<MovieDetailScreen> {
  @override
  void initState() {
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      widget.controller.getMovieReviews(widget.movie.id.toString());
      widget.controller.getVideoDetails(widget.movie.id.toString());
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = Get.mediaQuery;
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.movie.title),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(children: [
            BackDropWidget(
                controller: widget.controller,
                movie: widget.movie,
                mediaQuery: mediaQuery),
            const SizedBox(height: 5.0),
            RatingDetailWidget(movie: widget.movie),
            const SizedBox(height: 18),
            MovieDetailWidget(movie: widget.movie),
            const SizedBox(height: 5.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Padding(
                    padding: const EdgeInsets.only(right: 12.0),
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Get.toNamed(AppRouter.REVIEWS,
                            arguments: widget.controller.reviews);
                      },
                      style: ElevatedButton.styleFrom(
                          shape: const StadiumBorder()),
                      icon: const Icon(Icons.reviews),
                      label: const Padding(
                        padding: EdgeInsets.symmetric(vertical: 12.0),
                        child:
                            Text('Reviews', style: TextStyle(fontSize: 16.0)),
                      ),
                    ))
              ],
            )
          ]),
        ),
      ),
    );
  }
}

class BackDropWidget extends StatelessWidget {
  final MovieDetailController controller;
  final Results movie;
  final MediaQueryData mediaQuery;
  const BackDropWidget(
      {Key? key,
      required this.movie,
      required this.mediaQuery,
      required this.controller})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () =>
          Get.toNamed(AppRouter.VIDEO, arguments: controller.videoId.value),
      child: Container(
        margin: const EdgeInsets.only(left: 8.0, right: 8.0, top: 8.0),
        width: double.infinity,
        height: mediaQuery.size.height * 0.325,
        child: Hero(
          tag: movie,
          transitionOnUserGestures: true,
          child: Stack(
            children: [
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                bottom: 0,
                child: Card(
                    elevation: 10.0,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0)),
                    clipBehavior: Clip.antiAliasWithSaveLayer),
              ),
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                bottom: 0,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10.0),
                  child: CachedNetworkImage(
                      imageUrl: movie.backdropPath != null
                          ? Constants.BASE_IMAGE_URL +
                              movie.backdropPath.toString()
                          : Constants.BASE_IMAGE_URL +
                              movie.posterPath.toString(),
                      filterQuality: FilterQuality.high,
                      fit: BoxFit.cover),
                ),
              ),
              Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10.0),
                    child: Container(
                      decoration: const BoxDecoration(color: Colors.black26),
                      child: const Center(
                          child: FaIcon(
                        FontAwesomeIcons.playCircle,
                        size: 40.0,
                        color: Colors.white70,
                      )),
                    ),
                  ))
            ],
          ),
        ),
      ),
    );
  }
}

class MovieDetailWidget extends StatelessWidget {
  final Results movie;
  const MovieDetailWidget({Key? key, required this.movie}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final dateTimeObj = DateTime.parse(movie.releaseDate);
    final formattedDate = DateFormat.yMMMEd().format(dateTimeObj);
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Text(movie.title,
              textAlign: TextAlign.start,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Styles.colors.themeColor,
                  fontFamily: GoogleFonts.actor().fontFamily)),
        ),
        Padding(
          padding: const EdgeInsets.all(3.0),
          child: Text(
            formattedDate,
            style: TextStyle(
                color: Styles.colors.themeColor,
                fontSize: 12.0,
                fontWeight: FontWeight.bold,
                letterSpacing: 2.0,
                fontFamily: GoogleFonts.spartan().fontFamily),
          ),
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
      ],
    );
  }
}

class RatingDetailWidget extends StatelessWidget {
  final Results movie;
  const RatingDetailWidget({Key? key, required this.movie}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
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
        Text((movie.voteAverage / 2).toString(), style: Styles.textStyles.f14),
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
      ],
    );
  }
}
