import 'package:fit_mart/constants.dart';
import 'package:flutter/material.dart';

class ExerciseCard extends StatefulWidget {
  final Widget thumbnail;
  final String exerciseName;
  final int sets;
  final Widget more;

  const ExerciseCard(
      {Key key, this.thumbnail, this.exerciseName, this.sets, this.more})
      : super(key: key);
  @override
  _ExerciseCardState createState() => _ExerciseCardState();
}

class _ExerciseCardState extends State<ExerciseCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        trailing: widget.more,
        leading: widget.thumbnail,
        title: Text(widget.exerciseName),
        subtitle: Text(widget.sets.toString() + ' ' + kSets),
      ),
    );
  }
}
