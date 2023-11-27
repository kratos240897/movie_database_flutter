import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/route_manager.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:movie_database/core/service/theme_service.dart';
import '../../constants/app/styles.dart';
import '../../constants/enums/device_type.dart';
import '../../constants/enums/snackbar_status.dart';

class Utils {
  final context = Get.context!;
  showSnackBar(String title, String message, SnackBarStatus status) async {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    final isDarkMode = ThemeService().isDarkMode();
    final snackBar = SnackBar(
        duration: const Duration(seconds: 5),
        dismissDirection: DismissDirection.horizontal,
        backgroundColor:
            isDarkMode ? Styles.colors.backgroundGrey : Colors.white,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.r)),
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.all(15.w),
        content: SizedBox(
          height: 0.06.sh,
          child: Row(children: [
            Container(
              decoration: BoxDecoration(
                  color: status == SnackBarStatus.success
                      ? Colors.green
                      : status == SnackBarStatus.failure
                          ? Colors.red
                          : Colors.blue,
                  borderRadius: BorderRadius.circular(5.r)),
              width: 0.02.sw,
            ),
            0.05.sw.horizontalSpace,
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Styles.textStyles.f16Regular(
                      color: isDarkMode ? Colors.white : Colors.black),
                ),
                4.verticalSpace,
                Expanded(
                    child: Text(message,
                        style: Styles.textStyles.f14Regular(
                            color: isDarkMode ? Colors.white : Colors.black)))
              ],
            ),
            const Spacer(),
            IconButton(
                onPressed: () =>
                    ScaffoldMessenger.of(context).hideCurrentSnackBar(),
                icon: Icon(
                  Icons.close,
                  color: isDarkMode ? Colors.white : Colors.black,
                ))
          ]),
        ));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  showLoading() {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => AlertDialog(
              insetPadding: EdgeInsets.zero,
              contentPadding: EdgeInsets.zero,
              clipBehavior: Clip.antiAliasWithSaveLayer,
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0))),
              content: Builder(
                builder: (context) {
                  return SizedBox(
                    height: Get.height * 0.25,
                    child: Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Loading... 🍿',
                            style: Styles.textStyles.f20Regular(
                                fontFamily: GoogleFonts.poppins().fontFamily),
                          ),
                          12.verticalSpace,
                          const CupertinoActivityIndicator(),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ));
  }

  hideLoading() {
    Navigator.pop(context);
  }

  static DeviceType getDeviceType(BuildContext context) {
    final data = MediaQueryData.fromView(View.of(context));
    return data.size.shortestSide < 550 ? DeviceType.phone : DeviceType.tablet;
  }
}
