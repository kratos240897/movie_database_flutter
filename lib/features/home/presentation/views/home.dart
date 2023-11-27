import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:focused_menu/focused_menu.dart';
import 'package:focused_menu/modals.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:group_button/group_button.dart';
import 'package:share_plus/share_plus.dart';

import '../../../../core/components/custom_action_button.dart';
import '../../../../core/components/custom_app_bar_widget.dart';
import '../../../../core/components/custom_no_internet_widget.dart';
import '../../../../core/constants/app/app_constants.dart';
import '../../../../core/constants/app/styles.dart';
import '../../../../core/constants/enums/device_type.dart';
import '../../../../core/init/utils/utils.dart';
import '../../data/models/movies_response.dart';
import '../../../../core/init/routes/router.dart';
import '../../../../core/service/theme_service.dart';
import '../controllers/home_controller.dart';

class Home extends GetView<HomeController> {
  Home({Key? key}) : super(key: key);
  final mediaQuery = Get.mediaQuery;
  final movieListScrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          bottom: false,
          child: Obx(() => Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: EdgeInsets.only(right: 4.w, top: 12.h),
                    child: CustomAppBar(
                      title: 'Myth Flix',
                      isBackEnabled: false,
                      actions: [
                        CustomActionButton(
                            onTap: () => Get.toNamed(
                                  PageRouter.SEARCH,
                                  arguments: controller.allMoviesList[Random()
                                      .nextInt(
                                          controller.allMoviesList.length)],
                                ),
                            icon: Icons.search_outlined),
                        CustomActionButton(
                          onTap: () => Get.toNamed(PageRouter.FAVORITES),
                          icon: Icons.favorite_rounded,
                        ),
                        CustomActionButton(
                            onTap: () async {
                              await controller.changeTheme();
                            },
                            icon: controller.isDarkMode.value
                                ? Icons.light_mode_outlined
                                : Icons.dark_mode_outlined),
                        CustomActionButton(
                            onTap: () => controller.prepareLogout(),
                            icon: Icons.logout_outlined)
                      ],
                    ),
                  ),
                  CategoriesWidget(
                    controller: controller,
                    movieListScrollController: movieListScrollController,
                  ),
                  controller.isNetworkAvailable.value
                      ? MoviesListWidget(
                          controller: controller,
                          scrollController: movieListScrollController,
                          mediaQuery: mediaQuery)
                      : const CustomNoInternetWidget()
                ],
              ))),
    );
  }
}

class HomeV2 extends GetView<HomeController> {
  HomeV2({Key? key}) : super(key: key);
  final mediaQuery = Get.mediaQuery;
  final movieListScrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          bottom: false,
          child: Obx(() => Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CustomAppBar(
                    title: 'Myth Flix',
                    isBackEnabled: false,
                    actions: [
                      CustomActionButton(
                          onTap: () => Get.toNamed(
                                PageRouter.SEARCH,
                                arguments: controller.allMoviesList[Random()
                                    .nextInt(controller.allMoviesList.length)],
                              ),
                          icon: Icons.search_outlined),
                      CustomActionButton(
                        onTap: () => Get.toNamed(PageRouter.FAVORITES),
                        icon: Icons.favorite_rounded,
                      ),
                      CustomActionButton(
                          onTap: () async {
                            await controller.changeTheme();
                          },
                          icon: controller.isDarkMode.value
                              ? Icons.light_mode_outlined
                              : Icons.dark_mode_outlined),
                      CustomActionButton(
                          onTap: () => controller.prepareLogout(),
                          icon: Icons.logout_outlined)
                    ],
                  ),
                  controller.isNetworkAvailable.value
                      ? Expanded(
                          child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 12.w),
                          child: SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                8.verticalSpace,
                                MovieCategoryList(
                                    icon: Icons.movie_outlined,
                                    categoryTitle: 'Now Playing',
                                    movies: controller.nowPlaying,
                                    mediaQuery: mediaQuery),
                                8.verticalSpace,
                                MovieCategoryList(
                                    icon: Icons.new_label_outlined,
                                    categoryTitle: 'New',
                                    movies: controller.newMovies,
                                    mediaQuery: mediaQuery),
                                8.verticalSpace,
                                MovieCategoryList(
                                    icon: Icons.upcoming_outlined,
                                    categoryTitle: 'Upcoming',
                                    movies: controller.upcoming,
                                    mediaQuery: mediaQuery),
                                8.verticalSpace,
                                MovieCategoryList(
                                    icon: Icons.star_border_outlined,
                                    categoryTitle: 'Top rated',
                                    movies: controller.topRated,
                                    mediaQuery: mediaQuery),
                                8.verticalSpace,
                                MovieCategoryList(
                                    icon: Icons.tv_outlined,
                                    categoryTitle: 'TV Shows',
                                    movies: controller.tvShows,
                                    mediaQuery: mediaQuery)
                              ],
                            ),
                          ),
                        ))
                      : const CustomNoInternetWidget()
                ],
              ))),
    );
  }
}

