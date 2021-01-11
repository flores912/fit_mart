import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class WorkoutSessionSetCard extends StatefulWidget {
  final int set;
  final int reps;
  final int rest;

  const WorkoutSessionSetCard({Key key, this.set, this.reps, this.rest})
      : super(key: key);

  @override
  _WorkoutSessionSetCardState createState() => _WorkoutSessionSetCardState();
}

class _WorkoutSessionSetCardState extends State<WorkoutSessionSetCard> {
  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Row(
                  children: [
                    Container(
                        width: 48,
                        height: 48,
                        child: Checkbox(value: true, onChanged: (v) {})),
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
                Column(
                  children: [
                    Text(widget.rest.toString()),
                    Text('Rest'),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
