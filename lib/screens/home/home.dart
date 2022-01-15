// ignore_for_file: unnecessary_import

import 'package:flutter/material.dart';
import 'package:focused_menu/focused_menu.dart';
import 'package:focused_menu/modals.dart';
import 'package:get/state_manager.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:movie_database/helpers/constants.dart';
import 'package:movie_database/helpers/styles.dart';
import 'package:movie_database/screens/home/home_controller.dart';
import 'package:get/get.dart';
import 'package:movie_database/screens/movie_detail/movie_detail_screen.dart';

class Home extends GetView<HomeController> {
  Home({Key? key}) : super(key: key);
  final mediaQuery = Get.mediaQuery;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Flutter Movies',
            style: TextStyle(
                fontSize: 25.0,
                fontFamily: GoogleFonts.caveat().copyWith().fontFamily)),
      ),
      body: SafeArea(
          child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CategoriesWidget(controller: controller),
          MoviesListWidget(controller: controller, mediaQuery: mediaQuery)
        ],
      )),
    );
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
                        mediaQuery.orientation == Orientation.portrait ? 2 : 3,
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
                            title: Text('Favorite',
                                style: Styles.textStyles.f14Regular),
                            trailingIcon:
                                const Icon(Icons.favorite, color: Colors.red),
                            onPressed: () {}),
                        FocusedMenuItem(
                            title: Text('Share',
                                style: Styles.textStyles.f14Regular),
                            trailingIcon:
                                const Icon(Icons.share, color: Colors.blue),
                            onPressed: () {}),
                        FocusedMenuItem(
                            title: Text('Vote',
                                style: Styles.textStyles.f14Regular),
                            trailingIcon: const Icon(Icons.volunteer_activism,
                                color: Colors.green),
                            onPressed: () {})
                      ],
                      onPressed: () {},
                      child: MovieListItem(
                        controller: controller,
                        index: index,
                        mediaQuery: mediaQuery,
                      ));
                }),
          ),
        ),
      );
    });
  }
}

class MovieListItem extends StatelessWidget {
  final HomeController controller;
  final int index;
  final MediaQueryData mediaQuery;
  const MovieListItem(
      {Key? key,
      required this.controller,
      required this.index,
      required this.mediaQuery})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Get.to(
        () => MovieDetailScreen(movie: controller.movies[index]),
      ),
      child: Hero(
        tag: controller.movies[index],
        child: LayoutBuilder(builder: (context, constraints) {
          return Card(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            elevation: 4,
            child: Column(
              children: [
                SizedBox(
                  height: constraints.maxHeight * 0.6,
                  child: Stack(
                    children: [
                      Positioned(
                        top: 0,
                        left: 0,
                        right: 0,
                        child: ClipRRect(
                          borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(15),
                              topRight: Radius.circular(15)),
                          child: Image.network(controller
                                      .movies[index].posterPath !=
                                  null
                              ? Constants.IMAGE_BASE_URL +
                                  controller.movies[index].posterPath
                              : 'https://globalnews.ca/wp-content/uploads/2020/06/jfj50169012-2.jpg?quality=85&strip=all'),
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                              splashFactory: NoSplash.splashFactory,
                              shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(10.0),
                                      bottomLeft: Radius.circular(10.0)))),
                          child: Text(
                              controller.movies[index].voteAverage.toString() +
                                  ' ⭐',
                              textAlign: TextAlign.end),
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(height: constraints.maxHeight * 0.01),
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: constraints.maxWidth * 0.02,
                      vertical: constraints.maxHeight * 0.01),
                  child: Text(controller.movies[index].originalTitle,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 16,
                          fontFamily:
                              GoogleFonts.staatliches().copyWith().fontFamily)),
                ),
                SizedBox(height: constraints.maxHeight * 0.01),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: constraints.maxWidth * 0.05,
                        vertical: constraints.maxHeight * 0.01),
                    child: Text(controller.movies[index].overview,
                        style: TextStyle(
                            fontFamily:
                                GoogleFonts.quicksand().copyWith().fontFamily),
                        maxLines: mediaQuery.orientation == Orientation.portrait
                            ? 2
                            : 4,
                        overflow: TextOverflow.ellipsis),
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}

class CategoriesWidget extends StatelessWidget {
  final HomeController controller;
  const CategoriesWidget({Key? key, required this.controller})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 5, left: 5),
      height: 40.0,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: controller.categories.length,
        itemBuilder: (ctx, index) {
          var _category = controller.categories[index].toString();
          return Obx(
            () {
              return Container(
                  alignment: Alignment.center,
                  margin: const EdgeInsets.all(5.0),
                  child: _category.toString ==
                          controller.selectedCategory.value.toString
                      ? ElevatedButton(
                          onPressed: () {
                            controller.setSelectedCategory(_category);
                          },
                          style: ElevatedButton.styleFrom(
                              primary: Styles.colors.primaryColor,
                              shape: const StadiumBorder()),
                          child: Text(_category,
                              style: TextStyle(
                                  fontSize: 14.0,
                                  fontFamily: GoogleFonts.raleway()
                                      .copyWith()
                                      .fontFamily)))
                      : InkWell(
                          onTap: () =>
                              controller.setSelectedCategory(_category),
                          child: Text(
                            _category,
                            style: TextStyle(
                                fontSize: 14.0,
                                fontFamily: GoogleFonts.raleway()
                                    .copyWith()
                                    .fontFamily),
                          ),
                        ));
            },
          );
        },
      ),
    );
  }
}
