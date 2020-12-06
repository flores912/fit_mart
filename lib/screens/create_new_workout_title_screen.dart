import 'package:fit_mart/providers/firestore_provider.dart';
import 'package:fit_mart/screens/add_exercises_list_screen.dart';
import 'package:fit_mart/widgets/custom_text_form.dart';
import 'package:fit_mart/widgets/exercise_card_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../constants.dart';
import 'add_exercises_screen.dart';

class CreateNewWorkoutTitleScreen extends StatefulWidget {
  static const String title = 'Workout Title';
  static const String id = 'create_new_workout_title_screen';

  final String workoutPlanUid;
  final String workoutUid;

  const CreateNewWorkoutTitleScreen(
      {Key key, this.workoutPlanUid, this.workoutUid})
      : super(key: key);

  @override
  CreateNewWorkoutTitleScreenState createState() =>
      CreateNewWorkoutTitleScreenState();
}

class CreateNewWorkoutTitleScreenState
    extends State<CreateNewWorkoutTitleScreen> {
  String title;

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
                      widget.workoutPlanUid, widget.workoutUid, title)
                  .whenComplete(
                    () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AddExercisesScreen(
                          workoutTitle: title,
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
        title: Text(CreateNewWorkoutTitleScreen.title),
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: CustomTextForm(
                textInputType: TextInputType.text,
                labelText: 'Title',
                obscureText: false,
                onChanged: (value) {
                  title = value;
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
