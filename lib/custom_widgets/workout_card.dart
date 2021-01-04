import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../constants.dart';

class WorkoutCard extends StatefulWidget {
  final String workoutName;
  final int exercises;
  final int day;
  final Widget more;
  final Function onTap;
  final bool isOnCopyMode;
  final bool isParentCheckbox;
  final bool isSelected;
  final Function checkBoxOnChanged;
  final Function parentCheckBoxOnChanged;

  const WorkoutCard({
    Key key,
    this.workoutName,
    this.exercises,
    this.day,
    this.more,
    this.onTap,
    this.isOnCopyMode,
    this.isParentCheckbox,
    this.isSelected,
    this.checkBoxOnChanged,
    this.parentCheckBoxOnChanged,
  }) : super(key: key);
  @override
  _WorkoutCardState createState() => _WorkoutCardState();
}

class _WorkoutCardState extends State<WorkoutCard> {
  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: [
        Card(
          elevation: 2,
          child: ListTile(
            onTap: widget.onTap,
            leading: widget.isOnCopyMode == true
                ? checkBox(widget.isParentCheckbox)
                : null,
            title: Text(widget.workoutName +
                ' - ' +
                kDay +
                ' ' +
                widget.day.toString()),
            subtitle: Text(widget.exercises.toString() + ' exercises'),
            trailing: widget.more, //here goes popUpMenuButton widget
          ),
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
