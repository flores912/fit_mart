import 'package:fit_mart/blocs/add_exercises_screen_bloc.dart';
import 'package:flutter/cupertino.dart';

class AddExercisesScreenBlocProvider extends InheritedWidget {
  final bloc = AddExercisesScreenBloc();

  AddExercisesScreenBlocProvider({Key key, Widget child})
      : super(key: key, child: child);

  @override
  bool updateShouldNotify(_) => true;
  static AddExercisesScreenBloc of(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<AddExercisesScreenBlocProvider>()
        .bloc;
  }
}
