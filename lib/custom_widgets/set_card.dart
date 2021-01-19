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
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                widget.set.toString(),
                style: TextStyle(
                    color: kPrimaryColor,
                    fontSize: 22,
                    fontWeight: FontWeight.bold),
              ),
            ),
            Text(
              kSet,
              style: TextStyle(fontWeight: FontWeight.w300),
            ),
          ],
        )),
        Expanded(
            child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: widget.isFailure == true
                  ? Text(
                      'FAILURE',
                      style: TextStyle(
                          color: kPrimaryColor,
                          fontSize: 22,
                          fontWeight: FontWeight.bold),
                    )
                  : widget.isTimed == true
                      ? Text(
                          (widget.reps / 60).truncate().toString() +
                              ':' +
                              (widget.reps % 60).toString(),
                          style: TextStyle(
                              color: kPrimaryColor,
                              fontSize: 22,
                              fontWeight: FontWeight.bold),
                        )
                      : Text(
                          widget.reps.toString(),
                          style: TextStyle(
                              color: kPrimaryColor,
                              fontSize: 22,
                              fontWeight: FontWeight.bold),
                        ),
            ),
            widget.isTimed == true
                ? Text(
                    widget.reps >= 60 ? 'min' : 'secs',
                    style: TextStyle(fontWeight: FontWeight.w300),
                  )
                : Text(
                    kReps,
                    style: TextStyle(fontWeight: FontWeight.w300),
                  ),
          ],
        )),
        Expanded(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  widget.rest >= 60
                      ? (widget.rest / 60).truncate().toString() +
                          ':' +
                          (widget.rest % 60).toString()
                      : widget.rest.toString(),
                  style: TextStyle(
                      color: kPrimaryColor,
                      fontSize: 22,
                      fontWeight: FontWeight.bold),
                ),
              ),
              Text(
                widget.rest >= 60 ? 'Rest(min)' : 'Rest(secs)',
                style: TextStyle(fontWeight: FontWeight.w300),
              ),
            ],
          ),
        ),
        widget.more
      ],
    );
  }
}
