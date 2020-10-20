import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fit_mart/models/workout.dart';
import 'package:fit_mart/repository.dart';
import 'package:flutter/cupertino.dart';

class MyPlanWorkoutsBloc {
  final _repository = Repository();

  Stream<QuerySnapshot> currentPlanWorkoutsQuerySnapshot(
      String userUid, String workoutPlanUid) {
    return _repository.currentPlanWorkoutsQuerySnapshot(
        userUid, workoutPlanUid);
  }

  List<Workout> myPlanWorkoutsList({@required List<DocumentSnapshot> docList}) {
    List<Workout> currentPlansWorkoutsList = [];
    docList.forEach((document) {
      Workout workout = Workout(
          uid: document.id,
          title: document.get('title'),
          day: document.get('day'),
          isDone: document.get('isDone'));
      currentPlansWorkoutsList.add(workout);
    });
    return currentPlansWorkoutsList;
  }

  String getUserUid() {
    return _repository.getUser().uid;
  }

  Future<void> updateWorkoutProgress(String userUid, String workoutPlanUid,
          String workoutUid, bool isDone) =>
      _repository.updateWorkoutProgress(
          userUid, workoutPlanUid, workoutUid, isDone);
}
