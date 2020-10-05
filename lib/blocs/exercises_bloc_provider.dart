import 'package:fit_mart/blocs/exercises_bloc.dart';
import 'package:flutter/cupertino.dart';

class ExercisesBlocProvider extends InheritedWidget{
  final bloc = ExercisesBloc();

  ExercisesBlocProvider({Key key, Widget child})
      : super(key: key, child: child);


  @override
  bool updateShouldNotify(_) => true;

  static ExercisesBloc of(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<ExercisesBlocProvider>()
        .bloc;
  }

}