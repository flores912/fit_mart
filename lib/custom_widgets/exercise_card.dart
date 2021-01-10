import 'package:fit_mart/constants.dart';
import 'package:flutter/material.dart';

class ExerciseCard extends StatefulWidget {
  final Widget thumbnail;
  final String exerciseName;
  final int sets;
  final Widget more;
  final Function onTap;
  final double elevation;
  final Color color;

  const ExerciseCard(
      {Key key,
      this.thumbnail,
      this.exerciseName,
      this.sets,
      this.more,
      this.onTap,
      this.elevation,
      this.color})
      : super(key: key);
  @override
  _ExerciseCardState createState() => _ExerciseCardState();
}

class _ExerciseCardState extends State<ExerciseCard> {
  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: [
        Card(
          color: widget.color,
          elevation: widget.elevation,
          child: ListTile(
            onTap: widget.onTap,
            trailing: widget.more,
            leading: widget.thumbnail,
            title: Text(widget.exerciseName),
            subtitle: Text(widget.sets.toString() + ' ' + kSets),
          ),
        ),
      ],
    );
  }
}
