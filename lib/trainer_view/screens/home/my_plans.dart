import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fit_mart/constants.dart';
import 'package:fit_mart/custom_widgets/my_created_workout_plan_card.dart';
import 'package:fit_mart/custom_widgets/workout_plan_card.dart';
import 'package:fit_mart/models/workout_plan.dart';
import 'package:fit_mart/trainer_view/blocs/plans_bloc.dart';
import 'package:fit_mart/trainer_view/screens/create_plan/edit_plan.dart';
import 'package:fit_mart/trainer_view/screens/create_plan/plan_details.dart';
import 'package:fit_mart/trainer_view/screens/home/plan_overview.dart';
import 'package:fit_mart/trainer_view/screens/home/workout_plan_preview.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class MyPlans extends StatefulWidget {
  static const String title = kWorkoutPlans;

  @override
  _MyPlansState createState() => _MyPlansState();
}

class _MyPlansState extends State<MyPlans> {
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
                        child: MyCreatedWorkoutPlanCard(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => WorkoutPlanPreview(
                                  workoutPlan: workoutPlansList[index],
                                ),
                              ),
                            );
                          },
                          title: workoutPlansList[index].title,
                          weeks: workoutPlansList[index].weeks,
                          isLive: workoutPlansList[index].isPublished,
                          coverPhoto:
                              workoutPlansList[index].coverPhotoUrl != null
                                  ? Image.network(
                                      workoutPlansList[index].coverPhotoUrl)
                                  : Container(
                                      color: CupertinoColors.placeholderText,
                                    ),
                          more: PopupMenuButton(
                              onSelected: (value) {
                                switch (value) {
                                  case 1:
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => EditPlan(
                                          workoutPlanUid:
                                              workoutPlansList[index].uid,
                                        ),
                                      ),
                                    );

                                    break;
                                  case 2:
                                    EasyLoading.show();
                                    _bloc
                                        .deletePlan(workoutPlansList[index].uid)
                                        .whenComplete(
                                            () => EasyLoading.dismiss());

                                    break;
                                }
                              },
                              icon: Icon(Icons.more_vert),
                              itemBuilder: (BuildContext context) =>
                                  kMyCreatedWorkoutPlanCardPopUpMenuList),
                        ),
                      );
                    });
              }
              return Center(child: CircularProgressIndicator());
            }),
      ),
    );
  }

  List<WorkoutPlan> buildWorkoutPlansList(List<DocumentSnapshot> docList) {
    List<WorkoutPlan> workoutsList = [];
    docList.forEach((element) {
      WorkoutPlan workoutPlan = WorkoutPlan(
        users: element.get('users'),
        uid: element.id,
        trainerName: element.get('trainerName'),
        type: element.get('type'),
        weeks: element.get('weeks'),
        location: element.get('location'),
        level: element.get('level'),
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
