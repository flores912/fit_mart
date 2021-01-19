import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:fit_mart/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class WorkoutSessionSetCard extends StatefulWidget {
  final int set;
  final int reps;
  final int rest;
  final bool isTimed;
  final bool isFailure;
  final bool isDone;
  final Function onChanged;
  final bool showRestTimer;
  final Function onTimedSetTimerComplete;
  final Function onRestTimerComplete;
  final CountDownController restCountDownController;
  final CountDownController setCountDownController;
  final Function onRestTimerPressed;
  final Function onSetTimerPressed;

  const WorkoutSessionSetCard({
    Key key,
    this.set,
    this.reps,
    this.rest,
    this.isDone,
    this.onChanged,
    this.showRestTimer,
    this.onRestTimerComplete,
    this.restCountDownController,
    this.onRestTimerPressed,
    this.isTimed,
    this.isFailure,
    this.onTimedSetTimerComplete,
    this.setCountDownController,
    this.onSetTimerPressed,
  }) : super(key: key);

  @override
  _WorkoutSessionSetCardState createState() => _WorkoutSessionSetCardState();
}

class _WorkoutSessionSetCardState extends State<WorkoutSessionSetCard> {
  bool showTimedSetTimer = false;
  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 48,
                        height: 48,
                        child: Checkbox(
                            value: widget.isDone, onChanged: widget.onChanged),
                      ),
                      Column(
                        children: [
                          Text(
                            widget.set.toString(),
                            style: TextStyle(
                                color: kPrimaryColor,
                                fontSize: 22,
                                fontWeight: FontWeight.bold),
                          ),
                          Text(
                            'Set',
                            style: TextStyle(fontWeight: FontWeight.w300),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      widget.isFailure == true
                          ? Text(
                              'FAILURE',
                              style: TextStyle(
                                  color: kPrimaryColor,
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold),
                            )
                          : widget.isTimed == true && showTimedSetTimer == true
                              ? GestureDetector(
                                  onTap: widget.onSetTimerPressed,
                                  child: CircularCountDownTimer(
                                      controller: widget.setCountDownController,
                                      onComplete:
                                          widget.onTimedSetTimerComplete,
                                      strokeWidth: 10,
                                      width: 72,
                                      height: 72,
                                      duration: widget.reps,
                                      isReverseAnimation: true,
                                      isReverse: true,
                                      textStyle: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold),
                                      fillColor: Colors.white,
                                      color: kPrimaryColor),
                                )
                              : Text(
                                  widget.isTimed && widget.reps >= 60
                                      ? (widget.reps / 60)
                                              .truncate()
                                              .toString() +
                                          ':' +
                                          (widget.reps % 60).toString()
                                      : widget.reps.toString(),
                                  style: TextStyle(
                                      color: kPrimaryColor,
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold),
                                ),
                      widget.isTimed == true
                          ? Column(
                              children: [
                                Text(
                                  widget.reps >= 60 &&
                                          showTimedSetTimer == false
                                      ? 'min'
                                      : widget.reps < 60 &&
                                              showTimedSetTimer == false
                                          ? 'secs'
                                          : '',
                                  style: TextStyle(fontWeight: FontWeight.w300),
                                ),
                                showTimedSetTimer == false
                                    ? RaisedButton(
                                        onPressed: () {
                                          setState(() {
                                            showTimedSetTimer = true;
                                          });
                                        },
                                        child: Text('START TIMER'),
                                      )
                                    : Container()
                              ],
                            )
                          : Text(
                              'Reps',
                              style: TextStyle(fontWeight: FontWeight.w300),
                            ),
                    ],
                  ),
                  widget.showRestTimer == false
                      ? Column(
                          children: [
                            Text(
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
                            Text(
                              widget.rest >= 60 ? 'Rest(min)' : 'Rest(secs)',
                              style: TextStyle(fontWeight: FontWeight.w300),
                            ),
                          ],
                        )
                      : GestureDetector(
                          onTap: widget.onRestTimerPressed,
                          child: CircularCountDownTimer(
                              controller: widget.restCountDownController,
                              onComplete: widget.onRestTimerComplete,
                              strokeWidth: 10,
                              width: 72,
                              height: 72,
                              duration: widget.rest,
                              isReverseAnimation: true,
                              isReverse: true,
                              textStyle: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                              fillColor: Colors.white,
                              color: kPrimaryColor),
                        )
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
