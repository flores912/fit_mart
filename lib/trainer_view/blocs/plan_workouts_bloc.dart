import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fit_mart/providers/firestore_provider.dart';

class PlanWorkoutsBloc {
  FirestoreProvider _firestoreProvider = FirestoreProvider();

  Future<void> createNewWeek(String workoutPlanUid, int week) =>
      _firestoreProvider.createNewWeek(workoutPlanUid, week);

  Stream<QuerySnapshot> getWeeks(String workoutPlanUid) =>
      _firestoreProvider.getWeeks(workoutPlanUid);

  Stream<QuerySnapshot> getWorkouts(String workoutPlanUid, String weekUid) =>
      _firestoreProvider.getWorkouts(workoutPlanUid, weekUid);
}
