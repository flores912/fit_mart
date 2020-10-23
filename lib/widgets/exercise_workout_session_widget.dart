import 'package:fit_mart/widgets/video_player_workout_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ExerciseWorkoutSessionWidget extends StatelessWidget {
  final String title;
  final int weight;
  final ListView setsList;
  final Color colorContainer;

  final Function onSelected;

  final String videoUrl;

  const ExerciseWorkoutSessionWidget({
    Key key,
    this.title,
    this.weight,
    this.setsList,
    this.colorContainer,
    this.onSelected,
    this.videoUrl,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: [
        Container(
          color: colorContainer,
          width: MediaQuery.of(context).size.width,
          child: Row(
            children: [
              Expanded(
                child: Column(
                  children: [
                    SizedBox(
                      height: 8,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          title,
                          style: TextStyle(
                              fontSize: 22, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          '${weight.toString()} lbs',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.normal,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    SizedBox(
                      width: 8,
                    ),
                    VideoPlayerWorkoutWidget(
                      videoUrl: videoUrl,
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Center(
                      child: Container(
                        child: setsList,
                        height: 56,
                      ),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
