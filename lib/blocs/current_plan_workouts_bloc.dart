import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fit_mart/models/workout.dart';

import '../repository.dart';

class CurrentPlanWorkoutsBloc {
  final _repository = Repository();

  Future<QuerySnapshot> currentPlanWorkoutsQuerySnapshot(String email) =>
      _repository.currentPlanWorkoutsQuerySnapshot(email);

  List<Workout> convertToCurrentPlanWorkoutsList(
      {List<DocumentSnapshot> docList}) {
    List<Workout> currentPlansWorkoutsList = [];
    docList.forEach((document) {
      Workout workout = Workout(
          title: document.get('title'),
          day: document.get('day'),
          isDone: document.get('isDone'));
      currentPlansWorkoutsList.add(workout);
    });
    return currentPlansWorkoutsList;
  }

  String getEmail() {
    return _repository.getUser().email;
  }
}
