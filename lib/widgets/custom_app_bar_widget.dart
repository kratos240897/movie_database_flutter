import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

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
    return Row(
      children: [
        if (isBackEnabled)
          InkWell(
            onTap: () => Get.back(),
            child: Icon(
              CupertinoIcons.back,
              size: 20.h,
              color: Theme.of(context).textTheme.headline6?.color,
            ),
          ),
        10.horizontalSpace,
        Expanded(
          child: Text(title,
              maxLines: 2,
              style: Theme.of(context).textTheme.headline6?.copyWith(
                  fontSize: 22.sp,
                  overflow: TextOverflow.ellipsis,
                  fontFamily: GoogleFonts.josefinSans().copyWith().fontFamily)),
        ),
        if (actions != null) const Spacer(),
        if (actions != null) ..._buildActions(actions!)
      ],
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
