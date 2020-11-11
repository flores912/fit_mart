import 'package:fit_mart/widgets/video_player_workout_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class ExerciseWorkoutSessionWidget extends StatelessWidget {
  final ListView setsList;
  final Color colorContainer;

  final Function onSelected;

  final String videoUrl;

  final String exerciseTitle;

  const ExerciseWorkoutSessionWidget({
    Key key,
    this.setsList,
    this.colorContainer,
    this.onSelected,
    this.videoUrl,
    this.exerciseTitle,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      color: colorContainer,
      width: MediaQuery.of(context).size.width - 16,
      child: Row(
        children: [
          SizedBox(
            width: 4,
          ),
          Expanded(
            child: Column(
              children: [
                SizedBox(
                  height: 8,
                ),
                Text(
                  exerciseTitle,
                  style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 8,
                ),
                VideoPlayerWorkoutWidget(
                  videoPlayerController:
                      VideoPlayerController.network(videoUrl),
                  looping: true,
                ),
                SizedBox(
                  height: 16,
                ),
                Expanded(
                  child: setsList,
                ),
              ],
            ),
          ),
          SizedBox(
            width: 4,
          ),
        ],
      ),
    );
  }
}
