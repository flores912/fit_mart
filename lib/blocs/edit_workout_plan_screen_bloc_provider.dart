import 'package:fit_mart/blocs/edit_workout_plan_screen_bloc.dart';
import 'package:flutter/cupertino.dart';

class EditWorkoutPlanScreenBlocProvider extends InheritedWidget {
  final bloc = EditWorkoutPlanScreenBloc();

  EditWorkoutPlanScreenBlocProvider({Key key, Widget child})
      : super(key: key, child: child);

  @override
  bool updateShouldNotify(_) => true;

  static EditWorkoutPlanScreenBloc of(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<EditWorkoutPlanScreenBlocProvider>()
        .bloc;
  }
}
