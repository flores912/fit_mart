import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:fit_mart/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class WorkoutSessionSetCard extends StatefulWidget {
  final int set;
  final int reps;
  final int rest;
  final bool isDone;
  final Function onChanged;
  final bool showRestTimer;
  final Function onRestTimerComplete;
  final CountDownController countDownController;
  final Function onTimerPressed;
  const WorkoutSessionSetCard(
      {Key key,
      this.set,
      this.reps,
      this.rest,
      this.isDone,
      this.onChanged,
      this.showRestTimer,
      this.onRestTimerComplete,
      this.countDownController,
      this.onTimerPressed})
      : super(key: key);

  @override
  _WorkoutSessionSetCardState createState() => _WorkoutSessionSetCardState();
}

class _WorkoutSessionSetCardState extends State<WorkoutSessionSetCard> {
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
                          Text(widget.set.toString()),
                          Text('Set'),
                        ],
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      Text(widget.reps.toString()),
                      Text('Reps'),
                    ],
                  ),
                  widget.showRestTimer == false
                      ? Column(
                          children: [
                            Text(widget.rest.toString()),
                            Text('Rest'),
                          ],
                        )
                      : GestureDetector(
                          onTap: widget.onTimerPressed,
                          child: CircularCountDownTimer(
                              controller: widget.countDownController,
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
                              color: Colors.red),
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
