import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class WorkoutCardWidget extends StatelessWidget {
  final String title;
  final int day;

  final int numberOfExercises;

  const WorkoutCardWidget({
    Key key,
    this.title,
    this.day,
    this.numberOfExercises,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: [
        Container(
          width: MediaQuery.of(context).size.width,
          child: Card(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(8, 8, 0, 0),
                  child: Text(
                    title,
                    style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(8, 4, 0, 8),
                  child: Text(
                    'Day ${day.toString()}',
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w400,
                        color: Colors.black),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(8, 4, 0, 8),
                  child: Text(
                    '${numberOfExercises.toString()} Exercises',
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w300,
                        color: Colors.black),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
