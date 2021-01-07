import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fit_mart/providers/firebase_provider.dart';
import 'package:fit_mart/providers/firestore_provider.dart';

class ExerciseDetailsBloc {
  FirestoreProvider _firestoreProvider = FirestoreProvider();
  FirebaseProvider _firebaseProvider = FirebaseProvider();
  Stream<QuerySnapshot> getSets(String workoutPlanUid, String weekUid,
          String workoutUid, String exerciseUid) =>
      _firestoreProvider.getSets(
          workoutPlanUid, weekUid, workoutUid, exerciseUid);

  Stream<QuerySnapshot> getSetsCollection(String exerciseUid) =>
      _firestoreProvider.getSetsCollection(exerciseUid);

  Future<void> updateExerciseDetails(
          String videoUrl,
          int sets,
          String workoutPlanUid,
          String weekUid,
          String workoutUid,
          String exerciseUid) =>
      _firestoreProvider.updateExerciseDetails(
          videoUrl, sets, workoutPlanUid, weekUid, workoutUid, exerciseUid);

  Future<void> updateExerciseDetailsCollection(
          String videoUrl, int sets, String exerciseUid) =>
      _firestoreProvider.updateExerciseDetailsCollection(
          videoUrl, sets, exerciseUid);

  Future<String> downloadURL(File file, String path, String contentType) =>
      _firebaseProvider.downloadURL(file, path, contentType);
}
