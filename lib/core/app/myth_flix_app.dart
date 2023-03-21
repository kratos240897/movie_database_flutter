import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:get/instance_manager.dart';
import '../components/custom_error_widget.dart';
import '../init/theme/dark_theme.dart';
import '../init/theme/light_theme.dart';
import '../init/routes/router.dart';
import '../service/auth_service.dart';
import '../service/theme_service.dart';

class MythFlixApp extends StatefulWidget {
  const MythFlixApp({Key? key}) : super(key: key);

  @override
  State<MythFlixApp> createState() => _MythFlixAppState();
}

class _MythFlixAppState extends State<MythFlixApp> {
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
    return ScreenUtilInit(
        minTextAdapt: true,
        builder: (context, child) {
          return GetMaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Myth Flix',
            theme: lightTheme,
            darkTheme: darkTheme,
            themeMode: ThemeService().getThemeMode(),
            builder: (context, child) {
              ErrorWidget.builder = (details) {
                return CustomErrorWidget(errorDetails: details);
              };
              return ScrollConfiguration(
                behavior: const ScrollBehaviorModified(),
                child: child!,
              );
            },
            initialRoute:
                isLoggedIn == true ? PageRouter.HOME : PageRouter.LOGIN,
            onGenerateRoute: PageRouter().generateRoutes,
          );
        });
  }
}

class ScrollBehaviorModified extends ScrollBehavior {
  const ScrollBehaviorModified();
  @override
  ScrollPhysics getScrollPhysics(BuildContext context) {
    switch (getPlatform(context)) {
      case TargetPlatform.iOS:
      case TargetPlatform.macOS:
      case TargetPlatform.android:
        return const BouncingScrollPhysics();
      case TargetPlatform.fuchsia:
      case TargetPlatform.linux:
      case TargetPlatform.windows:
        return const BouncingScrollPhysics();
    }
  }
}
