import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/state_manager.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:movie_database/helpers/helpers.dart';
import 'package:movie_database/helpers/styles.dart';
import 'package:movie_database/helpers/utils.dart';
import 'package:movie_database/models/movies_response.dart';
import 'package:movie_database/helpers/constants.dart';
import 'package:movie_database/routes/router.dart';
import 'package:movie_database/screens/movie_detail/movie_detail_controller.dart';
import 'package:movie_database/screens/person/person.dart';
import 'package:movie_database/screens/person/person_binding.dart';

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
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      widget.controller.getMovieReviews(widget.movie.id.toString());
      widget.controller.getVideoDetails(widget.movie.id.toString());
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.movie.title),
      ),
      body: SafeArea(child: Obx(() {
        return widget.controller.isNetworkAvailable.value == true
            ? ContentWidget(controller: widget.controller, movie: widget.movie)
            : widget.controller.getNoInternetWidget;
      })),
    );
  }
}

class ContentWidget extends StatelessWidget {
  ContentWidget({Key? key, required this.controller, required this.movie})
      : super(key: key);
  final MovieDetailController controller;
  final Results movie;
  final mediaQuery = Get.mediaQuery;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 10.0),
            height: mediaQuery.size.height * 0.3,
            child: BackDropWidget(
                controller: controller, movie: movie, mediaQuery: mediaQuery),
          ),
          const SizedBox(height: 12.0),
          MovieDetailWidget(movie: movie),
          const SizedBox(height: 15.0),
          ReviewButton(controller: controller),
          Cast(controller: controller)
        ],
      ),
    );
  }
}

class Cast extends StatelessWidget {
  final MovieDetailController controller;
  const Cast({Key? key, required this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Container(
          height: 180.0,
          padding: const EdgeInsets.only(
              left: 8.0, right: 8.0, top: 5.0, bottom: 5.0),
          child: ListView.builder(
              itemCount: controller.cast.length,
              scrollDirection: Axis.horizontal,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return LayoutBuilder(builder: (context, constraints) {
                  return InkWell(
                    onTap: () => Get.to(
                        () => Person(
                            title: controller.cast[index].originalName,
                            id: controller.cast[index].id.toString()),
                        binding: PersonBinding()),
                    child: Container(
                      margin: const EdgeInsets.all(5.0),
                      child: Column(children: [
                        controller.cast[index].profilePath != null
                            ? CircleAvatar(
                                radius: constraints.maxHeight * 0.30,
                                backgroundColor: Colors.amber,
                                child: CircleAvatar(
                                  radius: constraints.maxHeight * 0.28,
                                  backgroundImage: CachedNetworkImageProvider(
                                      Constants.BASE_IMAGE_URL +
                                          controller.cast[index].profilePath
                                              .toString()),
                                ),
                              )
                            : CircleAvatar(
                                radius: constraints.maxHeight * 0.30,
                                backgroundColor: Colors.amber,
                                child: CircleAvatar(
                                  radius: constraints.maxHeight * 0.28,
                                  backgroundColor: Colors.white,
                                  backgroundImage: const AssetImage(
                                      'assets/images/actor.png'),
                                ),
                              ),
                        const SizedBox(height: 12.0),
                        ConstrainedBox(
                            constraints: BoxConstraints(
                                maxWidth: constraints.maxHeight * 0.60),
                            child: Text(
                              controller.cast[index].character,
                              textAlign: TextAlign.center,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ))
                      ]),
                    ),
                  );
                });
              }));
    });
  }
}

class ReviewButton extends StatelessWidget {
  final MovieDetailController controller;
  const ReviewButton({Key? key, required this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Padding(
            padding: const EdgeInsets.only(right: 12.0),
            child: ElevatedButton.icon(
              onPressed: () {
                Get.toNamed(AppRouter.REVIEWS, arguments: controller.reviews);
              },
              style: ElevatedButton.styleFrom(shape: const StadiumBorder()),
              icon: const Icon(Icons.reviews),
              label: const Padding(
                padding: EdgeInsets.symmetric(vertical: 12.0),
                child: Text('Reviews', style: TextStyle(fontSize: 16.0)),
              ),
            ))
      ],
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
      onTap: () {
        if (controller.videoId.isNotEmpty) {
          Get.toNamed(AppRouter.VIDEO, arguments: controller.videoId);
        } else {
          Utils().showSnackBar(
              'No videos found for movie', movie.originalTitle, false);
        }
      },
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
                    elevation: 15.0,
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
                        FontAwesomeIcons.solidPlayCircle,
                        size: 50.0,
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
        const SizedBox(height: 5.0),
        Padding(
          padding: const EdgeInsets.only(top: 5.0),
          child: Text(
            formattedDate,
            style: TextStyle(
                color: Styles.colors.themeColor,
                fontSize: 12.0,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.2,
                fontFamily: GoogleFonts.spartan().fontFamily),
          ),
        ),
        const SizedBox(height: 8.0),
        RatingDetailWidget(movie: movie),
        Padding(
          padding: const EdgeInsets.only(top: 10.0, left: 12.0, right: 12.0),
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
      mainAxisSize: MainAxisSize.min,
      children: [
        RatingBarIndicator(
            rating: (movie.voteAverage / 2).toDouble(),
            direction: Axis.horizontal,
            itemCount: 5,
            itemSize: 25.0,
            itemPadding: const EdgeInsets.symmetric(horizontal: 2.0),
            itemBuilder: (ctx, index) => const Icon(
                  Icons.star,
                  color: Colors.amber,
                )),
        Text((movie.voteAverage / 2).toString(),
            style: TextStyle(
                fontSize: 14,
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontFamily: GoogleFonts.nunito().copyWith().fontFamily)),
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