class MovieCategoryList extends StatelessWidget {
  const MovieCategoryList(
      {Key? key,
      required this.categoryTitle,
      required this.movies,
      required this.mediaQuery,
      required this.icon})
      : super(key: key);

  final String categoryTitle;
  final List<Results> movies;
  final MediaQueryData mediaQuery;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Obx(() => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(
                  icon,
                  size: 24.spMin,
                ),
                4.horizontalSpace,
                Text(
                  categoryTitle,
                  style: Styles.textStyles
                      .f16Regular(fontFamily: GoogleFonts.poppins().fontFamily),
                ),
                Icon(
                  Icons.chevron_right,
                  size: 24.spMin,
                )
              ],
            ),
            4.verticalSpace,
            SizedBox(
              height: 0.25.sh,
              child: ListView.builder(
                itemCount: movies.length,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  final movie = movies[index];
                  return MovieListItem(
                    mediaQuery: mediaQuery,
                    movie: movie,
                  );
                },
              ),
            ),
          ],
        ));
  }
}

class MoviesListWidget extends StatelessWidget {
  final HomeController controller;
  final ScrollController scrollController;
  final MediaQueryData mediaQuery;
  const MoviesListWidget(
      {Key? key,
      required this.controller,
      required this.mediaQuery,
      required this.scrollController})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() => Expanded(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.w),
            child: SingleChildScrollView(
              controller: scrollController,
              child: Visibility(
                  visible: controller.isLoading.value == true ? false : true,
                  child: GridView.builder(
                      itemCount: controller.nowPlaying.length,
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          mainAxisExtent:
                              mediaQuery.orientation == Orientation.portrait
                                  ? mediaQuery.size.height * 0.3
                                  : mediaQuery.size.height * 0.7,
                          crossAxisCount:
                              Utils.getDeviceType(context) == DeviceType.phone
                                  ? 2
                                  : 3,
                          crossAxisSpacing: 4.0,
                          mainAxisSpacing: 4.0),
                      itemBuilder: (ctx, index) {
                        return FocusedMenuHolder(
                            blurBackgroundColor:
                                Theme.of(context).scaffoldBackgroundColor,
                            menuOffset: 8.0,
                            animateMenuItems: true,
                            menuWidth: mediaQuery.size.width * 0.5,
                            menuItems: [
                              FocusedMenuItem(
                                  backgroundColor:
                                      Theme.of(context).cardTheme.color,
                                  title: Text(
                                    'Favorite',
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleLarge
                                        ?.copyWith(fontSize: 14.sp),
                                  ),
                                  trailingIcon: const Icon(Icons.favorite,
                                      color: Colors.red),
                                  onPressed: () async {
                                    controller.addFavorite(
                                        controller.nowPlaying[index]);
                                  }),
                              FocusedMenuItem(
                                  backgroundColor:
                                      Theme.of(context).cardTheme.color,
                                  title: Text('Share',
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleLarge
                                          ?.copyWith(fontSize: 14.sp)),
                                  trailingIcon: const Icon(Icons.send,
                                      color: Colors.orange),
                                  onPressed: () {
                                    Results movie =
                                        controller.nowPlaying[index];
                                    Share.share(
                                        'Check out my website https://hardcore-meninsky-e3f55f.netlify.app/#/',
                                        subject:
                                            'Check out this movie ${movie.title}');
                                  }),
                              FocusedMenuItem(
                                  backgroundColor:
                                      Theme.of(context).cardTheme.color,
                                  title: Text(
                                    'Vote',
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleLarge
                                        ?.copyWith(fontSize: 14.sp),
                                  ),
                                  trailingIcon: const Icon(
                                      Icons.volunteer_activism,
                                      color: Colors.green),
                                  onPressed: () {})
                            ],
                            onPressed: () {},
                            child: MovieListItem(
                              movie: controller.nowPlaying[index],
                              mediaQuery: mediaQuery,
                            ));
                      }),
                  replacement: GridView.builder(
                      itemCount: 10,
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          mainAxisExtent:
                              mediaQuery.orientation == Orientation.portrait
                                  ? mediaQuery.size.height * 0.3
                                  : mediaQuery.size.height * 0.7,
                          crossAxisCount:
                              Utils.getDeviceType(context) == DeviceType.phone
                                  ? 2
                                  : 3,
                          crossAxisSpacing: 4.0,
                          mainAxisSpacing: 4.0),
                      itemBuilder: (ctx, index) {
                        return Card(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15)),
                          elevation: 4,
                          child: const Center(
                            child: CupertinoActivityIndicator(
                                animating: true, radius: 12.0),
                          ),
                        );
                      })),
            ),
          ),
        ));
  }
}

