import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../constants.dart';

class WorkoutPlanCard extends StatefulWidget {
  final Widget image;
  final String title;
  final int weeks;
  final Widget more;
  final Function onTap;

  const WorkoutPlanCard(
      {Key key, this.image, this.title, this.weeks, this.more, this.onTap})
      : super(key: key);

  @override
  _WorkoutPlanCardState createState() => _WorkoutPlanCardState();
}

class _WorkoutPlanCardState extends State<WorkoutPlanCard> {
  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: [
        Container(
          width: MediaQuery.of(context).size.width / 2,
          child: Card(
            child: Column(
              children: [
                Container(
                    height: MediaQuery.of(context).size.width / 2 * 9 / 16,
                    child: widget.image),
                ListTile(
                  onTap: widget.onTap,
                  title: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [],
                  ),
                  subtitle: Text(widget.weeks.toString() + ' Week(s)'),
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}
