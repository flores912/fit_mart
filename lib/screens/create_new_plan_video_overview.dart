import 'package:fit_mart/screens/create_new_plan_add_workouts_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CreateNewPlanVideoOverview extends StatefulWidget {
  static const String title = ' Step 7 of 7: Video Overview';
  static const String id = 'create_new_plan_video_overview_screen';

  @override
  CreateNewPlanVideoOverviewState createState() =>
      CreateNewPlanVideoOverviewState();
}

class CreateNewPlanVideoOverviewState
    extends State<CreateNewPlanVideoOverview> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(CreateNewPlanVideoOverview.title),
        centerTitle: true,
        actions: [
          FlatButton(
            onPressed: () {
              Navigator.pushNamed(context, CreateNewPlanAddWorkoutsScreen.id);
            },
            textColor: Colors.white,
            child: Text(
              'Next',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
          )
        ],
      ),
    );
  }
}
