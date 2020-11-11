import 'package:fit_mart/screens/add_workouts_list_screen.dart';
import 'package:fit_mart/widgets/workout_card_widget.dart';
import 'package:flutter/material.dart';

import '../constants.dart';

class AddWorkoutsScreen extends StatefulWidget {
  static const String title = ' Add Workouts';
  static const String id = 'add_new_workouts_screen';

  @override
  AddWorkoutsScreenState createState() => AddWorkoutsScreenState();
}

class AddWorkoutsScreenState extends State<AddWorkoutsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(8.0),
        child: FloatingActionButton.extended(
          backgroundColor: kPrimaryColor,
          onPressed: () {
            Navigator.pushNamed(context, AddWorkoutsListScreen.id);
          },
          label: Text('ADD WORKOUT'),
          icon: Icon(Icons.add),
        ),
      ),
      appBar: AppBar(
        title: Text(AddWorkoutsScreen.title),
        actions: [
          FlatButton(
            onPressed: () {},
            textColor: Colors.white,
            child: Text(
              'Next',
            ),
          )
        ],
      ),
      body: SafeArea(
          child: ListView(
        children: [
          WorkoutCardWidget(
            title: 'Title',
            day: 1,
            numberOfExercises: 6,
            workoutButtonText: 'ADD WORKOUT',
          ),
        ],
      )),
    );
  }
}