class MovieListItem extends StatelessWidget {
  late HomeController controller;
  final Results movie;
  final MediaQueryData mediaQuery;
  MovieListItem({Key? key, required this.movie, required this.mediaQuery})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    controller = Get.find();
    return InkWell(
      onTap: () => Get.toNamed(PageRouter.MOVIE_DETAIL, arguments: movie),
      child: LayoutBuilder(builder: (context, constraints) {
        return FocusedMenuHolder(
          blurBackgroundColor: Theme.of(context).scaffoldBackgroundColor,
          menuOffset: 8.0,
          animateMenuItems: true,
          menuWidth: mediaQuery.size.width * 0.5,
          menuItems: [
            FocusedMenuItem(
                backgroundColor: Theme.of(context).cardTheme.color,
                title: Text(
                  'Favorite',
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge
                      ?.copyWith(fontSize: 14.sp),
                ),
                trailingIcon: const Icon(Icons.favorite, color: Colors.red),
                onPressed: () async {
                  controller.addFavorite(movie);
                }),
            FocusedMenuItem(
                backgroundColor: Theme.of(context).cardTheme.color,
                title: Text('Share',
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge
                        ?.copyWith(fontSize: 14.sp)),
                trailingIcon: const Icon(Icons.send, color: Colors.orange),
                onPressed: () {
                  Share.share(
                      'Check out my website https://hardcore-meninsky-e3f55f.netlify.app/#/',
                      subject: 'Check out this movie ${movie.title}');
                }),
            FocusedMenuItem(
                backgroundColor: Theme.of(context).cardTheme.color,
                title: Text(
                  'Vote',
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge
                      ?.copyWith(fontSize: 14.sp),
                ),
                trailingIcon:
                    const Icon(Icons.volunteer_activism, color: Colors.green),
                onPressed: () {})
          ],
          onPressed: () {},
          child: SizedBox(
            width: 0.45.sw,
            child: Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(22.r),
                  side: const BorderSide(color: Colors.white)),
              child: Column(
                children: [
                  SizedBox(
                    height: constraints.maxHeight * 0.8,
                    child: Stack(
                      children: [
                        Positioned(
                          top: 0,
                          left: 0,
                          right: 0,
                          child: ClipRRect(
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(22.r),
                                topRight: Radius.circular(22.r)),
                            child: CachedNetworkImage(
                                imageUrl: movie.posterPath != null
                                    ? AppConstants.BASE_IMAGE_URL +
                                        movie.posterPath!
                                    : 'https://globalnews.ca/wp-content/uploads/2020/06/jfj50169012-2.jpg?quality=85&strip=all'),
                          ),
                        ),
                        Positioned(
                          bottom: 8.h,
                          right: 0,
                          child: ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    Theme.of(context).cardTheme.color,
                                splashFactory: NoSplash.splashFactory,
                                shape: RoundedRectangleBorder(
                                    side: BorderSide(
                                        width: 0.8.sp,
                                        color: ThemeService().isDarkMode()
                                            ? Styles.colors.white
                                            : Colors.transparent),
                                    borderRadius: const BorderRadius.only(
                                        topLeft: Radius.circular(10.0),
                                        bottomLeft: Radius.circular(10.0)))),
                            child: Text(
                                (movie.voteAverage / 2).toStringAsFixed(1) +
                                    ' ✨',
                                style: TextStyle(
                                    color: Theme.of(context)
                                        .textTheme
                                        .displayLarge
                                        ?.color,
                                    fontWeight: FontWeight.bold),
                                textAlign: TextAlign.end),
                          ),
                        )
                      ],
                    ),
                  ),
                  Expanded(
                    child: Center(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8.w),
                        child: Text(
                            movie.originalTitle ?? (movie.title ?? '--'),
                            textAlign: TextAlign.center,
                            style: Styles.textStyles
                                .f14Regular(
                                    fontFamily:
                                        GoogleFonts.staatliches().fontFamily)
                                .copyWith(overflow: TextOverflow.ellipsis)),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      }),
    );
  }
}

