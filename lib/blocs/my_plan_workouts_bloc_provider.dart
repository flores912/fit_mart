import 'package:fit_mart/blocs/my_plan_workouts_bloc.dart';
import 'package:flutter/material.dart';

class MyPlanWorkoutsBlocProvider extends InheritedWidget {
  final bloc = MyPlanWorkoutsBloc();

  MyPlanWorkoutsBlocProvider({Key key, Widget child})
      : super(key: key, child: child);

  @override
  bool updateShouldNotify(_) => true;
  static MyPlanWorkoutsBloc of(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<MyPlanWorkoutsBlocProvider>()
        .bloc;
  }
}
