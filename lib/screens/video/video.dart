import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../../widgets/custom_app_bar_widget.dart';

class Video extends StatefulWidget {
  final List<String> videoId;
  const Video({Key? key, required this.videoId}) : super(key: key);

  @override
  State<Video> createState() => _VideoState();
}

class _VideoState extends State<Video> {
  late YoutubePlayerController _controller;
  int _currentPostiton = 0;
  String _title = '';
  String _author = '';
  String _duration = '';

  @override
  void initState() {
    _controller = YoutubePlayerController(
      initialVideoId: widget.videoId[_currentPostiton],
      flags: const YoutubePlayerFlags(
          mute: false,
          autoPlay: true,
          disableDragSeek: false,
          loop: false,
          isLive: false,
          forceHD: true,
          enableCaption: true,
          controlsVisibleAtStart: true),
    )..addListener(_youtubePlayerListener);
    super.initState();
  }

  void _youtubePlayerListener() {
    if (_controllerMetaDataIsNotEmpty() && _localMetaDataIsEmpty()) {
      setState(() {
        _author = _controller.metadata.author;
        _title = _controller.metadata.title;
        _duration = _controller.metadata.duration.inSeconds.toString();
      });
    }
  }

  bool _controllerMetaDataIsNotEmpty() {
    return (_controller.metadata.author.isNotEmpty &&
        _controller.metadata.title.isNotEmpty &&
        _controller.metadata.duration.inSeconds != 0);
  }

  bool _localMetaDataIsEmpty() {
    return (_author.isEmpty && _title.isEmpty && _duration.isEmpty);
  }

  @override
  void deactivate() {
    // Pauses video while navigating to next page.
    _controller.pause();
    super.deactivate();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return YoutubePlayerBuilder(
        player: YoutubePlayer(
          controller: _controller,
          onEnded: (metaData) {
            if (_currentPostiton != widget.videoId.length) {
              _currentPostiton = _currentPostiton + 1;
              _controller.load(widget.videoId[_currentPostiton]);
              _author = '';
              _title = '';
              _duration = '';
            }
          },
        ),
        builder: (context, player) {
          return Scaffold(
            body: SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 12.w, bottom: 8.h, top: 8.h),
                    child: const CustomAppBar(
                        title: 'Trailer and Others', isBackEnabled: true),
                  ),
                  8.verticalSpace,
                  player,
                  Padding(
                    padding:
                        EdgeInsets.only(top: 15.h, left: 20.w, right: 20.w),
                    child: Text(
                      _author,
                      style: TextStyle(
                          fontSize: 22.sp,
                          fontWeight: FontWeight.bold,
                          fontFamily: GoogleFonts.quicksand().fontFamily),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 8.h, left: 20.w, right: 20.w),
                    child: Text(_title,
                        maxLines: 4,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.normal,
                            fontFamily: GoogleFonts.roboto().fontFamily)),
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: Padding(
                      padding: EdgeInsets.only(top: 8.h),
                      child: Text(_duration + ' Secs',
                          style: TextStyle(
                              fontSize: 17.0.sp,
                              fontWeight: FontWeight.normal,
                              fontFamily: GoogleFonts.roboto().fontFamily)),
                    ),
                  )
                ],
              ),
            ),
          );
        });
  }
}
