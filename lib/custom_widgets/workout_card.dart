import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../constants.dart';

class WorkoutCard extends StatefulWidget {
  final String workoutName;
  final int exercises;
  final Widget more;
  final Function onTap;
  final bool isOnCopyMode;
  final bool isParentCheckbox;
  final bool isSelected;
  final Function checkBoxOnChanged;
  final Function parentCheckBoxOnChanged;
  final bool isWorkoutSwapMode;
  final double elevation;
  final int day;

  const WorkoutCard({
    Key key,
    this.workoutName,
    this.exercises,
    this.more,
    this.onTap,
    this.isOnCopyMode,
    this.isParentCheckbox,
    this.isSelected,
    this.checkBoxOnChanged,
    this.parentCheckBoxOnChanged,
    this.isWorkoutSwapMode,
    this.elevation,
    this.day,
  }) : super(key: key);
  @override
  _WorkoutCardState createState() => _WorkoutCardState();
}

class _WorkoutCardState extends State<WorkoutCard> {
  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: [
        Row(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Text('Day'),
                  Text(widget.day.toString()),
                ],
              ),
            ),
            Expanded(
              child: Card(
                color: widget.isWorkoutSwapMode == true ? kPrimaryColor : null,
                elevation: widget.elevation,
                child: ListTile(
                  onTap: widget.onTap,
                  leading: widget.isOnCopyMode == true
                      ? checkBox(widget.isParentCheckbox)
                      : null,
                  title: Text(widget.workoutName),
                  subtitle: Text(widget.exercises.toString() + ' exercises'),
                  trailing: widget.more, //here goes popUpMenuButton widget
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Checkbox checkBox(bool isParentCheckbox) {
    if (isParentCheckbox == true) {
      return Checkbox(
        tristate: true,
        onChanged: widget.parentCheckBoxOnChanged,
      );
    } else {
      return Checkbox(
        tristate: true,
        onChanged: widget.checkBoxOnChanged,
        value: widget.isSelected,
      );
    }
  }
}
