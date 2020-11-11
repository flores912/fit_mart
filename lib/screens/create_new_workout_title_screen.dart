import 'package:fit_mart/screens/add_exercises_list_screen.dart';
import 'package:fit_mart/widgets/custom_text_form.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../constants.dart';
import 'add_exercises_screen.dart';

class CreateNewWorkoutStep1Screen extends StatefulWidget {
  static const String title = 'Workout Title';
  static const String id = 'create_new_workout_step1_screen';

  @override
  CreateNewWorkoutStep1ScreenState createState() =>
      CreateNewWorkoutStep1ScreenState();
}

class CreateNewWorkoutStep1ScreenState
    extends State<CreateNewWorkoutStep1Screen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(CreateNewWorkoutStep1Screen.title),
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: CustomTextForm(
                isNumberOnly: false,
                textInputType: TextInputType.text,
                labelText: 'Title',
                obscureText: false,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: RaisedButton(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                color: kPrimaryColor,
                child: Text(
                  'Next',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                onPressed: () {
                  //next step
                  Navigator.pushNamed(context, AddExercisesScreen.id);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
