// ignore_for_file: avoid_print

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class Video extends StatefulWidget {
  final List<String> videoId;
  const Video({Key? key, required this.videoId}) : super(key: key);

  @override
  State<Video> createState() => _VideoState();
}

class _VideoState extends State<Video> {
  late YoutubePlayerController _controller;
  int _currentPostiton = 0;
  String title = '';
  String author = '';
  String duration = '';

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
    );
    getVideoDetails();
    super.initState();
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

  void getVideoDetails() {
    Timer.periodic(const Duration(milliseconds: 500), (timer) {
      print('timer running');
      if (_controller.metadata.author.isNotEmpty &&
          _controller.metadata.title.isNotEmpty &&
          _controller.metadata.duration.inSeconds.toString().isNotEmpty) {
        setState(() {
          author = _controller.metadata.author;
          title = _controller.metadata.title;
          duration = _controller.metadata.duration.inSeconds.toString();
        });
        timer.cancel();
      }
    });
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
              author = '';
              title = '';
              duration = '';
              getVideoDetails();
            }
          },
        ),
        builder: (context, player) {
          return Scaffold(
            appBar: AppBar(
              centerTitle: true,
              title: const Text('Video'),
            ),
            body: Column(
              children: [
                player,
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                          top: 15.0, left: 20.0, right: 20.0),
                      child: Text(
                        author,
                        style: TextStyle(
                            fontSize: 22.0,
                            fontWeight: FontWeight.bold,
                            fontFamily: GoogleFonts.quicksand().fontFamily),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(
                            top: 8.0, left: 20.0, right: 20.0),
                        child: Text(title,
                            maxLines: 4,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                fontSize: 16.0,
                                fontWeight: FontWeight.normal,
                                fontFamily: GoogleFonts.roboto().fontFamily)),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(duration + ' Secs',
                      style: TextStyle(
                          fontSize: 17.0,
                          fontWeight: FontWeight.normal,
                          fontFamily: GoogleFonts.roboto().fontFamily)),
                )
              ],
            ),
          );
        });
  }
}
