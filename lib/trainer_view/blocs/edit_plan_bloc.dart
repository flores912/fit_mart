import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fit_mart/providers/firestore_provider.dart';

class EditPlanBloc {
  FirestoreProvider _firestoreProvider = FirestoreProvider();

  Future<void> updatePublishedStatus(String workoutPlanUid, bool isPublished) =>
      _firestoreProvider.updatePublishedStatus(workoutPlanUid, isPublished);

  Stream<DocumentSnapshot> getPlanDetails(String workoutPlanUid) =>
      _firestoreProvider.getPlanDetails(workoutPlanUid);
}
