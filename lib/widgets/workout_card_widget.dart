import 'package:fit_mart/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class WorkoutCardWidget extends StatelessWidget {
  final String title;
  final int day;

  final int numberOfExercises;

  final Function addNewWorkoutFAB;

  const WorkoutCardWidget({
    Key key,
    this.title,
    this.day,
    this.numberOfExercises,
    this.addNewWorkoutFAB,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Card(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 8, 8, 8),
              child: Text(
                'Day ${day.toString()}',
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w400,
                    color: Colors.black),
              ),
            ),
            Padding(
                padding: const EdgeInsets.fromLTRB(8, 8, 8, 8),
                child: title == null
                    ? Container(
                        height: 36,
                        child: FloatingActionButton(
                          heroTag: day.toString(),
                          backgroundColor: kPrimaryColor,
                          elevation: 0,
                          onPressed: addNewWorkoutFAB,
                          child: Icon(Icons.add),
                        ),
                      )
                    : Column(
                        children: [
                          Text(
                            title,
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.black),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(8, 8, 8, 8),
                            child: numberOfExercises == null
                                ? null
                                : Text(
                                    '${numberOfExercises.toString()} Exercises',
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w300,
                                        color: Colors.black),
                                  ),
                          ),
                        ],
                      )),
          ],
        ),
      ),
    );
  }
}
