import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fit_mart/providers/firestore_provider.dart';

class PlanDetailsBloc {
  FirestoreProvider _firestoreProvider = FirestoreProvider();
  Stream<DocumentSnapshot> getPlanDetailsStream(String workoutPlanUid) =>
      _firestoreProvider.getPlanDetailsStream(workoutPlanUid);
  Future<DocumentReference> createNewPlan(
    String title,
    String description,
    String category,
    String location,
    String level,
  ) =>
      _firestoreProvider.createNewPlan(
          title, description, category, location, level);

  Future<void> updatePlanDetails(
    String workoutPlanUid,
    String title,
    String description,
    String category,
    String location,
    String level,
  ) =>
      _firestoreProvider.updatePlanDetails(
          workoutPlanUid, title, description, category, location, level);
}
