import 'package:fit_mart/widgets/custom_text_form.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../constants.dart';

class CreateNewExerciseTitleScreen extends StatefulWidget {
  static const String title = 'Exercise Title';
  static const String id = 'create_new_exercise_title_screen';

  @override
  CreateNewExerciseTitleScreenState createState() =>
      CreateNewExerciseTitleScreenState();
}

class CreateNewExerciseTitleScreenState
    extends State<CreateNewExerciseTitleScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(CreateNewExerciseTitleScreen.title),
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
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
