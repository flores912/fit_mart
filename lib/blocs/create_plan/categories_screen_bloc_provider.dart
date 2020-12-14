import 'package:fit_mart/blocs/create_plan/categories_screen_bloc.dart';
import 'package:flutter/cupertino.dart';

class CategoriesScreenBlocProvider extends InheritedWidget {
  final bloc = CategoriesScreenBloc();

  CategoriesScreenBlocProvider({Key key, Widget child})
      : super(key: key, child: child);

  @override
  bool updateShouldNotify(_) => true;

  static CategoriesScreenBloc of(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<CategoriesScreenBlocProvider>()
        .bloc;
  }
}
