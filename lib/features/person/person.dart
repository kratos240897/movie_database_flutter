import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:get/state_manager.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/constants/app/app_constants.dart';
import 'person_controller.dart';

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
  final _scrollController = ScrollController();
  final _expandedHeight = 0.4.sh;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollController.addListener(() {
        controller.isAppBarExtended.value = _scrollController.hasClients &&
            _scrollController.offset > (_expandedHeight - kToolbarHeight);
      });
      controller.getPerson(widget.id);
    });
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
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
        return controller.profile.isInitialized
            ? NestedScrollView(
                controller: _scrollController,
                headerSliverBuilder: ((context, innerBoxIsScrolled) {
                  return [
                    SliverOverlapAbsorber(
                      handle: NestedScrollView.sliverOverlapAbsorberHandleFor(
                          context),
                      sliver: SliverAppBar(
                        backgroundColor:
                            Theme.of(context).scaffoldBackgroundColor,
                        expandedHeight: _expandedHeight,
                        pinned: true,
                        primary: true,
                        flexibleSpace:
                            LayoutBuilder(builder: (context, constraints) {
                          return FlexibleSpaceBar(
                            title: Text(
                              widget.title,
                              style: TextStyle(
                                  fontSize: !controller.isAppBarExtended.value
                                      ? 22.sp
                                      : 18.sp,
                                  color: !controller.isAppBarExtended.value
                                      ? Colors.white
                                      : Theme.of(context)
                                          .textTheme
                                          .displayLarge
                                          ?.color,
                                  fontFamily: !controller.isAppBarExtended.value
                                      ? GoogleFonts.caveat().fontFamily
                                      : GoogleFonts.josefinSans().fontFamily),
                            ),
                            background: CachedNetworkImage(
                              imageUrl: AppConstants.BASE_IMAGE_URL +
                                  controller
                                      .profile.observable.value!.profilePath,
                              fit: BoxFit.cover,
                            ),
                          );
                        }),
                        leading: Padding(
                          padding: const EdgeInsets.only(left: 12.0),
                          child: InkWell(
                              onTap: () => Get.back(),
                              child: Icon(
                                Icons.arrow_back_ios_new_sharp,
                                color: !controller.isAppBarExtended.value
                                    ? Colors.white
                                    : Theme.of(context)
                                        .textTheme
                                        .displayLarge
                                        ?.color,
                              )),
                        ),
                        centerTitle: true,
                        actions: [
                          Padding(
                            padding: EdgeInsets.only(right: 15.w),
                            child: Icon(
                              FontAwesomeIcons.google,
                              color: !controller.isAppBarExtended.value
                                  ? Colors.white
                                  : Theme.of(context)
                                      .textTheme
                                      .displayLarge
                                      ?.color,
                            ),
                          )
                        ],
                      ),
                    )
                  ];
                }),
                body: SafeArea(
                    top: false,
                    bottom: false,
                    child: Builder(builder: ((context) {
                      return CustomScrollView(
                        slivers: [
                          SliverOverlapInjector(
                              handle: NestedScrollView
                                  .sliverOverlapAbsorberHandleFor(context)),
                          SliverToBoxAdapter(
                              child: Column(
                            children: [
                              8.verticalSpace,
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 6.w),
                                child: Wrap(
                                    spacing: 8.0,
                                    runSpacing: 1.0,
                                    alignment: WrapAlignment.center,
                                    direction: Axis.horizontal,
                                    children: List.generate(
                                        controller.profile.observable.value!
                                            .alsoKnownAs.length, (index) {
                                      return Container(
                                          margin: EdgeInsets.all(5.sp),
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 10.w, vertical: 8.h),
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10.r),
                                              gradient: getRandomGradient(
                                                  ([...Colors.primaries]
                                                        ..shuffle())
                                                      .first,
                                                  ([...Colors.primaries]
                                                        ..shuffle())
                                                      .last)),
                                          child: Text(
                                              '# ' +
                                                  controller
                                                      .profile
                                                      .observable
                                                      .value!
                                                      .alsoKnownAs[index],
                                              style: const TextStyle(
                                                  color: Colors.white)));
                                    })),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical: 8.h, horizontal: 12.w),
                                child: Text(
                                  controller
                                      .profile.observable.value!.biography,
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleLarge
                                      ?.copyWith(
                                          fontSize: 14.sp,
                                          wordSpacing: 1.0,
                                          height: 1.4,
                                          fontFamily: GoogleFonts.quicksand()
                                              .fontFamily),
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

  LinearGradient getRandomGradient(Color startColor, Color endColor) {
    return LinearGradient(
      colors: [startColor, endColor],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );
  }
}
