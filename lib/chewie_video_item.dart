import 'package:chewie/chewie.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class ChewieVideoItem extends StatefulWidget {
  static const String id = 'workout_session_screen';

  final VideoPlayerController videoPlayerController;
  final bool looping;

  const ChewieVideoItem({Key key, this.videoPlayerController, this.looping})
      : super(key: key);

  @override
  ChewieVideoItemState createState() => ChewieVideoItemState();
}

class ChewieVideoItemState extends State<ChewieVideoItem> {
  ChewieController _chewieController;
  @override
  void initState() {
    super.initState();
    _chewieController = ChewieController(
        videoPlayerController: widget.videoPlayerController,
        aspectRatio: 3 / 2,
        //avoids dark background on video by displaying 1st frame
        autoInitialize: true,
        looping: widget.looping,
        //displays error message on screen
        errorBuilder: (context, errorMessage) {
          return Center(
            child: Text(
              errorMessage,
              style: TextStyle(color: Colors.white),
            ),
          );
        });
  }

  @override
  void dispose() {
    super.dispose();
    //IMPORTANT!! to dispose of all the resources
    widget.videoPlayerController.dispose();
    _chewieController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return (Chewie(
      controller: _chewieController,
    ));
  }
}
