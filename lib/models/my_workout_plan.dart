import 'package:flutter/cupertino.dart';

class MyWorkoutPlan {
  final String title;
  final String trainer;
  final String imageUrl;
  final double progress;

  MyWorkoutPlan(
      {@required this.imageUrl,
      @required this.title,
      @required this.trainer,
      @required this.progress});
}
