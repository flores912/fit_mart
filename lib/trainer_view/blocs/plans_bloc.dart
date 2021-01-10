import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fit_mart/providers/firestore_provider.dart';

class PlansBloc {
  FirestoreProvider _firestoreProvider = FirestoreProvider();

  Stream<QuerySnapshot> getTrainerPlans() =>
      _firestoreProvider.getTrainerPlans();

  Future<void> deletePlan(String workoutPlanUid) =>
      _firestoreProvider.deletePlan(
        workoutPlanUid,
      );

  Future<void> updatePublishedStatus(String workoutPlanUid, bool isPublished) =>
      _firestoreProvider.updatePublishedStatus(workoutPlanUid, isPublished);
}
