import 'package:fit_mart/models/set.dart';
import 'package:flutter/cupertino.dart';

class Exercise {
  final int sets;
  final String title;
  final int weight;
  final String uid;

  Exercise(
      {@required this.sets,
      @required this.uid,
      @required this.title,
      @required this.weight});
}
