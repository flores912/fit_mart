import 'package:fit_mart/blocs/current_plan_workouts_bloc.dart';
import 'package:flutter/cupertino.dart';

class CurrentPlanWorkoutsBlocProvider extends InheritedWidget {
  final bloc = CurrentPlanWorkoutsBloc();

  CurrentPlanWorkoutsBlocProvider({Key key, Widget child})
      : super(key: key, child: child);

  @override
  bool updateShouldNotify(_) => true;
  static CurrentPlanWorkoutsBloc of(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<CurrentPlanWorkoutsBlocProvider>()
        .bloc;
  }
}
