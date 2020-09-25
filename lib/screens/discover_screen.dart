import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fit_mart/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../workout_plans_list.dart';

class DiscoverScreen extends StatefulWidget {
  static const String title = 'Explore';

  @override
  DiscoverScreenState createState() => DiscoverScreenState();
}

class DiscoverScreenState extends State<DiscoverScreen> {
  @override
  Widget build(BuildContext context) {
    return (Scaffold(
      body: ListView(children: [
        WorkoutPlansList(kWeightlifting),
        WorkoutPlansList(kBodyweight)
      ]),
    ));
  }
}
