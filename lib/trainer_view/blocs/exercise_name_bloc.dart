import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fit_mart/providers/firestore_provider.dart';

class ExerciseNameBloc {
  FirestoreProvider firestoreProvider = FirestoreProvider();

  Future<void> updateExerciseName(String workoutPlanUid, String weekUid,
          String workoutUid, String exerciseUid, String exerciseName) =>
      firestoreProvider.updateExerciseName(
          workoutPlanUid, weekUid, workoutUid, exerciseUid, exerciseName);

  Future<void> updateExerciseNameCollection(
          String exerciseUid, String exerciseName) =>
      firestoreProvider.updateExerciseNameCollection(exerciseUid, exerciseName);

  Future<DocumentReference> addNewExercise(
          String exerciseName,
          int exercise,
          int sets,
          String videoUrl,
          String workoutPlanUid,
          String weekUid,
          String workoutUid) =>
      firestoreProvider.addNewExercise(exerciseName, exercise, sets, videoUrl,
          workoutPlanUid, weekUid, workoutUid);
  Future<void> updateNumberOfExercises(String workoutPlanUid, String weekUid,
          String workoutUid, int exercises) =>
      firestoreProvider.updateNumberOfExercises(
          workoutPlanUid, weekUid, workoutUid, exercises);

  Future<DocumentReference> addNewExerciseToCollection(
          String exerciseName, int sets, String videoUrl) =>
      firestoreProvider.addNewExerciseToCollection(
          exerciseName, sets, videoUrl);
}
