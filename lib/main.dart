import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_loggy/flutter_loggy.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:loggy/loggy.dart';
import 'package:movie_database/helpers/constants.dart';
import 'package:movie_database/helpers/helpers.dart';
import 'package:movie_database/helpers/styles.dart';
import 'package:movie_database/routes/router.dart';
import 'package:movie_database/service/auth_service.dart';
import './models/movie_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(statusBarColor: Styles.colors.primaryColor));
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  await Firebase.initializeApp();
  await Hive.initFlutter();
  Hive.registerAdapter(MovieAdapter());
  await Hive.openBox<Movie>(Constants.DB_NAME);
  Loggy.initLoggy(
    logPrinter: const PrettyDeveloperPrinter(),
  );
  inject();
  FlutterNativeSplash.remove();
  runApp(const MyApp());
}


void inject() {
  Get.lazyPut(() => AuthService(), fenix: true);
  Get.lazyPut(() => FirebaseAuth.instance, fenix: true);
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final AuthService _authService = Get.find<AuthService>();
  var isLoggedIn = false;

  @override
  void initState() {
    if (_authService.getUser() != null) {
      isLoggedIn = true;
    } else {
      false;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Movies',
      theme: ThemeData(
        primarySwatch: Styles.colors.primaryColor,
      ),
      initialRoute: isLoggedIn == true ? AppRouter.HOME : AppRouter.LOGIN,
      onGenerateRoute: AppRouter().generateRoutes,
    );
  }
}
