import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:movie_database/widgets/custom_app_bar_widget.dart';
import '../../data/models/review_response.dart';

class Review extends StatelessWidget {
  final List<ReviewResults> reviews;
  const Review({Key? key, required this.reviews}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(left: 12.w, bottom: 8.h, top: 8.h),
            child: const CustomAppBar(title: 'Reviews', isBackEnabled: true),
          ),
          Expanded(
              child: reviews.isNotEmpty
                  ? ListView.builder(
                      padding: EdgeInsets.symmetric(horizontal: 12.w),
                      itemCount: reviews.length,
                      itemBuilder: (ctx, index) {
                        return Card(
                          elevation: 4.0,
                          shadowColor: Colors.grey,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15.r)),
                          margin: EdgeInsets.symmetric(vertical: 6.h),
                          child: ListTile(
                            title: Row(
                              children: [
                                reviews[index].authorDetails.avatarPath != null
                                    ? CircleAvatar(
                                        radius: 25.r,
                                        backgroundImage: NetworkImage(
                                            reviews[index]
                                                .authorDetails
                                                .avatarPath
                                                .toString()))
                                    : const CircleAvatar(
                                        radius: 25.0,
                                        backgroundImage: AssetImage(
                                            'assets/images/user.png')),
                                const SizedBox(width: 15.0),
                                Expanded(
                                  child: Text(
                                    reviews[index].author,
                                    style: Theme.of(context)
                                        .textTheme
                                        .headline6
                                        ?.copyWith(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14.sp,
                                            overflow: TextOverflow.ellipsis,
                                            fontFamily: GoogleFonts.leagueSpartan()
                                                .fontFamily),
                                  ),
                                ),
                              ],
                            ),
                            subtitle: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8.0, vertical: 10.0),
                              child: Text(
                                reviews[index].content,
                                style: Theme.of(context)
                                    .textTheme
                                    .headline6
                                    ?.copyWith(
                                        fontSize: 14.0,
                                        height: 1.5,
                                        fontFamily:
                                            GoogleFonts.leagueSpartan().fontFamily),
                              ),
                            ),
                          ),
                        );
                      })
                  : Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const FaIcon(
                            FontAwesomeIcons.commentDots,
                            size: 50.0,
                            color: Colors.green,
                          ),
                          const SizedBox(height: 20.0),
                          Text('No reviews found !',
                              style: Theme.of(context)
                                  .textTheme
                                  .headline6
                                  ?.copyWith(
                                      fontFamily:
                                          GoogleFonts.leagueSpartan().fontFamily,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 16.0,
                                      letterSpacing: 0.2)),
                        ],
                      ),
                    ))
        ],
      )),
    );
  }
}
