import 'dart:io';

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
      _firestoreProvider.exercisesQuerySnapshot(workoutPlanUid, workoutUid);

  Stream<QuerySnapshot> setsQuerySnapshot(String userUid, String workoutPlanUid,
          String workoutUid, String exerciseUid) =>
      _firestoreProvider.setsQuerySnapshot(
          userUid, workoutPlanUid, workoutUid, exerciseUid);

  Future<void> updateExerciseSelection(String userUid, String workoutPlanUid,
          String workoutUid, String exerciseUid, bool isSelected) =>
      _firestoreProvider.updateExerciseSelection(
          userUid, workoutPlanUid, workoutUid, exerciseUid, isSelected);

  Future<void> updateSetProgress(
          String userUid,
          String workoutPlanUid,
          String workoutUid,
          String exerciseUid,
          String setUid,
          bool isSetDone) =>
      _firestoreProvider.updateSetProgress(
          userUid, workoutPlanUid, workoutUid, exerciseUid, setUid, isSetDone);

  Future<void> updateWorkoutProgress(String userUid, String workoutPlanUid,
          String workoutUid, bool isDone) =>
      _firestoreProvider.updateWorkoutProgress(
          userUid, workoutPlanUid, workoutUid, isDone);

  Stream<QuerySnapshot> myWorkoutPlansLibraryQuerySnapshot() =>
      _firestoreProvider.myWorkoutPlansLibraryQuerySnapshot();
  Stream<QuerySnapshot> workoutPlansQuerySnapshot(String category) =>
      _firestoreProvider.workoutPlansQuerySnapshot(category);

  Future<DocumentReference> createNewWorkoutPlan(
    String title,
    String description,
  ) =>
      _firestoreProvider.createNewWorkoutPlan(
        title,
        description,
      );

  Future<void> updateWorkoutPlanCategories(String workoutPlanUid,
          String category, String location, String skillLevel) =>
      _firestoreProvider.updateWorkoutPlanCategories(
        workoutPlanUid,
        category,
        location,
        skillLevel,
      );
  Future<void> updateWorkoutPlanDetails(
    String workoutPlanUid,
    String title,
    String description,
  ) =>
      _firestoreProvider.updateWorkoutPlanDetails(
        workoutPlanUid,
        title,
        description,
      );

  Future<void> addDaysToPlan(
    int days,
    String workoutPlanUid,
  ) =>
      _firestoreProvider.addDaysToPlan(
        days,
        workoutPlanUid,
      );

  Stream<QuerySnapshot> myWorkoutsQuerySnapshot(String workoutPlanUid) =>
      _firestoreProvider.myWorkoutsQuerySnapshot(workoutPlanUid);

  Future<void> updateWorkoutPlanPrice(
    String workoutPlanUid,
    double price,
  ) =>
      _firestoreProvider.updateWorkoutPlanPrice(workoutPlanUid, price);

  Stream<DocumentSnapshot> getWorkoutPlanInfo(String workoutPlanUid) =>
      _firestoreProvider.getWorkoutPlanInfo(workoutPlanUid);

  Future<String> downloadURL(
    File file,
    String path,
    String contentType,
  ) =>
      _firestoreProvider.downloadURL(
        file,
        path,
        contentType,
      );

  Future<void> updateCoverForWorkoutPlan(
    String workoutPlanUid,
    String coverPhotoUrl,
  ) =>
      _firestoreProvider.updateCoverForWorkoutPlan(
          workoutPlanUid, coverPhotoUrl);

  Future<void> updatePromoVideoForWorkoutPlan(
    String workoutPlanUid,
    String promoVideoUrl,
  ) =>
      _firestoreProvider.updatePromoVideoForWorkoutPlan(
          workoutPlanUid, promoVideoUrl);

  Future<void> updatePublishStatus(
    String workoutPlanUid,
    bool isPublished,
  ) =>
      _firestoreProvider.updatePublishStatus(workoutPlanUid, isPublished);
}
