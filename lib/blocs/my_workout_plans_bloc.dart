import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fit_mart/models/my_workout_plan.dart';
import 'package:fit_mart/repository.dart';
import 'package:flutter/cupertino.dart';

class MyWorkoutPlansBloc {
  final _repository = Repository();

  Stream<QuerySnapshot> myWorkoutPlansQuerySnapshot(String userUid) =>
      _repository.myWorkoutPlansQuerySnapshot(userUid);

  List<MyWorkoutPlan> convertToMyWorkoutPlanList(
      {@required List<DocumentSnapshot> docList}) {
    List<MyWorkoutPlan> myWorkoutPlansList = [];
    docList.forEach((document) {
      MyWorkoutPlan myWorkoutPlan = MyWorkoutPlan(
          uid: document.id,
          imageUrl: document.get('imageUrl'),
          trainer: document.get('trainer'),
          title: document.get('title'),
          progress: document.get('progress'));
      myWorkoutPlansList.add(myWorkoutPlan);
    });
    return myWorkoutPlansList;
  }

  String getUserUid() {
    return _repository.getUser().uid;
  }
}
