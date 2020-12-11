import 'package:fit_mart/blocs/library_screen_bloc.dart';
import 'package:flutter/cupertino.dart';

class LibraryScreenBlocProvider extends InheritedWidget {
  final bloc = LibraryScreenBloc();

  LibraryScreenBlocProvider({Key key, Widget child})
      : super(key: key, child: child);

  @override
  bool updateShouldNotify(_) => true;

  static LibraryScreenBloc of(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<LibraryScreenBlocProvider>()
        .bloc;
  }
}
