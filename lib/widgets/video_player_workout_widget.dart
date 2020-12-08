import 'package:chewie/chewie.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerWorkoutWidget extends StatefulWidget {
  final VideoPlayerController videoPlayerController;
  final bool looping;
  final bool showControls;
  final bool autoPlay;

  const VideoPlayerWorkoutWidget({
    Key key,
    this.videoPlayerController,
    this.looping,
    this.showControls,
    this.autoPlay,
  }) : super(key: key);
  @override
  _VideoPlayerWorkoutWidgetState createState() =>
      _VideoPlayerWorkoutWidgetState();
}

class _VideoPlayerWorkoutWidgetState extends State<VideoPlayerWorkoutWidget> {
  ChewieController _chewieController;

  @override
  void initState() {
    _chewieController = ChewieController(
        showControls: widget.showControls,
        autoPlay: widget.autoPlay,
        videoPlayerController: widget.videoPlayerController,
        aspectRatio: widget.videoPlayerController.value.aspectRatio,
        looping: widget.looping,
        autoInitialize: true,
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
