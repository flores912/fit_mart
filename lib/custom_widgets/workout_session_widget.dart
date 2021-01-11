import 'package:fit_mart/custom_widgets/chewie_player_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class WorkoutSessionWidget extends StatefulWidget {
  final Widget setsList;
  final String videoUrl;

  const WorkoutSessionWidget({Key key, this.setsList, this.videoUrl})
      : super(key: key);
  @override
  _WorkoutSessionWidgetState createState() => _WorkoutSessionWidgetState();
}

class _WorkoutSessionWidgetState extends State<WorkoutSessionWidget> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          widget.videoUrl != null
              ? Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.width / 1.78,
                  child: ChewiePlayerWidget(
                    autoPlay: false,
                    looping: false,
                    showControls: true,
                    videoPlayerController: VideoPlayerController.network(
                        widget.videoUrl,
                        videoPlayerOptions:
                            VideoPlayerOptions(mixWithOthers: true)),
                  ),
                )
              : Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.width / 1.78,
                  color: CupertinoColors.placeholderText,
                  child: Card(),
                ),
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Sets',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              widget.setsList
            ],
          ),
        ],
      ),
    );
  }
}
