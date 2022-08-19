import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
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

import 'data/models/movie_model.dart';
import 'service/api_service.dart';

void main() async {
  await init();
  await inject();
  FlutterNativeSplash.remove();
  runApp(const MyApp());
}

Future<void> init() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setSystemPreference();
  await dotenv.load(fileName: ".env");
  await initFirebase();
  await initHive();
  Loggy.initLoggy(
    logPrinter: const PrettyDeveloperPrinter(),
  );
}

Future<void> setSystemPreference() async {
  SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(statusBarColor: Styles.colors.primaryColor));
  await SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
}

Future<void> initFirebase() async {
  if (GetPlatform.isMobile) {
    await Firebase.initializeApp();
  } else if (GetPlatform.isMacOS) {
    await Firebase.initializeApp(
        options: FirebaseOptions(
            apiKey: dotenv.env['FIREBASE_API_KEY']!,
            appId: dotenv.env['APPLE_APP_ID']!,
            messagingSenderId: dotenv.env['MESSAGING_SENDER_ID']!,
            projectId: dotenv.env['PROJECT_ID']!));
  } else if (GetPlatform.isWeb) {
    await Firebase.initializeApp(
        options: FirebaseOptions(
            apiKey: dotenv.env['FIREBASE_API_KEY']!,
            appId: dotenv.env['APP_ID']!,
            messagingSenderId: dotenv.env['MESSAGING_SENDER_ID']!,
            projectId: dotenv.env['PROJECT_ID']!));
  }
}

Future<void> initHive() async {
  await Hive.initFlutter();
  Hive.registerAdapter(MovieAdapter());
  await Hive.openBox<Movie>(Constants.DB_NAME);
}

Future<void> inject() async {
  Get.lazyPut(() => ApiService(), fenix: true);
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
      title: 'Myth Flix',
      theme: ThemeData(
        primarySwatch: Styles.colors.primaryColor,
      ),
      initialRoute: isLoggedIn == true ? PageRouter.HOME : PageRouter.LOGIN,
      onGenerateRoute: PageRouter().generateRoutes,
    );
  }
}
