import 'package:flutter/cupertino.dart';

class MyWorkoutPlan {
  final String title;
  final String trainer;
  final String imageUrl;
  final double progress;
  final String uid;

  MyWorkoutPlan({
    @required this.imageUrl,
    @required this.title,
    @required this.trainer,
    @required this.progress,
    @required this.uid,
  });
}
