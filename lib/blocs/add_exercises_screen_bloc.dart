import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fit_mart/models/exercise.dart';
import 'package:flutter/cupertino.dart';

class AddExercisesScreenBloc {
  List<Exercise> convertToExercisesList(
      {@required List<DocumentSnapshot> docList}) {
    List<Exercise> myExercisesList = [];
    docList.forEach((document) {
      Exercise exercise = Exercise(
        uid: document.id,
        title: document.get('title'),
        videoUrl: document.get('videoUrl'),
        sets: document.get('sets'),

        // isDone: document.get('isDone:'),
      );
      myExercisesList.add(exercise);
    });
    return myExercisesList;
  }
}
