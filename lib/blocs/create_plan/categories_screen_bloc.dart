import 'package:fit_mart/repository.dart';

class CategoriesScreenBloc {
  Repository _repository = Repository();
  Future<void> updateWorkoutPlanCategories(
    String workoutPlanUid,
    String category,
    String location,
    String skillLevel,
  ) =>
      _repository.updateWorkoutPlanCategories(
        workoutPlanUid,
        category,
        location,
        skillLevel,
      );
  bool isFieldsValid(
    String category,
    String location,
    String skillLevel,
  ) {
    bool isValid;

    if (category.isNotEmpty && location.isNotEmpty && skillLevel.isNotEmpty) {
      isValid = true;
    } else {
      //complete required fields
      isValid = false;
    }
    return isValid;
  }
}
