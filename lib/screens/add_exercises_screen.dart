import 'package:fit_mart/constants.dart';
import 'package:fit_mart/screens/create_new_exercise_title_screen.dart';
import 'package:fit_mart/widgets/exercise_card_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'add_exercises_list_screen.dart';

class AddExercisesScreen extends StatefulWidget {
  static const String id = 'add_exercises_screen';

  final String workoutTitle;

  const AddExercisesScreen({Key key, this.workoutTitle}) : super(key: key);

  @override
  AddExercisesScreenState createState() => AddExercisesScreenState();
}

class AddExercisesScreenState extends State<AddExercisesScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(8.0),
        child: FloatingActionButton.extended(
          backgroundColor: kPrimaryColor,
          onPressed: () {
            showDialog(
                context: context,
                barrierDismissible: true,
                builder: (BuildContext context) {
                  return SimpleDialog(
                    title: Text(
                      'Add Exercises',
                    ),
                    children: [
                      SimpleDialogOption(
                        onPressed: () {
                          Navigator.pushNamed(
                              context, AddExercisesListScreen.id);
                        },
                        child: const Text(
                          'Add exercises from library',
                        ),
                      ),
                      SimpleDialogOption(
                        onPressed: () {
                          Navigator.pushNamed(
                              context, CreateNewExerciseTitleScreen.id);
                        },
                        child: const Text('Create new exercise'),
                      ),
                    ],
                  );
                });
          },
          label: Text('ADD EXERCISE'),
          icon: Icon(Icons.add),
        ),
      ),
      appBar: AppBar(
        title: Text(widget.workoutTitle),
      ),
      body: SafeArea(
          child: ListView(
        children: [
          ExerciseCardWidget(
            title: 'TITLE',
            sets: 4,
            reps: 12,
            rest: 30,
            workoutButtonText: 'ADD EXERCISE',
          ),
        ],
      )),
    );
  }
}
