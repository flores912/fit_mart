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
                          _printDuration(Duration(seconds: widget.reps)),
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
                    _printDuration(Duration(seconds: widget.reps)),
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
                  _printDuration(Duration(seconds: widget.rest)),
                  style: TextStyle(
                      color: kPrimaryColor,
                      fontSize: 22,
                      fontWeight: FontWeight.bold),
                ),
              ),
              Text(
                'Rest',
                style: TextStyle(fontWeight: FontWeight.w300),
              ),
            ],
          ),
        ),
        widget.more
      ],
    );
  }

  String _printDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
  }
}
