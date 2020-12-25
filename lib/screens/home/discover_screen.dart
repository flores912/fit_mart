import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fit_mart/blocs/home/discover_screen_bloc.dart';
import 'package:fit_mart/blocs/home/discover_screen_bloc_provider.dart';
import 'package:fit_mart/models/workout_plan.dart';
import 'package:fit_mart/screens/plan_overview_screen.dart';
import 'package:fit_mart/widgets/my_workout_plan_widget.dart';
import 'package:fit_mart/widgets/workout_plan_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../my_plan_workouts_screen.dart';

//Todo: fix sizing for items
class DiscoverScreen extends StatefulWidget {
  static const String title = 'Discover';

  @override
  DiscoverScreenState createState() => DiscoverScreenState();
}

class DiscoverScreenState extends State<DiscoverScreen> {
  DiscoverScreenBloc _bloc;
  @override
  void didChangeDependencies() {
    _bloc = DiscoverScreenBlocProvider.of(context);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(height: 400, child: workoutPlanList('Weightlifting')),
          Container(height: 400, child: workoutPlanList('Bodybuilding')),
          Container(height: 400, child: workoutPlanList('Strength')),
          Container(height: 400, child: workoutPlanList('Bodyweight')),
          Container(height: 400, child: workoutPlanList('HIIT')),
        ],
      ),
    );
  }

  Widget workoutPlanList(String category) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            category,
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
        ),
        Expanded(
          child: StreamBuilder(
              stream: _bloc.workoutPlansQuerySnapshot(category),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasData) {
                  List<DocumentSnapshot> docs = snapshot.data.docs;
                  List<WorkoutPlan> workoutPlansList =
                      _bloc.convertToWorkoutPlanList(docList: docs);

                  if (workoutPlansList.isNotEmpty) {
                    return buildList(workoutPlansList);
                  } else {
                    return Center(child: Text('No workout plans'));
                  }
                } else {
                  return Center(child: Text('No workout plans'));
                }
              }),
        ),
      ],
    );
  }

  Widget buildList(List<WorkoutPlan> workoutPlansList) {
    return ListView.builder(
      itemCount: workoutPlansList.length,
      scrollDirection: Axis.horizontal,
      itemBuilder: (context, index) {
        String workoutPlanUid = workoutPlansList[index].uid;
        String title = workoutPlansList[index].title;
        String coverPhotoUrl = workoutPlansList[index].coverPhotoUrl;
        int rating = workoutPlansList[index].rating;
        double price = workoutPlansList[index].price;
        bool isFree = workoutPlansList[index].isFree;
        String category = workoutPlansList[index].category;
        String location = workoutPlansList[index].location;
        int numberOfReviews = workoutPlansList[index].numberOfReviews;
        String skillLevel = workoutPlansList[index].skillLevel;
        Image image = workoutPlansList != null
            ? Image.network(
                coverPhotoUrl,
                fit: BoxFit.fill,
              )
            : null;
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => PlanOverviewScreen(
                  workoutPlanUid: workoutPlanUid,
                ),
              ),
            );
          },
          child: Container(
            width: MediaQuery.of(context).size.width / 1.5,
            child: WorkoutPlanCardWidget(
              title: title,
              rating: rating,
              price: price,
              isFree: isFree,
              category: category,
              location: location,
              numberOfReviews: numberOfReviews,
              skillLevel: skillLevel,
              image: image,
            ),
          ),
        );
      },
    );
  }
}
