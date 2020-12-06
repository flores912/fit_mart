import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fit_mart/models/workout.dart';
import 'package:flutter/cupertino.dart';

class CreatePlanWorkoutsBloc {
  List<Workout> convertToMyWorkoutsList(
      {@required List<DocumentSnapshot> docList}) {
    List<Workout> myWorkoutsList = [];
    docList.forEach((document) {
      Workout workout = Workout(
        uid: document.id,
        title: document.get('title'),
        numberOfExercises: document.get('numberOfExercises'),
        day: document.get('day'),
        // isDone: document.get('isDone:'),
      );
      myWorkoutsList.add(workout);
    });
    return myWorkoutsList;
  }
}
