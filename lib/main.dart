import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_loggy/flutter_loggy.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:loggy/loggy.dart';
import 'data/models/movie_model.dart';
import 'helpers/constants.dart';
import 'myth_flix_app.dart';
import 'service/api_service.dart';
import 'service/auth_service.dart';

void main() async {
  await init();
  await inject();
  FlutterNativeSplash.remove();
  runApp(const MythFlixApp());
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
  await Hive.openBox<Movie>(Constants.DB_NAME);
}

Future<void> inject() async {
  Get.lazyPut(() => ApiService(), fenix: true);
  Get.lazyPut(() => AuthService(), fenix: true);
  Get.lazyPut(() => FirebaseAuth.instance, fenix: true);
}
