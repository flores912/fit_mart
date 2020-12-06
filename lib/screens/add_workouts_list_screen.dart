import 'package:fit_mart/constants.dart';
import 'package:fit_mart/screens/create_new_workout_title_screen.dart';
import 'package:fit_mart/screens/your_workouts_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AddWorkoutsListScreen extends StatefulWidget {
  static const String title = 'Workouts';
  static const String id = 'add_workouts_list_screen';

  @override
  AddWorkoutsListScreenState createState() => AddWorkoutsListScreenState();
}

class AddWorkoutsListScreenState extends State<AddWorkoutsListScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: Padding(
          padding: const EdgeInsets.all(8.0),
          child: FloatingActionButton.extended(
              backgroundColor: kPrimaryColor,
              onPressed: () {
                Navigator.pushNamed(context, CreateNewWorkoutTitleScreen.id);
              },
              icon: Icon(Icons.create),
              label: Text('CREATE NEW WORKOUT')),
        ),
        appBar: AppBar(
          bottom: TabBar(
            indicatorColor: Colors.white,
            tabs: [
              Tab(
                text: YourWorkoutsScreen.title,
              ),
              Tab(text: 'HISTORY'),
              Tab(
                text: 'SEARCH',
              ),
            ],
          ),
          title: Text(AddWorkoutsListScreen.title),
        ),
        body: TabBarView(
          children: [
            YourWorkoutsScreen(),
            YourWorkoutsScreen(),
            YourWorkoutsScreen()
          ],
        ),
      ),
    );
  }
}
