import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fit_mart/repository.dart';

class EditWorkoutPlanScreenBloc {
  Repository _repository = Repository();
  Stream<DocumentSnapshot> getWorkoutPlanInfo(String workoutPlanUid) =>
      _repository.getWorkoutPlanInfo(workoutPlanUid);

  Stream<QuerySnapshot> myWorkoutsQuerySnapshot(String workoutPlanUid) =>
      _repository.myWorkoutsQuerySnapshot(workoutPlanUid);
  Future<void> updatePublishStatus(
    String workoutPlanUid,
    bool isPublished,
  ) =>
      _repository.updatePublishStatus(workoutPlanUid, isPublished);
}
