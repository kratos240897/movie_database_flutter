import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../service/theme_service.dart';

class CustomErrorWidget extends StatelessWidget {
  final FlutterErrorDetails errorDetails;
  const CustomErrorWidget({Key? key, required this.errorDetails})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'OOPS!',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  letterSpacing: 2.0,
                  fontFamily: GoogleFonts.raleway().fontFamily,
                  fontSize: 20.sp,
                  fontWeight: FontWeight.bold),
            ),
            8.verticalSpace,
            Text(
              'Something went wrong.',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontSize: 16.sp,
                  fontFamily: GoogleFonts.poppins().fontFamily),
            ),
            12.verticalSpace,
            ElevatedButton(
              onPressed: () {
                Get.back();
              },
              style: ElevatedButton.styleFrom(
                  backgroundColor:
                      ThemeService().isDarkMode() ? Colors.white : Colors.black,
                  shape: const StadiumBorder()),
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 12.w),
                child: Text(
                  'Go Back',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontSize: 14.sp,
                      color: ThemeService().isDarkMode()
                          ? Colors.black
                          : Colors.white,
                      fontWeight: FontWeight.bold,
                      fontFamily: GoogleFonts.poppins().fontFamily),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