class CategoriesWidget extends StatelessWidget {
  final HomeController controller;
  final ScrollController movieListScrollController;
  final _categoryScrollController = ScrollController();
  final _categoryController = GroupButtonController(selectedIndex: 0);
  final _categories = const [
    'Now playing',
    'New',
    'Top rated',
    'Upcoming',
    'TV shows'
  ];
  CategoriesWidget(
      {Key? key,
      required this.controller,
      required this.movieListScrollController})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
        margin: EdgeInsets.only(top: 8.h, left: 6.w, right: 6.w, bottom: 8.h),
        duration: const Duration(milliseconds: 400),
        curve: Curves.bounceInOut,
        child: SingleChildScrollView(
          controller: _categoryScrollController,
          scrollDirection: Axis.horizontal,
          child: GroupButton(
              buttonIndexedBuilder: (selected, index, context) {
                return Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                  child: Opacity(
                    opacity: selected ? 1 : 0.5,
                    child: Text(
                      _categories[index],
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontSize: selected ? 15.sp : 14.sp,
                          fontWeight:
                              selected ? FontWeight.w600 : FontWeight.w400,
                          fontFamily: GoogleFonts.nunito().fontFamily),
                    ),
                  ),
                );
              },
              controller: _categoryController,
              isRadio: true,
              onSelected: (_, index, __) async {
                if (index == 0 &&
                    _categoryScrollController.position.pixels != 0.0) {
                  _categoryScrollController.animateTo(0.0,
                      duration: const Duration(milliseconds: 500),
                      curve: Curves.linearToEaseOut);
                } else if (index == _categories.length - 1) {
                  _categoryScrollController.animateTo(
                      _categoryScrollController.position.maxScrollExtent,
                      duration: const Duration(milliseconds: 500),
                      curve: Curves.linearToEaseOut);
                }
                await controller.setSelectedCategory(index);
                if (movieListScrollController.position.pixels != 0.0) {
                  movieListScrollController.animateTo(0.0,
                      duration: const Duration(milliseconds: 1000),
                      curve: Curves.linearToEaseOut);
                }
              },
              buttons: _categories),
        ));
  }
}
