import 'dart:io';

import 'package:fit_mart/repository.dart';

class PromoVideoScreenBloc {
  Repository _repository = Repository();

  Future<String> downloadURL(
    File file,
    String path,
    String contentType,
  ) =>
      _repository.downloadURL(file, path, contentType);

  Future<void> updatePromoVideoForWorkoutPlan(
    String workoutPlanUid,
    String promoVideoUrl,
  ) =>
      _repository.updatePromoVideoForWorkoutPlan(workoutPlanUid, promoVideoUrl);
}
