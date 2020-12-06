import 'package:fit_mart/blocs/exercise_sets_screen_bloc.dart';
import 'package:flutter/cupertino.dart';

class ExerciseSetsScreenBlocProvider extends InheritedWidget {
  final bloc = ExerciseSetsScreenBloc();

  ExerciseSetsScreenBlocProvider({Key key, Widget child})
      : super(key: key, child: child);

  @override
  bool updateShouldNotify(_) => true;
  static ExerciseSetsScreenBloc of(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<ExerciseSetsScreenBlocProvider>()
        .bloc;
  }
}
