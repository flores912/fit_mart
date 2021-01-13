import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fit_mart/providers/firestore_provider.dart';

class WorkoutSessionBloc {
  FirestoreProvider _firestoreProvider = FirestoreProvider();

  Future<void> updateIsDoneSet(
          bool isDone,
          String workoutPlanUid,
          String weekUid,
          String workoutUid,
          String exerciseUid,
          String setUid) =>
      _firestoreProvider.updateIsDoneSet(
          isDone, workoutPlanUid, weekUid, workoutUid, exerciseUid, setUid);
  Stream<QuerySnapshot> getSetIsDone(String workoutPlanUid, String weekUid,
          String workoutUid, String exerciseUid, String setUid) =>
      _firestoreProvider.getSetIsDone(
          workoutPlanUid, weekUid, workoutUid, exerciseUid, setUid);
}
