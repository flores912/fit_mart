import 'package:fit_mart/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SetCard extends StatefulWidget {
  final int set;
  final int reps;
  final int rest;
  final bool isTimed;
  final bool isFailure;
  final Widget more;
  const SetCard({
    Key key,
    this.set,
    this.reps,
    this.rest,
    this.more,
    this.isTimed,
    this.isFailure,
  }) : super(key: key);
  @override
  _SetCardState createState() => _SetCardState();
}

class _SetCardState extends State<SetCard> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
            child: Column(
          children: [
            Text(widget.set.toString()),
            Text(kSet),
          ],
        )),
        Expanded(
            child: Column(
          children: [
            widget.isFailure == true
                ? Text('FAILURE')
                : Text(widget.reps.toString()),
            widget.isTimed == true
                ? Text(widget.reps >= 60
                    ? (widget.reps / 60).truncate().toString() + 'min'
                    : widget.rest.toString() + 'secs')
                : Text(kReps),
          ],
        )),
        Expanded(
          child: Column(
            children: [
              Text(widget.rest >= 60
                  ? (widget.rest / 60).truncate().toString() + 'min'
                  : widget.rest.toString() + 'secs'),
              Text(kRest),
            ],
          ),
        ),
        widget.more
      ],
    );
  }
}
