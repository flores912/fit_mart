import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fit_mart/constants.dart';
import 'package:fit_mart/custom_widgets/workout_plan_card.dart';
import 'package:fit_mart/models/workout_plan.dart';
import 'package:fit_mart/trainer_view/blocs/plans_bloc.dart';
import 'package:fit_mart/trainer_view/screens/create_plan/plan_details.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Plans extends StatefulWidget {
  static const String title = kWorkoutPlans;

  @override
  _PlansState createState() => _PlansState();
}

class _PlansState extends State<Plans> {
  PlansBloc _bloc = PlansBloc();
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
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: StreamBuilder(
            stream: _bloc.getTrainerPlans(),
            builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasData) {
                List<WorkoutPlan> workoutPlansList =
                    buildWorkoutPlansList(snapshot.data.docs);
                return ListView.builder(
                    itemCount: workoutPlansList.length,
                    itemBuilder: (context, index) {
                      return Center(
                        child: WorkoutPlanCard(
                          title: workoutPlansList[index].title,
                          weeks: workoutPlansList[index].weeks,
                          image: workoutPlansList[index].coverPhotoUrl != null
                              ? Image.network(
                                  workoutPlansList[index].coverPhotoUrl)
                              : Container(
                                  color: CupertinoColors.placeholderText,
                                ),
                        ),
                      );
                    });
              }
              return Center(child: CircularProgressIndicator());
            }),
      ), //TODO: insert workout plans list here
    );
  }

  List<WorkoutPlan> buildWorkoutPlansList(List<DocumentSnapshot> docList) {
    List<WorkoutPlan> workoutsList = [];
    docList.forEach((element) {
      WorkoutPlan workoutPlan = WorkoutPlan(
        weeks: element.get('weeks'),
        price: element.get('price'),
        isFree: element.get('isFree'),
        description: element.get('description'),
        promoVideoUrl: element.get('promoVideoUrl'),
        isPublished: element.get('isPublished'),
        coverPhotoUrl: element.get('coverPhotoUrl'),
        userUid: element.get('userUid'),
        title: element.get('title'),
      );
      workoutsList.add(workoutPlan);
    });
    return workoutsList;
  }
}
