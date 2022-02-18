import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:movie_database/helpers/constants.dart';
import 'package:movie_database/models/review_response.dart';

class Review extends StatelessWidget {
  final List<ReviewResults> reviews;
  const Review({Key? key, required this.reviews}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Text('Flutter Movies',
            style: TextStyle(
                fontSize: 25.0,
                fontFamily: GoogleFonts.caveat().copyWith().fontFamily)),
      ),
      body: SafeArea(child: ListView.builder(itemBuilder: (ctx, index) {
        return ListTile(
          leading: CircleAvatar(
              radius: 40.0,
              backgroundImage: NetworkImage(Constants.IMAGE_BASE_URL +
                  reviews[index].authorDetails.avatarPath.toString())),
                  title: Text(reviews[index].author),
                  subtitle: Text(reviews[index].content),
        );
      })),
    );
  }
}
