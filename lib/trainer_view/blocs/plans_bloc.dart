import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fit_mart/providers/firestore_provider.dart';

class PlansBloc {
  FirestoreProvider _firestoreProvider = FirestoreProvider();
  Stream<QuerySnapshot> getOthersTrainerPlans() =>
      _firestoreProvider.getOthersTrainerPlans();
  Stream<QuerySnapshot> getTrainerPlans() =>
      _firestoreProvider.getTrainerPlans();
  Stream<QuerySnapshot> getWeeks(String workoutPlanUid) =>
      _firestoreProvider.getWeeks(workoutPlanUid);

  Future<void> deletePlan(String workoutPlanUid) =>
      _firestoreProvider.deletePlan(
        workoutPlanUid,
      );
  Future<void> removePlanFromList(String workoutPlanUid) =>
      _firestoreProvider.removePlanFromList(workoutPlanUid);

  Future<void> updatePublishedStatus(String workoutPlanUid, bool isPublished) =>
      _firestoreProvider.updatePublishedStatus(workoutPlanUid, isPublished);

  Stream<QuerySnapshot> getWeekIsDone(
    String workoutPlanUid,
    String weekUid,
  ) =>
      _firestoreProvider.getWeekIsDone(workoutPlanUid, weekUid);
  Future<QuerySnapshot> getWeekIsDoneFuture(
    String workoutPlanUid,
    String weekUid,
  ) =>
      _firestoreProvider.getWeekIsDoneFuture(workoutPlanUid, weekUid);
}
