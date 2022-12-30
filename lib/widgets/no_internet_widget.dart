import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

class NoInternetWidget extends StatelessWidget {
  const NoInternetWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Expanded(
      child: Center(
          child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Lottie.asset('assets/lottie/no_internet.json',
              width: deviceSize.width * 0.4,
              height: deviceSize.width * 0.4,
              repeat: false),
          30.verticalSpace,
          Text(
            'No Internet Connection',
            style: GoogleFonts.josefinSans()
                .copyWith(fontSize: 18.sp, fontWeight: FontWeight.w600),
          )
        ],
      )),
    );
  }
}
