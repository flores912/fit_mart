import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fit_mart/providers/firestore_provider.dart';

class PlanDetailsBloc {
  FirestoreProvider _firestoreProvider = FirestoreProvider();
  Future<DocumentSnapshot> getPlanDetails(String workoutPlanUid) =>
      _firestoreProvider.getPlanDetails(workoutPlanUid);
  Future<DocumentReference> createNewPlan(
    String title,
    String description,
    double price,
    bool isFree,
  ) =>
      _firestoreProvider.createNewPlan(title, description, price, isFree);
}
