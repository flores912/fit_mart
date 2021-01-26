import 'package:chewie/chewie.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';

class ChewiePlayerWidget extends StatefulWidget {
  final VideoPlayerController videoPlayerController;
  final bool looping;
  final bool showControls;
  final bool autoPlay;
  final bool autoInitialize;

  const ChewiePlayerWidget({
    Key key,
    this.videoPlayerController,
    this.looping,
    this.showControls,
    this.autoPlay,
    this.autoInitialize,
  }) : super(key: key);
  @override
  _ChewiePlayerWidgetState createState() => _ChewiePlayerWidgetState();
}

class _ChewiePlayerWidgetState extends State<ChewiePlayerWidget> {
  ChewieController _chewieController;

  @override
  void initState() {
    _chewieController = ChewieController(
        showControlsOnInitialize: false,
        showControls: widget.showControls,
        allowFullScreen: true,
        deviceOrientationsAfterFullScreen: [
          DeviceOrientation.portraitUp,
          DeviceOrientation.portraitDown,
          DeviceOrientation.landscapeRight,
          DeviceOrientation.landscapeLeft,
        ],
        deviceOrientationsOnEnterFullScreen: [
          DeviceOrientation.portraitUp,
          DeviceOrientation.portraitDown,
          DeviceOrientation.landscapeRight,
          DeviceOrientation.landscapeLeft,
        ],
        autoPlay: widget.autoPlay,
        videoPlayerController: widget.videoPlayerController,
        aspectRatio: 16 / 9,
        looping: widget.looping,
        autoInitialize: true,
        errorBuilder: (context, errorMessage) {
          return Center(
            child: Text(
              'Video not available.',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          );
        });
    super.initState();
  }

  @override
  void dispose() {
    widget.videoPlayerController.dispose();
    _chewieController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Chewie(
      controller: _chewieController,
    );
  }
}
