import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/route_manager.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:movie_database/enum/snackbar_status.dart';
import 'package:movie_database/helpers/styles.dart';

class Utils {
  final context = Get.context!;
  showSnackBar(String title, String message, SnackBarStatus status) async {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    final snackBar = SnackBar(
        duration: const Duration(seconds: 5),
        dismissDirection: DismissDirection.horizontal,
        backgroundColor:
            Get.isDarkMode ? Theme.of(context).cardTheme.color : Colors.white,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.r)),
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.all(15.w),
        content: SizedBox(
          height: 0.06.sh,
          child: Row(children: [
            Container(
              decoration: BoxDecoration(
                  color: status == SnackBarStatus.success ? Colors.green : status == SnackBarStatus.failure ? Colors.red : Colors.blue,
                  borderRadius: BorderRadius.circular(5.r)),
              width: 0.02.sw,
            ),
            SizedBox(width: 0.05.sw),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Styles.textStyles.f14Bold?.copyWith(
                      fontSize: 16.sp,
                      color: Theme.of(context).textTheme.headline6?.color),
                ),
                5.verticalSpace,
                Text(message,
                    style: Styles.textStyles.f14Bold?.copyWith(
                        fontSize: 14.sp,
                        color: Theme.of(context).textTheme.headline6?.color)),
              ],
            ),
            const Spacer(),
            IconButton(
                onPressed: () =>
                    ScaffoldMessenger.of(context).hideCurrentSnackBar(),
                icon: Icon(
                  Icons.close,
                  color: Get.isDarkMode ? Colors.white : Colors.black,
                ))
          ]),
        ));
    await Future.delayed(const Duration(milliseconds: 500), () {});
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
                            style: Theme.of(context)
                                .textTheme
                                .headline6
                                ?.copyWith(
                                    fontSize: 20.0,
                                    fontFamily:
                                        GoogleFonts.poppins().fontFamily),
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
}
