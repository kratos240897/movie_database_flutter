import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:movie_database/helpers/constants.dart';
import 'package:movie_database/helpers/styles.dart';
import 'package:movie_database/models/movies_response.dart';
import 'package:get/get.dart';
import 'dart:math' as math;

class SearchScreen extends StatefulWidget {
  const SearchScreen(this.movies, {Key? key}) : super(key: key);
  final List<Results> movies;

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  int _initalPage = 1;
  PageController? _pageController;

  final mediaQuery = Get.mediaQuery;

  @override
  void initState() {
    _pageController =
        PageController(viewportFraction: 0.8, initialPage: _initalPage);
    super.initState();
  }

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
        child: Column(
          children: [
            const SearchBarWidget(),
            Expanded(
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
                                  value =
                                      index - _pageController!.page!.toDouble();
                                  value = (value * 0.038).clamp(-1, 1);
                                }
                                return AnimatedOpacity(
                                  duration: const Duration(milliseconds: 350),
                                  opacity: _initalPage == index ? 1 : 0.4,
                                  child: Transform.rotate(
                                      angle: math.pi * value,
                                      child: MovieCard(
                                          movie: widget.movies[index])),
                                );
                              },
                            );
                          }))),
            ),
          ],
        ),
      ),
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
            height: constraints.maxHeight * 0.7,
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

class SearchBarWidget extends StatelessWidget {
  const SearchBarWidget({
    Key? key,
  }) : super(key: key);

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
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Start searching movies',
                      hintStyle: TextStyle(
                          fontFamily: GoogleFonts.raleway().fontFamily)),
                ),
              ),
            ),
          ),
          IconButton(
              onPressed: () {},
              icon: const FaIcon(FontAwesomeIcons.arrowCircleRight))
        ],
      ),
    );
  }
}
