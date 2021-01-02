import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class WeekCard extends StatefulWidget {
  final int week;
  final Widget workoutList;

  const WeekCard({Key key, this.week, this.workoutList}) : super(key: key);
  @override
  _WeekCardState createState() => _WeekCardState();
}

class _WeekCardState extends State<WeekCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text('Week ' + widget.week.toString()),
        trailing: Icon(Icons.more_vert), //here goes popUpMenuButton widget
        //TODO :leading attribute will have checkbox
        //TODO :subtitle attribute will have list of workouts of the week
        subtitle: widget.workoutList,
      ),
    );
  }
}
