import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../data/models/review_response.dart';

class Review extends StatelessWidget {
  final List<ReviewResults> reviews;
  const Review({Key? key, required this.reviews}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          centerTitle: true,
          leading: IconButton(
            onPressed: () => Get.back(),
            icon: Icon(
              CupertinoIcons.back,
              size: 20.h,
              color: Theme.of(context).textTheme.headline6?.color,
            ),
          ),
          title: Text('Reviews',
              style: Theme.of(context).textTheme.headline6?.copyWith(
                  fontSize: 22.sp,
                  fontFamily:
                      GoogleFonts.josefinSans().copyWith().fontFamily))),
      body: SafeArea(
          child: reviews.isNotEmpty
              ? ListView.builder(
                  itemCount: reviews.length,
                  itemBuilder: (ctx, index) {
                    return Card(
                      elevation: 4.0,
                      shadowColor: Colors.grey,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0)),
                      margin: const EdgeInsets.symmetric(
                          horizontal: 12.0, vertical: 5.0),
                      child: ListTile(
                        title: Row(
                          children: [
                            reviews[index].authorDetails.avatarPath != null
                                ? CircleAvatar(
                                    radius: 35.0,
                                    backgroundImage: NetworkImage(reviews[index]
                                        .authorDetails
                                        .avatarPath
                                        .toString()))
                                : const CircleAvatar(
                                    radius: 35.0,
                                    backgroundImage:
                                        AssetImage('assets/images/user.png')),
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
                                        fontFamily:
                                            GoogleFonts.spartan().fontFamily),
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
                                        GoogleFonts.spartan().fontFamily),
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
                                  fontFamily: GoogleFonts.spartan().fontFamily,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16.0,
                                  letterSpacing: 0.2)),
                    ],
                  ),
                )),
    );
  }
}
