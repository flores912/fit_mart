import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fit_mart/models/workout_plan.dart';
import 'package:fit_mart/repository.dart';
import 'package:flutter/cupertino.dart';

class MyWorkoutPlansBloc {
  final _repository = Repository();

  Stream<QuerySnapshot> myWorkoutPlansQuerySnapshot(String userUid) =>
      _repository.myWorkoutPlansQuerySnapshot(userUid);

  List<WorkoutPlan> convertToMyWorkoutPlanList(
      {@required List<DocumentSnapshot> docList}) {
    List<WorkoutPlan> myWorkoutPlansList = [];
    docList.forEach((document) {
      WorkoutPlan myWorkoutPlan = WorkoutPlan(
        uid: document.id,
        coverPhotoUrl: document.get('coverPhotoUrl'),
        trainer: document.get('trainer'),
        title: document.get('title'),
        progress: document.get('progress'),
      );
      myWorkoutPlansList.add(myWorkoutPlan);
    });
    return myWorkoutPlansList;
  }

  String getUserUid() {
    return _repository.getUser().uid;
  }
}
