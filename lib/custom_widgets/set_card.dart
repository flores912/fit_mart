import 'package:fit_mart/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SetCard extends StatefulWidget {
  final int set;
  final int reps;
  final int rest;
  final Widget more;
  const SetCard({
    Key key,
    this.set,
    this.reps,
    this.rest,
    this.more,
  }) : super(key: key);
  @override
  _SetCardState createState() => _SetCardState();
}

class _SetCardState extends State<SetCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      child: Row(
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
              Text(widget.reps.toString()),
              Text(kReps),
            ],
          )),
          Expanded(
            child: Column(
              children: [
                Text(widget.rest.toString() + 's'),
                Text(kRest),
              ],
            ),
          ),
          widget.more
        ],
      ),
    );
  }
}
