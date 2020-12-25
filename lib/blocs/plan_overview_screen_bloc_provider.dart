import 'package:fit_mart/blocs/plan_overview_screen_bloc.dart';
import 'package:flutter/cupertino.dart';

class PlanOverviewScreenBlocProvider extends InheritedWidget {
  final bloc = PlanOverviewScreenBloc();

  PlanOverviewScreenBlocProvider({Key key, Widget child})
      : super(key: key, child: child);

  @override
  bool updateShouldNotify(_) => true;
  static PlanOverviewScreenBloc of(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<PlanOverviewScreenBlocProvider>()
        .bloc;
  }
}
