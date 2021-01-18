import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fit_mart/providers/firestore_provider.dart';

class PlanOverviewBloc {
  FirestoreProvider _firestoreProvider = FirestoreProvider();
  Future<DocumentSnapshot> getPlanDetails(String workoutPlanUid) =>
      _firestoreProvider.getPlanDetails(workoutPlanUid);
  Future<void> addPlanToMyList(String workoutPlanUid) =>
      _firestoreProvider.addPlanToMyList(workoutPlanUid);
}
