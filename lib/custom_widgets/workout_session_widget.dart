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
  VideoPlayerController videoPlayerController;
  @override
  void initState() {
    videoPlayerController = VideoPlayerController.network(widget.videoUrl,
        videoPlayerOptions: VideoPlayerOptions(mixWithOthers: true));
    super.initState();
  }

  @override
  void dispose() {
    videoPlayerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              child: widget.videoUrl != null
                  ? Container(
                      color: Colors.black,
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.width * 16 / 9 / 2,
                      child: ChewiePlayerWidget(
                        autoPlay: false,
                        looping: false,
                        showControls: true,
                        videoPlayerController: videoPlayerController,
                      ),
                    )
                  : Container(),
            ),
          ),
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(32.0),
                child: Text(
                  'Sets',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
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
