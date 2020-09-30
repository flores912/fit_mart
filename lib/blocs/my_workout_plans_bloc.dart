import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fit_mart/models/my_workout_plan.dart';
import 'package:fit_mart/repository.dart';

//TODO: FINISH BLOC
class MyWorkoutPlansBloc {
  final _repository = Repository();

  Future<QuerySnapshot> myWorkoutPlansQuerySnapshot(String email) =>
      _repository.myWorkoutPlansQuerySnapshot(email);

  List<MyWorkoutPlan> convertToMyWorkoutPlanList(
      {List<DocumentSnapshot> docList}) {
    List<MyWorkoutPlan> myWorkoutPlansList = [];
    docList.forEach((document) {
      MyWorkoutPlan myWorkoutPlan = MyWorkoutPlan(
          imageUrl: document.get('imageUrl'),
          trainer: document.get('trainer'),
          title: document.get('title'),
          progress: document.get('progress'));
      myWorkoutPlansList.add(myWorkoutPlan);
    });
    return myWorkoutPlansList;
  }

  String getEmail() {
    return _repository.getUser().email;
  }
}
