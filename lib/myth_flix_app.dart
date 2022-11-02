import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:get/instance_manager.dart';
import 'package:movie_database/widgets/custom_error_widget.dart';
import 'helpers/themes.dart';
import 'routes/router.dart';
import 'service/auth_service.dart';
import 'service/theme_service.dart';

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
            theme: Themes().lightTheme,
            darkTheme: Themes().darkTheme,
            themeMode: ThemeService().getThemeMode(),
            builder: (context, child) {
              ErrorWidget.builder = (details) {
                return CustomErrorWidget(errorDetails: details);
              };
              return child!;
            },
            initialRoute:
                isLoggedIn == true ? PageRouter.HOME : PageRouter.LOGIN,
            onGenerateRoute: PageRouter().generateRoutes,
          );
        });
  }
}
