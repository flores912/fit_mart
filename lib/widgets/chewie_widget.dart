import 'package:chewie/chewie.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class ChewieWidget extends StatefulWidget {
  final VideoPlayerController videoPlayerController;
  final bool looping;

  const ChewieWidget({Key key, this.videoPlayerController, this.looping})
      : super(key: key);
  @override
  _ChewieWidgetState createState() => _ChewieWidgetState();
}

class _ChewieWidgetState extends State<ChewieWidget> {
  ChewieController _chewieController;
  @override
  void initState() {
    super.initState();
    _chewieController = ChewieController(
        videoPlayerController: widget.videoPlayerController,
        aspectRatio: 16 / 9,
        //see the first frame with this
        autoInitialize: true,
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
    //IMPORTANT GET RID OF UNNECESSARY RESOURCES
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
