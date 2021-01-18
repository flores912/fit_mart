import 'package:flutter/material.dart';

import '../constants.dart';

class MyCreatedWorkoutPlanCard extends StatefulWidget {
  final String title;
  final bool isLive;
  final Widget more;
  final Widget coverPhoto;
  final int weeks;
  final Function onTap;

  const MyCreatedWorkoutPlanCard(
      {Key key,
      this.title,
      this.isLive,
      this.more,
      this.coverPhoto,
      this.weeks,
      this.onTap})
      : super(key: key);

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
      leading: Container(height: 100, width: 100, child: widget.coverPhoto),
      subtitle: Row(
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
