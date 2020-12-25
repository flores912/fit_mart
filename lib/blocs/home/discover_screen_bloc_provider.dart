import 'package:fit_mart/blocs/home/discover_screen_bloc.dart';
import 'package:flutter/cupertino.dart';

class DiscoverScreenBlocProvider extends InheritedWidget {
  final bloc = DiscoverScreenBloc();

  DiscoverScreenBlocProvider({Key key, Widget child})
      : super(key: key, child: child);

  @override
  bool updateShouldNotify(_) => true;

  static DiscoverScreenBloc of(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<DiscoverScreenBlocProvider>()
        .bloc;
  }
}
