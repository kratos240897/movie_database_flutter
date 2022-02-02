import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:movie_database/helpers/constants.dart';
import 'package:movie_database/helpers/styles.dart';
import 'package:movie_database/helpers/utils.dart';
import 'package:movie_database/models/movies_response.dart';
import 'package:get/get.dart';
import 'package:movie_database/screens/screens.dart';
import 'dart:math' as math;

import 'package:movie_database/screens/search/search_controller.dart';

class SearchScreen extends GetView<SearchController> {
  SearchScreen(this.movies, {Key? key}) : super(key: key);
  final List<Results> movies;
  final mediaQuery = Get.mediaQuery;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Search Movies',
            style: TextStyle(
                fontSize: 25.0,
                fontFamily: GoogleFonts.caveat().copyWith().fontFamily)),
      ),
      body: SafeArea(
        child: Obx(() {
          return Column(
            children: [
              SearchBarWidget(
                controller: controller,
              ),
              controller.searchResults.isEmpty
                  ? Visibility(
                      visible: !controller.isSearchHasFocus.value,
                      child: CarouselMovieSlider(movies: movies),
                      replacement: Container())
                  : SearchedMovies(controller: controller)
            ],
          );
        }),
      ),
    );
  }
}

class SearchedMovies extends StatelessWidget {
  final SearchController controller;
  const SearchedMovies({Key? key, required this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView.builder(
          itemCount: controller.searchResults.length,
          shrinkWrap: true,
          itemBuilder: (context, index) {
            return InkWell(
              onTap: () => Get.to(
                  MovieDetailScreen(movie: controller.searchResults[index])),
              child: LayoutBuilder(builder: (context, constraints) {
                double vote = (controller.searchResults[index].voteAverage /
                    2.0) as double;
                String rating = vote.toStringAsFixed(1);
                return Container(
                  margin: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: constraints.maxWidth * 0.2 / 2,
                        backgroundImage: CachedNetworkImageProvider(
                            Constants.IMAGE_BASE_URL +
                                controller.searchResults[index].posterPath
                                    .toString()),
                      ),
                      const SizedBox(width: 10.0),
                      SizedBox(
                        width: constraints.maxWidth * 0.53,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(controller.searchResults[index].title,
                                style: TextStyle(
                                    fontSize: 16.0,
                                    fontFamily:
                                        GoogleFonts.quicksand().fontFamily,
                                    fontWeight: FontWeight.bold)),
                            Text(controller.searchResults[index].overview,
                                style: TextStyle(
                                  fontFamily:
                                      GoogleFonts.quicksand().fontFamily,
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
              }),
            );
          },
        ),
      ),
    );
  }
}

class CarouselMovieSlider extends StatefulWidget {
  final List<Results> movies;
  const CarouselMovieSlider({Key? key, required this.movies}) : super(key: key);

  @override
  State<CarouselMovieSlider> createState() => _CarouselMovieSliderState();
}

class _CarouselMovieSliderState extends State<CarouselMovieSlider> {
  int _initalPage = 1;
  PageController? _pageController;

  @override
  void initState() {
    _pageController =
        PageController(viewportFraction: 0.8, initialPage: _initalPage);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: AspectRatio(
              aspectRatio: 0.85,
              child: PageView.builder(
                  controller: _pageController,
                  onPageChanged: (value) => setState(() {
                        _initalPage = value;
                      }),
                  physics: const ClampingScrollPhysics(),
                  itemCount: widget.movies.length,
                  itemBuilder: (context, index) {
                    return AnimatedBuilder(
                      animation: _pageController!,
                      builder: (context, child) {
                        double value = 0;
                        if (_pageController!.position.haveDimensions) {
                          value = index - _pageController!.page!.toDouble();
                          value = (value * 0.038).clamp(-1, 1);
                        }
                        return AnimatedOpacity(
                          duration: const Duration(milliseconds: 350),
                          opacity: _initalPage == index ? 1 : 0.4,
                          child: Transform.rotate(
                              angle: math.pi * value,
                              child: MovieCard(movie: widget.movies[index])),
                        );
                      },
                    );
                  }))),
    );
  }
}

class MovieCard extends StatelessWidget {
  const MovieCard({Key? key, required this.movie}) : super(key: key);
  final Results movie;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return Column(
        children: [
          Container(
            height: constraints.maxHeight * 0.6,
            margin: const EdgeInsets.all(10.0),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50.0),
                image: DecorationImage(
                    fit: BoxFit.fill,
                    image: CachedNetworkImageProvider(Constants.IMAGE_BASE_URL +
                        movie.posterPath.toString()))),
          ),
          Container(
            margin: const EdgeInsets.symmetric(vertical: 15.0),
            child: Text(movie.title,
                textAlign: TextAlign.start,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Styles.colors.themeColor,
                    overflow: TextOverflow.ellipsis,
                    fontFamily: GoogleFonts.actor().fontFamily)),
          ),
          RatingBarIndicator(
              rating: (movie.voteAverage / 2).toDouble(),
              direction: Axis.horizontal,
              itemCount: 5,
              itemSize: 30.0,
              itemPadding: const EdgeInsets.symmetric(horizontal: 2.0),
              itemBuilder: (ctx, index) => const Icon(
                    Icons.star,
                    color: Colors.amber,
                  ))
        ],
      );
    });
  }
}

class SearchBarWidget extends StatefulWidget {
  final SearchController controller;

  const SearchBarWidget({
    Key? key,
    required this.controller,
  }) : super(key: key);

  @override
  State<SearchBarWidget> createState() => _SearchBarWidgetState();
}

class _SearchBarWidgetState extends State<SearchBarWidget> {
  final FocusNode _focus = FocusNode();

  final TextEditingController searchTextController = TextEditingController();

  @override
  void initState() {
    _focus.addListener(_focusListener);
    super.initState();
  }

  void _focusListener() {
    if (_focus.hasFocus) {
      widget.controller.isSearchHasFocus.value = true;
    } else {
      Future.delayed(const Duration(milliseconds: 300), () {
        widget.controller.isSearchHasFocus.value = false;
      });
    }
  }

  @override
  void dispose() {
    _focus.removeListener(_focusListener);
    _focus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0)),
              elevation: 4.0,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: TextField(
                  focusNode: _focus,
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Start searching movies',
                      hintStyle: TextStyle(
                          fontFamily: GoogleFonts.raleway().fontFamily)),
                  controller: searchTextController,
                ),
              ),
            ),
          ),
          IconButton(
              onPressed: () {
                if (searchTextController.text.isNotEmpty) {
                  widget.controller.searchMovies(
                      searchTextController.text.toString().trim());
                } else {
                  Utils().showSnackBar('Invalid query',
                      'Please enter a valid search query', false);
                }
              },
              icon: const FaIcon(FontAwesomeIcons.arrowCircleRight))
        ],
      ),
    );
  }
}
