import 'package:fit_mart/blocs/create_plan/details_screen_bloc.dart';
import 'package:flutter/cupertino.dart';

class DetailsScreenBlocProvider extends InheritedWidget {
  final bloc = DetailsScreenBloc();

  DetailsScreenBlocProvider({Key key, Widget child})
      : super(key: key, child: child);

  @override
  bool updateShouldNotify(_) => true;

  static DetailsScreenBloc of(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<DetailsScreenBlocProvider>()
        .bloc;
  }
}
