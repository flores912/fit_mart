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

  Stream<QuerySnapshot> setsQuerySnapshot(String userUid, String workoutPlanUid,
          String workoutUid, String exerciseUid) =>
      _repository.setsQuerySnapshot(
          userUid, workoutPlanUid, workoutUid, exerciseUid);

  String getUserUid() {
    return _repository.getUser().uid;
  }

  List<Exercise> exercisesList({@required List<DocumentSnapshot> docList}) {
    List<Exercise> exercisesList = [];
    docList.forEach((doc) {
      Exercise exercise = Exercise(
        uid: doc.id,
        videoUrl: doc.get('videoUrl'),
        title: doc.get('title'),
        sets: doc.get('sets'),
        isSelected: doc.get('isSelected'),
      );
      exercisesList.add(exercise);
    });
    return exercisesList;
  }

  List<Set> setList({@required List<DocumentSnapshot> docList}) {
    List<Set> setList = [];
    docList.forEach((doc) {
      Set set = Set(
          uid: doc.id,
          weight: doc.get('weight'),
          isSetDone: doc.get('isSetDone'),
          reps: doc.get('reps'),
          rest: doc.get('rest'),
          numOfSet: doc.get('numOfSet'));
      setList.add(set);
    });
    return setList;
  }

  Future<void> updateExerciseSelection(String userUid, String workoutPlanUid,
          String workoutUid, String exerciseUid, bool isSelected) =>
      _repository.updateExerciseSelection(
          userUid, workoutPlanUid, workoutUid, exerciseUid, isSelected);

  Future<void> updateSetProgress(
          String userUid,
          String workoutPlanUid,
          String workoutUid,
          String exerciseUid,
          String setUid,
          bool isSetDone) =>
      _repository.updateSetProgress(
          userUid, workoutPlanUid, workoutUid, exerciseUid, setUid, isSetDone);
}
