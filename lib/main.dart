import 'package:evolvex_lib/evolvex_lib.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:movie_database/core/app/myth_flix_app.dart';
import 'core/base/service_locator.dart';
import 'core/data/models/movie_model.dart';
import 'core/constants/app/app_constants.dart';
import 'core/service/auth_service.dart';

void main() async {
  await init();
  await inject();
  await setUpServiceLocator();
  FlutterNativeSplash.remove();
  runApp(const MythFlixApp());
}

Future<void> init() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setSystemPreference();
  await dotenv.load(fileName: ".env");
  await initFirebase();
  await initHive();
  EvolveX.init();
  await GetStorage.init();
}

Future<void> setSystemPreference() async {
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
  await Hive.openBox<Movie>(AppConstants.DB_NAME);
}

Future<void> inject() async {
  Get.lazyPut(() => ApiService(baseUrl: AppConstants.BASE_URLm), fenix: true);
  Get.lazyPut(() => AuthService(), fenix: true);
  Get.lazyPut(() => FirebaseAuth.instance, fenix: true);
}
