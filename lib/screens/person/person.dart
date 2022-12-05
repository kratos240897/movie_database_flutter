import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:get/state_manager.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:movie_database/screens/person/person_controller.dart';
import 'package:movie_database/service/theme_service.dart';

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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.getPerson(widget.id);
    });
    super.initState();
  }

  // previously used CustomScrollView with SliverAppBar and slivers[]
  // CustomScrollView(slivers: [
  //                 SliverAppBar(
  //                   backgroundColor: Styles.colors.primaryColor,
  //                   expandedHeight: 400.0,
  //                   pinned: true,
  //                   primary: true,
  //                   flexibleSpace: FlexibleSpaceBar(
  //                     title: Text(widget.title),
  //                     background: CachedNetworkImage(
  //                       imageUrl: Constants.BASE_IMAGE_URL +
  //                           controller.profile.profilePath,
  //                       fit: BoxFit.cover,
  //                     ),
  //                   ),
  //                   leading: Padding(
  //                     padding: const EdgeInsets.only(top: 5.0, left: 12.0),
  //                     child: InkWell(
  //                         onTap: () => Get.back(),
  //                         child: const Icon(Icons.arrow_back_ios_new_sharp)),
  //                   ),
  //                   centerTitle: true,
  //                   actions: const [
  //                     Padding(
  //                       padding: EdgeInsets.only(top: 5.0, right: 15.0),
  //                       child: Icon(FontAwesomeIcons.wikipediaW),
  //                     )
  //                   ],
  //                 ),
  //                 SliverToBoxAdapter(
  //                   child: Column(
  //                     children: [
  //                       Wrap(
  //                           spacing: 1.0,
  //                           runSpacing: 1.0,
  //                           alignment: WrapAlignment.spaceEvenly,
  //                           direction: Axis.horizontal,
  //                           children: List.generate(
  //                               controller.profile.alsoKnownAs.length, (index) {
  //                             return Container(
  //                               margin:
  //                                   const EdgeInsets.symmetric(horizontal: 5.0),
  //                               child: ElevatedButton(
  //                                   onPressed: () {},
  //                                   style: ElevatedButton.styleFrom(
  //                                       primary: Colors.amber,
  //                                       splashFactory: NoSplash.splashFactory,
  //                                       shape: const StadiumBorder()),
  //                                   child: Text(
  //                                       controller.profile.alsoKnownAs[index],
  //                                       style: const TextStyle(
  //                                           color: Colors.black))),
  //                             );
  //                           })),
  //                       Padding(
  //                         padding: const EdgeInsets.symmetric(
  //                             vertical: 8.0, horizontal: 12.0),
  //                         child: Text(
  //                           controller.profile.biography,
  //                           style: TextStyle(
  //                               color: Colors.black,
  //                               fontSize: 15.0,
  //                               wordSpacing: 1.0,
  //                               height: 1.4,
  //                               fontFamily: GoogleFonts.quicksand().fontFamily),
  //                         ),
  //                       )
  //                     ],
  //                   ),
  //                 )
  //               ])

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() {
        return controller.isLoaded.value == true
            ? NestedScrollView(
                headerSliverBuilder: ((context, innerBoxIsScrolled) {
                return [
                  SliverOverlapAbsorber(
                    handle: NestedScrollView.sliverOverlapAbsorberHandleFor(
                        context),
                    sliver: SliverAppBar(
                      backgroundColor:
                          Theme.of(context).scaffoldBackgroundColor,
                      expandedHeight: 0.4.sh,
                      pinned: true,
                      primary: true,
                      flexibleSpace: FlexibleSpaceBar(
                        title: Text(
                          widget.title,
                          style: TextStyle(
                              fontSize: 25.0,
                              color:
                                  Theme.of(context).textTheme.headline1?.color,
                              fontFamily: GoogleFonts.caveat().fontFamily),
                        ),
                        background: Stack(
                          children: [
                            Positioned.fill(
                              child: CachedNetworkImage(
                                imageUrl: Constants.BASE_IMAGE_URL +
                                    controller.profile.profilePath,
                                fit: BoxFit.cover,
                              ),
                            ),
                            Positioned.fill(
                                child: Container(
                                    color: ThemeService().isDarkMode()
                                        ? Colors.black26
                                        : Colors.white12)),
                          ],
                        ),
                      ),
                      leading: Padding(
                        padding: const EdgeInsets.only(top: 5.0, left: 12.0),
                        child: InkWell(
                            onTap: () => Get.back(),
                            child: Icon(
                              Icons.arrow_back_ios_new_sharp,
                              color:
                                  Theme.of(context).textTheme.headline1?.color,
                            )),
                      ),
                      centerTitle: true,
                      actions: [
                        Padding(
                          padding: EdgeInsets.only(top: 5.h, right: 15.w),
                          child: Icon(
                            FontAwesomeIcons.wikipediaW,
                            color: Theme.of(context).textTheme.headline1?.color,
                          ),
                        )
                      ],
                    ),
                  )
                ];
              }), body: SafeArea(child: Builder(builder: ((context) {
                return CustomScrollView(
                  slivers: [
                    SliverOverlapInjector(
                        handle: NestedScrollView.sliverOverlapAbsorberHandleFor(
                            context)),
                    SliverToBoxAdapter(
                        child: Column(
                      children: [
                        Wrap(
                            spacing: 8.0,
                            runSpacing: 1.0,
                            alignment: WrapAlignment.center,
                            direction: Axis.horizontal,
                            children: List.generate(
                                controller.profile.alsoKnownAs.length, (index) {
                              return ElevatedButton(
                                  onPressed: () {},
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.amber,
                                      splashFactory: NoSplash.splashFactory,
                                      shape: const StadiumBorder()),
                                  child: Text(
                                      controller.profile.alsoKnownAs[index],
                                      style: const TextStyle(
                                          color: Colors.black)));
                            })),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 8.0, horizontal: 12.0),
                          child: Text(
                            controller.profile.biography,
                            style: Theme.of(context)
                                .textTheme
                                .headline6
                                ?.copyWith(
                                    fontSize: 15.sp,
                                    wordSpacing: 1.0,
                                    height: 1.4,
                                    fontFamily:
                                        GoogleFonts.quicksand().fontFamily),
                          ),
                        )
                      ],
                    ))
                  ],
                );
              }))))
            : Container();
      }),
    );
  }
}
