import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fit_mart/blocs/create_plan/cover_screen_bloc.dart';
import 'package:fit_mart/blocs/edit_workout_plan_screen_bloc.dart';
import 'package:fit_mart/blocs/edit_workout_plan_screen_bloc_provider.dart';
import 'package:fit_mart/providers/firestore_provider.dart';
import 'package:fit_mart/screens/create_plan/categories_screen.dart';
import 'package:fit_mart/screens/create_plan/cover_screen.dart';
import 'package:fit_mart/screens/create_plan/details_screen.dart';
import 'package:fit_mart/screens/create_plan/plan_length_screen.dart';
import 'package:fit_mart/screens/create_plan/price_screen.dart';
import 'package:fit_mart/screens/create_plan/promo_video_screen.dart';
import 'package:fit_mart/screens/create_plan/workouts_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class EditWorkoutPlanScreen extends StatefulWidget {
  static const String title = 'Edit Workout Plan';
  static const String id = 'edit_workout_plan_screen';

  final String workoutPlanUid;

  const EditWorkoutPlanScreen({
    Key key,
    this.workoutPlanUid,
  }) : super(key: key);

  @override
  EditWorkoutPlanScreenState createState() => EditWorkoutPlanScreenState();
}

class EditWorkoutPlanScreenState extends State<EditWorkoutPlanScreen> {
  EditWorkoutPlanScreenBloc _bloc;
  String workoutPlanTitle;

  String description;

  String category;

  String location;

  String skillLevel;

  int length;

  double price;
  String coverPhotoUrl;

  String promoVideoUrl;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    _bloc = EditWorkoutPlanScreenBlocProvider.of(context);
    _bloc.getWorkoutPlanInfo(widget.workoutPlanUid).forEach((value) async {
      workoutPlanTitle = await value.get('title');
      description = await value.get('description');
      category = await value.get('category');
      location = await value.get('location');
      skillLevel = await value.get('skillLevel');
      length = await value.get('numberOfDays');
      price = await value.get('pricing');
      coverPhotoUrl = await value.get('coverPhotoUrl');
      promoVideoUrl = await value.get('promoVideoUrl');
    });
    super.didChangeDependencies();
  }

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
                      workoutPlanUid: widget.workoutPlanUid,
                      workoutPlanTitle: workoutPlanTitle,
                      description: description,
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
                      workoutPlanUid: widget.workoutPlanUid,
                      isEdit: true,
                      category: category,
                      location: location,
                      skillLevel: skillLevel,
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
                      length: length,
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
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PriceScreen(
                      isEdit: true,
                      price: price,
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
                        PriceScreen.title,
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
                    builder: (context) => CoverScreen(
                      isEdit: true,
                      workoutPlanUid: widget.workoutPlanUid,
                      coverPhotoUrl: coverPhotoUrl,
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
                        CoverScreen.title,
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
                    builder: (context) => PromoVideoScreen(
                      isEdit: true,
                      workoutPlanUid: widget.workoutPlanUid,
                      promoVideoUrl: promoVideoUrl,
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
                        PromoVideoScreen.title,
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
          ],
        ),
      ),
    );
  }
}
