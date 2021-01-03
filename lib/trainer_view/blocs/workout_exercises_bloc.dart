import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fit_mart/providers/firestore_provider.dart';

class WorkoutExercisesBloc {
  FirestoreProvider _firestoreProvider = FirestoreProvider();
  Stream<QuerySnapshot> getExercises(
          String workoutPlanUid, String weekUid, String workoutUid) =>
      _firestoreProvider.getExercises(workoutPlanUid, weekUid, workoutUid);

  Future<void> updateWorkoutExerciseNumber(
          String workoutPlanUid, String weekUid, String workoutUid) =>
      _firestoreProvider.updateWorkoutExerciseNumber(
          workoutPlanUid, weekUid, workoutUid);
}
