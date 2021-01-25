import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../constants.dart';

class MyCreatedWorkoutPlanCard extends StatefulWidget {
  final String title;
  final bool isLive;
  final Widget more;
  final int weeks;
  final Function onTap;
  final String url;
  final String trainerName;

  const MyCreatedWorkoutPlanCard({
    Key key,
    this.title,
    this.isLive,
    this.more,
    this.weeks,
    this.onTap,
    this.url,
    this.trainerName,
  }) : super(key: key);

  @override
  _MyCreatedWorkoutPlanCardState createState() =>
      _MyCreatedWorkoutPlanCardState();
}

class _MyCreatedWorkoutPlanCardState extends State<MyCreatedWorkoutPlanCard> {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: widget.onTap,
      trailing: widget.more,
      leading: widget.url != null
          ? Container(
              height: 56,
              width: 100,
              child: Image.network(widget.url),
            )
          : null,
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(widget.weeks.toString() + ' Week(s)   '),
              widget.isLive == true
                  ? Text(
                      'PUBLIC',
                      style: TextStyle(color: kPrimaryColor),
                    )
                  : Text(
                      '(PRIVATE)',
                    ),
            ],
          ),
          Text(widget.trainerName),
        ],
      ),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.title,
          ),
        ],
      ),
    );
  }
}
