import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../service/theme_service.dart';

class CustomActionButton extends StatelessWidget {
  final GestureTapCallback onTap;
  final IconData icon;
  const CustomActionButton({Key? key, required this.onTap, required this.icon})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashFactory: NoSplash.splashFactory,
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      onTap: onTap,
      child: Stack(
        children: [
          Container(
            margin: EdgeInsets.only(top: 10.h, bottom: 5.h),
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: ThemeService().isDarkMode()
                    ? Colors.grey[400]!.withOpacity(0.5)
                    : Colors.black38),
            child: Padding(
              padding: EdgeInsets.all(6.spMin),
              child: Icon(
                icon,
                color: Colors.white,
                size: 16.sp,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
