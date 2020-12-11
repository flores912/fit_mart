import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fit_mart/models/exercise.dart';
import 'package:fit_mart/models/workout_plan.dart';
import 'package:fit_mart/repository.dart';
import 'package:fit_mart/widgets/workout_plan_card.dart';
import 'package:flutter/cupertino.dart';

class LibraryScreenBloc {
  final _repository = Repository();
  Stream<QuerySnapshot> myWorkoutPlansLibraryQuerySnapshot() =>
      _repository.myWorkoutPlansLibraryQuerySnapshot();

  List<WorkoutPlan> convertToWorkoutPlansList(
      {@required List<DocumentSnapshot> docList}) {
    List<WorkoutPlan> workoutPlansList = [];
    docList.forEach((document) {
      WorkoutPlan workoutPlan = WorkoutPlan(
        uid: document.id,
        title: document.get('title'),
        description: document.get('description'),
        category: document.get('category'),
        numberOfDays: document.get('numberOfDays'),
        location: document.get('location'),
        skillLevel: document.get('skillLevel'),
        rating: document.get('rating'),
        price: document.get('pricing'),
        isFree: document.get('isFree'),
        coverPhotoUrl: document.get('coverPhotoUrl'),
        numberOfReviews: document.get('numberOfReviews'),
      );
      workoutPlansList.add(workoutPlan);
    });
    return workoutPlansList;
  }
}
