import 'package:fit_mart/screens/create_new_plan_pricing.dart';
import 'package:fit_mart/widgets/workout_card_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../constants.dart';
import 'add_workouts_list_screen.dart';

class CreateNewPlanAddWorkoutsScreen extends StatefulWidget {
  static const String title = 'Step 2 of 5: Workouts';
  static const String id = 'create_new_plan_add_workouts_screen';

  @override
  CreateNewPlanAddWorkoutsScreenState createState() =>
      CreateNewPlanAddWorkoutsScreenState();
}

class CreateNewPlanAddWorkoutsScreenState
    extends State<CreateNewPlanAddWorkoutsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Padding(
        padding: EdgeInsets.all(8.0),
        child: FloatingActionButton.extended(
          backgroundColor: kPrimaryColor,
          onPressed: () {
            Navigator.pushNamed(context, AddWorkoutsListScreen.id);
          },
          label: Text('ADD NEW WORKOUT'),
          icon: Icon(Icons.add),
        ),
      ),
      appBar: AppBar(
        title: Text(CreateNewPlanAddWorkoutsScreen.title),
        centerTitle: true,
        actions: [
          FlatButton(
            onPressed: () {
              Navigator.pushNamed(context, CreateNewPlanPricingScreen.id);
            },
            textColor: Colors.white,
            child: Text(
              'Publish',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
          )
        ],
      ),
      body: SafeArea(
          child: Column(
        children: [
          Expanded(
            child: ListView(
              children: [
                WorkoutCardWidget(
                  title: 'Title',
                  day: 1,
                  numberOfExercises: 6,
                ),
              ],
            ),
          ),
        ],
      )),
    );
  }
}
