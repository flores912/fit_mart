import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fit_mart/models/workout.dart';
import 'package:fit_mart/providers/firestore_provider.dart';
import 'package:fit_mart/models/week.dart';

class PlanWorkoutsBloc {
  FirestoreProvider _firestoreProvider = FirestoreProvider();

  Future<void> createNewWeek(String workoutPlanUid, int week) =>
      _firestoreProvider.createNewWeek(workoutPlanUid, week);

  Stream<QuerySnapshot> getWeeks(String workoutPlanUid) =>
      _firestoreProvider.getWeeks(workoutPlanUid);

  Stream<QuerySnapshot> getWorkouts(String workoutPlanUid, String weekUid) =>
      _firestoreProvider.getWorkouts(workoutPlanUid, weekUid);

  Stream<QuerySnapshot> getExercises(
          String workoutPlanUid, String weekUid, String workoutUid) =>
      _firestoreProvider.getExercises(workoutPlanUid, weekUid, workoutUid);

  Future<void> updateWorkoutExerciseNumber(
          String workoutPlanUid, String weekUid, String workoutUid) =>
      _firestoreProvider.updateWorkoutExerciseNumber(
          workoutPlanUid, weekUid, workoutUid);

  Future<void> copyWorkout(String workoutPlanUid, Workout originalWorkout,
          Workout copyWorkout) =>
      _firestoreProvider.copyWorkout(
          workoutPlanUid, originalWorkout, copyWorkout);
  Future<void> copyWeek(
          String workoutPlanUid, Week originalWeek, Week copyWeek) =>
      _firestoreProvider.copyWeek(workoutPlanUid, originalWeek, copyWeek);
}
