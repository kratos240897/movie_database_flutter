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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Text('Myth Flix',
              style: Theme.of(context).textTheme.headline6?.copyWith(
                  fontSize: 22.sp,
                  fontFamily: GoogleFonts.josefinSans().copyWith().fontFamily)),
        ),
        actions: [
          SearchActionButton(controller: controller),
          FavoriteActionButton(controller: controller),
          ThemeActionButton(controller: controller),
          LogoutActionButton(controller: controller)
        ],
      ),
      body: SafeArea(child: Obx(() {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CategoriesWidget(controller: controller),
            controller.isNetworkAvailable.value
                ? MoviesListWidget(
                    controller: controller, mediaQuery: mediaQuery)
                : controller.getNoInternetWidget
          ],
        );
      })),
    );
  }
}

class SearchActionButton extends StatelessWidget {
  final HomeController controller;
  const SearchActionButton({Key? key, required this.controller})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashFactory: NoSplash.splashFactory,
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      onTap: () => Get.toNamed(
        PageRouter.SEARCH,
        arguments: controller.movies.value as List<Results>,
      ),
      child: Container(
        margin: const EdgeInsets.only(top: 10.0, bottom: 5.0),
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: ThemeService().isDarkMode()
                ? Colors.grey[400]!.withOpacity(0.5)
                : Colors.black45),
        child: const Padding(
          padding: EdgeInsets.all(4.0),
          child: Icon(Icons.search, color: Colors.white),
        ),
      ),
    );
  }
}

class LogoutActionButton extends StatelessWidget {
  final HomeController controller;
  const LogoutActionButton({Key? key, required this.controller})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashFactory: NoSplash.splashFactory,
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      onTap: () {
        controller.logout();
      },
      child: Container(
        margin: const EdgeInsets.only(
            top: 10.0, bottom: 5.0, left: 5.0, right: 8.0),
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: ThemeService().isDarkMode()
                ? Colors.grey[400]!.withOpacity(0.5)
                : Colors.black45),
        child: const Padding(
          padding: EdgeInsets.all(4.0),
          child: Icon(Icons.logout_rounded, color: Colors.white),
        ),
      ),
    );
  }
}

class ThemeActionButton extends StatelessWidget {
  final HomeController controller;
  const ThemeActionButton({Key? key, required this.controller})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashFactory: NoSplash.splashFactory,
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      onTap: () async {
        await controller.changeTheme();
      },
      child: Container(
        margin: const EdgeInsets.only(top: 10.0, bottom: 5.0, left: 5.0),
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: ThemeService().isDarkMode()
                ? Colors.grey[400]!.withOpacity(0.5)
                : Colors.black45),
        child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: Obx(() {
            return Icon(
                controller.isDarkMode.value
                    ? Icons.light_mode
                    : Icons.dark_mode,
                color: Colors.white);
          }),
        ),
      ),
    );
  }
}

class FavoriteActionButton extends StatelessWidget {
  final HomeController controller;
  const FavoriteActionButton({Key? key, required this.controller})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return controller.favoritesCount.value > 0
          ? GestureDetector(
              onTap: () => Get.toNamed(PageRouter.FAVORITES),
              child: Container(
                  margin:
                      const EdgeInsets.only(left: 5.0, bottom: 5.0, top: 10.0),
                  child: Badge(
                    animationType: BadgeAnimationType.slide,
                    badgeContent: Text(
                        controller.favoritesCount.value.toString(),
                        style:
                            const TextStyle(fontSize: 10, color: Colors.white)),
                    child: Container(
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: ThemeService().isDarkMode()
                              ? Colors.grey[400]!.withOpacity(0.5)
                              : Colors.black45),
                      child: const Padding(
                        padding: EdgeInsets.all(4.0),
                        child: Icon(Icons.favorite),
                      ),
                    ),
                  )),
            )
          : GestureDetector(
              onTap: () => Get.toNamed(PageRouter.FAVORITES),
              child: Container(
                margin:
                    const EdgeInsets.only(bottom: 5.0, top: 10.0, left: 5.0),
                child: Container(
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: ThemeService().isDarkMode()
                          ? Colors.grey[400]!.withOpacity(0.5)
                          : Colors.black45),
                  child: const Padding(
                    padding: EdgeInsets.all(4.0),
                    child: Icon(Icons.favorite),
                  ),
                ),
              ),
            );
    });
  }
}

class MoviesListWidget extends StatelessWidget {
  final HomeController controller;
  final MediaQueryData mediaQuery;
  const MoviesListWidget(
      {Key? key, required this.controller, required this.mediaQuery})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Expanded(
        child: Container(
          margin: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
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
                      bottom: 0,
                      right: 0,
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.amber,
                            splashFactory: NoSplash.splashFactory,
                            shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(10.0),
                                    bottomLeft: Radius.circular(10.0)))),
                        child: Text(
                            movie.voteAverage.toStringAsFixed(2) + ' 💜',
                            style: const TextStyle(
                                color: Colors.black,
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
                  child: Text(movie.originalTitle,
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
  final categoryController = GroupButtonController(selectedIndex: 0);
  CategoriesWidget({Key? key, required this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
        margin: const EdgeInsets.only(top: 5, left: 5),
        height: 50.0,
        duration: const Duration(milliseconds: 400),
        curve: Curves.bounceInOut,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: GroupButton(
            controller: categoryController,
            isRadio: true,
            options: GroupButtonOptions(
                elevation: 4.0,
                spacing: 3.0,
                groupingType: GroupingType.row,
                direction: Axis.horizontal,
                selectedColor: Colors.amber,
                unselectedTextStyle: Theme.of(context)
                    .textTheme
                    .headline6
                    ?.copyWith(
                        fontSize: 14.0,
                        fontWeight: FontWeight.w400,
                        fontFamily: GoogleFonts.beVietnamPro().fontFamily),
                selectedTextStyle: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                    fontFamily: GoogleFonts.beVietnamPro().fontFamily),
                unselectedColor: Theme.of(context).cardTheme.color,
                borderRadius: BorderRadius.circular(15.0)),
            onSelected: (_, index, __) async {
              controller.setSelectedCategory(index);
            },
            buttons: const [
              'Now playing',
              'New',
              'Top rated',
              'Upcoming',
              'TV shows'
            ],
          ),
        ));
  }
}
