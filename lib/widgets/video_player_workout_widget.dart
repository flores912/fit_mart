import 'package:chewie/chewie.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerWorkoutWidget extends StatefulWidget {
  final VideoPlayerController videoPlayerController;
  final bool looping;

  const VideoPlayerWorkoutWidget({
    Key key,
    this.videoPlayerController,
    this.looping,
  }) : super(key: key);
  @override
  _VideoPlayerWorkoutWidgetState createState() =>
      _VideoPlayerWorkoutWidgetState();
}

class _VideoPlayerWorkoutWidgetState extends State<VideoPlayerWorkoutWidget> {
  ChewieController _chewieController;
  @override
  void initState() {
    super.initState();
    _chewieController = ChewieController(
        videoPlayerController: widget.videoPlayerController,
        aspectRatio: 16 / 9,
        autoInitialize: true,
        showControlsOnInitialize: false,
        looping: widget.looping,
        errorBuilder: (context, errorMessage) {
          return Center(
            child: Text(
              errorMessage,
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          );
        });
  }

  @override
  void dispose() {
    super.dispose();
    widget.videoPlayerController.dispose();
    _chewieController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Chewie(
      controller: _chewieController,
    );
  }
}
