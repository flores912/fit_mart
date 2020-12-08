import 'package:fit_mart/blocs/create_new_exercise_title_screen_bloc.dart';
import 'package:flutter/cupertino.dart';

class CreateNewExerciseTitleScreenBlocProvider extends InheritedWidget {
  final bloc = CreateNewExerciseTitleScreenBloc();

  CreateNewExerciseTitleScreenBlocProvider({Key key, Widget child})
      : super(key: key, child: child);

  @override
  bool updateShouldNotify(_) => true;
  static CreateNewExerciseTitleScreenBloc of(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<
            CreateNewExerciseTitleScreenBlocProvider>()
        .bloc;
  }
}
