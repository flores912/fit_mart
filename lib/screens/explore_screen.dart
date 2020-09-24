import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../buy_workout_plan_card.dart';
import '../workout_plans_list.dart';

class ExploreScreen extends StatefulWidget {
  @override
  ExploreScreenState createState() => ExploreScreenState();
}

class ExploreScreenState extends State<ExploreScreen> {
  @override
  Widget build(BuildContext context) {
    return (Scaffold(
      body: ListView(children: [
        WorkoutPlansList('Weightlifting'),
        WorkoutPlansList('Bodyweight')
      ]),
    ));
  }
}
