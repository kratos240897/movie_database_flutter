import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../service/theme_service.dart';

class CustomActionButton extends StatelessWidget {
  final GestureTapCallback onTap;
  final IconData icon;
  final int? badgeCount;
  const CustomActionButton(
      {Key? key, required this.onTap, required this.icon, this.badgeCount})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashFactory: NoSplash.splashFactory,
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      onTap: onTap,
      child: badgeCount != null
          ? Badge(
              animationType: BadgeAnimationType.slide,
              badgeContent: Text(badgeCount.toString(),
                  style: TextStyle(fontSize: 10.sp, color: Colors.white)),
              child: Container(
                margin: const EdgeInsets.only(top: 10.0, bottom: 5.0),
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: ThemeService().isDarkMode()
                        ? Colors.grey[400]!.withOpacity(0.5)
                        : Colors.black45),
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Icon(
                    icon,
                    color: Colors.white,
                    size: 20.sp,
                  ),
                ),
              ),
            )
          : Container(
              margin: const EdgeInsets.only(top: 10.0, bottom: 5.0),
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: ThemeService().isDarkMode()
                      ? Colors.grey[400]!.withOpacity(0.5)
                      : Colors.black45),
              child: Padding(
                padding: EdgeInsets.all(6.r),
                child: Icon(
                  icon,
                  color: Colors.white,
                  size: 16.sp,
                ),
              ),
            ),
    );
  }
}
