import 'package:flutter/cupertino.dart';

class Workout {
  final String title;
  final int day;
  final bool isDone;
  final String uid;

  Workout({
    @required this.title,
    @required this.day,
    @required this.isDone,
    @required this.uid,
  });
}
