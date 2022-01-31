import 'package:flutter/material.dart';
import 'package:flutter_loggy/flutter_loggy.dart';
import 'package:get/get.dart';
import 'package:loggy/loggy.dart';
import 'package:movie_database/helpers/styles.dart';
import 'package:movie_database/routes/router.dart';

void main() {
  Loggy.initLoggy(
    logPrinter: const PrettyDeveloperPrinter(),
  );
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
      initialRoute: AppRouter.LOGIN,
      getPages: AppRouter().getPages,
    );
  }
}
