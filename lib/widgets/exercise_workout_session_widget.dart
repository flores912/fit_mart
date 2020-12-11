import 'package:better_player/better_player.dart';
import 'package:fit_mart/widgets/better_player_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ExerciseWorkoutSessionWidget extends StatelessWidget {
  final ListView setsList;

  final Function onSelected;

  final String videoUrl;

  final String exerciseTitle;

  const ExerciseWorkoutSessionWidget({
    Key key,
    this.setsList,
    this.onSelected,
    this.videoUrl,
    this.exerciseTitle,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 4,
        ),
        Container(
          width: MediaQuery.of(context).size.width - 32,
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
                      style:
                          TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    BetterPlayerWidget(
                      aspectRatio: 1,
                      autoPlay: true,
                      betterPlayerDataSource:
                          BetterPlayerDataSource.network(videoUrl),
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
            ],
          ),
        ),
        SizedBox(
          width: 4,
        ),
      ],
    );
  }
}
