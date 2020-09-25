import 'package:fit_mart/chewie_video_item.dart';
import 'package:fit_mart/exercise_card_item.dart';
import 'package:fit_mart/round_button_set_item.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:chewie/chewie.dart';
import 'package:video_player/video_player.dart';

class WorkoutSessionScreen extends StatefulWidget {
  static const String id = 'workout_session_screen';

  @override
  WorkoutSessionScreenState createState() => WorkoutSessionScreenState();
}

class WorkoutSessionScreenState extends State<WorkoutSessionScreen> {
  bool isSetDone = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            (ChewieVideoItem(
              videoPlayerController: VideoPlayerController.network(
                'https://www.learningcontainer.com/wp-content/uploads/2020/05/sample-mp4-file.mp4?_=1',
              ),
              looping: false,
            )),
            Expanded(
              child: Container(
                  child: ListView(children: [
                ExerciseCardItem(),
                ExerciseCardItem(),
                ExerciseCardItem(),
              ])),
            ),
          ],
        ),
      ),
    );
  }
}
