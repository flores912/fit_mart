import 'package:fit_mart/repository.dart';

class PriceScreenBloc {
  Repository _repository = Repository();

  Future<void> updateWorkoutPlanPrice(
    String workoutPlanUid,
    double price,
  ) =>
      _repository.updateWorkoutPlanPrice(workoutPlanUid, price);
}
