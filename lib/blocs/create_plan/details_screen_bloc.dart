import 'package:cloud_firestore/cloud_firestore.dart';

import '../../repository.dart';

class DetailsScreenBloc {
  final _repository = Repository();

  Future<DocumentReference> createNewWorkoutPlan(
    String title,
    String description,
  ) =>
      _repository.createNewWorkoutPlan(title, description);
  Future<void> updateWorkoutPlanDetails(
    String workoutPlanUid,
    String title,
    String description,
  ) =>
      _repository.updateWorkoutPlanDetails(workoutPlanUid, title, description);

  bool isFieldsValid(String title, String description) {
    bool isValid;
    if ( //TODO : add a minimum string length
        title.isNotEmpty &&
            title.contains(new RegExp(r'[A-Z]', caseSensitive: false)) &&
            description.isNotEmpty &&
            description.contains(new RegExp(r'[A-Z]', caseSensitive: false))) {
      isValid = true;
    } else {
      //fix required fields
      isValid = false;
    }
    return isValid;
  }
}
