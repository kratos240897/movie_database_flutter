// ignore_for_file: unused_import

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/state_manager.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../core/components/custom_app_bar_widget.dart';
import '../home/presentation/views/movies_list_widget.dart';
import '../../core/constants/app/app_constants.dart';
import '../../core/data/models/movie_model.dart';
import '../../core/init/local_storage/boxes.dart';
import './favorites_controller.dart';

class Favorties extends GetView<FavoritesController> {
  const Favorties({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(left: 12.w, bottom: 8.h, top: 8.h),
            child: const CustomAppBar(title: 'Favorites', isBackEnabled: true),
          ),
          Expanded(
            child: ValueListenableBuilder(
                valueListenable: Boxes.getFavorites().listenable(),
                builder: (context, Box<Movie> box, child) {
                  final favorites = box.values.toList().cast<Movie>();
                  return MovieListWidget(movies: favorites);
                }),
          ),
        ],
      )),
    );
  }
}
