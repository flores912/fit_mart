import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fit_mart/custom_widgets/my_created_workout_plan_card.dart';
import 'package:fit_mart/models/workout_plan.dart';
import 'package:fit_mart/trainer_view/blocs/plans_bloc.dart';
import 'package:fit_mart/trainer_view/screens/create_plan/edit_plan.dart';
import 'package:fit_mart/trainer_view/screens/create_plan/plan_details.dart';
import 'package:fit_mart/trainer_view/screens/home/workout_plan_preview.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

import '../../../constants.dart';

class OthersPlans extends StatefulWidget {
  @override
  _OthersPlansState createState() => _OthersPlansState();
}

class _OthersPlansState extends State<OthersPlans> {
  PlansBloc _bloc = PlansBloc();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: StreamBuilder(
            stream: _bloc.getOthersTrainerPlans(),
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
                          more: GestureDetector(
                              onTap: () {
                                Get.dialog(AlertDialog(
                                  title: Text('Remove Workout Plan?'),
                                  actions: [
                                    TextButton(
                                        onPressed: () => Navigator.pop(context),
                                        child: Text('No')),
                                    TextButton(
                                        onPressed: () {
                                          EasyLoading.show();
                                          _bloc
                                              .removePlanFromList(
                                                  workoutPlansList[index].uid)
                                              .whenComplete(
                                                () => Scaffold.of(context)
                                                    .showSnackBar(
                                                  SnackBar(
                                                    content: Text(
                                                        'Workout Plan Removed.'),
                                                  ),
                                                ),
                                              )
                                              .whenComplete(
                                                  () => EasyLoading.dismiss())
                                              .whenComplete(
                                                  () => Navigator.pop(context));
                                        },
                                        child: Text('YES'))
                                  ],
                                ));
                              },
                              child: Icon(Icons.delete)),
                          title: workoutPlansList[index].title,
                          weeks: workoutPlansList[index].weeks,
                          isLive: workoutPlansList[index].isPublished,
                          url: workoutPlansList[index].coverPhotoUrl,
                        ),
                      );
                    });
              }
              return Center(child: Text('No plans have been added here.'));
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
