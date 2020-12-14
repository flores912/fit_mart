import 'package:fit_mart/blocs/create_plan/plan_length_screen_bloc.dart';
import 'package:flutter/cupertino.dart';

class PlanLengthScreenBlocProvider extends InheritedWidget {
  final bloc = PlansLengthScreenBloc();

  PlanLengthScreenBlocProvider({Key key, Widget child})
      : super(key: key, child: child);

  @override
  bool updateShouldNotify(_) => true;

  static PlansLengthScreenBloc of(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<PlanLengthScreenBlocProvider>()
        .bloc;
  }
}
