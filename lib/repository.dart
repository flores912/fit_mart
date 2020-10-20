import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fit_mart/providers/firestore_provider.dart';

class Repository {
  final _firestoreProvider = FirestoreProvider();

  Future<void> registerUser(String email, String password) =>
      _firestoreProvider.registerUser(email, password);

  Future<UserCredential> loginUser(String email, String password) =>
      _firestoreProvider.loginUser(email, password);

  User getUser() => _firestoreProvider.getUser();

  Stream<QuerySnapshot> myWorkoutPlansQuerySnapshot(String userUid) =>
      _firestoreProvider.myWorkoutPlansQuerySnapshot(userUid);

  Stream<QuerySnapshot> currentPlanWorkoutsQuerySnapshot(
          String userUid, String workoutPlanUid) =>
      _firestoreProvider.currentPlanWorkoutsQuerySnapshot(
          userUid, workoutPlanUid);
  Stream<QuerySnapshot> exercisesQuerySnapshot(
          String userUid, String workoutPlanUid, String workoutUid) =>
      _firestoreProvider.exercisesQuerySnapshot(
          userUid, workoutPlanUid, workoutUid);

  Stream<QuerySnapshot> setsQuerySnapshot(String userUid, String workoutPlanUid,
          String workoutUid, String exerciseUid) =>
      _firestoreProvider.setsQuerySnapshot(
          userUid, workoutPlanUid, workoutUid, exerciseUid);

  Future<void> updateExerciseSelection(String userUid, String workoutPlanUid,
          String workoutUid, String exerciseUid, bool isSelected) =>
      _firestoreProvider.updateExerciseSelection(
          userUid, workoutPlanUid, workoutUid, exerciseUid, isSelected);

  Future<void> updateSet(
          String userUid,
          String workoutPlanUid,
          String workoutUid,
          String exerciseUid,
          String setUid,
          bool isSetDone) =>
      _firestoreProvider.updateSet(
          userUid, workoutPlanUid, workoutUid, exerciseUid, setUid, isSetDone);
}
