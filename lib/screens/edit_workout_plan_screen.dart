import 'package:fit_mart/screens/create_plan/categories_screen.dart';
import 'package:fit_mart/screens/create_plan/cover_screen.dart';
import 'package:fit_mart/screens/create_plan/details_screen.dart';
import 'package:fit_mart/screens/create_plan/plan_length_screen.dart';
import 'package:fit_mart/screens/create_plan/price_screen.dart';
import 'package:fit_mart/screens/create_plan/video_overview_screen.dart';
import 'package:fit_mart/screens/create_plan/workouts_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class EditWorkoutPlanScreen extends StatefulWidget {
  static const String title = 'Edit Workout Plan';
  static const String id = 'edit_workout_plan_screen';

  final String workoutPlanUid;
  final String workoutPlanTitle;
  final String description;
  final String category;
  final String location;
  final String skillLevel;
  final int length;
  final int price;
  final String coverPhotoUrl;
  final String videoOverviewUrl;

  const EditWorkoutPlanScreen(
      {Key key,
      this.workoutPlanUid,
      this.workoutPlanTitle,
      this.description,
      this.category,
      this.location,
      this.skillLevel,
      this.length,
      this.price,
      this.coverPhotoUrl,
      this.videoOverviewUrl})
      : super(key: key);

  @override
  EditWorkoutPlanScreenState createState() => EditWorkoutPlanScreenState();
}

class EditWorkoutPlanScreenState extends State<EditWorkoutPlanScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(EditWorkoutPlanScreen.title),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DetailsScreen(
                      isEdit: true,
                      workoutPlanTitle: widget.workoutPlanTitle,
                      description: widget.description,
                    ),
                  ),
                );
              },
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        DetailsScreen.title,
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                      Icon(Icons.edit),
                    ],
                  ),
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CategoriesScreen(
                      isEdit: true,
                      category: widget.category,
                      location: widget.location,
                      skillLevel: widget.skillLevel,
                    ),
                  ),
                );
              },
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        CategoriesScreen.title,
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                      Icon(Icons.edit),
                    ],
                  ),
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PlanLengthScreen(
                      isEdit: true,
                      length: widget.length,
                      workoutPlanUid: widget.workoutPlanUid,
                    ),
                  ),
                );
              },
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        PlanLengthScreen.title,
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                      Icon(Icons.edit),
                    ],
                  ),
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => WorkoutsScreen(
                      isEdit: true,
                      workoutPlanUid: widget.workoutPlanUid,
                    ),
                  ),
                );
              },
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        WorkoutsScreen.title,
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                      Icon(Icons.edit),
                    ],
                  ),
                ),
              ),
            ),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      CreateNewPlanPricingScreen.title,
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                    Icon(Icons.edit),
                  ],
                ),
              ),
            ),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      CreateNewPlanCoverScreen.title,
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                    Icon(Icons.edit),
                  ],
                ),
              ),
            ),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      VideoOverviewScreen.title,
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                    Icon(Icons.edit),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
