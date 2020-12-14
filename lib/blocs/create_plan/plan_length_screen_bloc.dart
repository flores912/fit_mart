import 'package:fit_mart/repository.dart';

class PlansLengthScreenBloc {
  Repository _repository = Repository();

  Future<void> addDaysToPlan(
    int days,
    String workoutPlanUid,
  ) =>
      _repository.addDaysToPlan(
        days,
        workoutPlanUid,
      );
}
