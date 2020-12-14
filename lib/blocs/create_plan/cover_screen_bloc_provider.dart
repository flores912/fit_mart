import 'package:fit_mart/blocs/create_plan/cover_screen_bloc.dart';
import 'package:flutter/cupertino.dart';

class CoverScreenBlocProvider extends InheritedWidget {
  final bloc = CoverScreenBloc();

  CoverScreenBlocProvider({Key key, Widget child})
      : super(key: key, child: child);

  @override
  bool updateShouldNotify(_) => true;

  static CoverScreenBloc of(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<CoverScreenBlocProvider>()
        .bloc;
  }
}
