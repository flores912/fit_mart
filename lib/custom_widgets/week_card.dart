import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class WeekCard extends StatefulWidget {
  final int week;
  final Widget workoutList;
  final bool isSelected;
  final Function checkBoxOnChanged;
  final Function parentCheckBoxOnChanged;
  final bool isOnCopyMode;
  final bool isParentCheckbox;
  final Widget more;

  const WeekCard(
      {Key key,
      this.week,
      this.workoutList,
      this.isSelected,
      this.checkBoxOnChanged,
      this.parentCheckBoxOnChanged,
      this.isOnCopyMode,
      this.isParentCheckbox,
      this.more})
      : super(key: key);
  @override
  _WeekCardState createState() => _WeekCardState();
}

class _WeekCardState extends State<WeekCard> {
  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: [
        Card(
          elevation: 1,
          child: ListTile(
            title: Text('Week ' + widget.week.toString()),
            trailing: widget.more,
            leading: widget.isOnCopyMode == true
                ? checkBox(widget.isParentCheckbox)
                : null,
            subtitle: widget.workoutList,
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
