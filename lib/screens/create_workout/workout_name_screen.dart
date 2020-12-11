import 'package:fit_mart/providers/firestore_provider.dart';
import 'package:fit_mart/widgets/custom_text_form.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../constants.dart';
import 'exercises_screen.dart';

class WorkoutNameScreen extends StatefulWidget {
  static const String title = 'Workout Name';
  static const String id = 'workout_name_screen';

  final String workoutPlanUid;
  final String workoutUid;

  const WorkoutNameScreen({Key key, this.workoutPlanUid, this.workoutUid})
      : super(key: key);

  @override
  WorkoutNameScreenState createState() => WorkoutNameScreenState();
}

class WorkoutNameScreenState extends State<WorkoutNameScreen> {
  String workoutName;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          FlatButton(
            onPressed: () {
              //next step
              FirestoreProvider firestoreProvider = FirestoreProvider();
              firestoreProvider
                  .updateNewWorkoutToWorkoutPlan(
                      widget.workoutPlanUid, widget.workoutUid, workoutName)
                  .whenComplete(
                    () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ExercisesScreen(
                          workoutTitle: workoutName,
                          workoutUid: widget.workoutUid,
                          workoutPlanUid: widget.workoutPlanUid,
                        ),
                      ),
                    ),
                  );
            },
            child: Text(
              'Next',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          )
        ],
        title: Text(WorkoutNameScreen.title),
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: CustomTextForm(
                textInputType: TextInputType.text,
                labelText: 'Create Workout Name',
                obscureText: false,
                onChanged: (value) {
                  workoutName = value;
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
