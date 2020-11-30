import 'package:flutter/cupertino.dart';

import 'create_plan_workouts_bloc.dart';
import 'my_plan_workouts_bloc.dart';

class CreatePlanWorkoutsBlocProvider extends InheritedWidget {
  final bloc = CreatePlanWorkoutsBloc();

  CreatePlanWorkoutsBlocProvider({Key key, Widget child})
      : super(key: key, child: child);

  @override
  bool updateShouldNotify(_) => true;
  static CreatePlanWorkoutsBloc of(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<CreatePlanWorkoutsBlocProvider>()
        .bloc;
  }
}
