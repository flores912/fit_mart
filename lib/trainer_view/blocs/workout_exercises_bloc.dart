import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fit_mart/providers/firestore_provider.dart';

class WorkoutExercisesBloc {
  FirestoreProvider _firestoreProvider = FirestoreProvider();
  Stream<QuerySnapshot> getExercises(
          String workoutPlanUid, String weekUid, String workoutUid) =>
      _firestoreProvider.getExercises(workoutPlanUid, weekUid, workoutUid);
  Stream<QuerySnapshot> getExercisesCollection() =>
      _firestoreProvider.getExercisesCollection();
  Future<void> deleteExerciseFromCollection(String exerciseUid) =>
      _firestoreProvider.deleteExerciseFromCollection(exerciseUid);
  Future<void> deleteExerciseFromWorkout(String workoutPlanUid, String weekUid,
          String workoutUid, String exerciseUid) =>
      _firestoreProvider.deleteExerciseFromWorkout(
          workoutPlanUid, weekUid, workoutUid, exerciseUid);
  Future<void> updateNumberOfExercises(String workoutPlanUid, String weekUid,
          String workoutUid, int exercises) =>
      _firestoreProvider.updateNumberOfExercises(
          workoutPlanUid, weekUid, workoutUid, exercises);

  Future<DocumentReference> addNewExercise(
          String exerciseName,
          int exercise,
          int sets,
          String videoUrl,
          String workoutPlanUid,
          String weekUid,
          String workoutUid) =>
      _firestoreProvider.addNewExercise(exerciseName, exercise, sets, videoUrl,
          workoutPlanUid, weekUid, workoutUid);

  Stream<QuerySnapshot> getSetsCollection(String exerciseUid) =>
      _firestoreProvider.getSetsCollection(exerciseUid);

  Future<DocumentReference> addNewSet(String workoutPlanUid, String weekUid,
          String workoutUid, String exerciseUid, int set, int reps, int rest) =>
      _firestoreProvider.addNewSet(
          workoutPlanUid, weekUid, workoutUid, exerciseUid, set, reps, rest);

  Future<void> updateExerciseIndex(String workoutPlanUid, String weekUid,
          String workoutUid, String exerciseUid, int exercise) =>
      _firestoreProvider.updateExerciseIndex(
          workoutPlanUid, weekUid, workoutUid, exerciseUid, exercise);
}
