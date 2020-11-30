import 'package:flutter/cupertino.dart';

class Workout {
  final String title;
  final int day;
  final bool isDone;
  final String uid;
  final int numberOfExercises;

  Workout({
    this.numberOfExercises,
    this.title,
    this.day,
    this.isDone,
    this.uid,
  });
}
