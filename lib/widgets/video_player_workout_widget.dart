import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerWorkoutWidget extends StatefulWidget {
  final String videoUrl;

  const VideoPlayerWorkoutWidget({Key key, this.videoUrl}) : super(key: key);
  @override
  _VideoPlayerWorkoutWidgetState createState() =>
      _VideoPlayerWorkoutWidgetState();
}

class _VideoPlayerWorkoutWidgetState extends State<VideoPlayerWorkoutWidget> {
  //The _controller variable will be used for controlling the functionality of the video player.
  VideoPlayerController _controller;
  //_initializeVideoPlayerFuture variable will be used to store and return the value from VideoPlayerController.initialize.
  Future<void> _initializeVideoPlayerFuture;

  @override
  void initState() {
    _controller = VideoPlayerController.network(widget.videoUrl);
    _initializeVideoPlayerFuture = _controller.initialize();
    _controller.setLooping(true);
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initializeVideoPlayerFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return Center(
            child: AspectRatio(
              aspectRatio: 16 / 9,
              child: VideoPlayer(
                _controller,
              ),
            ),
          );
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}
