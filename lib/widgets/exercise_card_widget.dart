import 'package:fit_mart/widgets/video_player_workout_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

import '../constants.dart';

class ExerciseCardWidget extends StatelessWidget {
  final String title;
  final String videoUrl;
  const ExerciseCardWidget({
    Key key,
    this.title,
    this.videoUrl,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: [
        Container(
          width: MediaQuery.of(context).size.width,
          child: Card(
            elevation: 1,
            child: Row(
              children: [
                //TODO: Here place video preview
                videoUrl == null
                    ? Container(
                        height: 100,
                        width: 100,
                        color: Colors.black,
                      )
                    : Center(
                        child: Container(
                          height: 100,
                          width: 100,
                          child: VideoPlayerWorkoutWidget(
                            looping: true,
                            autoPlay: false,
                            showControls: false,
                            videoPlayerController:
                                VideoPlayerController.network(videoUrl),
                          ),
                        ),
                      ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(8, 8, 0, 0),
                      child: title == null
                          ? Text(
                              '(No title)',
                              style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black),
                            )
                          : Text(
                              title,
                              style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black),
                            ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
