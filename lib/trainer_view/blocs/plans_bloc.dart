import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fit_mart/providers/firestore_provider.dart';

class PlansBloc {
  FirestoreProvider _firestoreProvider = FirestoreProvider();
  Stream<QuerySnapshot> getOthersTrainerPlans() =>
      _firestoreProvider.getOthersTrainerPlans();
  Stream<QuerySnapshot> getTrainerPlans() =>
      _firestoreProvider.getTrainerPlans();

  Future<void> deletePlan(String workoutPlanUid) =>
      _firestoreProvider.deletePlan(
        workoutPlanUid,
      );
  Future<void> removePlanFromList(String workoutPlanUid) =>
      _firestoreProvider.removePlanFromList(workoutPlanUid);

  Future<void> updatePublishedStatus(String workoutPlanUid, bool isPublished) =>
      _firestoreProvider.updatePublishedStatus(workoutPlanUid, isPublished);
}
