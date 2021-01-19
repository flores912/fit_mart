import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fit_mart/providers/firestore_provider.dart';

class EditSetBloc {
  FirestoreProvider _firestoreProvider = FirestoreProvider();

  Future<DocumentReference> addNewSet(
          String workoutPlanUid,
          String weekUid,
          String workoutUid,
          String exerciseUid,
          int set,
          int reps,
          int rest,
          bool isTimed,
          bool isFailure) =>
      _firestoreProvider.addNewSet(workoutPlanUid, weekUid, workoutUid,
          exerciseUid, set, reps, rest, isTimed, isFailure);

  Future<void> updateExerciseDetailsNumberOfSets(
          int sets,
          String workoutPlanUid,
          String weekUid,
          String workoutUid,
          String exerciseUid) =>
      _firestoreProvider.updateExerciseDetailsNumberOfSets(
          sets, workoutPlanUid, weekUid, workoutUid, exerciseUid);
  Future<void> updateExerciseDetailsNumberOfSetsCollection(
          int sets, String exerciseUid) =>
      _firestoreProvider.updateExerciseDetailsNumberOfSetsCollection(
          sets, exerciseUid);

  Future<DocumentReference> addNewSetCollection(String exerciseUid, int set,
          int reps, int rest, bool isTimed, bool isFailure) =>
      _firestoreProvider.addNewSetCollection(
          exerciseUid, set, reps, rest, isTimed, isFailure);
}
