import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../constants.dart';

class WorkoutCard extends StatefulWidget {
  final String workoutName;
  final int exercises;
  final int day;
  final Widget more;

  const WorkoutCard(
      {Key key, this.workoutName, this.exercises, this.day, this.more})
      : super(key: key);
  @override
  _WorkoutCardState createState() => _WorkoutCardState();
}

class _WorkoutCardState extends State<WorkoutCard> {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      //TODO :leading attribute will have checkbox
      title:
          Text(widget.workoutName + ' - ' + kDay + ' ' + widget.day.toString()),
      subtitle: Text(widget.exercises.toString() + ' exercises'),
      trailing: widget.more, //here goes popUpMenuButton widget
    );
  }
}
