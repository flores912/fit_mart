import 'package:fit_mart/blocs/create_plan/workouts_screen_bloc.dart';
import 'package:flutter/cupertino.dart';

class WorkoutsScreenBlocProvider extends InheritedWidget {
  final bloc = WorkoutsScreenBloc();

  WorkoutsScreenBlocProvider({Key key, Widget child})
      : super(key: key, child: child);

  @override
  bool updateShouldNotify(_) => true;
  static WorkoutsScreenBloc of(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<WorkoutsScreenBlocProvider>()
        .bloc;
  }
}
