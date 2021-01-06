import 'package:fit_mart/providers/firestore_provider.dart';

class EditWorkoutNameBloc {
  FirestoreProvider _firestoreProvider = FirestoreProvider();

  Future<void> updateWorkoutName(String workoutPlanUid, String weekUid,
          String workoutUid, String workoutName) =>
      _firestoreProvider.updateWorkoutName(
          workoutPlanUid, weekUid, workoutUid, workoutName);
}
