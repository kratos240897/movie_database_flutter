import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/state_manager.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../../../core/components/custom_app_bar_widget.dart';
import '../../../../core/components/custom_no_internet_widget.dart';
import '../../../../core/constants/app/app_constants.dart';
import '../../../../core/constants/enums/snackbar_status.dart';
import '../../../home/data/models/movies_response.dart';
import '../../../../core/init/routes/router.dart';
import '../../../../core/service/theme_service.dart';
import '../controllers/movie_detail_controller.dart';

class MovieDetailScreen extends StatefulWidget {
  final Results movie;
  final MovieDetailController controller = Get.find<MovieDetailController>();
  MovieDetailScreen({Key? key, required this.movie}) : super(key: key);

  @override
  State<MovieDetailScreen> createState() => _MovieDetailScreenState();
}

class _MovieDetailScreenState extends State<MovieDetailScreen> {
  late DateTime? _dateTimeObj;
  late String _formattedDate;
  late bool _upcoming;
  @override
  void initState() {
    _dateTimeObj = widget.movie.releaseDate != null
        ? DateTime.parse(widget.movie.releaseDate!)
        : null;
    _formattedDate =
        _dateTimeObj != null ? DateFormat.yMMMEd().format(_dateTimeObj!) : '--';
    _upcoming =
        _dateTimeObj == null ? false : _dateTimeObj!.isAfter(DateTime.now());
    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.controller.movieId = widget.movie.id.toString();
      widget.controller.init();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          bottom: false,
          child: Column(
            children: [
              CustomAppBar(
                  title: widget.movie.title ?? '--', isBackEnabled: true),
              Expanded(
                child: Obx(() {
                  if (!widget.controller.isNetworkAvailable.value) {
                    return const CustomNoInternetWidget();
                  } else {
                    return ContentWidget(
                      controller: widget.controller,
                      movie: widget.movie,
                      formattedDate: _formattedDate,
                      upcoming: _upcoming,
                    );
                  }
                }),
              )
            ],
          )),
    );
  }
}

class ContentWidget extends StatelessWidget {
  ContentWidget(
      {Key? key,
      required this.controller,
      required this.movie,
      required this.formattedDate,
      required this.upcoming})
      : super(key: key);
  final MovieDetailController controller;
  final Results movie;
  final String formattedDate;
  final bool upcoming;
  final mediaQuery = Get.mediaQuery;

