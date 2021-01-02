import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class WorkoutCard extends StatefulWidget {
  final String workoutName;
  final int exercises;

  const WorkoutCard({Key key, this.workoutName, this.exercises})
      : super(key: key);
  @override
  _WorkoutCardState createState() => _WorkoutCardState();
}

class _WorkoutCardState extends State<WorkoutCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        //TODO :leading attribute will have checkbox
        title: Text(widget.workoutName),
        subtitle: Text(widget.exercises.toString() + ' exercises'),
        trailing: Icon(Icons.more_vert), //here goes popUpMenuButton widget
      ),
    );
  }
}
