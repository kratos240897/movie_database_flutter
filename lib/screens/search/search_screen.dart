import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:focused_menu/focused_menu.dart';
import 'package:focused_menu/modals.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import 'package:movie_database/enum/snackbar_status.dart';
import 'dart:math' as math;
import 'package:share_plus/share_plus.dart';
import '../../data/models/movies_response.dart';
import '../../enum/device_type.dart';
import '../../helpers/constants.dart';
import '../../helpers/device_size.dart';
import '../../helpers/styles.dart';
import '../../routes/router.dart';
import 'search_controller.dart';

class SearchScreen extends GetView<SearchController> {
  SearchScreen(this.movies, {Key? key}) : super(key: key);
  final List<Results> movies;
  final mediaQuery = Get.mediaQuery;

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
        title: Text('Search Movies',
            style: Theme.of(context).textTheme.headline6?.copyWith(
                fontSize: 22.sp,
                fontFamily: GoogleFonts.josefinSans().copyWith().fontFamily)),
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
            return SearchedMovieItem(controller: controller, index: index);
          },
        ),
      ),
    );
  }
}

class SearchedMovieItem extends StatelessWidget {
  final SearchController controller;
  final int index;
  final mediaQuery = Get.mediaQuery;
  SearchedMovieItem({Key? key, required this.controller, required this.index})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final movie = controller.searchResults[index];
    double vote = (movie.voteAverage / 2.0) as double;
    String rating = vote.toStringAsFixed(1);
    return FocusedMenuHolder(
      blurBackgroundColor: Colors.white,
      menuOffset: 8.0,
      animateMenuItems: true,
      menuWidth: mediaQuery.size.width * 0.5,
      menuItems: [
        FocusedMenuItem(
            title: Text('Favorite', style: Styles.textStyles.f14Regular),
            trailingIcon: const Icon(Icons.favorite, color: Colors.red),
            onPressed: () async {
              controller.addFavorite(movie);
            }),
        FocusedMenuItem(
            title: Text('Share', style: Styles.textStyles.f14Regular),
            trailingIcon: const Icon(Icons.share, color: Colors.blue),
            onPressed: () {
              Results movie = controller.searchResults[index];
              Share.share(
                  'Check out my website https://hardcore-meninsky-e3f55f.netlify.app/#/',
                  subject: 'Check out this movie ${movie.title}');
            }),
        FocusedMenuItem(
            title: Text('Vote', style: Styles.textStyles.f14Regular),
            trailingIcon:
                const Icon(Icons.volunteer_activism, color: Colors.green),
            onPressed: () {})
      ],
      onPressed: () {},
      child: InkWell(
          onTap: () => Get.toNamed(PageRouter.MOVIE_DETAIL,
              arguments: controller.searchResults[index]),
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 8.0),
            child: Row(
              children: [
                Expanded(
                  flex: 1,
                  child: AspectRatio(
                    aspectRatio: 1 / 1,
                    child: CircleAvatar(
                      backgroundImage: CachedNetworkImageProvider(
                        Constants.BASE_IMAGE_URL + movie.posterPath.toString(),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10.0),
                Expanded(
                  flex: 4,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(movie.title,
                          style: Theme.of(context)
                              .textTheme
                              .headline6
                              ?.copyWith(
                                  fontSize: 16.sp,
                                  fontFamily:
                                      GoogleFonts.quicksand().fontFamily,
                                  fontWeight: FontWeight.bold)),
                      Text(movie.overview,
                          style: Theme.of(context)
                              .textTheme
                              .headline6
                              ?.copyWith(
                                fontSize: 14.sp,
                                fontFamily: GoogleFonts.quicksand().fontFamily,
                              ),
                          maxLines: 4,
                          overflow: TextOverflow.ellipsis),
                    ],
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Align(
                    alignment: Alignment.centerRight,
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
                ),
              ],
            ),
          )),
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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _animateSlider();
    });
    super.initState();
  }

  void _animateSlider() {
    Future.delayed(const Duration(seconds: 3)).then((_) {
      if (_pageController!.hasClients) {
        int nextPage = _pageController!.page!.round() + 1;
        if (nextPage == widget.movies.length) {
          nextPage = 0;
        }
        _pageController!
            .animateToPage(nextPage,
                duration: const Duration(milliseconds: 400),
                curve: Curves.linear)
            .then((_) {
          _animateSlider();
        });
      }
    });
  }

  @override
  void dispose() {
    _pageController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: AspectRatio(
              aspectRatio: 0.75,
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
    return GestureDetector(
      onTap: () => Get.toNamed(PageRouter.MOVIE_DETAIL, arguments: movie),
      child: LayoutBuilder(builder: (context, constraints) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: getDeviceType() == DeviceType.phone
                  ? constraints.maxHeight * 0.65
                  : constraints.maxHeight * 0.75,
              margin: EdgeInsets.all(
                  getDeviceType() == DeviceType.phone ? 15.0 : 30.0),
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.white),
                  borderRadius: BorderRadius.circular(50.0),
                  image: DecorationImage(
                      fit: BoxFit.fill,
                      image: CachedNetworkImageProvider(
                          Constants.BASE_IMAGE_URL +
                              movie.posterPath.toString()))),
            ),
            Container(
              margin: const EdgeInsets.symmetric(vertical: 15.0),
              child: Text(movie.title,
                  textAlign: TextAlign.start,
                  style: Theme.of(context).textTheme.headline6?.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
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
      }),
    );
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
                  style: Theme.of(context).textTheme.headline6?.copyWith(
                      fontSize: 16.sp,
                      fontFamily: GoogleFonts.raleway().fontFamily),
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Start searching movies',
                      hintStyle: Theme.of(context)
                          .textTheme
                          .headline6
                          ?.copyWith(
                              fontSize: 14.sp,
                              fontFamily: GoogleFonts.raleway().fontFamily)),
                  controller: searchTextController,
                  onSubmitted: (value) async {
                    if (value.isNotEmpty) {
                      widget.controller.searchMovies(value.trim());
                    } else {
                      widget.controller.utils.showSnackBar('Invalid query',
                          'Please enter a valid search query', SnackBarStatus.failure);
                    }
                  },
                ),
              ),
            ),
          ),
          IconButton(
              onPressed: () async {
                if (searchTextController.text.isNotEmpty) {
                  widget.controller.searchMovies(
                      searchTextController.text.toString().trim());
                } else {
                  widget.controller.utils.showSnackBar('Invalid query',
                      'Please enter a valid search query', SnackBarStatus.failure);
                }
              },
              icon: const FaIcon(FontAwesomeIcons.arrowCircleRight))
        ],
      ),
    );
  }
}
