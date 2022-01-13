import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:movie_database/helpers/styles.dart';
import 'package:movie_database/routes/router.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Movies',
      theme: ThemeData(
        primarySwatch: Styles.colors.primaryColor,
      ),
      initialRoute: AppRouter.HOME,
      getPages: AppRouter().getPages,
    );
  }
}
