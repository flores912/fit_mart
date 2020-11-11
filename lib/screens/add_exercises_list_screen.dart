import 'package:fit_mart/screens/your_exercises_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../constants.dart';
import 'create_new_exercise_title_screen.dart';

class AddExercisesListScreen extends StatefulWidget {
  static const String title = 'Exercises';
  static const String id = 'add_exercises_list_screen';

  @override
  AddExercisesListScreenState createState() => AddExercisesListScreenState();
}

class AddExercisesListScreenState extends State<AddExercisesListScreen> {
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
                Navigator.pushNamed(context, CreateNewExerciseTitleScreen.id);
              },
              icon: Icon(Icons.create),
              label: Text('CREATE NEW EXERCISE')),
        ),
        appBar: AppBar(
          bottom: TabBar(
            indicatorColor: Colors.white,
            tabs: [
              Tab(
                text: YourExercisesScreen.title,
              ),
              Tab(text: 'HISTORY'),
              Tab(
                text: 'SEARCH',
              ),
            ],
          ),
          title: Text(AddExercisesListScreen.title),
        ),
        body: TabBarView(
          children: [
            YourExercisesScreen(),
            YourExercisesScreen(),
            YourExercisesScreen(),
          ],
        ),
      ),
    );
  }
}
