import 'package:flutter/cupertino.dart';

import 'my_workout_plans_bloc.dart';

class MyWorkoutPlansBlocProvider extends InheritedWidget {
  final bloc = MyWorkoutPlansBloc();

  MyWorkoutPlansBlocProvider({Key key, Widget child})
      : super(key: key, child: child);

  @override
  bool updateShouldNotify(_) => true;

  static MyWorkoutPlansBloc of(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<MyWorkoutPlansBlocProvider>()
        .bloc;
  }
}
