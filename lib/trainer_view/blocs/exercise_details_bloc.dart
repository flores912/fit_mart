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
  Future<void> deleteSetFromExercise(String workoutPlanUid, String weekUid,
          String workoutUid, String exerciseUid, String setUid) =>
      _firestoreProvider.deleteSetFromExercise(
          workoutPlanUid, weekUid, workoutUid, exerciseUid, setUid);
  Future<void> deleteSetFromCollectionExercise(
          String exerciseUid, String setUid) =>
      _firestoreProvider.deleteSetFromCollectionExercise(exerciseUid, setUid);
  Future<DocumentSnapshot> getExerciseDetails(String workoutPlanUid,
          String weekUid, String workoutUid, String exerciseUid) =>
      _firestoreProvider.getExerciseDetails(
          workoutPlanUid, weekUid, workoutUid, exerciseUid);

  Future<DocumentSnapshot> getExerciseDetailsFromCollection(
          String exerciseUid) =>
      _firestoreProvider.getExerciseDetailsFromCollectionExercise(exerciseUid);

  Future<void> updateExerciseDetailsNumberOfSetsCollection(
          int sets, String exerciseUid) =>
      _firestoreProvider.updateExerciseDetailsNumberOfSetsCollection(
          sets, exerciseUid);
  Future<void> updateExerciseDetailsNumberOfSets(
          int sets,
          String workoutPlanUid,
          String weekUid,
          String workoutUid,
          String exerciseUid) =>
      _firestoreProvider.updateExerciseDetailsNumberOfSets(
          sets, workoutPlanUid, weekUid, workoutUid, exerciseUid);
  Future<void> updateSetIndexCollection(
          String exerciseUid, String setUid, int set) =>
      _firestoreProvider.updateSetIndexCollection(exerciseUid, setUid, set);

  Future<void> updateSetIndex(String workoutPlanUid, String weekUid,
          String workoutUid, String exerciseUid, String setUid, int set) =>
      _firestoreProvider.updateSetIndex(
          workoutPlanUid, weekUid, workoutUid, exerciseUid, setUid, set);
}
