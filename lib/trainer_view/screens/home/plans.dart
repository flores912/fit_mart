import 'package:fit_mart/constants.dart';
import 'package:fit_mart/trainer_view/screens/create_plan/plan_details.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Plans extends StatefulWidget {
  static const String title = kWorkoutPlans;

  @override
  _PlansState createState() => _PlansState();
}

class _PlansState extends State<Plans> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          //go first step
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PlanDetails(),
            ),
          );
        },
        child: Icon(
          Icons.add,
        ),
      ),
      body: Container(), //TODO: insert workout plans list here
    );
  }
}
