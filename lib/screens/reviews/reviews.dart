import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
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
          title: const Text(
            'Reviews',
          )),
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
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18.0,
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
                            style: TextStyle(
                                fontSize: 14.0,
                                color: Colors.black,
                                height: 1.5,
                                fontFamily: GoogleFonts.spartan().fontFamily),
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
                        FontAwesomeIcons.solidCommentDots,
                        size: 50.0,
                      ),
                      const SizedBox(height: 20.0),
                      Text(
                        'No reviews !',
                        style: GoogleFonts.actor(
                            fontWeight: FontWeight.w600,
                            fontSize: 25.0,
                            letterSpacing: 1.5),
                      )
                    ],
                  ),
                )),
    );
  }
}
