// ignore_for_file: unnecessary_import

import 'package:flutter/material.dart';
import 'package:get/state_manager.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:movie_database/helpers/constants.dart';
import 'package:movie_database/helpers/styles.dart';
import 'package:movie_database/screens/home/home_controller.dart';
import 'package:get/get.dart';
import 'package:movie_database/screens/movie_detail/movie_detail_screen.dart';

class Home extends GetResponsiveView<HomeController> {
  Home({Key? key}) : super(key: key);
  final mediaQuery = Get.mediaQuery;

  @override
  Widget? phone() {
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
          Container(
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
          ),
          Obx(() {
            return Expanded(
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
                            mediaQuery.orientation == Orientation.portrait
                                ? 2
                                : 3,
                        crossAxisSpacing: 4.0,
                        mainAxisSpacing: 4.0),
                    itemBuilder: (ctx, index) {
                      return InkWell(
                        onTap: () => Get.to(() =>
                            MovieDetailScreen(movie: controller.movies[index])),
                        child: LayoutBuilder(builder: (context, constraints) {
                          return Card(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15)),
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
                                                      .movies[index]
                                                      .posterPath !=
                                                  null
                                              ? Constants.IMAGE_BASE_URL +
                                                  controller
                                                      .movies[index].posterPath
                                              : 'https://globalnews.ca/wp-content/uploads/2020/06/jfj50169012-2.jpg?quality=85&strip=all'),
                                        ),
                                      ),
                                      Positioned(
                                        bottom: 0,
                                        right: 0,
                                        child: ElevatedButton(
                                          onPressed: () {},
                                          style: ElevatedButton.styleFrom(
                                              splashFactory: NoSplash
                                                  .splashFactory,
                                              shape:
                                                  const RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.only(
                                                              topLeft: Radius
                                                                  .circular(
                                                                      10.0),
                                                              bottomLeft: Radius
                                                                  .circular(
                                                                      10.0)))),
                                          child: Text(
                                              controller
                                                      .movies[index].voteAverage
                                                      .toString() +
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
                                  child: Text(
                                      controller.movies[index].originalTitle,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontFamily: GoogleFonts.staatliches()
                                              .copyWith()
                                              .fontFamily)),
                                ),
                                SizedBox(height: constraints.maxHeight * 0.01),
                                Expanded(
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: constraints.maxWidth * 0.05,
                                        vertical: constraints.maxHeight * 0.01),
                                    child: Text(
                                        controller.movies[index].overview,
                                        style: TextStyle(
                                            fontFamily: GoogleFonts.quicksand()
                                                .copyWith()
                                                .fontFamily),
                                        maxLines: mediaQuery.orientation ==
                                                Orientation.portrait
                                            ? 2
                                            : 4,
                                        overflow: TextOverflow.ellipsis),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }),
                      );
                    }),
              ),
            );
          }),
        ],
      )),
    );
  }

  @override
  Widget? desktop() {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Flutter Movies'),
      ),
      body: SafeArea(child: Obx(() {
        return GridView.builder(
            itemCount: controller.movies.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                mainAxisExtent: mediaQuery.orientation == Orientation.portrait
                    ? mediaQuery.size.height * 0.4
                    : mediaQuery.size.height * 0.8,
                crossAxisCount:
                    mediaQuery.orientation == Orientation.portrait ? 3 : 4,
                crossAxisSpacing: 6.0,
                mainAxisSpacing: 6.0),
            itemBuilder: (ctx, index) {
              return LayoutBuilder(builder: (context, constraints) {
                return Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)),
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
                                child: Image.network(Constants.IMAGE_BASE_URL +
                                    controller.movies[index].posterPath),
                              ),
                            ),
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: ElevatedButton(
                                onPressed: () {},
                                style: ElevatedButton.styleFrom(
                                    shape: const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(10.0),
                                            bottomLeft:
                                                Radius.circular(10.0)))),
                                child: Text(
                                    controller.movies[index].voteAverage
                                            .toString() +
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
                            vertical: constraints.maxHeight * 0.01),
                        child: Text(controller.movies[index].originalTitle,
                            style: TextStyle(
                                fontSize: 16,
                                fontFamily: GoogleFonts.staatliches()
                                    .copyWith()
                                    .fontFamily)),
                      ),
                      SizedBox(height: constraints.maxHeight * 0.01),
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: constraints.maxWidth * 0.05,
                              vertical: constraints.maxHeight * 0.01),
                          child: Text(controller.movies[index].overview,
                              style: TextStyle(
                                  fontFamily: GoogleFonts.quicksand()
                                      .copyWith()
                                      .fontFamily),
                              maxLines:
                                  mediaQuery.orientation == Orientation.portrait
                                      ? 3
                                      : 6,
                              overflow: TextOverflow.ellipsis),
                        ),
                      ),
                    ],
                  ),
                );
              });
            });
      })),
    );
  }
}
