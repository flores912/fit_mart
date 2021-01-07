import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fit_mart/providers/firestore_provider.dart';

class ExerciseNameBloc {
  FirestoreProvider firestoreProvider = FirestoreProvider();
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
    String exerciseName,
  ) =>
      firestoreProvider.addNewExerciseToCollection(exerciseName);
}
