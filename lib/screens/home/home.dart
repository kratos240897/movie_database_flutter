// ignore_for_file: unnecessary_import, invalid_use_of_protected_member

import 'package:badges/badges.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:focused_menu/focused_menu.dart';
import 'package:focused_menu/modals.dart';
import 'package:get/state_manager.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:group_button/group_button.dart';
import 'package:get/get.dart';
import 'package:movie_database/service/theme_service.dart';
import 'package:movie_database/widgets/custom_action_button.dart';
import 'package:movie_database/widgets/custom_app_bar_widget.dart';
import 'package:share_plus/share_plus.dart';
import '../../data/models/movies_response.dart';
import '../../enum/device_type.dart';
import '../../helpers/constants.dart';
import '../../helpers/device_size.dart';
import '../../helpers/styles.dart';
import '../../routes/router.dart';
import 'home_controller.dart';

class Home extends GetView<HomeController> {
  Home({Key? key}) : super(key: key);
  final mediaQuery = Get.mediaQuery;
  final movieListScrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: Obx(() {
        return Padding(
          padding: EdgeInsets.symmetric(vertical: 8.sp),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: EdgeInsets.only(right: 4.w),
                child: CustomAppBar(
                  title: 'Myth Flix',
                  isBackEnabled: false,
                  actions: [
                    CustomActionButton(
                        onTap: () => Get.toNamed(
                              PageRouter.SEARCH,
                              arguments:
                                  controller.movies.value as List<Results>,
                            ),
                        icon: Icons.search_outlined),
                    CustomActionButton(
                      onTap: () => Get.toNamed(PageRouter.FAVORITES),
                      icon: Icons.favorite_border,
                      badgeCount: controller.favoritesCount.value,
                    ),
                    CustomActionButton(
                        onTap: () async {
                          await controller.changeTheme();
                        },
                        icon: controller.isDarkMode.value
                            ? Icons.light_mode_outlined
                            : Icons.dark_mode_outlined),
                    CustomActionButton(
                        onTap: () => controller.logout(),
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
                  : controller.getNoInternetWidget
            ],
          ),
        );
      })),
    );
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
    return Obx(() {
      return Expanded(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 8.w),
          child: SingleChildScrollView(
            controller: scrollController,
            child: Visibility(
                visible: controller.isLoading.value == true ? false : true,
                child: GridView.builder(
                    itemCount: controller.movies.length,
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        mainAxisExtent:
                            mediaQuery.orientation == Orientation.portrait
                                ? mediaQuery.size.height * 0.3
                                : mediaQuery.size.height * 0.7,
                        crossAxisCount:
                            getDeviceType() == DeviceType.phone ? 2 : 3,
                        crossAxisSpacing: 4.0,
                        mainAxisSpacing: 4.0),
                    itemBuilder: (ctx, index) {
                      return FocusedMenuHolder(
                          blurBackgroundColor: Colors.blueGrey[900],
                          menuOffset: 8.0,
                          animateMenuItems: true,
                          menuWidth: mediaQuery.size.width * 0.5,
                          menuItems: [
                            FocusedMenuItem(
                                backgroundColor:
                                    Theme.of(context).cardTheme.color,
                                title: Text('Favorite',
                                    style:
                                        Styles.textStyles.f14Regular?.copyWith(
                                      color: Theme.of(context)
                                          .textTheme
                                          .headline6
                                          ?.color,
                                    )),
                                trailingIcon: const Icon(Icons.favorite,
                                    color: Colors.red),
                                onPressed: () async {
                                  controller
                                      .addFavorite(controller.movies[index]);
                                }),
                            FocusedMenuItem(
                                backgroundColor:
                                    Theme.of(context).cardTheme.color,
                                title: Text('Share',
                                    style:
                                        Styles.textStyles.f14Regular?.copyWith(
                                      color: Theme.of(context)
                                          .textTheme
                                          .headline6
                                          ?.color,
                                    )),
                                trailingIcon: const Icon(Icons.send,
                                    color: Colors.orange),
                                onPressed: () {
                                  Results movie = controller.movies[index];
                                  Share.share(
                                      'Check out my website https://hardcore-meninsky-e3f55f.netlify.app/#/',
                                      subject:
                                          'Check out this movie ${movie.title}');
                                }),
                            FocusedMenuItem(
                                backgroundColor:
                                    Theme.of(context).cardTheme.color,
                                title: Text('Vote',
                                    style:
                                        Styles.textStyles.f14Regular?.copyWith(
                                      color: Theme.of(context)
                                          .textTheme
                                          .headline6
                                          ?.color,
                                    )),
                                trailingIcon: const Icon(
                                    Icons.volunteer_activism,
                                    color: Colors.green),
                                onPressed: () {})
                          ],
                          onPressed: () {},
                          child: MovieListItem(
                            movie: controller.movies[index],
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
                            getDeviceType() == DeviceType.phone ? 2 : 3,
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
      );
    });
  }
}

class MovieListItem extends StatelessWidget {
  final Results movie;
  final MediaQueryData mediaQuery;
  const MovieListItem({Key? key, required this.movie, required this.mediaQuery})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Get.toNamed(PageRouter.MOVIE_DETAIL, arguments: movie),
      child: LayoutBuilder(builder: (context, constraints) {
        return Card(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
              side: const BorderSide(color: Colors.white)),
          elevation: 6.0,
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
                        borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(10.0),
                            topRight: Radius.circular(10.0)),
                        child: CachedNetworkImage(
                            imageUrl: movie.posterPath != null
                                ? Constants.BASE_IMAGE_URL + movie.posterPath!
                                : 'https://globalnews.ca/wp-content/uploads/2020/06/jfj50169012-2.jpg?quality=85&strip=all'),
                      ),
                    ),
                    Positioned(
                      bottom: 8.h,
                      right: 0,
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Theme.of(context).cardTheme.color,
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
                            (movie.voteAverage / 2).toStringAsFixed(1) + ' ✨',
                            style: TextStyle(
                                color: Theme.of(context)
                                    .textTheme
                                    .headline1
                                    ?.color,
                                fontWeight: FontWeight.bold),
                            textAlign: TextAlign.end),
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(height: constraints.maxHeight * 0.01),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: constraints.maxWidth * 0.02,
                      vertical: constraints.maxHeight * 0.03),
                  child: Text(movie.originalTitle ?? (movie.title ?? '--'),
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.headline6?.copyWith(
                          fontSize: 16.0,
                          overflow: TextOverflow.ellipsis,
                          fontFamily:
                              GoogleFonts.staatliches().copyWith().fontFamily)),
                ),
              ),
            ],
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
        margin: EdgeInsets.only(top: 8.h, left: 6.w, right: 6.w, bottom: 12.h),
        duration: const Duration(milliseconds: 400),
        curve: Curves.bounceInOut,
        child: SingleChildScrollView(
          controller: _categoryScrollController,
          scrollDirection: Axis.horizontal,
          child: GroupButton(
              buttonIndexedBuilder: (selected, index, context) {
                return Container(
                  padding: EdgeInsets.symmetric(horizontal: 6.sp),
                  child: IntrinsicWidth(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          _categories[index],
                          style: Theme.of(context)
                              .textTheme
                              .headline6
                              ?.copyWith(
                                  fontSize: selected ? 15.sp : 14.sp,
                                  fontWeight: selected
                                      ? FontWeight.w600
                                      : FontWeight.w400,
                                  fontFamily: GoogleFonts.nunito().fontFamily),
                        ),
                        Column(
                          children: [
                            6.verticalSpace,
                            Container(
                              height: 2.h,
                              decoration: BoxDecoration(
                                  color: selected
                                      ? Colors.amber
                                      : Colors.transparent,
                                  borderRadius: BorderRadius.circular(10.r)),
                            ),
                          ],
                        )
                      ],
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
                      duration: const Duration(milliseconds: 1000),
                      curve: Curves.linearToEaseOut);
                } else if (index == _categories.length - 1) {
                  _categoryScrollController.animateTo(
                      _categoryScrollController.position.maxScrollExtent,
                      duration: const Duration(milliseconds: 1000),
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
