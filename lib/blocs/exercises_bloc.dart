import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fit_mart/models/exercise.dart';
import 'package:fit_mart/models/set.dart';
import 'package:fit_mart/repository.dart';
import 'package:flutter/cupertino.dart';

class ExercisesBloc {
  final _repository = Repository();

  Stream<QuerySnapshot> exercisesQuerySnapshot(
          String userUid, String workoutPlanUid, String workoutUid) =>
      _repository.exercisesQuerySnapshot(userUid, workoutPlanUid, workoutUid);

  List<Exercise> exercisesList({@required List<DocumentSnapshot> docList}) {
    List<Exercise> exercisesList = [];
    docList.forEach((doc) {
      Exercise exercise = Exercise(
          title: doc.get('title'),
          sets: doc.get('sets'),
          weight: doc.get('weight'));
      exercisesList.add(exercise);
    });
    return exercisesList;
  }

  List<Set> setList({@required List<DocumentSnapshot> docList}) {
    List<Set> setList = [];
    docList.forEach((doc) {
      Set set = Set(
          reps: doc.get('reps'),
          rest: doc.get('rest'),
          numOfSet: doc.get('numOfSet'));
    });
  }

  String getUserUid() {
    return _repository.getUser().uid;
  }
}
