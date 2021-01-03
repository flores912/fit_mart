import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fit_mart/providers/firestore_provider.dart';

class EditSetBloc {
  FirestoreProvider firestoreProvider = FirestoreProvider();

  Future<DocumentReference> addNewSet(String workoutPlanUid, String weekUid,
          String workoutUid, String exerciseUid, int set, int reps, int rest) =>
      firestoreProvider.addNewSet(
          workoutPlanUid, weekUid, workoutUid, exerciseUid, set, reps, rest);
}