  @override
  Widget build(BuildContext context) {
    return NestedScrollView(
      headerSliverBuilder: (context, innerBoxIsScrolled) {
        return [
          SliverOverlapAbsorber(
            handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
            sliver: SliverAppBar(
              expandedHeight: 0.25.sh + 6.h,
              floating: false,
              pinned: false,
              automaticallyImplyLeading: false,
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              flexibleSpace: FlexibleSpaceBar(
                background: BackDropWidget(
                    controller: controller,
                    movie: movie,
                    mediaQuery: mediaQuery),
              ),
            ),
          )
        ];
      },
      body: SingleChildScrollView(
        child: Column(
          children: [
            MovieDetailWidget(
                movie: movie, formattedDate: formattedDate, upcoming: upcoming),
            8.verticalSpace,
            ReviewButton(controller: controller),
            8.verticalSpace,
            Cast(controller: controller)
          ],
        ),
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
                    onTap: () => Get.toNamed(PageRouter.PERSON, arguments: {
                      'title': controller.cast[index].originalName,
                      'id': controller.cast[index].id.toString()
                    }),
                    child: Container(
                      margin: const EdgeInsets.all(5.0),
                      child: Column(children: [
                        controller.cast[index].profilePath != null
                            ? Container(
                                width: constraints.maxHeight * 0.60,
                                height: constraints.maxHeight * 0.60,
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                        width: 2.h,
                                        color: Colors.amber.shade400)),
                                child: Padding(
                                  padding: EdgeInsets.all(6.r),
                                  child: CircleAvatar(
                                    radius: constraints.maxHeight * 0.28,
                                    backgroundImage: CachedNetworkImageProvider(
                                        AppConstants.BASE_IMAGE_URL +
                                            controller.cast[index].profilePath
                                                .toString()),
                                  ),
                                ),
                              )
                            : Container(
                                width: constraints.maxHeight * 0.60,
                                height: constraints.maxHeight * 0.60,
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                        width: 2.h,
                                        color: Colors.amber.shade400)),
                                child: Padding(
                                  padding: EdgeInsets.all(6.r),
                                  child: CircleAvatar(
                                    radius: constraints.maxHeight * 0.28,
                                    backgroundColor: Colors.white,
                                    backgroundImage: const AssetImage(
                                        'assets/images/actor.png'),
                                  ),
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
                              style: TextStyle(
                                  fontSize: 12.sp,
                                  color: Theme.of(context)
                                      .textTheme
                                      .displayLarge
                                      ?.color),
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
                Get.toNamed(PageRouter.REVIEWS, arguments: controller.reviews);
              },
              style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).primaryColor,
                  shape: const StadiumBorder()),
              icon: Icon(
                Icons.type_specimen,
                color:
                    ThemeService().isDarkMode() ? Colors.white : Colors.black,
              ),
              label: Padding(
                padding: const EdgeInsets.symmetric(vertical: 12.0),
                child: Text('Reviews',
                    style: TextStyle(
                        fontSize: 14.sp,
                        color: ThemeService().isDarkMode()
                            ? Colors.white
                            : Colors.black,
                        fontWeight: FontWeight.bold,
                        fontFamily: GoogleFonts.poppins().fontFamily)),
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
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 12.w),
      child: Column(
        children: [
          6.verticalSpace,
          Container(
            height: 0.25.sh,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                border: Border.all(color: Colors.white)),
            width: double.infinity,
            child: InkWell(
              onTap: () {
                if (controller.videoId.isNotEmpty) {
                  Get.toNamed(PageRouter.VIDEO, arguments: controller.videoId);
                } else {
                  controller.utils.showSnackBar(
                      'No videos found for movie',
                      movie.originalTitle ?? (movie.title ?? '--'),
                      SnackBarStatus.info);
                }
              },
              child: Stack(
                children: [
                  Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    bottom: 0,
                    child: Card(
                        elevation: 15.sp,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.r)),
                        clipBehavior: Clip.antiAliasWithSaveLayer),
                  ),
                  Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    bottom: 0,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8.r),
                      child: CachedNetworkImage(
                          imageUrl: movie.backdropPath != null
                              ? AppConstants.BASE_IMAGE_URL +
                                  movie.backdropPath.toString()
                              : AppConstants.BASE_IMAGE_URL +
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
                        borderRadius: BorderRadius.circular(8.r),
                        child: Container(
                          decoration:
                              const BoxDecoration(color: Colors.black26),
                          child: const Center(
                              child: FaIcon(
                            FontAwesomeIcons.solidCirclePlay,
                            size: 50.0,
                            color: Colors.white70,
                          )),
                        ),
                      ))
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class MovieDetailWidget extends StatelessWidget {
  final Results movie;
  final String formattedDate;
  final bool upcoming;
  const MovieDetailWidget(
      {Key? key,
      required this.movie,
      required this.formattedDate,
      required this.upcoming})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 12.w),
      child: Column(
        children: [
          16.verticalSpace,
          Text(
            formattedDate,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontSize: 12.sp,
                fontWeight: FontWeight.w400,
                letterSpacing: 1.2,
                fontFamily: GoogleFonts.leagueSpartan().fontFamily),
          ),
          8.verticalSpace,
          RatingDetailWidget(movie: movie, upcoming: upcoming),
          8.verticalSpace,
          Text(movie.overview ?? '--',
              textAlign: TextAlign.start,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  height: 1.5,
                  wordSpacing: 1.0,
                  fontSize: 14.sp,
                  fontFamily: GoogleFonts.quicksand().fontFamily))
        ],
      ),
    );
  }
}

class RatingDetailWidget extends StatelessWidget {
  final Results movie;
  final bool upcoming;
  const RatingDetailWidget(
      {Key? key, required this.movie, required this.upcoming})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (!upcoming)
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
        4.verticalSpace,
        if (upcoming)
          Text('UPCOMING',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.5,
                  fontFamily: GoogleFonts.nunito().copyWith().fontFamily))
        else
          Text((movie.voteAverage / 2).toStringAsFixed(1),
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.bold,
                  fontFamily: GoogleFonts.nunito().copyWith().fontFamily)),
        if (!upcoming)
          Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 5, right: 5),
                child: Text('${movie.voteCount} votes',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontSize: 14.0.sp,
                        fontFamily: GoogleFonts.jost().fontFamily)),
              ),
              const Icon(Icons.volunteer_activism_sharp, color: Colors.red)
            ],
          ),
      ],
    );
  }
}
