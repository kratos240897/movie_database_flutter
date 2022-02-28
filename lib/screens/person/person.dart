import 'package:flutter/material.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:get/state_manager.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:movie_database/screens/person/person_controller.dart';

import '../../helpers/constants.dart';

class Person extends StatefulWidget {
  final String title;
  final String id;
  const Person({Key? key, required this.title, required this.id})
      : super(key: key);

  @override
  State<Person> createState() => _PersonState();
}

class _PersonState extends State<Person> {
  PersonController controller = Get.find<PersonController>();

  @override
  void initState() {
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      controller.getPerson(widget.id);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: SafeArea(
        child: Obx(() {
          return SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  margin: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      controller.isLoaded.value == true
                          ? CircleAvatar(
                              radius: 60.0,
                              backgroundImage: NetworkImage(
                                  Constants.BASE_IMAGE_URL +
                                      controller.profile.profilePath),
                            )
                          : const CircleAvatar(
                              radius: 60.0,
                              backgroundImage:
                                  AssetImage('assets/images/user.png'))
                    ],
                  ),
                ),
                Wrap(
                    spacing: 1.0,
                    runSpacing: 1.0,
                    direction: Axis.horizontal,
                    children: List.generate(
                        controller.profile.alsoKnownAs.length, (index) {
                      return Container(
                        margin: const EdgeInsets.symmetric(horizontal: 5.0),
                        child: ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                                primary: Colors.amber,
                                splashFactory: NoSplash.splashFactory,
                                shape: const StadiumBorder()),
                            child: Text(controller.profile.alsoKnownAs[index],
                                style: const TextStyle(color: Colors.black))),
                      );
                    })),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 8.0, horizontal: 12.0),
                  child: Text(
                    controller.profile.biography,
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 15.0,
                        wordSpacing: 1.0,
                        height: 1.4,
                        fontFamily: GoogleFonts.quicksand().fontFamily),
                  ),
                )
              ],
            ),
          );
        }),
      ),
    );
  }
}
