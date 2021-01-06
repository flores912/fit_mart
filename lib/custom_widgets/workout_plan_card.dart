import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../constants.dart';

class WorkoutPlanCard extends StatefulWidget {
  final Widget image;
  final String title;
  final int weeks;
  final int price;
  final Widget more;

  const WorkoutPlanCard(
      {Key key, this.image, this.title, this.weeks, this.more, this.price})
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
          width: 344,
          child: Card(
            child: Column(
              children: [
                Container(height: 194, child: widget.image),
                ListTile(
                  title: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(widget.title),
                      widget.price != null
                          ? Text('\$ ' + widget.price.toString())
                          : Text(kFree)
                    ],
                  ),
                  subtitle: Text(widget.weeks.toString() + ' Week(s)'),
                  leading: widget.more,
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}
