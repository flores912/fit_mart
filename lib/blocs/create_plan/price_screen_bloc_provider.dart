import 'package:fit_mart/blocs/create_plan/price_screen_bloc.dart';
import 'package:flutter/cupertino.dart';

class PriceScreenBlocProvider extends InheritedWidget {
  final bloc = PriceScreenBloc();

  PriceScreenBlocProvider({Key key, Widget child})
      : super(key: key, child: child);

  @override
  bool updateShouldNotify(_) => true;

  static PriceScreenBloc of(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<PriceScreenBlocProvider>()
        .bloc;
  }
}
