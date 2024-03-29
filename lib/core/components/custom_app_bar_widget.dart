import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:movie_database/core/service/theme_service.dart';

class CustomAppBar extends StatelessWidget {
  final String title;
  final List<Widget>? actions;
  final bool isBackEnabled;
  const CustomAppBar(
      {Key? key,
      required this.title,
      this.actions,
      required this.isBackEnabled})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 2.0,
      color: ThemeService().isDarkMode() ? Colors.transparent : null,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: actions != null ? 4.h : 12.h),
        decoration: BoxDecoration(
            border: Border(
                bottom: BorderSide(
                    color: ThemeService().isDarkMode()
                        ? Colors.white30
                        : Colors.grey.shade300))),
        child: Row(
          children: [
            if (isBackEnabled) 10.horizontalSpace,
            if (isBackEnabled)
              InkWell(
                onTap: () => Get.back(),
                child: Icon(
                  CupertinoIcons.back,
                  size: 20.h,
                  color: Theme.of(context).textTheme.titleLarge?.color,
                ),
              ),
            10.horizontalSpace,
            Expanded(
              child: Text(title,
                  maxLines: 2,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontSize: 20.sp,
                      overflow: TextOverflow.ellipsis,
                      fontFamily: GoogleFonts.josefinSans().fontFamily)),
            ),
            if (actions != null) const Spacer(),
            if (actions != null) ..._buildActions(actions!),
            10.horizontalSpace
          ],
        ),
      ),
    );
  }

  List<Widget> _buildActions(List<Widget> actions) {
    final List<Widget> x = [];
    for (var element in actions) {
      x.add(element);
      x.add(2.horizontalSpace);
    }
    return x;
  }
}
