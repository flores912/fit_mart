import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fit_mart/providers/firestore_provider.dart';

class ExerciseNameBloc {
  FirestoreProvider firestoreProvider = FirestoreProvider();
  Future<DocumentReference> addNewExercise(
          exerciseName, exercise, workoutPlanUid, weekUid, workoutUid) =>
      firestoreProvider.addNewExercise(
          exerciseName, exercise, workoutPlanUid, weekUid, workoutUid);
  Future<void> updateNumberOfExercises(
          String workoutPlanUid, String workoutUid, int exercises) =>
      firestoreProvider.updateNumberOfExercises(
          workoutPlanUid, workoutUid, exercises);
}
